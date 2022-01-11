
// GlueMFCView.cpp : implementation of the CGlueMFCView class
//

#include "pch.h"
#include "GlueCpp.h"

#include "framework.h"
// SHARED_HANDLERS can be defined in an ATL project implementing preview, thumbnail
// and search filter handlers and allows sharing of document code with that project.
#ifndef SHARED_HANDLERS
#include "GlueMFC.h"
#endif

#include "GlueMFCDoc.h"
#include "GlueMFCView.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// CGlueMFCView

IMPLEMENT_DYNCREATE(CGlueMFCView, CView)

BEGIN_MESSAGE_MAP(CGlueMFCView, CView)
	ON_WM_CREATE()
	ON_WM_SIZE()
	ON_BN_CLICKED(1, OnSetGlueContextClicked)
END_MESSAGE_MAP()

// CGlueMFCView construction/destruction

CGlueMFCView::CGlueMFCView() noexcept
{
	// TODO: add construction code here
}

CGlueMFCView::~CGlueMFCView()
{

}

BOOL CGlueMFCView::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	const auto pc = CView::PreCreateWindow(cs);

	return pc;
}

void CGlueMFCView::OnActivateView(BOOL bActivate, CView* pActivateView, CView* pDeactiveView)
{
}

void CGlueMFCView::OnActivateFrame(UINT nState, CFrameWnd* pFrameWnd)
{
	const auto mainHwnd = theApp.GetMainWnd()->m_hWnd;
	const auto parentFrame = GetParentFrame();
	if (nState == 1 && mainHwnd != parentFrame->m_hWnd && m_cGlueWindow == nullptr)
	{
		// register child window
		RegisterGlueWindow(parentFrame);
	}
}

void CGlueMFCView::OnUpdate(CView* pSender, LPARAM lHint, CObject* pHint)
{
}

HRESULT __stdcall CGlueMFCView::raw_HandleWindowReady(
	/*[in]*/ struct IGlueWindow* GlueWindow)
{
	return S_OK;
}

HTREEITEM AddItem(CGlueMFCView *owner, HTREEITEM *node, const char *data, bool leaf)
{
	HTREEITEM n;
	CTreeCtrl* tree = owner->GetTree();
	if (node == nullptr)
	{
		n = tree->InsertItem(CA2W(data));
	}
	else
	{
		if (leaf)
		{
			CString str;
			str.Format(TEXT("%s = %hs"), tree->GetItemText(*node), data);

			tree->SetItemText(*node, str);
			n = *node;
		}
		else
		{
			n = tree->InsertItem(CA2W(data), *node);
		}
	}
	return n;
}

HRESULT CGlueMFCView::raw_HandleChannelData(IGlueWindow* GlueWindow, IGlueContextUpdate* channelUpdate)
{
	return PopulateContext(channelUpdate->GetContext());
}

HRESULT CGlueMFCView::PopulateContext(IGlueContext* context)
{
	//_variant_t first_name_as_variant = context->GetReflectData("data.contact.name.firstName"); // this will be a string
	//_variant_t contact_as_variant = context->GetReflectData("data.contact"); // this will be the safearray

	//_bstr_t first_name_as_json = context->GetDataAsJson("data.contact.name.firstName"); // if the value is a leaf you will get it as json value - {"John"}
	//_bstr_t composite_name_as_json = context->GetDataAsJson("data.contact.name"); // you will get the composite as a nice json encoded string

	auto data = context->GetData();
	m_tree.DeleteAllItems();
	auto parent = m_tree.InsertItem(context->GetContextInfo().Name, 0, 0, TVI_ROOT);
	
	TraverseContextValues<CGlueMFCView, HTREEITEM>(data, this, &parent, &AddItem);

	m_tree.Invalidate();
		
	context->Release();
	return S_OK;
}

HRESULT CGlueMFCView::raw_HandleChannelChanged(IGlueWindow* GlueWindow, IGlueContext* Channel, GlueContext prevChannel)
{
	return PopulateContext(Channel);
}

