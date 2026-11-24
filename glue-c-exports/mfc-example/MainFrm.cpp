
// MainFrm.cpp : implementation of the CMainFrame class
//

#include "pch.h"
#include "framework.h"
#include "GlueCExp_MFC.h"

#include "MainFrm.h"

#include <sstream>
#include <algorithm>

static constexpr UINT IDC_GLUE_BUTTON = 1001;
static constexpr UINT IDC_GLUE_NAMES = 1002;
static constexpr UINT IDC_GLUE_LOG = 1003;
static constexpr int LOG_HEIGHT = 120;

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// CMainFrame

IMPLEMENT_DYNAMIC(CMainFrame, CFrameWnd)

BEGIN_MESSAGE_MAP(CMainFrame, CFrameWnd)
	ON_WM_CREATE()
	ON_COMMAND(ID_FILE_CLOSE, &CMainFrame::OnFileClose)
	ON_WM_CLOSE()
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_GLUE_BUTTON, &CMainFrame::OnGlueButtonClicked)
	ON_LBN_SELCHANGE(IDC_GLUE_NAMES, &CMainFrame::OnNameSelected)
	ON_COMMAND_RANGE(ID_VIEW_APPLOOK_WIN_2000, ID_VIEW_APPLOOK_WINDOWS_7, &CMainFrame::OnApplicationLook)
	ON_UPDATE_COMMAND_UI_RANGE(ID_VIEW_APPLOOK_WIN_2000, ID_VIEW_APPLOOK_WINDOWS_7, &CMainFrame::OnUpdateApplicationLook)
END_MESSAGE_MAP()

static UINT indicators[] =
{
	ID_SEPARATOR,           // status line indicator
	ID_INDICATOR_CAPS,
	ID_INDICATOR_NUM,
	ID_INDICATOR_SCRL,
};

// CMainFrame construction/destruction

CMainFrame::CMainFrame() noexcept
{
	// TODO: add member initialization code here
}

CMainFrame::~CMainFrame()
{
}

int CMainFrame::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CFrameWnd::OnCreate(lpCreateStruct) == -1)
		return -1;

	if (!m_wndToolBar.CreateEx(this, TBSTYLE_FLAT, WS_CHILD | WS_VISIBLE | CBRS_TOP | CBRS_GRIPPER | CBRS_TOOLTIPS | CBRS_FLYBY | CBRS_SIZE_DYNAMIC) ||
		!m_wndToolBar.LoadToolBar(IDR_MAINFRAME))
	{
		TRACE0("Failed to create toolbar\n");
		return -1;      // fail to create
	}

	if (!m_wndStatusBar.Create(this))
	{
		TRACE0("Failed to create status bar\n");
		return -1;      // fail to create
	}
	m_wndStatusBar.SetIndicators(indicators, sizeof(indicators) / sizeof(UINT));

	// TODO: Delete these three lines if you don't want the toolbar to be dockable
	m_wndToolBar.EnableDocking(CBRS_ALIGN_ANY);
	EnableDocking(CBRS_ALIGN_ANY);
	DockControlBar(&m_wndToolBar);

	m_button.Create(_T("Set Glue Context"), WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON,
		CRect(10, 40, 160, 60), this, IDC_GLUE_BUTTON);

	m_list.Create(WS_CHILD | WS_VISIBLE | WS_BORDER | WS_VSCROLL | LBS_NOTIFY | LBS_NOINTEGRALHEIGHT,
		CRect(10, 70, 160, 220), this, IDC_GLUE_NAMES);
	for (const auto* name : { L"Alice Johnson", L"Bob Smith", L"Carol White", L"David Brown", L"Eve Davis" })
	{
		m_list.AddString(name);
	}

	m_log.Create(WS_CHILD | WS_VISIBLE | WS_BORDER | WS_VSCROLL | ES_MULTILINE | ES_READONLY | ES_AUTOVSCROLL,
		CRect(0, 0, 0, 0), this, IDC_GLUE_LOG);
	RecalcLayout();

	return 0;
}

BOOL CMainFrame::PreCreateWindow(CREATESTRUCT& cs)
{
	if (!CFrameWnd::PreCreateWindow(cs))
		return FALSE;
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	return TRUE;
}

// CMainFrame diagnostics

#ifdef _DEBUG
void CMainFrame::AssertValid() const
{
	CFrameWnd::AssertValid();
}

