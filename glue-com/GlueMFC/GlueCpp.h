// contains helper functions to ease translations of safe-arrays - to be turned in a library

#pragma once
#pragma warning(disable : 0102)
#include <iostream>
#include <atlsafe.h>
#include <string>
#include <sstream>
#include <tuple>
#include <vector>

#import "C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorlib.tlb"\
	named_guids\
	raw_interfaces_only\
	high_property_prefixes("_get","_put","_putref")\
	auto_rename

#import "C:\work\tick42\stash\dot-net-glue-com\GlueCom\bin\Debug\GlueCOM.dll"\
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

	inline const char* glue_type_to_string(GlueValueType gvt)
	{
		switch (gvt)
		{
		case GlueValueType_Bool: return "Bool";
		case GlueValueType_Int: return "Int";
		case GlueValueType_Double: return "Double";
		case GlueValueType_Long: return "Long";
		case GlueValueType_String: return "String";
		case GlueValueType_DateTime: return "DateTime";
		case GlueValueType_Tuple: return "Tuple";
		case GlueValueType_Composite: return "Composite";
		default: return "[Unknown GlueValueType]";
		}
	}

#define get_gv_as_array(NAME, SA, TYPE)\
	inline void NAME(const GlueValue& gv, vector<TYPE>& v)\
	{\
		SAFEARRAY* sa = gv.SA;\
		\
		void* pVoid;\
		throw_if_fail(SafeArrayAccessData(sa, &pVoid));\
		\
		const TYPE* pItems = static_cast<TYPE*>(pVoid);\
		\
		for (ULONG i = 0; i < sa->rgsabound[0].cElements; ++i)\
		{\
			v.push_back(pItems[i]);\
		}\
		\
		SafeArrayUnaccessData(sa);\
	}\

	get_gv_as_array(get_glue_longs, LongArray, long long)
	get_gv_as_array(get_glue_doubles, DoubleArray, double)
	get_gv_as_array(get_glue_bools, BoolArray, bool)

	inline void get_glue_strings(const GlueValue& gv, vector<std::string>& v)
	{
		void* pVoid;
		SAFEARRAY* saValues = gv.StringArray;
		throw_if_fail(SafeArrayAccessData(saValues, &pVoid));

		const BSTR* pStrings = static_cast<BSTR*>(pVoid);

		for (ULONG i = 0; i < saValues->rgsabound[0].cElements; ++i)
		{
			const char* str = _com_util::ConvertBSTRToString(pStrings[i]);
			v.emplace_back(str);
			delete[] str;
		}

		SafeArrayUnaccessData(saValues);
	}

	inline void get_glue_tuple(const GlueValue& gv, vector<GlueValue>& v)
	{
		SAFEARRAY* saValues = gv.Tuple;
		if (saValues == nullptr)
		{
			return;
		}

		void* pVoid;
		throw_if_fail(SafeArrayAccessData(saValues, &pVoid));
		const VARIANT* pTuple = static_cast<VARIANT*>(pVoid);

		for (ULONG i = 0; i < saValues->rgsabound[0].cElements; ++i)
		{
			const GlueValue* inner = static_cast<GlueValue*>(pTuple[i].pvRecord);
			GlueValue vv = *inner;
			v.emplace_back(vv);
		}

		SafeArrayUnaccessData(saValues);
	}

	inline void get_glue_composite(const GlueValue& gv, vector<tuple<string, GlueValue>>& v)
	{
		SAFEARRAY* sa = gv.CompositeValue;
		if (sa == nullptr)
		{
			return;
		}

		void* pVoid;
		throw_if_fail(SafeArrayAccessData(sa, &pVoid));

		const VARIANT* pComposite = static_cast<VARIANT*>(pVoid);

		for (ULONG i = 0; i < sa->rgsabound[0].cElements; ++i)
		{
			const GlueContextValue* inner = static_cast<GlueContextValue*>(pComposite[i].pvRecord);
			GlueContextValue vv = *inner;
			auto pchr = _com_util::ConvertBSTRToString(vv.Name);
			string name(pchr);
			delete[] pchr;

			v.emplace_back(std::make_tuple(name, vv.Value));
		}

		SafeArrayUnaccessData(sa);
	}

	template<typename T>
	extern HRESULT TraverseSA(SAFEARRAY* sa, T** items, int* count);
	extern HRESULT DestroyValue(const GlueValue& value);
	extern HRESULT DestroyContextValuesSA(SAFEARRAY* sa, bool is_variant_array = false);

	extern HRESULT ExtractGlueRecordInfos();

	template <typename T, typename N>
	HRESULT TraverseContextValues(SAFEARRAY* sa, T* tree = nullptr, N* node = nullptr, N(*addNode)(T*, N*, const char*, bool, const GlueValue&, const GlueContextValue*) = nullptr, bool is_variant_array = false)
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
	extern HRESULT TraverseValue(const GlueValue& value, GlueContextValue* parent = nullptr, T* tree = nullptr, N* node = nullptr, N(*addNode)(T*, N*, const char*, bool, const GlueValue&, const GlueContextValue*) = nullptr)
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
					GlueValue* inner = static_cast<GlueValue*>(pTuple[i].pvRecord);
					TraverseValue<T, N>(*inner, parent, tree, node, addNode);
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
					addNode(tree, node, &to_string(value.DoubleValue)[0], true, value, parent);
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
					addNode(tree, node, &to_string(value.LongValue)[0], true, value, parent);
				}
				break;
			case GlueValueType_Bool:
				if (addNode != nullptr)
				{
					addNode(tree, node, &to_string(value.BoolValue)[0], true, value, parent);
				}
				break;
			case GlueValueType_Long:
				if (addNode != nullptr)
				{
					addNode(tree, node, &to_string(value.LongValue)[0], true, value, parent);
				}
				break;
			case GlueValueType_Composite:
				return TraverseContextValues<T, N>(value.CompositeValue, tree, node, addNode, true);
			case GlueValueType_DateTime:
				if (addNode != nullptr)
				{
					addNode(tree, node, &to_string(value.LongValue)[0], true, value, parent);
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


