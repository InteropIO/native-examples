#include <iostream>
#include <sstream>

#define _CRTDBG_MAP_ALLOC
#include <stdlib.h>
#include <crtdbg.h>
#include <thread>
#define _USE_MATH_DEFINES
#pragma execution_character_set("utf-8")
#pragma comment(lib, "rpcrt4.lib")

#include <functional>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "GlueCLILib.h"


/**
 * \brief Dumps Glue payload.
 */
void handle_payload(const char* endpoint, COOKIE cookie, const glue_payload* payload);

void method_invoked(const char* method, const COOKIE cookie, const glue_payload* payload, const void* invocation)
{
	std::cout << "Method " << method << " invoked by " << payload->origin << "with " << payload->args_len << " args" <<
		std::endl;

	std::cout << glue_read_s(payload->reader, "obj.name.first") << std::endl;

	handle_payload(method, cookie, payload);

	/*
	glue_arg result[] = {
		glarg_i("xyz",5),
		glarg_s("some_string", "that's the one"),
		glarg_comp("sender", new glue_arg[]
		{
			glarg_comp("contact", new glue_arg[]
			{
				glarg_s("name", "xaoc")
			}, 1),
			glarg_s("email", "xaoc@xaoc.xaoc")
		}, 2),
		glarg_dt("date", 1050500),
		glarg_tuple("tuple_ibd", new glue_value[]{ glv_i(5), glv_b(true), glv_d(3.14) }, 3) };

	glue_push_payload(invocation, result, std::size(result));*/
	glue_push_json_payload(invocation, "{x: 5, y: {a: 51, s: \"hello\"}}");
	//glue_push_failure(invocation, "no, something went wrong");
	//glue_push_payload(invocation, nullptr, 0);

	// release strings and values
}

void traverse_glue_value(const glue_value& gv, std::stringstream& str)
{
#define BUILD_STR(ARR)\
        for (int ix = 0; ix < gv.len; ++ix)\
        {\
			str << gv.ARR[ix] << ",";\
        }
	if (gv.len < 0)
	{
		switch (gv.type)
		{
		case glue_type::glue_bool: str << gv.b << std::endl;
			break;
		case glue_type::glue_int: str << gv.i << std::endl;
			break;
		case glue_type::glue_long: str << gv.l << std::endl;
			break;
		case glue_type::glue_double: str << gv.d << std::endl;
			break;
		case glue_type::glue_string: str << gv.s << std::endl;
			break;
		case glue_type::glue_datetime: str << gv.l << std::endl;
			break;
		default: ;
		}
	}
	else
	{
		str << "(" << gv.len << ")" << "[";
		switch (gv.type)
		{
		case glue_type::glue_bool:
			BUILD_STR(bb)
			break;
		case glue_type::glue_int:
			BUILD_STR(ii)
			break;
		case glue_type::glue_long:
			BUILD_STR(ll)
			break;
		case glue_type::glue_double:
			BUILD_STR(dd)
			break;
		case glue_type::glue_string:
			BUILD_STR(ss)
			break;
		case glue_type::glue_datetime:
			BUILD_STR(ll)
			break;
		case glue_type::glue_tuple:
			for (int i = 0; i < gv.len; ++i)
			{
				traverse_glue_value(gv.tuple[i], str);
			}
			break;
		case glue_type::glue_composite:
		case glue_type::glue_composite_array:
			for (int i = 0; i < gv.len; ++i)
			{
				const auto arg = gv.composite[i];
				str << arg.name << " = ";
				traverse_glue_value(arg.value, str);
			}
			break;
		default: ;
		}
		str << "]";
	}
}

void handle_payload(const char* endpoint, const COOKIE cookie, const glue_payload* payload)
{
	std::cout << (cookie == nullptr ? "" : static_cast<const char*>(cookie)) << ": Payload from " << (endpoint == nullptr ? "" : endpoint) << " with origin " <<
		(payload->origin != nullptr ? payload->origin : "NULL") << " with status " << payload->status << std::endl;

	for (int i = 0; i < payload->args_len; ++i)
	{
		const auto arg = payload->args[i];
		std::cout << arg.name << " = ";

		const auto gv = arg.value;
		std::stringstream str;
		traverse_glue_value(gv, str);
		std::cout << str.str() << std::endl;
	}
	std::cout << std::endl;
}

