
// GlueMFCView.cpp : implementation of the CGlueMFCView class
//

#include "pch.h"
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
END_MESSAGE_MAP()

// CGlueMFCView construction/destruction

CGlueMFCView::CGlueMFCView() noexcept
{
	m_cGlueWindow = nullptr;
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

HTREEITEM AddItem(CGlueMFCView *owner, HTREEITEM *node, const char *data)
{
	HTREEITEM n;
	if (node == nullptr)
	{
		n = owner->GetTree()->InsertItem(CA2W(data));
	}
	else
	{
		n = owner->GetTree()->InsertItem(CA2W(data), *node);
	}
	return n;
}

HRESULT CGlueMFCView::raw_HandleChannelData(IGlueWindow* GlueWindow, IGlueContextUpdate* channelUpdate)
{
	return PopulateContext(channelUpdate->GetContext());
}

HRESULT CGlueMFCView::PopulateContext(IGlueContext* context)
{
	m_tree.DeleteAllItems();
	auto parent = m_tree.InsertItem(context->GetContextInfo().Name, 0, 0, TVI_ROOT);
	
	TraverseContextValues<CGlueMFCView, HTREEITEM>(context->GetData(), this, &parent, &AddItem);

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

void CGlueMFCView::RegisterGlueWindow(CWnd* wnd)
{
	m_cGlueWindow = theGlue->RegisterGlueWindow(reinterpret_cast<long>(wnd->m_hWnd), this);
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
	const CRect rectDummy(0, 0, 0, 0);
	m_tree.Create(WS_CHILD | WS_VISIBLE | WS_BORDER | WS_TABSTOP,
		rectDummy, this, 0x1221);
	m_tree.SetIndent(30);

	return 0;
}


void CGlueMFCView::OnSize(UINT nType, int cx, int cy)
{
	__super::OnSize(nType, cx, cy);
	m_tree.SetWindowPos(nullptr, -1, -1, cx, cy,
	                    SWP_NOMOVE | SWP_NOZORDER | SWP_NOACTIVATE);
}
