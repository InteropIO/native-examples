
// GlueCExp_MFC.h : main header file for the GlueCExp_MFC application
//
#pragma once

#ifndef __AFXWIN_H__
	#error "include 'pch.h' before including this file for PCH"
#endif

#include "resource.h"       // main symbols


// CGlueCExpMFCApp:
// See GlueCExp_MFC.cpp for the implementation of this class
//

class CGlueCExpMFCApp : public CWinApp
{
public:
	CGlueCExpMFCApp() noexcept;

	CArray<HWND, HWND> m_aryFrames;
public:

// Overrides
public:
	virtual BOOL InitInstance();
	virtual int ExitInstance();

// Implementation
protected:
	HMENU  m_hMDIMenu;
	HACCEL m_hMDIAccel;

public:
	UINT  m_nAppLook;
	afx_msg void OnAppAbout();
	afx_msg void OnFileNewFrame();
	DECLARE_MESSAGE_MAP()
};

extern CGlueCExpMFCApp theApp;
