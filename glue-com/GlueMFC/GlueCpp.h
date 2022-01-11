// contains helper functions to ease translations of safe-arrays - to be turned in a library

#pragma once
#pragma warning(disable : 0102)
#include <iostream>
#include <atlsafe.h>
#include <string>
#include <sstream>

#import "C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorlib.tlb"\
	named_guids\
	raw_interfaces_only\
	high_property_prefixes("_get","_put","_putref")\
	auto_rename

#import "C:\Users\CHANGE_ME\AppData\Local\Tick42\GlueSDK\GlueCOMv2\GlueCOM.dll"\
	named_guids\
	high_property_prefixes("_get","_put","_putref")	

using namespace std;
using namespace GlueCOM;

namespace GlueCOM
{
	inline void throw_if_fail(HRESULT hr)
	{
		if (FAILED(hr))
		{
			throw _com_error(hr);
		}
	}

	template<typename T>
	extern HRESULT TraverseSA(SAFEARRAY* sa, T** items, int* count);
	extern HRESULT DestroyValue(const GlueValue& value);
	extern HRESULT DestroyContextValuesSA(SAFEARRAY* sa);

	extern HRESULT ExtractGlueRecordInfos();

	template <typename T, typename N>
	HRESULT TraverseContextValues(SAFEARRAY* sa, T* tree = nullptr, N* node = nullptr, N(*addNode)(T*, N*, const char*, bool) = nullptr)
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

			// or Variant array with each item as GlueContextValue
			const VARIANT* inners = static_cast<VARIANT*>(pVoid);

