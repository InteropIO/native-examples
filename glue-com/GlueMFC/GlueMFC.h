
// GlueMFC.h : main header file for the GlueMFC application
//
#pragma once

#ifndef __AFXWIN_H__
	#error "include 'pch.h' before including this file for PCH"
#endif

#include <map>

#include "resource.h"       // main symbols


// CGlueMFCApp:
// See GlueMFC.cpp for the implementation of this class
//

class CGlueMFCApp : public CWinApp, IAppFactory, IGlueEvents
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
		else if (riid == IID_IGlueEvents)
			*ppv = static_cast<IGlueEvents*>(this);
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
		{
			// do not delete this; lifetime is MFC managed 
		}
		return l;
	}

protected:
	HRESULT __stdcall raw_HandleConnectionStatus(
		/*[in]*/ enum GlueState state,
		/*[in]*/ BSTR Message,
		/*[in]*/ __int64 date) override;
	HRESULT __stdcall raw_HandleInstanceStatus(
		/*[in]*/ struct GlueInstance Instance,
		/*[in]*/ VARIANT_BOOL active) override;
	HRESULT __stdcall raw_HandleMethodStatus(
		/*[in]*/ struct GlueMethod method,
		/*[in]*/ VARIANT_BOOL active) override;
	HRESULT __stdcall raw_HandleGlueContext(
		/*[in]*/ struct GlueContext context,
		/*[in]*/ VARIANT_BOOL created) override;
	HRESULT __stdcall raw_HandleException(
		/*[in]*/ BSTR Message,
		/*[in]*/ struct GlueValue ex);

private:
	ULONG m_cRef = 0;
	std::map<HWND, IAppAnnouncer*>* m_announcers_;

// Overrides
public:
	virtual BOOL InitInstance();
	virtual int ExitInstance();

	IAppAnnouncer* get_announcer(HWND hwnd) const;

// Implementation
	UINT  m_nAppLook{};
	afx_msg void OnAppAbout();
	void create_new_frame(IAppAnnouncer* announcer = nullptr) const;
	afx_msg void OnFileNewFrame();
	afx_msg void OnFileNew();
	DECLARE_MESSAGE_MAP()

	
};

extern CGlueMFCApp theApp;
extern IGlue42Ptr theGlue;