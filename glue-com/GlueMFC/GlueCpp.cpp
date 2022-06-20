#include "GlueCpp.h"
#include <string>

namespace GlueCOM
{
	template<typename T>
	HRESULT SafeArrayAsItemArray(SAFEARRAY* sa, T** items, int* count)
	{
		void* pVoid;
		const HRESULT hr = SafeArrayAccessData(sa, &pVoid);

		if (SUCCEEDED(hr))
		{
			long lowerBound, upperBound; // get array bounds
			SafeArrayGetLBound(sa, 1, &lowerBound);
			SafeArrayGetUBound(sa, 1, &upperBound);

			*items = static_cast<T*>(pVoid);

			*count = upperBound - lowerBound + 1;

			return hr;
		}

		return S_FALSE;
	}

	// creates T[]
	template <typename T>
	SAFEARRAY* CreateGlueRecordSafeArray(T* items, int len, IRecordInfo* recordInfo)
	{
		SAFEARRAYBOUND bounds[1];
		bounds[0].lLbound = 0;
		bounds[0].cElements = len;

		SAFEARRAY* psa = SafeArrayCreateEx(VT_RECORD, 1, bounds, recordInfo);

		long ind = 0;
		for (int i = 0; i < len; ++i)
		{
			throw_if_fail(SafeArrayPutElement(psa, &ind, &items[i]));
			ind++;
		}

		return psa;
	}

	// variant[] corresponds to object[]
	template <typename T>
	SAFEARRAY* CreateGlueVariantSafeArray(T* items, int len, IRecordInfo* recordInfo)
	{
		SAFEARRAYBOUND bounds[1];
		bounds[0].lLbound = 0;
		bounds[0].cElements = len;

		SAFEARRAY* psa = SafeArrayCreate(VT_VARIANT, 1, bounds);

		long ind = 0;
		for (int i = 0; i < len; ++i)
		{
			VARIANT item;
			VariantInit(&item);
			item.vt = VT_RECORD;
			item.pRecInfo = recordInfo;
			item.pvRecord = &items[i];

			throw_if_fail(SafeArrayPutElement(psa, &ind, &item));
			ind++;
		}

		return psa;
	}

	IRecordInfo* ri_glue_instance;
	IRecordInfo* ri_glue_context_value;
	IRecordInfo* ri_glue_value;

	HRESULT DestroyValue(const GlueValue& value)
	{
		if (value.IsArray)
		{
			switch (value.GlueType)
			{
			case GlueValueType_Tuple:
			{
				SAFEARRAY* saValues = value.Tuple;
				if (saValues == nullptr)
				{
					return S_OK;
				}

				void* pVoid;
				throw_if_fail(SafeArrayAccessData(saValues, &pVoid));
				const VARIANT* pTuple = static_cast<VARIANT*>(pVoid);

				for (ULONG i = 0; i < saValues->rgsabound[0].cElements; ++i)
				{
					GlueValue* inner = static_cast<GlueValue*>(pTuple[i].pvRecord);
					DestroyValue(*inner);
				}

				throw_if_fail(SafeArrayUnaccessData(saValues));
				throw_if_fail(SafeArrayDestroy(saValues));
			}
			break;
			case GlueValueType_Composite:
				return DestroyContextValuesSA(value.CompositeValue, true);
			case GlueValueType_Int:
			case GlueValueType_Long:
			case GlueValueType_DateTime:
			{
				SAFEARRAY* saValues = value.LongArray;
				throw_if_fail(SafeArrayDestroy(saValues));
			}
			break;
			case GlueValueType_Double:
			{
				SAFEARRAY* saValues = value.DoubleArray;
				throw_if_fail(SafeArrayDestroy(saValues));
			}
			break;

			case GlueValueType_String:
			{
				void* pVoid;
				SAFEARRAY* saValues = value.StringArray;
				throw_if_fail(SafeArrayAccessData(saValues, &pVoid));

				const BSTR* pStrings = static_cast<BSTR*>(pVoid);

				for (ULONG i = 0; i < saValues->rgsabound[0].cElements; ++i)
				{
					SysFreeString(pStrings[i]);
				}

				throw_if_fail(SafeArrayUnaccessData(saValues));
				throw_if_fail(SafeArrayDestroy(saValues));
			}
			break;
			case GlueValueType_Bool:
			{
				SAFEARRAY* saValues = value.BoolArray;
				throw_if_fail(SafeArrayDestroy(saValues));
			}
			break;
			}
		}
		else
		{
			switch (value.GlueType)
			{
			case GlueValueType_String:
				SysFreeString(value.StringValue);
				break;
			case GlueValueType_Composite:
				return DestroyContextValuesSA(value.CompositeValue, true);
			default:
				break;
			}
		}

		return S_OK;
	}