			long cnt_elements = upperBound - lowerBound + 1;
			for (int i = 0; i < cnt_elements; ++i) // iterate through returned values
			{
				N nn;
				VARIANT vv = inners[i];
				std::cout << vv.vt << endl;
				if (vv.vt == VT_RECORD)
				{
					GlueContextValue* inner = static_cast<GlueContextValue*>(vv.pvRecord);

					if (addNode != nullptr)
					{
						char* name = _com_util::ConvertBSTRToString(inner->Name);
						nn = addNode(tree, node, name, false);
						delete[] name;
					}

					TraverseValue<T, N>(inner->Value, tree, &nn, addNode);
					continue;
				}

				GlueContextValue gcv = cvs[i];
				if (addNode != nullptr)
				{
					char* name = _com_util::ConvertBSTRToString(gcv.Name);
					nn = addNode(tree, node, name, false);
					delete[] name;
				}
				TraverseValue<T, N>(gcv.Value, tree, &nn, addNode);
			}
		}

		SafeArrayUnaccessData(sa);

		return hr;
	}

	template <typename T, typename N>
	extern HRESULT TraverseValue(GlueValue value, T* tree = nullptr, N* node = nullptr, N(*addNode)(T*, N*, const char*, bool) = nullptr)
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

				for (int i = 0; i < saValues->rgsabound[0].cElements; ++i)
				{
					GlueValue* inner = static_cast<GlueValue*>(pTuple[i].pvRecord);
					TraverseValue<T, N>(*inner, tree, node, addNode);
				}

				SafeArrayUnaccessData(saValues);
			}
			break;
			case GlueValueType_Composite:
				return TraverseContextValues<T, N>(value.CompositeValue, tree, node, addNode);
			case GlueValueType_Int:
			case GlueValueType_Long:
			case GlueValueType_DateTime:
			{
				SAFEARRAY* saValues = value.LongArray;

				void* pVoid;
				throw_if_fail(SafeArrayAccessData(saValues, &pVoid));

				const __int64* pLongs = static_cast<__int64*>(pVoid);

				for (int i = 0; i < saValues->rgsabound[0].cElements; ++i)
				{
					os << pLongs[i];
				}

				if (addNode != nullptr)
				{
					addNode(tree, node, os.str().c_str(), true);
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
				for (int i = 0; i < saValues->rgsabound[0].cElements; ++i)
				{
					os << pFloats[i];
				}

				if (addNode != nullptr)
				{
					addNode(tree, node, os.str().c_str(), true);
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

				for (int i = 0; i < saValues->rgsabound[0].cElements; ++i)
				{
					char* str = _com_util::ConvertBSTRToString(pStrings[i]);
					os << str;

					delete[] str;
				}

				if (addNode != nullptr)
				{
					addNode(tree, node, os.str().c_str(), true);
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

				for (int i = 0; i < saValues->rgsabound[0].cElements; ++i)
				{
					os << pBools[i];
				}

				if (addNode != nullptr)
				{
					addNode(tree, node, os.str().c_str(), true);
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
					addNode(tree, node, &to_string(value.DoubleValue)[0], true);
				}
				break;
			case GlueValueType_String:
				if (addNode != nullptr)
				{
					const auto str = _com_util::ConvertBSTRToString(value.StringValue);
					addNode(tree, node, str, true);
					delete[] str;
				}

				break;
			case GlueValueType_Int:
				if (addNode != nullptr)
				{
					addNode(tree, node, &to_string(value.LongValue)[0], true);
				}
				break;
			case GlueValueType_Bool:
				if (addNode != nullptr)
				{
					addNode(tree, node, &to_string(value.BoolValue)[0], true);
				}
				break;
			case GlueValueType_Long:
				if (addNode != nullptr)
				{
					addNode(tree, node, &to_string(value.LongValue)[0], true);
				}
				break;
			case GlueValueType_Composite:
				return TraverseContextValues<T, N>(value.CompositeValue, tree, node, addNode);
			case GlueValueType_DateTime:
				if (addNode != nullptr)
				{
					addNode(tree, node, &to_string(value.LongValue)[0], true);
				}
				break;
			case GlueValueType_Tuple:
				// impossible
				break;
			}
		}

		return S_OK;
	}

	extern SAFEARRAY* CreateGlueContextValuesSafeArray(GlueContextValue* values, int len);
	extern SAFEARRAY* CreateContextValuesVARIANTSafeArray(GlueContextValue* contextValues, int len);
	extern SAFEARRAY* CreateValuesSafeArray(GlueValue* values, int len);
	extern HRESULT CreateGlueContextsFromSafeArray(SAFEARRAY* sa, GlueContext** gc, long* count);
	extern HRESULT GetRecordInfo(REFGUID rGuidTypeInfo, IRecordInfo** pRecordInfo);
	extern HRESULT GetIRecordType(
		LPCTSTR lpszTypeLibraryPath,		// Path to type library that contains definition of a User-Defined Type (UDT).
		REFGUID refguid,					// GUID of UDT.
		IRecordInfo** ppIRecordInfoReceiver // Receiver of IRecordInfo that encapsulates information of the UDT.
	);

	class GlueContextHandler : public IGlueContextHandler
	{
	public:

		HRESULT HandleContext(
			struct IGlueContext* context) {
			return S_OK;
		}

		//
		// Raw methods provided by interface
		//

		HRESULT __stdcall raw_HandleContext(
			/*[in]*/ struct IGlueContext* context) override
		{
			const auto contextData = context->GetData();
			cout << "Traversing context " << _com_util::ConvertBSTRToString(context->GetContextInfo().Name) << endl;
			TraverseContextValues<void*, void*>(contextData);
			return S_OK;
		}

		HRESULT __stdcall HandleContextUpdate(
			struct IGlueContextUpdate* contextUpdate) {
			return S_OK;
		}

		//
		// Raw methods provided by interface
		//

		HRESULT __stdcall raw_HandleContextUpdate(
			/*[in]*/ struct IGlueContextUpdate* contextUpdate) override
		{
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
			if (l == 0)
				delete this;
			return l;
		}

		GlueContextHandler()
		{
			m_cRef = 0;
		}

	private:
		ULONG m_cRef;
	};
}