void invocation_results(const char* method, const COOKIE cookie, const glue_payload* results, const int len)
{
	std::cout << "Finished invocation of " << method << " for " << len << " targets" << std::endl;
	for (int i = 0; i < len; ++i)
	{
		const auto r = results[i];
		glue_payload payload = {results[i].reader, r.origin, r.status, r.args, r.args_len};
		handle_payload(method, cookie, &payload);
	}
}

/**
 * \brief Handles Glue context/channel data.
 */
void cxt_callback(const char* cxt, const char* field_path, const glue_value* v, const COOKIE cookie)
{
	if (v == nullptr)
	{
		std::cout << static_cast<const char*>(cookie) << "NULL" << std::endl;
		return;
	}

	if (v->type == glue_type::glue_string)
	{
		std::cout << static_cast<const char*>(cookie) << v->s << std::endl;
	}
}

void stream_data(const char* stream, const COOKIE cookie, const glue_payload* glue_payload)
{
	handle_payload(stream, cookie, glue_payload);
}

std::string get_new_guid()
{
	std::string guid;

	UUID uuid = {0};
	UuidCreate(&uuid);

	RPC_CSTR sz_uuid = nullptr;
	if (UuidToStringA(&uuid, &sz_uuid) == RPC_S_OK)
	{
		guid = reinterpret_cast<char*>(sz_uuid);
		RpcStringFreeA(&sz_uuid);
	}

	return guid;
}