	HRESULT DestroyContextValuesSA(SAFEARRAY* sa, bool is_variant_array)
	{
		void* pVoid;
		throw_if_fail(SafeArrayAccessData(sa, &pVoid));

		long lowerBound, upperBound; // get array bounds
		SafeArrayGetLBound(sa, 1, &lowerBound);
		SafeArrayGetUBound(sa, 1, &upperBound);

		// it's either array of GlueContextValue
		const GlueContextValue* cvs = static_cast<GlueContextValue*>(pVoid);

		// or Variant array with each item as GlueContextValue
		const VARIANT* inners = static_cast<VARIANT*>(pVoid);

		long cnt_elements = upperBound - lowerBound + 1;
		for (int i = 0; i < cnt_elements; ++i) // iterate through returned values
		{
			if (is_variant_array)
			{
				VARIANT vv = inners[i];
				assert(vv.vt == VT_RECORD);
				GlueContextValue* inner = static_cast<GlueContextValue*>(vv.pvRecord);

				SysFreeString(inner->Name);
				DestroyValue(inner->Value);
				continue;
			}

			GlueContextValue gcv = cvs[i];

			SysFreeString(gcv.Name);
			DestroyValue(gcv.Value);
		}

		throw_if_fail(SafeArrayUnaccessData(sa));
		SafeArrayReleaseData(sa->pvData);
		throw_if_fail(SafeArrayDestroyDescriptor(sa));

		return S_OK;
	}

	HRESULT ExtractGlueRecordInfos()
	{
		if (ri_glue_instance == nullptr)
		{
			throw_if_fail(GetRecordInfo(__uuidof(GlueInstance), &ri_glue_instance));
		}

		if (ri_glue_context_value == nullptr)
		{
			throw_if_fail(GetRecordInfo(__uuidof(GlueContextValue), &ri_glue_context_value));
		}

		if (ri_glue_value == nullptr)
		{
			throw_if_fail(GetRecordInfo(__uuidof(GlueValue), &ri_glue_value));
		}

		return S_OK;
	}

	HRESULT CreateGlueContextsFromSafeArray(SAFEARRAY* sa, GlueContext** gc, long* count) {
		void* pVoid;
		const HRESULT hr = SafeArrayAccessData(sa, &pVoid);

		if (SUCCEEDED(hr))
		{
			long lowerBound, upperBound; // get array bounds
			SafeArrayGetLBound(sa, 1, &lowerBound);
			SafeArrayGetUBound(sa, 1, &upperBound);

			*gc = static_cast<GlueContext*>(pVoid);

			*count = upperBound - lowerBound + 1;

			return hr;
		}

		SafeArrayUnaccessData(sa);

		return S_FALSE;
	}

	class GlueResultHandler : public IGlueInvocationResultHandler
	{
	public:
		//
		// Raw methods provided by interface
		//

		HRESULT __stdcall raw_HandleResult(
			/*[in]*/ SAFEARRAY* invocationResult,
			/*[in]*/ BSTR correlationId) override
		{
			handler_(invocationResult, correlationId);

			return S_OK;
		}

