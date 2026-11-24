
// MainFrm.h : interface of the CMainFrame class
//

#pragma once
#include <string>
#include "ChildView.h"

class CMainFrame : public CFrameWnd
{
	
public:
	CMainFrame() noexcept;
protected: 
	DECLARE_DYNAMIC(CMainFrame)

// Attributes
public:

// Operations
public:

// Overrides
public:
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	virtual BOOL LoadFrame(UINT nIDResource, DWORD dwDefaultStyle = WS_OVERLAPPEDWINDOW | FWS_ADDTOTITLE, CWnd* pParentWnd = nullptr, CCreateContext* pContext = nullptr);

// Implementation
public:
	virtual ~CMainFrame();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif
	void OnWindowEvent(glue_window_command command, const char* state_message);
	void AppendLog(const char* utf8_text);
	virtual void RecalcLayout(BOOL bNotify = TRUE);

protected:  // control bar embedded members
	CEdit             m_log;
	CToolBar          m_wndToolBar;
	CStatusBar        m_wndStatusBar;
	CButton			  m_button;
	CListBox          m_list;
	std::string       m_context = "GlueCExp_MFC";
	int               m_clicks = 0;

// Generated message map functions
protected:
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnFileClose();
	afx_msg void OnClose();
	afx_msg void OnDestroy();
	afx_msg void OnGlueButtonClicked();
	afx_msg void OnNameSelected();
	afx_msg void OnApplicationLook(UINT id);
	afx_msg void OnUpdateApplicationLook(CCmdUI* pCmdUI);
	DECLARE_MESSAGE_MAP()

};


