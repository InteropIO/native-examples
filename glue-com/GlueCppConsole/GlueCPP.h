#pragma once
#include <iostream>
#include <atlsafe.h>
#include <sstream>
#include <string>
#include <comdef.h>

inline void throw_if_fail(const HRESULT hr)
{
	if (FAILED(hr))
	{
		throw _com_error(hr);
	}
}

#import "C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorlib.tlb"\
	named_guids\
	raw_interfaces_only\
	high_property_prefixes("_get","_put","_putref")\
	auto_rename

#import "C:\work\tick42\stash\dot-net-glue-com\GlueCom\bin\Debug\GlueCOM.dll"\
	named_guids\
	high_property_prefixes("_get","_put","_putref")	

namespace GlueCOM
{
	template <typename T>
	SAFEARRAY* CreateGlueRecordSafeArray(T* values, int len, IRecordInfo* recordInfo);
	template <typename T>
	SAFEARRAY* CreateGlueVariantSafeArray(T* contextValues, int len, IRecordInfo* recordInfo);

	template <typename T, typename N>
	using add_node = N(*)(T* tree, N* node, const char* data, bool leaf, const GlueValue& value, const GlueContextValue* parent);

	template <typename T, typename N>
	HRESULT TraverseValue(const GlueValue& value, GlueContextValue* parent = nullptr, T* tree = nullptr, N* node = nullptr, add_node<T, N> addNode = nullptr);

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

	template <typename T, typename N>
	HRESULT TraverseContextValues(SAFEARRAY* sa, T* tree = nullptr, N* node = nullptr, add_node<T, N> addNode = nullptr, bool is_variant_array = false)
	{
		void* pVoid;
		HRESULT hr = SafeArrayAccessData(sa, &pVoid);
		throw_if_fail(hr);

		if (SUCCEEDED(hr))
		{
			long lowerBound, upperBound; // get array bounds
			SafeArrayGetLBound(sa, 1, &lowerBound);
			SafeArrayGetUBound(sa, 1, &upperBound);

			// it's either array of GlueContextValue
			const GlueContextValue* cvs = static_cast<GlueContextValue*>(pVoid);

			// or Variant array with each item as GlueContextValue (when this is composite)
			const VARIANT* inners = static_cast<VARIANT*>(pVoid);

			long cnt_elements = upperBound - lowerBound + 1;
			for (int i = 0; i < cnt_elements; ++i) // iterate through returned values
			{
				N nn;

				if (is_variant_array)
				{
					VARIANT vv = inners[i];
					assert(vv.vt == VT_RECORD);
					GlueContextValue* inner = static_cast<GlueContextValue*>(vv.pvRecord);

					auto glue_value = inner->Value;
					if (addNode != nullptr)
					{
						char* name = _com_util::ConvertBSTRToString(inner->Name);
						nn = addNode(tree, node, name, false, glue_value, inner);
						delete[] name;
					}

					TraverseValue<T, N>(glue_value, inner, tree, &nn, addNode);
					continue;
				}

				GlueContextValue gcv = cvs[i];
				if (addNode != nullptr)
				{
					char* name = _com_util::ConvertBSTRToString(gcv.Name);
					nn = addNode(tree, node, name, false, gcv.Value, &gcv);
					delete[] name;
				}
				TraverseValue<T, N>(gcv.Value, &gcv, tree, &nn, addNode);
			}
		}

		SafeArrayUnaccessData(sa);

		return hr;
	}