		STDMETHODIMP QueryInterface(REFIID riid, void** ppv) override
		{
			if (riid == IID_IGlueInvocationResultHandler || riid == IID_IUnknown)
				*ppv = static_cast<IGlueInvocationResultHandler*>(this);
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
			// if (l == 0) dont delete this;
			return l;
		}

		GlueResultHandler(glue_result_handler handler) : handler_(handler)
		{
			m_cRef = 0;
		}

	private:
		ULONG m_cRef;
		glue_result_handler handler_;
	};

	class ContextBuilder : public IGlueContextBuilderCallback
	{
	public:
				
		//
		// Raw methods provided by interface
		//

		HRESULT __stdcall raw_Build(
			/*[in]*/ struct IGlueContextBuilder* builder) override
		{
			builder_(builder, cookie_);
			return S_OK;
		}

		STDMETHODIMP QueryInterface(REFIID riid, void** ppv) override
		{
			if (riid == IID_IGlueContextBuilderCallback || riid == IID_IUnknown)
				*ppv = static_cast<IGlueContextBuilderCallback*>(this);
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

		ContextBuilder(glue_context_builder builder, const void* cookie = nullptr): builder_(builder), cookie_(cookie)
		{
			m_cRef = 0;
		}

	private:
		ULONG m_cRef;
		glue_context_builder builder_;
		const void* cookie_;
	};

	class GlueRequestHandler : public IGlueRequestHandler
	{
	public:
		//
		// Raw methods provided by interface
		//

		HRESULT __stdcall raw_HandleInvocationRequest(
			/*[in]*/ struct GlueMethod Method,
			/*[in]*/ struct GlueInstance caller,
			/*[in]*/ SAFEARRAY* requestValues,
			/*[in]*/ struct IGlueServerMethodResultCallback* resultCallback) override
		{

			handler_(Method, caller, requestValues, resultCallback, m_pGlueContextValueRI);

			return S_OK;
		}

		STDMETHODIMP QueryInterface(REFIID riid, void** ppv) override
		{
			if (riid == IID_IGlueRequestHandler || riid == IID_IUnknown)
				*ppv = static_cast<IGlueRequestHandler*>(this);
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
			// if (l == 0) dont delete this;
			return l;
		}

		GlueRequestHandler(IRecordInfo* pGlueContextValueRI, glue_request_handler handler) : handler_(handler) {
			m_cRef = 0;
			m_pGlueContextValueRI = pGlueContextValueRI;
		}

	private:
		ULONG m_cRef;
		IRecordInfo* m_pGlueContextValueRI;
		glue_request_handler handler_;
	};

	// creates GlueInstance[]
	SAFEARRAY* CreateGlueInstanceSafeArray(GlueInstance* glueInstances, int len)
	{
		throw_if_fail(ExtractGlueRecordInfos());

		SAFEARRAYBOUND bounds[1];
		bounds[0].lLbound = 0;
		bounds[0].cElements = len;

		SAFEARRAY* sa = SafeArrayCreateEx(VT_RECORD, 1, bounds, ri_glue_instance);

		long ind = 0;
		for (int i = 0; i < len; ++i)
		{
			throw_if_fail(SafeArrayPutElement(sa, &ind, &glueInstances[i]));
			ind++;
		}

		return sa;
	}

	// creates GlueContextValue[]
	SAFEARRAY* CreateGlueContextValuesSafeArray(GlueContextValue* values, int len)
	{
		throw_if_fail(ExtractGlueRecordInfos());

		SAFEARRAYBOUND bounds[1];
		bounds[0].lLbound = 0;
		bounds[0].cElements = len;

		SAFEARRAY* sa = SafeArrayCreateEx(VT_RECORD, 1, bounds, ri_glue_context_value);

		for (long ix = 0; ix < len; ++ix)
		{
			throw_if_fail(SafeArrayPutElement(sa, &ix, &values[ix]));
		}

		return sa;
	}