int main()
{
	HANDLE initEvent = CreateEvent(
		nullptr,
		TRUE,
		FALSE,
		TEXT("GlueInitEvent")
	);

	if (initEvent == nullptr)
	{
		std::cout << "Something went very wrong - cannot create event" << std::endl;
		return 0;
	}

	std::cout << "Hello Glue Native World!" << std::endl;

	struct Globals {
		std::unordered_set<std::string> registrations;
		using callback_lambda = std::function<void(const glue_payload*)>;
		std::unordered_map<std::string, callback_lambda> handlers;
	} globals;

	glue_init("glue_cpp_native",
	          [](const glue_state state, const char* message, const glue_payload* glue_payload, const COOKIE cookie)
	          {
		          std::cout << "Glue Init state: " << enum_as_int(state) << " Message: " << message << std::endl;
		          if (state == glue_state::connected)
		          {
			          const auto glue_ready_event = const_cast<HANDLE>(cookie);
			          SetEvent(glue_ready_event);
		          }
	          }, initEvent);

	const auto wait_res = WaitForSingleObject(initEvent, 20000);
	if (wait_res != WAIT_OBJECT_0)
	{
		std::cout << "Glue not started" << std::endl;
		std::cin.ignore();
		return -1;
	}

	const void* write_status = glue_write_context("MyContext", "data.instrument.price", glv_d(3.14));

	glue_subscribe_endpoints_status([](const char* endpoint_name, const char* origin, const bool state, COOKIE cookie)
	{
		std::cout << (state ? "+" : "-") << endpoint_name << " at " << origin << std::endl;
	}, nullptr);

	glue_register_endpoint("sum", [](const char* endpoint_name, COOKIE cookie, const glue_payload* payload,
	                                 const void* result_endpoint)
	{
		const auto args = payload->args;
		if (payload->args_len < 2)
		{
			glue_push_failure(result_endpoint, "Incorrect number of arguments.");
			return;
		}

		long long sum = 0;
		for (int i = 0; i < payload->args_len; i++)
		{
			switch (args[i].value.type)
			{
			case glue_type::glue_int:
				sum += args[i].value.i;
				break;
			case glue_type::glue_long:
				sum += args[i].value.l;
				break;
			default:
				// skip non whole args
				break;
			}
		}

		const glue_arg result[] = {glarg_l("sum", sum)};
		glue_push_payload(result_endpoint, result, 1);
	});

	glue_register_endpoint("glue_native_cpp",
	                       [](const char* endpoint_name, const COOKIE cookie, const glue_payload* payload,
	                          const void* endpoint)
	                       {
		                       std::cout << "Method " << endpoint_name << " invoked by " << payload->origin << "with "
			                       << payload->args_len << " args" << std::endl;

		                       std::cout << glue_read_s(payload->reader, "obj.name.first") << std::endl;

		                       handle_payload(endpoint_name, cookie, payload);

		                       /*
		                       glue_arg result[] = {
			                       glarg_i("xyz",5),
			                       glarg_s("some_string", "that's the one"),
			                       glarg_comp("sender", new glue_arg[]
			                       {
				                       glarg_comp("contact", new glue_arg[]
				                       {
					                       glarg_s("name", "xaoc")
				                       }, 1),
				                       glarg_s("email", "xaoc@xaoc.xaoc")
			                       }, 2),
			                       glarg_dt("date", 1645551286008l),
			                       glarg_tuple("tuple_ibd", new glue_value[]{ glv_i(5), glv_b(true), glv_d(3.14) }, 3) };
		                       */

		                       //glue_push_payload(endpoint, result, std::size(result));
		                       glue_push_json_payload(endpoint, "{x: 5, y: {a: 51, s: \"hello\"}}");
		                       //glue_push_failure(endpoint, "no, something went wrong");
		                       //glue_push_payload(endpoint, nullptr, 0);

		                       // release any resources
	                       }, "invocation cookie");

	const auto cxt = glue_get_starting_context_reader();
	auto val = glue_read_glue_value(cxt, "");

	// subscribe to the Glue Red channel to a specific field
	const void* contact_subscription = glue_subscribe_context("___channel___Red", "data.contact.displayName",
	                                                          [](const char* context_name, const char* field_path,
	                                                             const glue_value* glue_value, const COOKIE cookie)
	                                                          {
		                                                          if (glue_value == nullptr)
		                                                          {
			                                                          std::cout << static_cast<const char*>(cookie) <<
				                                                          "NULL" << std::endl;
			                                                          return;
		                                                          }

		                                                          if (glue_value->type == glue_type::glue_string)
		                                                          {
			                                                          std::cout << static_cast<const char*>(cookie) <<
				                                                          glue_value->s << std::endl;
		                                                          }
	                                                          }, "CONTACT: ");

	// subscribe to the Glue Red channel to a specific field
	const void* id_sub = glue_subscribe_context("___channel___Red", "data.contact.id", &cxt_callback,
	                                            "ID: ");

	glue_subscribe_stream("T42.Wnd.OnEvent", [](const char* origin, const COOKIE cookie, const glue_payload* payload)
	{
		handle_payload(origin, cookie, payload);
	}, nullptr, 0, "wnd event");

	const auto stream = glue_register_streaming_endpoint("cli_stream",
	                                                     [](const char* endpoint_name, COOKIE cookie,
	                                                        const glue_payload* payload, const char*& branch)
	                                                     {
		                                                     //branch = "apples";
		                                                     return true;
	                                                     }, nullptr);

	glue_subscribe_single_stream("cli_stream", [](const char* origin, COOKIE cookie, const glue_payload* payload)
	{
	}, nullptr, 0);


	while (true)
	{
		std::string input;
		std::getline(std::cin, input);

		if (input == "gc")
		{
			glue_gc();
		}
		else if (input == "dump")
		{
			_CrtDumpMemoryLeaks();
		}
		else if (input == "quit")
		{
			break;
		}
		else if (input == "notify")
		{
			std::string str("Notification from Native app");
			std::string description = "This is a notification raised from a native C++ app using glue-cli-lib";
			description.append("\n");
			description.append(get_new_guid());
			glue_raise_simple_notification(str.c_str(), description.c_str(),
				glue_notification_severity::glue_severity_high);
		}
		else if (input == "bbg_fn")
		{
			std::string sec;
			std::cout << "Enter security: ";
			std::getline(std::cin, sec);

			std::vector<std::string> storage;
			storage.push_back(sec);

			std::vector<const char*> securities;
			securities.push_back(storage.back().c_str());

			glue_arg args[] = {
				glarg_s("mnemonic", "GP"),
				glarg_s("tabName", "ChartTab"),
				glarg_ss("securities", securities.data(), 1),
			};

			glue_invoke("T42.BBG.RunFunction", args, std::size(args),
				[](const char* origin, const COOKIE cookie, const glue_payload* payload)
				{
					handle_payload(origin, cookie, payload);
				}, "bbg");
		}
		else if (input == "bbg_req")
		{
			auto bbg_request_callback = "OnBBGMDFData";
			if (globals.registrations.insert(bbg_request_callback).second)
			{
				glue_register_endpoint(bbg_request_callback, [](const char* endpoint_name, COOKIE cookie, const glue_payload* payload, const void* result_endpoint) {
					// ack
					glue_push_payload(result_endpoint, nullptr, 0);

					std::cout << "Method " << endpoint_name << " invoked by " << payload->origin << " with " << payload->args_len << " args" << std::endl;
					std::string cor_id = glue_read_s(payload->reader, "requestCorrelationId");
					const Globals* globals = static_cast<const Globals*>(cookie);
					auto it = globals->handlers.find(cor_id);
					if (it != globals->handlers.end())
						it->second(payload);
					}, &globals);
			}

			auto request_id = get_new_guid();
			globals.handlers[request_id] = [request_id](const glue_payload* payload) {
				std::cout << "Callback for request " << request_id << " received." << std::endl;
				handle_payload(nullptr, nullptr, payload);
				};

			std::vector<glue_arg> sessionOptions = {
				glarg_s("serverHost", "localhost"),
				glarg_i("serverPort", 8194)
			};

			std::vector<glue_arg> settings = {
				glarg_comp("sessionOptions", sessionOptions.data(), sessionOptions.size()),
				glarg_s("sessionName", "")
			};

			std::vector<glue_arg> operationArgs = {
				glarg_dt("startDateTime", 1546300800000),
				glarg_dt("endDateTime", 1573344000000),
				glarg_s("eventType", "TRADE"),
				glarg_i("maxDataPoints", 100),
				glarg_b("returnEids", true),
				glarg_i("interval", 60),
				glarg_s("security", "IBM US Equity")
			};

			std::vector<glue_arg> args = {
				glarg_s("requestCorrelationId", request_id.data()),
				glarg_comp("settings", settings.data(), settings.size()),
				glarg_s("service", "//blp/refdata"),
				glarg_s("operation", "IntradayBarRequest"),
				glarg_comp("operationArgs", operationArgs.data(), operationArgs.size()),
				glarg_s("callbackMethod", bbg_request_callback)
			};

			glue_invoke("T42.MDFApi.CreateRequest", args.data(), args.size(),
			            [](const char* origin, const COOKIE cookie, const glue_payload* payload)
			            {
				            std::cout << "Invocation response from " << origin << std::endl;
				            handle_payload(origin, cookie, payload);
			            }, "bbg request");
		}
		else if (input == "bbg_sub")
		{
			auto bbg_sub_callback = "OnBBGMDFSubData";
			if (globals.registrations.insert(bbg_sub_callback).second)
			{
				glue_register_endpoint(bbg_sub_callback,
					[](const char* endpoint_name, const COOKIE cookie, const glue_payload* payload,
						const void* result_endpoint)
					{
						//std::cout << "Method " << endpoint_name << " invoked by " << payload->origin << " with " << payload->args_len << " args" << std::endl;
						// ack
						glue_push_payload(result_endpoint, nullptr, 0);

						const std::string cor_id = glue_read_s(payload->reader, "requestCorrelationId");
						auto globals = static_cast<const Globals*>(cookie);
						const auto it = globals->handlers.find(cor_id);
						if (it != globals->handlers.end())
							it->second(payload);
					}, &globals);
			}

			auto request_id = get_new_guid();
			globals.handlers[request_id] = [request_id](const glue_payload* payload)
				{
					std::cout << "Callback for subscription " << request_id << " received." << std::endl;
					//handle_payload(nullptr, nullptr, payload);
					const auto last = glue_read_d(payload->reader, "msg.eventMessages[0].MarketDataEvents.LAST_PRICE");
					const auto bid = glue_read_d(payload->reader, "msg.eventMessages[0].MarketDataEvents.BID");
					const auto ask = glue_read_d(payload->reader, "msg.eventMessages[0].MarketDataEvents.ASK");

					std::cout << "Last: " << last << ", Bid: " << bid << ", Ask: " << ask << std::endl;
				};

			std::vector<glue_arg> sessionOptions = {
				glarg_s("serverHost", "localhost"),
				glarg_i("serverPort", 8194)
			};

			std::vector<glue_arg> settings = {
				glarg_comp("sessionOptions", sessionOptions.data(), sessionOptions.size()),
				glarg_s("sessionName", "")
			};

			std::vector<glue_arg> subscription1 = {
				glarg_s("subscriptionId", request_id.data()),
				glarg_s("security", "IBM US Equity"),
				glarg_s("fields", "LAST_PRICE,BID,ASK,BID_YIELD,ASK_YIELD")
			};

			std::vector<glue_arg> subscriptions = {
				glarg_comp("1", subscription1.data(), subscription1.size())
			};

			// Build the top-level args vector
			std::vector<glue_arg> args = {
				glarg_s("requestCorrelationId", request_id.data()),
				glarg_comp("settings", settings.data(), settings.size()),
				glarg_s("service", "//blp/mktdata"),
				glarg_comps("subscriptions", subscriptions.data(), subscriptions.size()),
				glarg_s("callbackMethod", bbg_sub_callback)
			};

			glue_invoke("T42.MDFApi.CreateSubscriptionRequest", args.data(), args.size(),
			            [](const char* origin, const COOKIE cookie, const glue_payload* payload)
			            {
				            std::cout << "Invocation response from " << origin << std::endl;
				            handle_payload(origin, cookie, payload);
			            }, "subscription request");
		}
		else if (input.rfind("invokeall_") == 0)
		{
			std::string method = input.substr(strlen("invokeall_"));
			glue_invoke_all(method.c_str(), nullptr, 0,
				[](const char* origin, const COOKIE cookie, const glue_payload* payloads, const int len)
				{
					std::cout << "Finished invocation of " << origin << " for " << len << " targets" <<
						std::endl;
					for (int i = 0; i < len; ++i)
					{
						std::cout << (payloads[i].status == 0
							? std::to_string(payloads[i].args[0].value.l)
							: "No result.");

						const glue_payload payload = payloads[i];
						handle_payload(origin, cookie, &payload);
					}
				}, "multiple results");
		}
		else if (input.rfind("invoke_") == 0)
		{
			std::string method = input.substr(strlen("invoke_"));
			glue_invoke(method.c_str(), nullptr, 0,
				[](const char* origin, const COOKIE cookie, const glue_payload* glue_payload)
				{
					handle_payload(origin, cookie, glue_payload);
				}, "single result");
		}
		else if (input.rfind("channel_", 0) == 0)
		{
			std::string channel_name = "___channel___";
			channel_name.append(input.substr(strlen("channel_")));
			const auto channel = glue_read_context_sync(channel_name.c_str());

			glue_read_context(channel_name.c_str(), "data.contact.displayName",
				[](const char* context_name, const char* field_path, const glue_value* glue_value,
					COOKIE cookie)
				{
					std::cout << context_name << "(" << field_path << ") = " << (glue_value == nullptr
						? "null"
						: glue_value->s) << std::endl;
				}, nullptr);

			const glue_value v = glue_read_glue_value(channel, "data.contact.psn");

			if (v.type == glue_type::glue_string)
			{
				std::cout << "Display name as glue value: " << v.s << std::endl;
			}

			if (const auto read_s = glue_read_s(channel, "data.contact.displayName"))
			{
				std::cout << "Prev " << channel_name << " display name: " << read_s << std::endl;
			}

			if (const auto read_json = glue_read_json(channel, "data.contact.name"))
			{
				std::cout << "Prev " << channel_name << " composite name: " << read_json << std::endl;
			}

			if (const auto read_json = glue_read_json(channel, "data.contact.displayName"))
			{
				std::cout << "Prev " << channel_name << " display name: " << read_json << std::endl;
			}

			glue_write_context(channel_name.c_str(), "data.contact.displayName", glv_s("Black Smith"));

			glue_destroy_resource(channel);
		}
		else if (input.rfind("writer_") == 0)
		{
			std::string channel_name = "___channel___";
			channel_name.append(input.substr(strlen("writer_")));

			const auto writer = glue_get_context_writer(channel_name.c_str(), "data.some_field");
			auto json = "{a: 5, y: {s: \"yes\", z: 5.155, abc: [12,3,4,5,66]}, cyrillic: 'Кирил и Методий'}";
			glue_push_json_payload(writer, json);
			glue_destroy_resource(writer);

			auto r = glue_read_context_sync(channel_name.c_str());
			auto zz = glue_read_json(r, "data.some_field");

			std::cout << glue_read_json(r, nullptr);
			std::string ss = zz;

			std::cout << ss << std::endl;
		}
		else if (input.rfind("push_") == 0)
		{
			std::string branch = input.substr(strlen("push_"));

			if (branch.length() == 0)
			{
				glue_push_json_payload(stream, "{a: 5, y: {s: \"yes\", z: 5.155, abc: [12,3,4,5,66]}}");
			}
			else
			{
				glue_push_json_payload(glue_open_streaming_branch(stream, branch.c_str()),
					"{fruits: {type: 'apples', items: ['red', 'white']}}");
			}
		}
	}

	CloseHandle(initEvent);
}
