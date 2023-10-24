/*
 * Demonstrates usage of Glue C exports library.
 *
 * - handling invocations (registered endpoints)
 * - sending invocations to other endpoints
 * - subscribing to Glue channels (contexts)
 * - reading from Glue channels (contexts)
 * - writing to Glue channels (contexts)
 * - subscribing to Glue streams
 * - pushing to Glue streams/branches
 *
 * Note: the Glue C Exports MFC demo demonstrates:
 * - Registering Glue windows
 * - Glue app factories
 * - Saving/Restoring
 *
 */
#include <iostream>
#include <sstream>

#include "GlueCLILib.h"
#pragma comment(lib, "rpcrt4.lib")

/**
 * \brief Dumps Glue payload.
 */
void handle_payload(const char* method, COOKIE cookie, const glue_payload* payload);

/**
 * \brief Handles Glue context/channel data.
 */
void cxt_callback(const char* cxt, const char* field_path, const glue_value* v, COOKIE cookie);

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

	glue_init("glue_cpp_native", [](glue_state state, const char* message, const glue_payload* glue_payload, COOKIE cookie)
		{
			const auto glue_ready_event = const_cast<const HANDLE>(cookie);

			std::cout << "Glue Init state: " << enum_as_int(state) << " Message: " << message << std::endl;
			if (state == glue_state::connected)
			{
				SetEvent(glue_ready_event);
			}
		}, initEvent);

	const auto wait_res = WaitForSingleObject(initEvent, 10000);
	if (wait_res != WAIT_OBJECT_0)
	{
		std::cout << "Glue not started" << std::endl;
		std::cin.ignore();
		return -1;
	}

	glue_subscribe_endpoints_status([](const char* endpoint_name, const char* origin, bool state, COOKIE cookie)
		{
			std::cout << (state ? "+" : "-") << endpoint_name << " at " << origin << std::endl;
		}, nullptr);

	glue_register_endpoint("glue_native_cpp",
		[](const char* endpoint_name, COOKIE cookie, const glue_payload* payload, const void* endpoint)
		{
			std::cout << "Method " << endpoint_name << " invoked by " << payload->origin << "with " << payload->args_len << " args" << std::endl;

			std::cout << glue_read_s(payload->reader, "obj.name.first") << std::endl;

			handle_payload(endpoint_name, cookie, payload);
			/*
			// build result as structures
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
			// and then push it

			glue_push_payload(endpoint, result, std::size(result));
			*/

			// push json payload
			glue_push_json_payload(endpoint, "{x: 5, y: {a: 51, s: \"hello\"}}");

			// push failure
			//glue_push_failure(endpoint, "no, something went wrong");

			// push void(no) result
			//glue_push_payload(endpoint, nullptr, 0);

			// release any resources
		}, "invocation cookie");
	

	// get reader of the starting context
	const auto cxt = glue_get_starting_context_reader();
	auto val = glue_read_glue_value(cxt, "");

	// subscribe to the Glue Red channel to a specific field
	const void* contact_subscription = glue_subscribe_context("___channel___Red", "data.contact.displayName", &cxt_callback,
		"CONTACT: ");

	// subscribe to the Red channel to a specific field
	const void* id_sub = glue_subscribe_context("___channel___Red", "data.contact.id", &cxt_callback,
		"ID: ");

	// subscribe to a Glue stream
	glue_subscribe_stream("T42.Wnd.OnEvent", [](const char* origin, COOKIE cookie, const glue_payload* payload)
		{
			handle_payload(origin, cookie, payload);
		}, nullptr, 0, "wnd event");


	// register native Glue stream
	const auto stream = glue_register_streaming_endpoint("native_stream", [](const char* endpoint_name, COOKIE cookie, const glue_payload* payload, const char*& branch)
		{
			// optionally select a branch for that stream subscriber
			//branch = "apples";

			// return true to accept the subscription request
			return true;
		}, nullptr);

	auto get_new_guid = []()
		{
			std::string guid;

			UUID uuid = { 0 };
			UuidCreate(&uuid);

			RPC_CSTR sz_uuid = nullptr;
			if (UuidToStringA(&uuid, &sz_uuid) == RPC_S_OK)
			{
				guid = reinterpret_cast<char*>(sz_uuid);
				RpcStringFreeA(&sz_uuid);
			}

			return guid;
		};

	while (true)
	{
		std::string input;
		std::getline(std::cin, input);

		if (input == "quit")
		{
			break;
		}

		if (input == "notify")
		{
			std::string str("Notification from Native app");
			std::string description = "This is a notification raised from a native C++ app using glue-cli-lib";
			description.append("\n");
			description.append(get_new_guid());
			glue_raise_simple_notification(str.c_str(), description.c_str(), 
			                               glue_notification_severity::glue_severity_high);
			continue;
		}

		if (input.rfind("invokeall_") == 0)
		{
			std::string method = input.substr(strlen("invokeall_"));

			// send invocation to all available targets with that method
			glue_invoke_all(method.c_str(), nullptr, 0,
				[](const char* origin, COOKIE cookie, const glue_payload* payloads, int len)
				{
					std::cout << "Finished invocation of " << origin << " for " << len << " targets" << std::endl;
					for (int i = 0; i < len; ++i)
					{
						const glue_payload payload = payloads[i];
						handle_payload(origin, cookie, &payload);
					}
				}, "multiple results");
			continue;
		}

		if (input.rfind("invoke_") == 0)
		{
			std::string method = input.substr(strlen("invoke_"));

			// invoke the first (best) target with that method
			glue_invoke(method.c_str(), nullptr, 0,
				[](const char* origin, COOKIE cookie, const glue_payload* glue_payload)
				{
					handle_payload(origin, cookie, glue_payload);
				}, "single result");
			continue;
		}

		if (input.rfind("channel_", 0) == 0)
		{
			std::string channel_name = "___channel___";
			channel_name.append(input.substr(strlen("channel_")));

			// get read for channel
			const auto channel = glue_read_context_sync(channel_name.c_str());

			// async channel reading
			glue_read_context(channel_name.c_str(), "data.contact.displayName", [](const char* context_name, const char* field_path, const glue_value* glue_value, COOKIE cookie)
				{
					std::cout << context_name << "(" << field_path << ") = " << glue_value->len << std::endl;
				}, nullptr);


			// channel reading
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

			// write to the channel
			glue_write_context(channel_name.c_str(), "data.contact.displayName", glv_s("Black Smith"));

			glue_destroy_resource(channel);
			continue;
		}

		if (input.rfind("writer_") == 0)
		{
			std::string channel_name = "___channel___";
			channel_name.append(input.substr(strlen("writer_")));

			const auto writer = glue_get_context_writer(channel_name.c_str(), "data.some_field");
			glue_push_json_payload(writer, "{a: 5, y: {s: \"yes\", z: 5.155, abc: [12,3,4,5,66]}}");
			glue_destroy_resource(writer);

			continue;
		}

		if (input.rfind("push_") == 0)
		{
			std::string branch = input.substr(strlen("push_"));

			// pushing data to the registered stream

			if (branch.length() == 0)
			{
				// push to a branch selected in the subscription request acceptor
				glue_push_json_payload(stream, "{a: 5, y: {s: \"yes\", z: 5.155, abc: [12,3,4,5,66]}}");
			}
			else
			{
				// broadcast (main branch)
				glue_push_json_payload(glue_open_streaming_branch(stream, branch.c_str()), "{fruits: {type: 'apples', items: ['red', 'white']}}");
			}
			continue;
		}
	}

	CloseHandle(initEvent);
}

void cxt_callback(const char* cxt, const char* field_path, const glue_value* v, COOKIE cookie)
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


void traverse_glue_value(const glue_value& gv, std::stringstream& str)
{
#define BUILD_STR(ARR)\
        for (int ix = 0; ix < gv.len; ++ix)\
        {\
			str << gv.ARR[ix] << ",";\
        }\

	if (gv.len < 0)
	{
		switch (gv.type)
		{
		case glue_type::glue_bool: str << gv.b << std::endl; break;
		case glue_type::glue_int: str << gv.i << std::endl; break;
		case glue_type::glue_long: str << gv.l << std::endl; break;
		case glue_type::glue_double: str << gv.d << std::endl; break;
		case glue_type::glue_string: str << gv.s << std::endl; break;
		case glue_type::glue_datetime: str << gv.l << std::endl; break;
		default:;
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
		default:;
		}
		str << "]";
	}
}

void handle_payload(const char* endpoint, COOKIE cookie, const glue_payload* payload)
{
	std::cout << static_cast<const char*>(cookie) << ": Payload from " << endpoint << " with origin " <<
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