	// creates GlueValue[]
	SAFEARRAY* CreateValuesSafeArray(GlueValue* values, int len)
	{
		throw_if_fail(ExtractGlueRecordInfos());

		SAFEARRAYBOUND bounds[1];
		bounds[0].lLbound = 0;
		bounds[0].cElements = len;

		SAFEARRAY* safeargs = SafeArrayCreateEx(VT_RECORD, 1, bounds, ri_glue_value);

		long ind = 0;
		for (int i = 0; i < len; ++i)
		{
			throw_if_fail(SafeArrayPutElement(safeargs, &ind, &values[i]));
			ind++;
		}

		return safeargs;
	}

	// variant[] corresponds to object[]
	SAFEARRAY* CreateContextValuesVARIANTSafeArray(GlueContextValue* contextValues, int len)
	{
		throw_if_fail(ExtractGlueRecordInfos());

		SAFEARRAYBOUND bounds[1];
		bounds[0].lLbound = 0;
		bounds[0].cElements = len;

		SAFEARRAY* safeargs = SafeArrayCreate(VT_VARIANT, 1, bounds);

		long ind = 0;
		for (int i = 0; i < len; ++i)
		{
			VARIANT item;
			VariantInit(&item);
			item.vt = VT_RECORD;
			item.pRecInfo = ri_glue_context_value;
			item.pvRecord = &contextValues[i];

			throw_if_fail(SafeArrayPutElement(safeargs, &ind, &item));
			ind++;
		}

		return safeargs;
	}

	SAFEARRAY* CreateValuesVARIANTSafeArray(GlueValue* contextValues, int len)
	{
		throw_if_fail(ExtractGlueRecordInfos());

		SAFEARRAYBOUND bounds[1];
		bounds[0].lLbound = 0;
		bounds[0].cElements = len;

		SAFEARRAY* safeargs = SafeArrayCreate(VT_VARIANT, 1, bounds);

		long ind = 0;
		for (int i = 0; i < len; ++i)
		{
			VARIANT item;
			VariantInit(&item);
			item.vt = VT_RECORD;
			item.pRecInfo = ri_glue_value;
			item.pvRecord = &contextValues[i];

			throw_if_fail(SafeArrayPutElement(safeargs, &ind, &item));
			ind++;
		}

		return safeargs;
	}

	HRESULT GetIRecordType(
		LPCTSTR lpszTypeLibraryPath,		// Path to type library that contains definition of a User-Defined Type (UDT).
		REFGUID refguid,					// GUID of UDT.
		IRecordInfo** ppIRecordInfoReceiver // Receiver of IRecordInfo that encapsulates information of the UDT.
	)
	{
		const _bstr_t bstTypeLibraryPath = lpszTypeLibraryPath;
		ITypeLib* pTypeLib = nullptr;
		ITypeInfo* pTypeInfo = nullptr;
		HRESULT hrRet = S_OK;

		*ppIRecordInfoReceiver = nullptr; // Initialize receiver.

		hrRet = LoadTypeLib(bstTypeLibraryPath, &pTypeLib);

		if (SUCCEEDED(hrRet))
		{
			if (pTypeLib)
			{
				hrRet = pTypeLib->GetTypeInfoOfGuid(refguid, &pTypeInfo);
				pTypeLib->Release();
				pTypeLib = nullptr;
			}

			if (pTypeInfo)
			{
				hrRet = GetRecordInfoFromTypeInfo(pTypeInfo, ppIRecordInfoReceiver);
				pTypeInfo->Release();
				pTypeInfo = nullptr;
			}
		}

		return hrRet;
	}

	HRESULT GetRecordInfo(REFGUID rGuidTypeInfo, IRecordInfo** pRecordInfo)
	{
		const HRESULT hr = GetRecordInfoFromGuids(LIBID_GlueCOM, 2, 0, LOCALE_USER_DEFAULT, rGuidTypeInfo, pRecordInfo);
		if (FAILED(hr))
		{
			cout << "Failed while getting record info for " << &rGuidTypeInfo << endl;
		}

		return hr;
	}
} // namespace GlueInterop