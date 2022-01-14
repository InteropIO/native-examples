
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

HTREEITEM AddItem(CGlueMFCView* owner, HTREEITEM* node, const char* data, const bool leaf, const GlueValue& value, const GlueContextValue* gcv)
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

			str.Format(TEXT("%s [%hs] = %hs"), gcv->Name, glue_type_to_string(value.GlueType), data);

			if (value.IsArray)
			{
				switch (value.GlueType)
				{
				case GlueValueType_Bool:
				{
					vector<bool> v;
					get_glue_bools(value, v);
					break;
				}
				case GlueValueType_Int:
				case GlueValueType_Long:
				case GlueValueType_DateTime:
				{
					vector<long long> v;
					get_glue_longs(value, v);
					break;
				}
				case GlueValueType_String:
				{
					vector<string> v;
					get_glue_strings(value, v);
					break;
				}
				case GlueValueType_Double: 
				{
					vector<double> v;
					get_glue_doubles(value, v);
					break;
				}
				default:;
				}
			}

			tree->SetItemText(*node, str);
			tree->SetItemState(*node, TVIS_BOLD, ~TVIS_BOLD);

			n = *node;
		}
		else
		{
			if (value.GlueType == GlueValueType_Tuple)
			{
				vector<GlueValue> v;
				get_glue_tuple(value, v);
			} else if (value.GlueType == GlueValueType_Composite)
			{
				vector<tuple<string, GlueValue>> v;
				get_glue_composite(value, v);
			}

			stringstream s;
			s << "(+) " << data << "[" << glue_type_to_string(value.GlueType) << "]";
			tree->SetItemState(*node, TVIS_BOLD, TVIS_BOLD);
			n = tree->InsertItem(CA2W(s.str().c_str()), *node);
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

	vector<tuple<string, GlueValue>> v;
	get_glue_top_composite(context->GetData(), v);

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

#pragma warning( push )
#pragma warning( disable : 4302 )
#pragma warning( disable : 4311 )
	const long hwnd = reinterpret_cast<long>(wnd->m_hWnd);
#pragma warning( pop )

	m_cGlueWindow = main ? theGlue->RegisterStartupGlueWindowWithSettings(hwnd, settings, this) :
		                theGlue->RegisterGlueWindowWithSettings(hwnd, settings, this);
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

#pragma warning( push )
#pragma warning( disable : 4267 )
#pragma warning( disable : 4018 )

		int len = 100;
		auto gvs = std::make_unique<GlueContextValue[]>(len);
		
		for (int ix = 0; ix < len; ++ix)
		{
			gvs[ix] = {};

			stringstream str;
			str << "key_" << ix;

			gvs[ix].Name = _com_util::ConvertStringToBSTR(str.str().c_str());
			// default everything
			gvs[ix].Value = {};
			if (ix % 5 == 0)
			{
				// build a composite
				gvs[ix].Value.GlueType = GlueValueType_Composite;

				// use smart pointer (or a static array if smart pointers cannot be used)
				constexpr int composite_len = 10;
				auto composite = std::make_unique<GlueContextValue[]>(composite_len);
				
				// if this is dynamically created - it needs to be freed after!
				for (int cmp_ix = 0; cmp_ix < composite_len; ++cmp_ix)
				{
					composite[cmp_ix] = {};
					composite[cmp_ix].Value = {};
					stringstream field_name;
					if (cmp_ix % 2 == 0)
					{
						field_name << "dbl_field";
						composite[cmp_ix].Value.GlueType = GlueValueType_Double;
						composite[cmp_ix].Value.DoubleValue = 3.14 * (cmp_ix + 1.0);
					}
					else
					{
						field_name << "string_field";
						composite[cmp_ix].Value.GlueType = GlueValueType_String;
						composite[cmp_ix].Value.StringValue = _com_util::ConvertStringToBSTR("valval");
					}

					field_name << "_" << cmp_ix;

					// the name of a composite need to be different
					composite[cmp_ix].Name = _com_util::ConvertStringToBSTR(field_name.str().c_str());
				}

				gvs[ix].Value.CompositeValue = CreateContextValuesVARIANTSafeArray(composite.get(), composite_len);
			}
			else if (ix % 4 == 0)
			{
				gvs[ix].Value.GlueType = GlueCOM::GlueValueType::GlueValueType_String;
				gvs[ix].Value.StringValue = _com_util::ConvertStringToBSTR("string value");
			}
			else if (ix % 3 == 0)
			{
				gvs[ix].Value.GlueType = GlueValueType_Double;
				gvs[ix].Value.IsArray = true;

				SAFEARRAYBOUND bounds[1];
				bounds[0].lLbound = 0;
				double dbl_arr[5] = { 3.14 + ix, 5.1 + ix, 6.7 + ix, 8.1 + ix, 9.2 + ix };

				bounds[0].cElements = std::size(dbl_arr);

				auto dbl_sa = SafeArrayCreate(VT_R8, 1, bounds);
				for (long dbl_ix = 0; dbl_ix < bounds[0].cElements; ++dbl_ix)
				{
					throw_if_fail(SafeArrayPutElement(dbl_sa, &dbl_ix, &dbl_arr[dbl_ix]));
				}

				gvs[ix].Value.DoubleArray = dbl_sa;
			}
			else
			{
				gvs[ix].Value.GlueType = GlueValueType_Int;
				gvs[ix].Value.IsArray = true;

				SAFEARRAYBOUND bounds[1];
				bounds[0].lLbound = 0;
				long long ll_arr[5] = { 552 * ix, 744 * ix, 1203 * ix, 9348 * ix, 2939 * ix };
				bounds[0].cElements = std::size(ll_arr);

				auto lng_sa = SafeArrayCreate(VT_I8, 1, bounds);
				for (long l_ix = 0; l_ix < bounds[0].cElements; ++l_ix)
				{
					throw_if_fail(SafeArrayPutElement(lng_sa, &l_ix, &ll_arr[l_ix]));
				}

				gvs[ix].Value.LongArray = lng_sa;
			}
		}
#pragma warning( pop )

		auto sa = CreateGlueContextValuesSafeArray(gvs.get(), len);

		context->SetContextDataOnFieldPath("data.outer.something.in.here", sa);

		// destroy the safe array
		throw_if_fail(SafeArrayDestroy(sa));

		// the memory reserved by the main array will be destroyed as it's in a smart pointer
	}
}