HRESULT CGlueMFCView::raw_HandleWindowDestroyed(IGlueWindow* GlueWindow)
{
	return S_OK;
}

void CGlueMFCView::RegisterGlueWindow(CWnd* wnd, bool main)
{
	auto settings = theGlue->CreateDefaultVBGlueWindowSettings();

	settings->Type = "Tab";
	settings->Title = "Something-something-dark-side";
	settings->StandardButtons = "LockUnlock, Extract, Collapse, Minimize, Maximize, Close";

	m_cGlueWindow = main ? theGlue->RegisterStartupGlueWindowWithSettings(reinterpret_cast<long>(wnd->m_hWnd), settings, this) :
		theGlue->RegisterGlueWindowWithSettings(reinterpret_cast<long>(wnd->m_hWnd), settings, this);
	settings->Release();
}

void CGlueMFCView::OnInitialUpdate()
{
}

// CGlueMFCView drawing

void CGlueMFCView::OnDraw(CDC* /*pDC*/)
{
	CGlueMFCDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);
	if (!pDoc)
		return;

	// TODO: add draw code for native data here
}


// CGlueMFCView diagnostics

#ifdef _DEBUG
void CGlueMFCView::AssertValid() const
{
	CView::AssertValid();
}

void CGlueMFCView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CGlueMFCDoc* CGlueMFCView::GetDocument() const // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CGlueMFCDoc)));
	return dynamic_cast<CGlueMFCDoc*>(m_pDocument);
}
#endif //_DEBUG


// CGlueMFCView message handlers


int CGlueMFCView::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (__super::OnCreate(lpCreateStruct) == -1)
		return -1;

	// TODO:  Add your specialized creation code here
	const LPRECT r = new tagRECT;
	this->GetWindowRect(r);

	m_button.Create(_T("Set Glue Context"), WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON,
		CRect(10, 10, 160, 30), this, 1);

	m_tree.Create(WS_CHILD | WS_VISIBLE | WS_BORDER | WS_TABSTOP,
		CRect(0, 45, 0, 0), this, 0x1221);
	m_tree.SetIndent(30);

	return 0;
}


void CGlueMFCView::OnSize(UINT nType, int cx, int cy)
{
	__super::OnSize(nType, cx, cy);
	m_tree.SetWindowPos(nullptr, -1, -1, cx, cy,
	                    SWP_NOMOVE | SWP_NOZORDER | SWP_NOACTIVATE);
}

void CGlueMFCView::OnSetGlueContextClicked()
{
	const auto context = m_cGlueWindow->GetChannelContext();
	if (context != nullptr)
	{
		// this will try and convert the value passed to variant and the 'other' side will serialize it as best as it could
		// e.g. all glue types (int, double, string ...) and respectively their arrays
		//context->SetValue("data.setMeHere.inner", "some string value");

		// alternatively you can send objects encoded as json strings
		// note that you have to pass valid json here
		//context->UpdateContextDataJson("data.setMeHere.inner", "{parent: {child: {age: 5, name:\"Jay\"}}}");

		int len = 5;
		GlueCOM::GlueContextValue* gvs = new GlueCOM::GlueContextValue[len];

		for (int i = 0; i < len; ++i)
		{
			gvs[i] = {};

			stringstream str;
			str << "key_" << i;

			gvs[i].Name = _com_util::ConvertStringToBSTR(str.str().c_str());
			// default everything
			gvs[i].Value = {};
			gvs[i].Value.GlueType = GlueCOM::GlueValueType::GlueValueType_String;
			gvs[i].Value.StringValue = _com_util::ConvertStringToBSTR("string value");
		}	

		auto sa = CreateGlueContextValuesSafeArray(gvs, len);

		context->SetContextDataOnFieldPath("data.outer.something.in.here", sa);

		SafeArrayDestroy(sa);

		// todo: deep free any allocations such as com strings - SysFreeString
	}
}
