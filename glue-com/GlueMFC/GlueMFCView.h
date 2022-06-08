
// GlueMFCView.h : interface of the CGlueMFCView class
//

#pragma once

class CGlueMFCView : public CView, IGlueWindowEventHandler, IGlueApp
{
protected: // create from serialization only
	CGlueMFCView() noexcept;
	DECLARE_DYNCREATE(CGlueMFCView)

// Attributes
public:
	CGlueMFCDoc* GetDocument() const;

// Operations
public:

// Overrides
public:
	virtual void OnDraw(CDC* pDC);  // overridden to draw this view
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);

	void OnActivateView(BOOL bActivate, CView* pActivateView,
		CView* pDeactiveView) override;
	void OnActivateFrame(UINT nState, CFrameWnd* pFrameWnd) override;

	
	void OnUpdate(
		CView* pSender,
		LPARAM lHint,
		CObject* pHint) override;


protected:
// Implementation
public:
	void RegisterGlueWindow(CWnd* wnd, bool main = false);
	void OnInitialUpdate() override; // called first time after construct
	~CGlueMFCView() override;
#ifdef _DEBUG
	void AssertValid() const override;
	void Dump(CDumpContext& dc) const override;
#endif

protected:
	IGlueWindowPtr m_cGlueWindow = nullptr;
	bool main_ = true;
	bool registered_ = false;

	// Generated message map functions
protected:
	DECLARE_MESSAGE_MAP()

public:
	//
	// Raw methods provided by interface
	//

	HRESULT __stdcall raw_HandleWindowReady(
		/*[in]*/ struct IGlueWindow* GlueWindow) override;
	HRESULT __stdcall raw_HandleChannelData(
		/*[in]*/ struct IGlueWindow* GlueWindow,
		/*[in]*/ struct IGlueContextUpdate* channelUpdate) override;
	HRESULT PopulateContext(IGlueContext* context);
	HRESULT __stdcall raw_HandleChannelChanged(
		/*[in]*/ struct IGlueWindow* GlueWindow,
		/*[in]*/ struct IGlueContext* Channel,
		/*[in]*/ struct GlueContext prevChannel) override;
	HRESULT __stdcall raw_HandleWindowDestroyed(
		/*[in]*/ struct IGlueWindow* GlueWindow) override;

	HRESULT __stdcall raw_HandleWindowEvent(
		/*[in]*/ struct IGlueWindow* GlueWindow,
		/*[in]*/ enum GlueWindowEventType eventType,
		/*[in]*/ struct GlueValue eventData) override;

	HRESULT __stdcall raw_SaveState(
		struct IGlueValueReceiver* receiver) override;
	HRESULT __stdcall raw_Initialize(
		/*[in]*/ struct GlueValue state,
		/*[in]*/ struct IGlueWindow* GlueWindow) override;
	HRESULT __stdcall raw_Shutdown()  override;

	STDMETHODIMP QueryInterface(REFIID riid, void** ppv) override
	{
		if (riid == IID_IGlueWindowEventHandler || riid == IID_IUnknown)
			*ppv = static_cast<IGlueWindowEventHandler*>(this);
		else if (riid == IID_IGlueApp)
			*ppv = static_cast<IGlueApp*>(this);
		else
			*ppv = nullptr;

		if (*ppv)
		{
			AddRef();
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


private:
	ULONG m_cRef = 0;
	CTreeCtrl m_tree;
	CButton m_button;

public:

	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnSize(UINT nType, int cx, int cy);

	void OnSetGlueContextClicked();
	CTreeCtrl* GetTree()
	{
		return &m_tree;
	}
};

#ifndef _DEBUG  // debug version in GlueMFCView.cpp
inline CGlueMFCDoc* CGlueMFCView::GetDocument() const
   { return reinterpret_cast<CGlueMFCDoc*>(m_pDocument); }
#endif

