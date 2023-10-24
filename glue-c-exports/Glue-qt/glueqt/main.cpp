#include "mainwindow.h"

#include <QAction>
#include <QApplication>
#include <QMenu>
#include <QPushButton>

#include<QSlider>
#include<QSpinBox>
#include<QHBoxLayout>
#include<QWidget>
#include <QSemaphore>
#include <QTimer>

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
    MainWindow w;

    QStatusBar sb;

    w.setWindowTitle("Glue QT application with context menu");

    char clsName[MAX_PATH];
    GetClassNameA((HWND)w.winId(), clsName, MAX_PATH);
    w.setWindowTitle(QString(clsName) + "       0x" + QString::fromStdString(HWNDToString((HWND)w.winId())));

    QPushButton init_btn("Init Glue", &w);
    init_btn.move(50, 50);

    QObject::connect(&init_btn, &QPushButton::clicked, [&w, &init_btn]() {
        init_btn.setEnabled(false);
        glue_init("qt-glue-app", [](glue_state state, const char* message, const glue_payload* glue_payload, COOKIE cookie)
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

                auto wnd = static_cast<MainWindow*>(const_cast<void*>(cookie));

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
                                          }, "QT Main Glue Window", cookie);
            }, &w);
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

    w.statusBar()->addWidget(statusButton);

    QMenu *file = w.menuBar()->addMenu("&File");
    file->addAction(quit);
    w.menuBar()->addAction("Glue test");

    w.show();
    return a.exec();
}
