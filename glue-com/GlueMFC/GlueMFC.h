
// GlueMFC.h : main header file for the GlueMFC application
//
#pragma once

#ifndef __AFXWIN_H__
	#error "include 'pch.h' before including this file for PCH"
#endif

#include "resource.h"       // main symbols


// CGlueMFCApp:
// See GlueMFC.cpp for the implementation of this class
//

class CGlueMFCApp : public CWinApp, IAppFactory
{
public:
	CGlueMFCApp() noexcept;

protected:
	CMultiDocTemplate* m_pDocTemplate{};
public:
	HRESULT __stdcall raw_CreateApp(
		/*[in]*/ BSTR appDefName,
		/*[in]*/ struct GlueValue state,
		/*[in]*/ struct IAppAnnouncer* announcer) override;
	
	STDMETHODIMP QueryInterface(REFIID riid, void** ppv) override
	{
		if (riid == IID_IAppFactory || riid == IID_IUnknown)
			*ppv = static_cast<IAppFactory*>(this);
		else
			*ppv = nullptr;

		if (*ppv)
		{
			static_cast<IUnknown*>(*ppv)->AddRef();
			return S_OK;
		}

		return E_NOINTERFACE;
	}

	ULONG __stdcall AddRef() override
	{
		return InterlockedIncrement(&m_cRef);
	}

	ULONG __stdcall Release() override
	{
		const ULONG l = InterlockedDecrement(&m_cRef);
		if (l == 0)
			delete this;
		return l;
	}


private:
	ULONG m_cRef = 0;
	
// Overrides
public:
	virtual BOOL InitInstance();
	virtual int ExitInstance();

// Implementation
	UINT  m_nAppLook{};
	afx_msg void OnAppAbout();
	afx_msg void OnFileNewFrame();
	afx_msg void OnFileNew();
	DECLARE_MESSAGE_MAP()

	
};

extern CGlueMFCApp theApp;
extern IGlue42Ptr theGlue;