#include <deque>
#define NOMINMAX
#include "mainwindow.h"
#include <QAction>
#include <QApplication>
#include <QMenu>
#include <QPushButton>

#include <QSlider>
#include <QSpinBox>
#include <QHBoxLayout>
#include <QWidget>
#include <QSemaphore>
#include <QTimer>
#include <QDateTime>
#include <QtCharts/QChart>
#include <QtCharts/QLineSeries>
#include <QtCharts/QChartView>
#include <QtCharts/QValueAxis>
#include <QtCharts/QDateTimeAxis>
#include <QtCharts/QSplineSeries>
#include <QMenu>
#include <QMenuBar>
#include <QStatusBar>
#include <string>
#include <QDebug>

#include <sstream>

#include <GlueCLILib.h>

using Qt::ActionsContextMenu;

std::string HWNDToString(HWND hWnd)
{
    std::stringstream ss;
    ss << std::hex << *reinterpret_cast<uint64_t*>(&hWnd) << std::endl;
    return ss.str();
}

int main(int argc, char *argv[]) {
    QApplication a(argc, argv);
    MainWindow main_wnd;

    // Create the series
    auto bidSeries = new QtCharts::QSplineSeries();
    auto askSeries = new QtCharts::QSplineSeries();

    bidSeries->setColor(Qt::red);
    askSeries->setColor(Qt::blue);

    QtCharts::QChart *chart = new QtCharts::QChart();

    chart->addSeries(bidSeries);
    chart->addSeries(askSeries);
    chart->createDefaultAxes();

    QtCharts::QChartView *chartView = new QtCharts::QChartView(chart);
    main_wnd.setCentralWidget(chartView);

    std::deque<double> xTicks;
    std::deque<double> bidPrices;
    std::deque<double> askPrices;

    QtCharts::QValueAxis *xAxis = new QtCharts::QValueAxis();
    xAxis->setTickCount(60);

    chart->addAxis(xAxis, Qt::AlignBottom);
    bidSeries->attachAxis(xAxis);
    askSeries->attachAxis(xAxis);

    QtCharts::QValueAxis *yAxis = new QtCharts::QValueAxis();
    chart->addAxis(yAxis, Qt::AlignLeft);
    bidSeries->attachAxis(yAxis);
    askSeries->attachAxis(yAxis);

    xAxis->setRange(0, 60);
    yAxis->setRange(5, 10000);

    chartView->setRenderHint(QPainter::Antialiasing);
    chart->setAnimationOptions(QtCharts::QChart::SeriesAnimations);

    auto update_prices = [&](double bid, double ask) {
        qDebug() << "bid:" << bid << ", ask:" << ask;

        xTicks.push_back(xTicks.size() ? xTicks.back() + 1 : 0);
        bidPrices.push_back(bid);
        askPrices.push_back(ask);

        bidSeries->append(xTicks.back(), bid);
        askSeries->append(xTicks.back(), ask);

        if (xTicks.size() > 60) {
            xTicks.clear();
            bidPrices.clear();
            askPrices.clear();
            bidSeries->clear();
            askSeries->clear();
            //            xTicks.pop_front();
            //            bidPrices.pop_front();
            //            askPrices.pop_front();

            //            bidSeries->remove(0);
            //            askSeries->remove(0);

            //            xAxis->setRange(bidSeries->at(0).x(), bidSeries->at(bidSeries->count() - 1).x());
        }
    };

    QStatusBar sb;

    main_wnd.setWindowTitle("Glue QT application with context menu");

    char clsName[MAX_PATH];
    GetClassNameA((HWND)main_wnd.winId(), clsName, MAX_PATH);
    main_wnd.setWindowTitle(QString(clsName) + "       0x" + QString::fromStdString(HWNDToString((HWND)main_wnd.winId())));

    QPushButton init_btn("Init Glue", &main_wnd);
    init_btn.move(50, 35);

    QPushButton bbg_btn("BBG Sub", &main_wnd);
    bbg_btn.move(160, 35);

    struct Context {
        QPushButton* init_btn;
        QPushButton* bbg_btn;
        MainWindow* main_wnd;
        std::function<void(double, double)> price_callback;
        bool state;
    };

    Context* context = new Context{ &init_btn, &bbg_btn, &main_wnd, update_prices };

    QObject::connect(&bbg_btn, &QPushButton::clicked, [&context]() {
        context->bbg_btn->setEnabled(false);
        glue_register_endpoint("qt_bbg_callback",
            [](const char* endpoint_name, const COOKIE cookie, const ::glue_payload* payload,
               const void* result_endpoint)
            {
                glue_push_payload(result_endpoint, nullptr, 0);

                double bid = glue_read_glue_value(payload->reader, "msg.eventMessages[0].marketDataEvents.bid").d;
                double ask = glue_read_glue_value(payload->reader, "msg.eventMessages[0].marketDataEvents.ask").d;

                const Context& context = *reinterpret_cast<const Context*>(cookie);

                QMetaObject::invokeMethod(qApp, [bid, ask, &context]() {
                        context.price_callback(bid, ask);
                    }, Qt::QueuedConnection);
            }, context);

        ::glue_value bbg_sub;
        auto des = glue_build_glue_value(
            "{callbackMethod: 'qt_bbg_callback', requestCorrelationId: '1', service: '//blp/mktdata', subscriptions: [{subscriptionId: 'x', security: 'VOD LN Equity', fields: 'BID, ASK'}]}",
            bbg_sub);

        glue_invoke("T42.MDFApi.CreateSubscriptionRequest", bbg_sub.composite, bbg_sub.len);
        glue_destroy_resource(des);
    });

    QObject::connect(&init_btn, &QPushButton::clicked, [&context]() {
        context->init_btn->setEnabled(false);

        glue_init("qt-glue-app", [](glue_state state, const char* message, const glue_payload* glue_payload, COOKIE init_cookie)
            {
                if (state != glue_state::initialized)
                {
                    // handle state
                    return;
                }
                glue_set_save_state(
                    [](const char* endpoint_name, COOKIE cookie, const ::glue_payload* payload, const void* endpoint)
                    {
                        glue_push_json_payload(endpoint, "{saved_state: 5, client: {id: 51, name: \"John\"}}");
                    });

                if (glue_is_launched_by_gd())
                {
                    auto starting_context_reader = glue_get_starting_context_reader();
                    glue_value val = glue_read_glue_value(starting_context_reader, "");
                }

                const Context& context = *reinterpret_cast<const Context*>(init_cookie);
                auto wnd = context.main_wnd;
                QSemaphore setup_sem;
                // prepare the window - remove frame and sizing - make sure it's in the main thread
                QMetaObject::invokeMethod(qApp, [&]() {
                        wnd->setWindowFlags(Qt::Window | Qt::FramelessWindowHint);
                        wnd->statusBar()->setSizeGripEnabled(false);
                        wnd->show();
                        setup_sem.release();
                    }, Qt::QueuedConnection);

                setup_sem.acquire();

                glue_register_main_window((HWND)wnd->winId(),
                                          [](glue_app_command command, const void* callback, const ::glue_payload* payload, COOKIE cookie)
                                          {
                                              switch (command)
                                              {
                                              case glue_app_command::init:
                                              {
                                                  auto json = glue_read_json(payload->reader, nullptr);
                                                  //MessageBoxA(0, json, "Glue restore state", 0);
                                              }
                                              break;
                                              case glue_app_command::save:
                                                  glue_push_json_payload(callback, "{cats: 55}");
                                                  break;
                                              case glue_app_command::shutdown:
                                                  ExitProcess(0);
                                              case glue_app_command::create:
                                                  // only received for factories
                                                  break;
                                              default:;
                                              }
                                          },
                                          [](glue_window_command command, const char* context_name, COOKIE cookie)
                                          {
                                              auto main_wnd = static_cast<MainWindow*>(const_cast<void*>(cookie));
                                              main_wnd->OnWindowEvent(command, context_name);
                                          }, "QT Main Glue Window", init_cookie);
            }, context);
    });

    QMenu *menu = new QMenu(&init_btn);
    QAction *action = new QAction("Context Menu Item", &init_btn);
    menu->addAction(action);
    init_btn.setContextMenuPolicy(ActionsContextMenu);
    init_btn.addAction(action);

    auto *quit = new QAction("&Quit");

    QPushButton *statusButton = new QPushButton("Status Button");
    QMenu *menu2 = new QMenu(statusButton);
    QAction *action2 = new QAction("Context Menu Item", statusButton);
    menu2->addAction(action2);
    statusButton->setContextMenuPolicy(Qt::ActionsContextMenu);
    statusButton->addAction(action);

    main_wnd.statusBar()->addWidget(statusButton);

    QMenu *file = main_wnd.menuBar()->addMenu("&File");
    file->addAction(quit);
    main_wnd.menuBar()->addAction("Glue test");

    main_wnd.show();
    return a.exec();
}