	template <typename T, typename N>
	HRESULT TraverseValue(const GlueValue& value, GlueContextValue* parent, T* tree, N* node, add_node<T, N> addNode)
	{
		if (value.IsArray)
		{
			std::ostringstream os;
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
					const GlueValue* inner = static_cast<GlueValue*>(pTuple[i].pvRecord);

					const GlueValue tuple_item = *inner;
					auto tuple_node = addNode(tree, node, std::to_string(i).c_str(), false, tuple_item, parent);
					TraverseValue<T, N>(tuple_item, parent, tree, &tuple_node, addNode);
				}

				SafeArrayUnaccessData(saValues);
			}
			break;
			case GlueValueType_Composite:
				return TraverseContextValues<T, N>(value.CompositeValue, tree, node, addNode, true);
			case GlueValueType_Int:
			case GlueValueType_Long:
			case GlueValueType_DateTime:
			{
				SAFEARRAY* saValues = value.LongArray;

				void* pVoid;
				throw_if_fail(SafeArrayAccessData(saValues, &pVoid));

				const long long* pLongs = static_cast<long long*>(pVoid);

				for (ULONG i = 0; i < saValues->rgsabound[0].cElements; ++i)
				{
					os << pLongs[i];
					if (i < saValues->rgsabound[0].cElements - 1)
					{
						os << ", ";
					}
				}

				if (addNode != nullptr)
				{
					addNode(tree, node, os.str().c_str(), true, value, parent);
				}

				SafeArrayUnaccessData(saValues);
			}
			break;
			case GlueValueType_Double:
			{
				void* pVoid;
				SAFEARRAY* saValues = value.DoubleArray;
				throw_if_fail(SafeArrayAccessData(saValues, &pVoid));

				const double* pFloats = static_cast<double*>(pVoid);
				for (ULONG i = 0; i < saValues->rgsabound[0].cElements; ++i)
				{
					os << pFloats[i];
					if (i < saValues->rgsabound[0].cElements - 1)
					{
						os << ", ";
					}
				}

				if (addNode != nullptr)
				{
					addNode(tree, node, os.str().c_str(), true, value, parent);
				}

				SafeArrayUnaccessData(saValues);
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
					const char* str = _com_util::ConvertBSTRToString(pStrings[i]);
					os << str;
					if (i < saValues->rgsabound[0].cElements - 1)
					{
						os << ", ";
					}

					delete[] str;
				}

				if (addNode != nullptr)
				{
					addNode(tree, node, os.str().c_str(), true, value, parent);
				}