void CMainFrame::Dump(CDumpContext& dc) const
{
	CFrameWnd::Dump(dc);
}
#endif //_DEBUG

void CMainFrame::OnGlueButtonClicked()
{
	const bool is_main = AfxGetApp()->m_pMainWnd == this;
	const auto err = glue_write_context(m_context.c_str(),
		is_main ? "data.mfc.main.buttonClicked" : "data.mfc.child.buttonClicked", glv_i(++m_clicks));
	if (err != nullptr)
	{
		TRACE(_T("glue_write_context failed: %d\n"), static_cast<int>(reinterpret_cast<intptr_t>(err)));
	}
}

void CMainFrame::OnNameSelected()
{
	CString name;
	const int sel = m_list.GetCurSel();
	if (sel == LB_ERR)
	{
		return;
	}
	m_list.GetText(sel, name);
	const auto err = glue_write_context(m_context.c_str(), "data.contact.displayName", glv_s(CW2A(name, CP_UTF8)));
	if (err != nullptr)
	{
		TRACE(_T("glue_write_context failed: %d\n"), static_cast<int>(reinterpret_cast<intptr_t>(err)));
	}
}

void CMainFrame::RecalcLayout(BOOL bNotify)
{
	CFrameWnd::RecalcLayout(bNotify);
	if (m_log.GetSafeHwnd() == nullptr)
	{
		return;
	}
	CRect client;
	GetClientRect(&client);
	if (m_wndStatusBar.GetSafeHwnd() != nullptr)
	{
		CRect status;
		m_wndStatusBar.GetWindowRect(&status);
		client.bottom -= status.Height();
	}
	const int height = std::min<int>(LOG_HEIGHT, client.Height());
	m_log.MoveWindow(client.left, client.bottom - height, client.Width(), height);
}

void CMainFrame::AppendLog(const char* utf8_text)
{
	const CString line = CString(CA2W(utf8_text != nullptr ? utf8_text : "(null)", CP_UTF8)) + L"\r\n";
	m_log.SetSel(-1, -1);
	m_log.ReplaceSel(line);
}

void CMainFrame::OnWindowEvent(glue_window_command command, const char* state_message)
{
	switch (command)
	{
	case glue_window_command::init:
		// initialized
		break;
	case glue_window_command::data_update:
	{
		m_context = state_message;
		const auto reader = glue_read_context_sync(state_message);
		const char* name = reader != nullptr ? glue_read_s(reader, "data.contact.displayName") : nullptr;
		if (name != nullptr)
		{
			const CString display(CA2W(name, CP_UTF8));
			m_button.SetWindowTextW(display);
			int idx = m_list.FindStringExact(-1, display);
			if (idx == LB_ERR)
			{
				idx = m_list.AddString(display);
			}
			m_list.SetCurSel(idx);
		}
		break;
	}
	case glue_window_command::channel_switch:
	{
		m_context = state_message;
		std::stringstream s;
		s << state_message;
		const CString title(s.str().c_str());
		m_button.SetWindowTextW(title);
		break;
	}
	case glue_window_command::close:
		// handle closed
		break;
	}
}


// CMainFrame message handlers

