// GlueCpp.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "pch.h"
#pragma warning(disable : 0102)
#include <iostream>
#include <atlsafe.h>
#include <sstream>
#include <string>
#include <thread>
#include <comdef.h>
#include <vector>
#include "GlueCPP.h"

using namespace GlueCOM;

const _bstr_t null_bstr = static_cast<char*>(nullptr);

int glue_com_loop(HANDLE init_event, IGlue42** glue42)
{
	HRESULT hr = CoInitializeEx(nullptr, COINIT_MULTITHREADED);
	if (FAILED(hr))
	{
		std::cout << "Failed while initializing COM" << std::endl;
		return -1;
	}
	hr = CoCreateInstance(CLSID_Glue42, nullptr, CLSCTX_INPROC_SERVER, IID_IGlue42, reinterpret_cast<void**>(&*glue42));
	if (FAILED(hr))
	{
		std::cout << "Failed while initializing Glue42 COM" << std::endl;
		return -1;
	}
	GlueInstance instance = {};
	instance.ApplicationName = _com_util::ConvertStringToBSTR("Glue_CPP_ConsoleApp_Demo");

	char* un_buff = nullptr;
	size_t sz = 0;
	_dupenv_s(&un_buff, &sz, "username");
	const auto user = _com_util::ConvertStringToBSTR(un_buff);
	free(un_buff);

	instance.UserName = user;
	(*glue42)->Start(instance);

	SetEvent(init_event);

	MSG msg;
	while (GetMessage(&msg, nullptr, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	throw_if_fail((*glue42)->Stop());
	return 0;
}

int main()
{
	IRecordInfo* pGlueInstanceRI;
	IRecordInfo* pGlueContextValueRI;

	if (FAILED(GetRecordInfo(__uuidof(GlueInstance), &pGlueInstanceRI)))
	{
		std::cout << "Failed while getting record info for GlueInstance" << std::endl;
		return -1;
	}

	if (FAILED(GetRecordInfo(__uuidof(GlueContextValue), &pGlueContextValueRI)))
	{
		std::cout << "Failed while getting record info for GlueContextValue" << std::endl;
		return -1;
	}

	auto init_event = CreateEvent(
		nullptr,
		TRUE,
		FALSE,
		TEXT("GlueInitEvent")
	);

	if (init_event == nullptr)
	{
		std::cout << "Something went very wrong - cannot create event" << std::endl;
		return -1;
	}

	std::cout << "\nInitializing Glue COM library..." << std::endl;

	IGlue42Ptr glue42;
	std::thread glue_com_msg_thread(glue_com_loop, init_event, &glue42);

	const auto wait_res = WaitForSingleObject(init_event, 10000);
	if (wait_res != WAIT_OBJECT_0)
	{
		std::cout << "Glue not started" << std::endl;
		std::cin.ignore();
		return -1;
	}

	std::cout << "\nGlue COM library initialized. Press enter to fetch Glue servers and Glue contexts." << std::endl;

	std::cin.ignore();

	SAFEARRAY* servers_psa = glue42->GetAllInstances();

	GlueInstance* servers;
	int severs_count;
	throw_if_fail(SafeArrayAsItemArray<GlueInstance>(servers_psa, &servers, &severs_count));

	for (int server_ix = 0; server_ix < severs_count; ++server_ix)
	{
		const auto app_name = _com_util::ConvertBSTRToString(servers[server_ix].ApplicationName);
		std::cout << app_name << std::endl;
		delete[] app_name;
	}

	GlueContext* contexts;
	int contexts_count;
	throw_if_fail(SafeArrayAsItemArray<GlueContext>(glue42->GetKnownContexts(), &contexts, &contexts_count));

	for (int i = 0; i < contexts_count; ++i) {
		const GlueContext* gc = contexts;
		const auto pc = _com_util::ConvertBSTRToString(gc->Name);
		std::cout << pc << std::endl;
		delete[] pc;
		contexts++;
	}

	std::cout << "Press enter to subscribe to the Green channel" << std::endl;
	std::cin.ignore();

	IGlueContextHandler* context_handler = new GlueContextHandler([](IGlueContext* context, IGlueContextUpdate* update, const void* cookie)
		{
			const auto contextData = context->GetData();
			const auto pc = _com_util::ConvertBSTRToString(context->GetContextInfo().Name);
			std::cout << "Traversing context " << pc << std::endl;
			delete[] pc;

			IGlue42* g = static_cast<IGlue42*>(const_cast<void*>(cookie));
			const auto gv = g->GetValueByFieldPath(contextData, L"data.contact.displayName");
			if (gv.GlueType == GlueValueType_String && gv.StringValue != nullptr)
			{
				const auto dn = _com_util::ConvertBSTRToString(gv.StringValue);
				std::cout << "Select contact's display name is: " << dn << std::endl;
				delete[] dn;
			}

			TraverseContextValues<int, int>(contextData, nullptr, nullptr,
				[](int* tree, int* node, const char* data, bool leaf, const GlueValue& value, const GlueContextValue* parent)
				{
					if (leaf)
					{
						const auto pc = _com_util::ConvertBSTRToString(parent->Name);
						std::cout << pc << " = " << data << std::endl;
						delete[] pc;
					}
					return 0;
				});
		}, glue42);

	IGlueContextPtr glue_context = glue42->GetGlueContext(L"___channel___Green");
	glue42->SubscribeGlueContext(L"___channel___Green", context_handler);

	std::cout << "Subscribed to Green. Waiting for events..." << std::endl;
	IGlueRequestHandler* request_handler = new GlueRequestHandler(pGlueContextValueRI,
		[](GlueMethod method, GlueInstance caller, SAFEARRAY* request_values, IGlueServerMethodResultCallback* result_callback, IRecordInfo* gcvRI, const void* cookie)
		{
			TraverseContextValues<int, int>(request_values, nullptr, nullptr,
				[](int* tree, int* node, const char* data, bool leaf, const GlueValue& value, const GlueContextValue* parent)
				{
					if (leaf)
					{
						const auto pc = _com_util::ConvertBSTRToString(parent->Name);
						std::cout << pc << " = " << data << std::endl;
						delete[] pc;
					}
					return 0;
				});

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
			invocationArgs[1].Value.CompositeValue =
				CreateGlueVariantSafeArray(innerArgs, 2, gcvRI);

			const auto invocationArgsSA = CreateGlueRecordSafeArray(invocationArgs, 2, gcvRI);
			r.Values = invocationArgsSA;
			result_callback->SendResult(r);

			throw_if_fail(SafeArrayDestroy(invocationArgsSA));

			// or alternatively push JSON result_callback->SendJsonValues(L"{a: 5, b: 6, c: {x: 'yes'}}");
		});

	glue42->RegisterMethod("Glue42COM", request_handler, null_bstr, null_bstr, nullptr);

	std::cout << "Waiting for calls on Glue42COM and channel subscription updates.";

	std::cin.ignore();

	std::cout << "Press enter to BuildAndInvoke JSMethod";
	std::cin.ignore();

	IGlueInvocationResultHandler* res_handler = new GlueResultHandler([](SAFEARRAY* invocation_result, BSTR correlationId, const void* cookie)
		{
			std::cout << "Got results" << std::endl;
			GlueInvocationResult* results;

			int result_count;
			const auto hr = SafeArrayAsItemArray<GlueInvocationResult>(invocation_result, &results, &result_count);

			if (FAILED(hr))
			{
				return;
			}

			for (int i = 0; i < result_count; ++i)
			{
				const GlueInvocationResult gcv = results[i];

				if (gcv.result.Message != nullptr)
				{
					const char* msg = _com_util::ConvertBSTRToString(gcv.result.Message);
					std::cout << "Result message: " << msg << std::endl;
					delete[] msg;
				}

				if (gcv.method.Instance.ApplicationName != nullptr)
				{
					const char* app = _com_util::ConvertBSTRToString(gcv.method.Instance.ApplicationName);
					std::cout << "Results from " << app << std::endl;
					delete[] app;
				}

				TraverseContextValues<int, int>(gcv.result.Values, nullptr, nullptr,
					[](int* tree, int* node, const char* data, bool leaf, const GlueValue& value, const GlueContextValue* parent)
					{
						if (leaf)
						{
							const auto pc = _com_util::ConvertBSTRToString(parent->Name);
							std::cout << pc << " = " << data << std::endl;
							delete[] pc;
						}
						return 0;
					});
			}
		});

	glue_context_builder build_args = [](IGlueContextBuilder* builder, const void* cookie)
	{
		const auto tup = *static_cast<std::tuple<glue_context_builder, int>*>(const_cast<void*>(cookie));

		glue_context_builder build_fn = std::get<0>(tup);
		int depth = std::get<1>(tup);

		CComBSTR prefix;
		throw_if_fail(prefix.Append(std::to_string(depth).c_str()));

		GlueValue gv{};
		gv.GlueType = GlueValueType_Double;
		gv.DoubleValue = 205.02032F * depth;

		builder->AddGlueValue(prefix + "_Inner_GlueValue", gv);
		builder->AddString(prefix + "_bam", "dam");
		builder->AddDouble(prefix + "_double", 3.5 * depth);
		if (depth > 0)
		{
			depth--;
			const auto inner_tuple = std::make_tuple(build_fn, depth);
			const auto inner = new ContextBuilder(build_fn, &inner_tuple);
			builder->BuildComposite(prefix + "_Inner", inner, false);
		}
	};

	const auto tuple = std::make_tuple(build_args, 7);
	IGlueContextBuilderCallback* pBuilderCallback = new ContextBuilder(build_args, &tuple);

	glue42->BuildAndInvoke(L"JSMethod", pBuilderCallback, nullptr, true, GlueInstanceIdentity_None, res_handler, 5678,
		L"correlationId1");
	std::cout << "Press enter to invoke methods" << std::endl;
	std::cin.ignore();

	GlueContextValue inner_args[2];
	inner_args[0] = {};
	inner_args[0].Name = _com_util::ConvertStringToBSTR("Arg1");
	inner_args[0].Value = {};
	inner_args[0].Value.GlueType = GlueValueType_Double;
	inner_args[0].Value.DoubleValue = 3.14;

	inner_args[1] = {};
	inner_args[1].Name = _com_util::ConvertStringToBSTR("Arg2");
	inner_args[1].Value = {};
	inner_args[1].Value.GlueType = GlueValueType_String;
	inner_args[1].Value.StringValue = _com_util::ConvertStringToBSTR("Value2");


	GlueContextValue invocation_args[2];
	invocation_args[0] = {};
	invocation_args[0].Name = _com_util::ConvertStringToBSTR("Arg1");
	invocation_args[0].Value = {};
	invocation_args[0].Value.GlueType = GlueValueType_Double;
	invocation_args[0].Value.DoubleValue = 3.14;

	invocation_args[1] = {};
	invocation_args[1].Name = _com_util::ConvertStringToBSTR("DeepArg");
	invocation_args[1].Value = {};
	invocation_args[1].Value.GlueType = GlueValueType_Composite;
	invocation_args[1].Value.CompositeValue = CreateGlueVariantSafeArray(inner_args, 2, pGlueContextValueRI);

	GlueInstance arr[3];
	arr[0] = GlueInstance{};
	arr[0].ApplicationName = _com_util::ConvertStringToBSTR("App1");
	arr[0].UserName = _com_util::ConvertStringToBSTR("User1");

	arr[1] = GlueInstance{};
	arr[1].ApplicationName = _com_util::ConvertStringToBSTR("App2");
	arr[1].UserName = _com_util::ConvertStringToBSTR("User2");

	arr[2] = GlueInstance{};
	arr[2].ApplicationName = _com_util::ConvertStringToBSTR("App3");
	arr[2].UserName = _com_util::ConvertStringToBSTR("User3");

	const auto targets_sa = CreateGlueRecordSafeArray(arr, 3, pGlueInstanceRI);

	const auto args_sa = CreateGlueRecordSafeArray(invocation_args, 2, pGlueContextValueRI);
	glue42->InvokeMethods(L"MyFavoriteGlueInvocation", args_sa, targets_sa, true,
		GlueInstanceIdentity_ApplicationName, res_handler, 12345,
		L"correlationId2");

	SafeArrayDestroy(targets_sa);
	SafeArrayDestroy(args_sa);

	std::cout << "Press enter to invoke method with json payload" << std::endl;
	std::cin.ignore();

	glue42->InvokeMethodsWithJson("JSMethod", "{a: 5, comp: {z : 5}}", nullptr, true, GlueInstanceIdentity_None, res_handler, 5678,
		L"correlationId1");

	std::cout << "\nPress enter to quit" << std::endl;
	std::cin.ignore();
	PostThreadMessage(GetThreadId(glue_com_msg_thread.native_handle()), WM_QUIT, 0, 0);

	std::cout << "\nHappy end" << std::endl;
	std::cin.ignore();

	return 0;
}