				SafeArrayUnaccessData(saValues);
			}
			break;
			case GlueValueType_Bool:
			{
				void* pVoid;
				SAFEARRAY* saValues = value.BoolArray;
				throw_if_fail(SafeArrayAccessData(saValues, &pVoid));

				const bool* pBools = static_cast<bool*>(pVoid);

				for (ULONG i = 0; i < saValues->rgsabound[0].cElements; ++i)
				{
					os << pBools[i];
					if (i < saValues->rgsabound[0].cElements - 1)
					{
						os << ", ";
					}
				}

				if (addNode != nullptr)
				{
					addNode(tree, node, os.str().c_str(), true, value, parent);
				}

				SafeArrayUnaccessData(saValues);
			}
			break;
			}
		}
		else
		{
			switch (value.GlueType)
			{
			case GlueValueType_Double:
				if (addNode != nullptr)
				{
					addNode(tree, node, &std::to_string(value.DoubleValue)[0], true, value, parent);
				}
				break;
			case GlueValueType_String:
				if (addNode != nullptr)
				{
					const auto str = _com_util::ConvertBSTRToString(value.StringValue);
					addNode(tree, node, str, true, value, parent);
					delete[] str;
				}

				break;
			case GlueValueType_Int:
				if (addNode != nullptr)
				{
					addNode(tree, node, &std::to_string(value.LongValue)[0], true, value, parent);
				}
				break;
			case GlueValueType_Bool:
				if (addNode != nullptr)
				{
					addNode(tree, node, &std::to_string(value.BoolValue)[0], true, value, parent);
				}
				break;
			case GlueValueType_Long:
				if (addNode != nullptr)
				{
					addNode(tree, node, &std::to_string(value.LongValue)[0], true, value, parent);
				}
				break;
			case GlueValueType_Composite:
				return TraverseContextValues<T, N>(value.CompositeValue, tree, node, addNode, true);
			case GlueValueType_DateTime:
				if (addNode != nullptr)
				{
					addNode(tree, node, &std::to_string(value.LongValue)[0], true, value, parent);
				}
				break;
			case GlueValueType_Tuple:
				// impossible
				break;
			}
		}

		return S_OK;
	}

	typedef void (*glue_context_builder)(IGlueContextBuilder* builder, const void* cookie);
	typedef void (*glue_result_handler)(SAFEARRAY* invocationResult, BSTR correlationId, const void* cookie);
	typedef void (*glue_context_handler)(IGlueContext* context, IGlueContextUpdate* update, const void* cookie);
	typedef void (*glue_request_handler)(GlueMethod method, GlueInstance caller, SAFEARRAY* request_values, IGlueServerMethodResultCallback* result_callback,
		IRecordInfo* gcv_ri, const void* cookie);

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
			handler_(invocationResult, correlationId, cookie_);

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

		explicit GlueResultHandler(glue_result_handler handler, const void* cookie = nullptr) : handler_(handler), cookie_(cookie)
		{
			m_cRef = 0;
		}

	private:
		ULONG m_cRef;
		glue_result_handler handler_;
		const void* cookie_;
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

		explicit ContextBuilder(glue_context_builder builder, const void* cookie = nullptr) : builder_(builder), cookie_(cookie)
		{
			m_cRef = 0;
		}

	private:
		ULONG m_cRef;
		glue_context_builder builder_;
		const void* cookie_;
	};

	class GlueContextHandler : public IGlueContextHandler
	{
	public:

		//
		// Raw methods provided by interface
		//

		HRESULT __stdcall raw_HandleContext(
			/*[in]*/ struct IGlueContext* context) override
		{
			handler_(context, nullptr, cookie_);
			return S_OK;
		}

		//
		// Raw methods provided by interface
		//

		HRESULT __stdcall raw_HandleContextUpdate(
			/*[in]*/ struct IGlueContextUpdate* contextUpdate) override
		{
			const auto context = contextUpdate->GetContext();
			handler_(context, contextUpdate, cookie_);
			return S_OK;
		}

		STDMETHODIMP QueryInterface(REFIID riid, void** ppv) override
		{
			if (riid == IID_IGlueContextHandler || riid == IID_IUnknown)
				*ppv = static_cast<IGlueContextHandler*>(this);
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

		explicit GlueContextHandler(glue_context_handler handler, const void* cookie = nullptr) : handler_(handler), cookie_(cookie)
		{
			m_cRef = 0;
		}

	private:
		ULONG m_cRef;
		glue_context_handler handler_;
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

			handler_(Method, caller, requestValues, resultCallback, m_pGlueContextValueRI, cookie_);

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

		GlueRequestHandler(IRecordInfo* pGlueContextValueRI, glue_request_handler handler, const void* cookie = nullptr) : handler_(handler), cookie_(cookie)
		{
			m_cRef = 0;
			m_pGlueContextValueRI = pGlueContextValueRI;
		}

	private:
		ULONG m_cRef;
		IRecordInfo* m_pGlueContextValueRI;
		glue_request_handler handler_;
		const void* cookie_;
	};

	// creates SAFEARRAY of T[]
	template <typename T>
	SAFEARRAY* CreateGlueRecordSafeArray(T* values, const int len, IRecordInfo* recordInfo)
	{
		SAFEARRAYBOUND bounds[1];
		bounds[0].lLbound = 0;
		bounds[0].cElements = len;

		SAFEARRAY* psa = SafeArrayCreateEx(VT_RECORD, 1, bounds, recordInfo);

		long ind = 0;
		for (int i = 0; i < len; ++i)
		{
			throw_if_fail(SafeArrayPutElement(psa, &ind, &values[i]));
			ind++;
		}

		return psa;
	}

	// creates SAFEARRAY of object[] (variant[] corresponds to object[])
	template <typename T>
	SAFEARRAY* CreateGlueVariantSafeArray(T* contextValues, const int len, IRecordInfo* recordInfo)
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
			item.pvRecord = &contextValues[i];

			throw_if_fail(SafeArrayPutElement(psa, &ind, &item));
			ind++;
		}

		return psa;
	}

	HRESULT GetRecordInfo(REFGUID rGuidTypeInfo, IRecordInfo** pRecordInfo)
	{
		const HRESULT hr = GetRecordInfoFromGuids(LIBID_GlueCOM, 2, 0, LOCALE_USER_DEFAULT, rGuidTypeInfo, pRecordInfo);
		if (FAILED(hr))
		{
			std::cout << "Failed while getting record info for " << &rGuidTypeInfo << std::endl;
		}

		return hr;
	}
} // namespace GlueInterop