
// GlueCExp_MFC.cpp : Defines the class behaviors for the application.
//

#include "pch.h"

#include <iostream>
#include <ostream>

#include "framework.h"
#include "afxwinappex.h"
#include "afxdialogex.h"
#include "GlueCExp_MFC.h"
#include "MainFrm.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// CGlueCExpMFCApp

BEGIN_MESSAGE_MAP(CGlueCExpMFCApp, CWinApp)
	ON_COMMAND(ID_APP_ABOUT, &CGlueCExpMFCApp::OnAppAbout)
	ON_COMMAND(ID_FILE_NEW_FRAME, &CGlueCExpMFCApp::OnFileNewFrame)
END_MESSAGE_MAP()


// CGlueCExpMFCApp construction

CGlueCExpMFCApp::CGlueCExpMFCApp() noexcept
{

	// support Restart Manager
	m_dwRestartManagerSupportFlags = AFX_RESTART_MANAGER_SUPPORT_ALL_ASPECTS;
#ifdef _MANAGED
	// If the application is built using Common Language Runtime support (/clr):
	//     1) This additional setting is needed for Restart Manager support to work properly.
	//     2) In your project, you must add a reference to System.Windows.Forms in order to build.
	System::Windows::Forms::Application::SetUnhandledExceptionMode(System::Windows::Forms::UnhandledExceptionMode::ThrowException);
#endif

	// TODO: replace application ID string below with unique ID string; recommended
	// format for string is CompanyName.ProductName.SubProduct.VersionInformation
	SetAppID(_T("GlueCExpMFC.AppID.NoVersion"));

	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

// The one and only CGlueCExpMFCApp object

CGlueCExpMFCApp theApp;

void glue_window_callback(const glue_window_command state, const char* state_message, COOKIE cookie)
{
	auto main_wnd = static_cast<CMainFrame*>(const_cast<void*>(cookie));
	main_wnd->OnWindowEvent(state, state_message);
}

// handle app instance commands
void app_callback(const glue_app_command command, const void* callback, const glue_payload* payload, COOKIE cookie)
{
	auto app_wnd = static_cast<CMainFrame*>(const_cast<void*>(cookie));

	switch (command)
	{
	case glue_app_command::init:
		// handle payload
		break;
	case glue_app_command::save:
		glue_push_json_payload(callback, "{x: 5, y: {a: 51, s: \"hello\"}}");
		break;
	case glue_app_command::shutdown:
		app_wnd->CloseWindow();
		break;
	default:;
	}
}

void factory_callback(glue_app_command command, const void* callback, const glue_payload* payload, COOKIE cookie)
{
	switch (command)
	{
	case glue_app_command::create:
	{
		CFrameWnd* pFrame = new CMainFrame;
		pFrame->LoadFrame(IDR_MAINFRAME, WS_OVERLAPPEDWINDOW | FWS_ADDTOTITLE,
			nullptr, nullptr);
		pFrame->ShowWindow(SW_SHOW);
		pFrame->UpdateWindow();

		theApp.m_aryFrames.Add(pFrame->GetSafeHwnd());

		glue_app_announce_instance(callback, pFrame->m_hWnd, &app_callback,
			[](glue_window_command command, const char* context_name, COOKIE cookie)
			{
				auto main_wnd = static_cast<CMainFrame*>(const_cast<void*>(cookie));
				main_wnd->OnWindowEvent(command, context_name);
			}, pFrame);
		break;
	}
	default:;
	}
}

void glue_init_callback(glue_state state, const char* message, const glue_payload* payload, COOKIE cookie)
{
}

// CGlueCExpMFCApp initialization

BOOL CGlueCExpMFCApp::InitInstance()
{
	// InitCommonControlsEx() is required on Windows XP if an application
	// manifest specifies use of ComCtl32.dll version 6 or later to enable
	// visual styles.  Otherwise, any window creation will fail.
	INITCOMMONCONTROLSEX InitCtrls;
	InitCtrls.dwSize = sizeof(InitCtrls);
	// Set this to include all the common control classes you want to use
	// in your application.
	InitCtrls.dwICC = ICC_WIN95_CLASSES;
	InitCommonControlsEx(&InitCtrls);

	CWinApp::InitInstance();


	// Initialize OLE libraries
	if (!AfxOleInit())
	{
		AfxMessageBox(IDP_OLE_INIT_FAILED);
		return FALSE;
	}

	AfxEnableControlContainer();

	EnableTaskbarInteraction(FALSE);

	// AfxInitRichEdit2() is required to use RichEdit control
	// AfxInitRichEdit2();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	// of your final executable, you should remove from the following
	// the specific initialization routines you do not need
	// Change the registry key under which our settings are stored
	// TODO: You should modify this string to be something appropriate
	// such as the name of your company or organization
	SetRegistryKey(_T("Local AppWizard-Generated Applications"));


	// To create the main window, this code creates a new frame window
	// object and then sets it as the application's main window object
	CFrameWnd* pFrame = new CMainFrame;
	if (!pFrame)
		return FALSE;
	m_pMainWnd = pFrame;
	// create main MDI frame window
	if (!pFrame->LoadFrame(IDR_MAINFRAME))
		return FALSE;
	// try to load shared MDI menus and accelerator table
	//TODO: add additional member variables and load calls for
	//	additional menu types your application may need
	HINSTANCE hInst = AfxGetResourceHandle();
	m_hMDIMenu = ::LoadMenu(hInst, MAKEINTRESOURCE(IDR_GlueCExpMFCTYPE));
	m_hMDIAccel = ::LoadAccelerators(hInst, MAKEINTRESOURCE(IDR_GlueCExpMFCTYPE));

	// The one and only window has been initialized, so show and update it
	pFrame->ShowWindow(SW_SHOW);
	pFrame->UpdateWindow();

	glue_init("GlueCExp_MFC",
		[](glue_state state, const char* message, const glue_payload* glue_payload, COOKIE cookie)
		{
			auto app = static_cast<CGlueCExpMFCApp*>(const_cast<void*>(cookie));
			std::cout << "Glue Init state: " << enum_as_int(state) << " Message: " << message << std::endl;

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
				auto val = glue_read_glue_value(starting_context_reader, "");
			}

			// register an app called MFCCLI
			glue_app_register_factory("MFCCLI",
				[](glue_app_command command, const void* callback, const ::glue_payload* payload, COOKIE cookie)
				{
					switch (command)
					{
					case glue_app_command::create:
					{
						CFrameWnd* pFrame = new CMainFrame;
						pFrame->LoadFrame(IDR_MAINFRAME, WS_OVERLAPPEDWINDOW | FWS_ADDTOTITLE,
							nullptr, nullptr);
						pFrame->ShowWindow(SW_SHOW);
						pFrame->UpdateWindow();

						theApp.m_aryFrames.Add(pFrame->GetSafeHwnd());

						glue_app_announce_instance(callback, pFrame->m_hWnd, &app_callback,
							[](glue_window_command command, const char* context_name, COOKIE cookie)
							{
								auto main_wnd = static_cast<CMainFrame*>(const_cast<void*>(cookie));
								main_wnd->OnWindowEvent(command, context_name);
							}, pFrame);

						// or alternatively, factories can 'deny' creating instances by pushing failure
						//glue_push_failure(callback, "cannot create this instance atm")
						break;
					}
					default:;
					}
				}, cookie);

			// register the main window
			glue_register_main_window(app->m_pMainWnd->m_hWnd,
				[](glue_app_command command, const void* callback, const ::glue_payload* payload, COOKIE cookie)
				{
					switch (command)
					{
					case glue_app_command::init:
					{
						auto json = glue_read_json(payload->reader, nullptr);
						MessageBoxA(0, json, "Glue restore state", 0);
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
					auto main_wnd = static_cast<CMainFrame*>(const_cast<void*>(cookie));
					main_wnd->OnWindowEvent(command, context_name);
				}, "Main MFC", app->m_pMainWnd);			

			/****
				 **** Here you can use Glue to:
				 **** glue_register_endpoint - registers invocation endpoint
				 **** glue_register_streaming_endpoint - registers streaming endpoint
				 **** glue_read_context_sync - reads from a context
				 **** glue_write_context - writes to a context
				 **** glue_invoke_all - invokes endpoint
				 ****/
		}, this);

	return TRUE;
}

int CGlueCExpMFCApp::ExitInstance()
{
	//TODO: handle additional resources you may have added
	AfxOleTerm(FALSE);

	return CWinApp::ExitInstance();
}

// CGlueCExpMFCApp message handlers


// CAboutDlg dialog used for App About

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg() noexcept;

	// Dialog Data
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_ABOUTBOX };
#endif

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Implementation
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() noexcept : CDialogEx(IDD_ABOUTBOX)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()

// App command to run the dialog
void CGlueCExpMFCApp::OnAppAbout()
{
	CAboutDlg aboutDlg;
	aboutDlg.DoModal();
}

// CGlueCExpMFCApp message handlers

void CGlueCExpMFCApp::OnFileNewFrame()
{
	CFrameWnd* pFrame = new CMainFrame;
	pFrame->LoadFrame(IDR_MAINFRAME, WS_OVERLAPPEDWINDOW | FWS_ADDTOTITLE,
		nullptr, nullptr);
	pFrame->ShowWindow(SW_SHOW);
	pFrame->UpdateWindow();
	m_aryFrames.Add(pFrame->GetSafeHwnd());

	// register 'flier' window.
	glue_register_window(pFrame->m_hWnd, &glue_window_callback, "Child", pFrame);
}