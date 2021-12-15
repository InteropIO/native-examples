#include "GlueCpp.h"
#include <string>

namespace GlueCOM
{
	template<typename T>
	HRESULT TraverseSA(SAFEARRAY* sa, T** items, int* count)
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
		
	HRESULT Validate()
	{
		IRecordInfo* pGlueInstanceRI;
		IRecordInfo* pGlueContextValueRI;

		if (FAILED(GetRecordInfo(__uuidof(GlueInstance), &pGlueInstanceRI)))
		{
			cout << "Failed while getting record info for GlueInstance" << endl;
			return -1;
		}

		if (FAILED(GetRecordInfo(__uuidof(GlueContextValue), &pGlueContextValueRI)))
		{
			cout << "Failed while getting record info for GlueContextValue" << endl;
			return -1;
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

		return S_FALSE;
	}

	class GlueResultHandler : public IGlueInvocationResultHandler
	{
	public:

		HRESULT HandleResult(
			SAFEARRAY* invocationResult,
			_bstr_t correlationId) {
			return S_OK;
		}

		//
		// Raw methods provided by interface
		//

		HRESULT __stdcall raw_HandleResult(
			/*[in]*/ SAFEARRAY* invocationResult,
			/*[in]*/ BSTR correlationId) override
		{

			cout << "Results!";
			void* pVoid;
			SAFEARRAY* saArray = invocationResult;
			const HRESULT hr = SafeArrayAccessData(saArray, &pVoid);

			if (SUCCEEDED(hr))
			{
				long lowerBound, upperBound; // get array bounds
				SafeArrayGetLBound(saArray, 1, &lowerBound);
				SafeArrayGetUBound(saArray, 1, &upperBound);

				const GlueInvocationResult* results = static_cast<GlueInvocationResult*>(pVoid);

				const long cnt_elements = upperBound - lowerBound + 1;
				for (int i = 0; i < cnt_elements; ++i) // iterate through returned values
				{
					const auto gcv = results[i];

					TraverseContextValues<void*, void*>(gcv.result.Values);
				}

				SafeArrayUnaccessData(saArray);
			}

			return S_OK;
		}

		HRESULT HandleResult(
			struct GlueMethod Method,
			struct GlueResult Result)
		{
			return S_OK;
		}

		HRESULT __stdcall raw_HandleResult(
			/*[in]*/ struct GlueMethod Method,
			/*[in]*/ struct GlueResult Result)
		{

			cout << _com_util::ConvertBSTRToString(Result.Message) << endl;
			TraverseContextValues<void*, void*>(Result.Values);
			//m_glue->InvokeMethod(GlueMethod{}, Result.Values, NULL, -1);
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
			if (l == 0)
				delete this;
			return l;
		}

		GlueResultHandler(IGlue42Ptr glue)
		{
			m_glue = glue;
			m_cRef = 0;
		}

	private:
		IGlue42Ptr m_glue;
		ULONG m_cRef;
	};

	class ContextBuilder : public IGlueContextBuilderCallback
	{
	public:
		ContextBuilder(int depth)
		{
			m_depth = depth;
		}

		HRESULT Build(
			struct IGlueInvocationBuilder* builder)
		{
			return S_OK;
		}

		//
		// Raw methods provided by interface
		//

		HRESULT __stdcall raw_Build(
			/*[in]*/ struct IGlueContextBuilder* builder) override
		{
			CComBSTR comBSTR(std::to_string(m_depth).c_str());
			const _bstr_t level = comBSTR.Detach();
			GlueValue gv{};
			gv.GlueType = GlueValueType_Double;
			gv.DoubleValue = 205.02032F * m_depth;
			builder->AddGlueValue(level + "_Inner_GlueValue", gv);
			builder->AddString(level + "_bam", "dam");
			builder->AddDouble(level + "_bouble", 3.5 * m_depth);
			if (m_depth > 0)
			{
				ContextBuilder inner(m_depth - 1);
				builder->BuildComposite(level + "_Inner", &inner, false);
			}
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

		ContextBuilder()
		{
			m_cRef = 0;
			m_depth = 25;
		}

	private:
		ULONG m_cRef;
		int m_depth;
	};

	class ResultHandler : public IGlueInvocationResultHandler
	{
	public:
		HRESULT HandleResult(
			SAFEARRAY* invocationResult,
			_bstr_t correlationId)
		{
			return S_OK;
		}

		HRESULT __stdcall raw_HandleResult(
			/*[in]*/ SAFEARRAY* invocationResult,
			/*[in]*/ BSTR correlationId) override
		{
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
			if (l == 0)
				delete this;
			return l;
		}

		ResultHandler()
		{
			m_cRef = 0;
		}

	private:
		ULONG m_cRef;
	};

	class GlueRequestHandler : public IGlueRequestHandler
	{
	public:

		HRESULT HandleInvocationRequest(
			struct GlueMethod Method,
			struct GlueInstance caller,
			SAFEARRAY* requestValues,
			struct IGlueServerMethodResultCallback* resultCallback) {
			return S_OK;
		}

		//
		// Raw methods provided by interface
		//

		HRESULT __stdcall raw_HandleInvocationRequest(
			/*[in]*/ struct GlueMethod Method,
			/*[in]*/ struct GlueInstance caller,
			/*[in]*/ SAFEARRAY* requestValues,
			/*[in]*/ struct IGlueServerMethodResultCallback* resultCallback) override
		{

			TraverseContextValues<void*, void*>(requestValues);

			GlueResult r{};
			r.Message = _com_util::ConvertStringToBSTR("OK, Fine!");

			GlueContextValue innerArgs[2];
			innerArgs[0] = {};
			innerArgs[0].Name = _com_util::ConvertStringToBSTR("Arg1");
			innerArgs[0].Value = {};
			innerArgs[0].Value.GlueType = GlueValueType_Double;
			innerArgs[0].Value.DoubleValue = 3.14;

			innerArgs[1] = {};
			innerArgs[1].Name = _com_util::ConvertStringToBSTR("Arg2");
			innerArgs[1].Value = {};
			innerArgs[1].Value.GlueType = GlueValueType_String;
			innerArgs[1].Value.StringValue = _com_util::ConvertStringToBSTR("Value2");


			GlueContextValue invocationArgs[2];
			invocationArgs[0] = {};
			invocationArgs[0].Name = _com_util::ConvertStringToBSTR("Arg1");
			invocationArgs[0].Value = {};
			invocationArgs[0].Value.GlueType = GlueValueType_Double;
			invocationArgs[0].Value.DoubleValue = 3.14;

			invocationArgs[1] = {};
			invocationArgs[1].Name = _com_util::ConvertStringToBSTR("DeepArg");
			invocationArgs[1].Value = {};
			invocationArgs[1].Value.GlueType = GlueValueType_Composite;
			invocationArgs[1].Value.CompositeValue = CreateContextValuesVARIANTSafeArray(innerArgs, 2, m_pGlueContextValueRI);

			const auto invocationArgsSA = CreateGlueContextValuesSafeArray(invocationArgs, 2, m_pGlueContextValueRI);

			r.Values = invocationArgsSA;

			resultCallback->SendResult(r);
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
			if (l == 0)
				delete this;
			return l;
		}

		GlueRequestHandler(IRecordInfo* pGlueContextValueRI)
		{
			m_cRef = 0;
			m_pGlueContextValueRI = pGlueContextValueRI;
		}

	private:
		ULONG m_cRef;
		IRecordInfo* m_pGlueContextValueRI;

	};

	class ServerInvocationHandler : public IGlueRequestHandler
	{
	public:
		HRESULT HandleInvocationRequest(
			struct GlueMethod Method,
			struct GlueInstance caller,
			SAFEARRAY* requestValues,
			struct IGlueServerMethodResultCallback* resultCallback)
		{

			return S_OK;
		}

		HRESULT __stdcall raw_HandleInvocationRequest(
			/*[in]*/ struct GlueMethod Method,
			/*[in]*/ struct GlueInstance caller,
			/*[in]*/ SAFEARRAY* requestValues,
			/*[in]*/ struct IGlueServerMethodResultCallback* resultCallback) override
		{
			//resultCallback->SendResult();
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
			if (l == 0)
				delete this;
			return l;
		}

		ServerInvocationHandler()
		{
			m_cRef = 0;
		}

	private:
		ULONG m_cRef;
	};

	// creates GlueInstance[]
	SAFEARRAY* CreateGlueInstanceSafeArray(GlueInstance* glueInstances, int len, IRecordInfo* recordInfo)
	{
		SAFEARRAYBOUND bounds[1];
		bounds[0].lLbound = 0;
		bounds[0].cElements = len;

		SAFEARRAY* safeargs = SafeArrayCreateEx(VT_RECORD, 1, bounds, recordInfo);

		long ind = 0;
		for (int i = 0; i < len; ++i)
		{
			SafeArrayPutElement(safeargs, &ind, &glueInstances[i]);
			ind++;
		}

		return safeargs;
	}

	// creates GlueContextValue[]
	SAFEARRAY* CreateGlueContextValuesSafeArray(GlueContextValue* values, int len, IRecordInfo* recordInfo)
	{
		SAFEARRAYBOUND bounds[1];
		bounds[0].lLbound = 0;
		bounds[0].cElements = len;

		SAFEARRAY* safeargs = SafeArrayCreateEx(VT_RECORD, 1, bounds, recordInfo);

		long ind = 0;
		for (int i = 0; i < len; ++i)
		{
			SafeArrayPutElement(safeargs, &ind, &values[i]);
			ind++;
		}

		return safeargs;
	}

	// creates GlueValue[]
	SAFEARRAY* CreateValuesSafeArray(GlueValue* values, int len, IRecordInfo* recordInfo)
	{
		SAFEARRAYBOUND bounds[1];
		bounds[0].lLbound = 0;
		bounds[0].cElements = len;

		SAFEARRAY* safeargs = SafeArrayCreateEx(VT_RECORD, 1, bounds, recordInfo);

		long ind = 0;
		for (int i = 0; i < len; ++i)
		{
			SafeArrayPutElement(safeargs, &ind, &values[i]);
			ind++;
		}

		return safeargs;
	}

	// variant[] corresponds to object[]
	SAFEARRAY* CreateContextValuesVARIANTSafeArray(GlueContextValue* contextValues, int len, IRecordInfo* recordInfo)
	{
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
			item.pRecInfo = recordInfo;
			item.pvRecord = &contextValues[i];

			SafeArrayPutElement(safeargs, &ind, &item);
			ind++;
		}

		return safeargs;
	}

	SAFEARRAY* CreateValuesVARIANTSafeArray(GlueValue* contextValues, int len, IRecordInfo* recordInfo)
	{
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
			item.pRecInfo = recordInfo;
			item.pvRecord = &contextValues[i];

			SafeArrayPutElement(safeargs, &ind, &item);
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