void CMainFrame::OnApplicationLook(UINT id)
{
	CWaitCursor wait;

	theApp.m_nAppLook = id;

	switch (theApp.m_nAppLook)
	{
	case ID_VIEW_APPLOOK_WIN_2000:
		CMFCVisualManager::SetDefaultManager(RUNTIME_CLASS(CMFCVisualManager));
		break;

	case ID_VIEW_APPLOOK_OFF_XP:
		CMFCVisualManager::SetDefaultManager(RUNTIME_CLASS(CMFCVisualManagerOfficeXP));
		break;

	case ID_VIEW_APPLOOK_WIN_XP:
		CMFCVisualManagerWindows::m_b3DTabsXPTheme = TRUE;
		CMFCVisualManager::SetDefaultManager(RUNTIME_CLASS(CMFCVisualManagerWindows));
		break;

	case ID_VIEW_APPLOOK_OFF_2003:
		CMFCVisualManager::SetDefaultManager(RUNTIME_CLASS(CMFCVisualManagerOffice2003));
		CDockingManager::SetDockingMode(DT_SMART);
		break;

	case ID_VIEW_APPLOOK_VS_2005:
		CMFCVisualManager::SetDefaultManager(RUNTIME_CLASS(CMFCVisualManagerVS2005));
		CDockingManager::SetDockingMode(DT_SMART);
		break;

	case ID_VIEW_APPLOOK_VS_2008:
		CMFCVisualManager::SetDefaultManager(RUNTIME_CLASS(CMFCVisualManagerVS2008));
		CDockingManager::SetDockingMode(DT_SMART);
		break;

	case ID_VIEW_APPLOOK_WINDOWS_7:
		CMFCVisualManager::SetDefaultManager(RUNTIME_CLASS(CMFCVisualManagerWindows7));
		CDockingManager::SetDockingMode(DT_SMART);
		break;

	default:
		switch (theApp.m_nAppLook)
		{
		case ID_VIEW_APPLOOK_OFF_2007_BLUE:
			CMFCVisualManagerOffice2007::SetStyle(CMFCVisualManagerOffice2007::Office2007_LunaBlue);
			break;

		case ID_VIEW_APPLOOK_OFF_2007_BLACK:
			CMFCVisualManagerOffice2007::SetStyle(CMFCVisualManagerOffice2007::Office2007_ObsidianBlack);
			break;

		case ID_VIEW_APPLOOK_OFF_2007_SILVER:
			CMFCVisualManagerOffice2007::SetStyle(CMFCVisualManagerOffice2007::Office2007_Silver);
			break;

		case ID_VIEW_APPLOOK_OFF_2007_AQUA:
			CMFCVisualManagerOffice2007::SetStyle(CMFCVisualManagerOffice2007::Office2007_Aqua);
			break;
		}

		CMFCVisualManager::SetDefaultManager(RUNTIME_CLASS(CMFCVisualManagerOffice2007));
		CDockingManager::SetDockingMode(DT_SMART);
	}

	RedrawWindow(nullptr, nullptr, RDW_ALLCHILDREN | RDW_INVALIDATE | RDW_UPDATENOW | RDW_FRAME | RDW_ERASE);

}

void CMainFrame::OnUpdateApplicationLook(CCmdUI* pCmdUI)
{
	pCmdUI->SetRadio(theApp.m_nAppLook == pCmdUI->m_nID);
}


BOOL CMainFrame::LoadFrame(UINT nIDResource, DWORD dwDefaultStyle, CWnd* pParentWnd, CCreateContext* pContext)
{
	// base class does the real work

	if (!CFrameWnd::LoadFrame(nIDResource, dwDefaultStyle, pParentWnd, pContext))
	{
		return FALSE;
	}

	CWinApp* pApp = AfxGetApp();
	if (pApp->m_pMainWnd == nullptr)
		pApp->m_pMainWnd = this;

	// replace Exit option on File menu with Close for secondary windows
	if (AfxGetApp()->m_pMainWnd != this)
	{
		CMenu* pMenu = GetMenu();
		ASSERT(pMenu);
		BOOL bNameValid;
		CString strTemp;
		bNameValid = strTemp.LoadString(IDS_CLOSE);
		ASSERT(bNameValid);
		pMenu->ModifyMenu(ID_APP_EXIT, MF_BYCOMMAND | MF_STRING, ID_FILE_CLOSE, strTemp);
	}

	return TRUE;
}

void CMainFrame::OnFileClose()
{
	DestroyWindow();
}

void CMainFrame::OnDestroy()
{
	// A sticky (reparented) window is WS_CHILD, so GetMenu returns NULL and CFrameWnd::OnDestroy asserts on menu restore.
	if (GetStyle() & WS_CHILD)
	{
		m_hMenuDefault = nullptr;
	}
	CFrameWnd::OnDestroy();
}

void CMainFrame::OnClose()
{
	CGlueCExpMFCApp* pApp = reinterpret_cast<CGlueCExpMFCApp*>(AfxGetApp());
	// main window is being closed so cleanup
	if (pApp->m_pMainWnd == this)
	{
		for (int iCntr = 0; iCntr < pApp->m_aryFrames.GetSize(); iCntr++)
		{
			HWND hFrame = pApp->m_aryFrames.GetAt(iCntr);
			if (::IsWindow(hFrame))
				::SendMessage(hFrame, WM_CLOSE, 0, 0);
		}
	}
	CFrameWnd::OnClose();
}
