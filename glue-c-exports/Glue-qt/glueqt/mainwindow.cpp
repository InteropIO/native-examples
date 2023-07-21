#include "mainwindow.h"
#include "./ui_mainwindow.h"

#include <sstream>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent), ui(new Ui::MainWindow) {
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::OnWindowEvent(glue_window_command command, const char *state_message)
{
    switch (command)
    {
    case glue_window_command::init:
        // initialized
        break;
    case glue_window_command::data_update:
    {
        const auto reader = glue_read_context_sync(state_message);

        std::stringstream s;
        s << glue_read_s(reader, "data.contact.displayName");
//        const CString title(s.str().c_str());
//        m_button.SetWindowTextW(title);
        break;
    }
    case glue_window_command::channel_switch:
    {
        std::stringstream s;
        s << state_message;
//        const CString title(s.str().c_str());
//        m_button.SetWindowTextW(title);
        break;
    }
    case glue_window_command::close:
        // handle closed
        break;
    }
}

