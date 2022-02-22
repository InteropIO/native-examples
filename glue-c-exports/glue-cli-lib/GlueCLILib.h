#pragma once
#include <type_traits>
#include <Windows.h>

#ifdef GLUE_LIBRARY_EXPORTS
#define GLUE_LIB_API __declspec(dllexport)
#else
#define GLUE_LIB_API __declspec(dllimport)
#endif

template <typename Enumeration>
std::underlying_type_t<Enumeration> enum_as_int(Enumeration const value)
{
	return static_cast<std::underlying_type_t<Enumeration>>(value);
}


enum class glue_type { glue_none, glue_bool, glue_int, glue_long, glue_double, glue_string, glue_datetime, glue_tuple, glue_composite, glue_composite_array };

struct glue_value;

#define VAL_BUILD(T, N, V, GT) \
 inline glue_value N(T V) \
 {\
	glue_value val{};\
	val.type = glue_type::GT;\
	val.len = -1;\
	val.V = V;\
	return val;\
 }

#define VAL_ARR_BUILD(T, N, V, GT) \
 inline glue_value N(T V, int len) \
 {\
	glue_value val{};\
	val.type = glue_type::GT;\
	val.len = len;\
	val.V = V;\
	return val;\
 }

#define ARG_BUILD(T, N, V, GT) \
 inline glue_arg N(const char* name, T V) \
 {\
	glue_arg t {};\
	t.name = name;\
	glue_value val{};\
	val.type = glue_type::GT;\
	val.len = -1;\
	val.V = V;\
	t.value = val;\
	return t;\
 }

#define ARR_BUILD(T, N, V, GT) \
 inline glue_arg N(const char* name, T V, int len) \
 {\
	glue_arg t {};\
	t.name = name;\
	glue_value val{};\
	val.type = glue_type::GT;\
	val.V = V;\
	val.len = len;\
	t.value = val;\
	return t;\
 }

/**
 * \brief Encapsulates all possible values that can be sent/received via Glue.
 * Use glv_ methods to wrap values as Glue values.
 */
struct glue_value
{
	union
	{
		bool b;
		int i;
		long long l;
		double d;
		const char* s;

		bool* bb;
		int* ii;
		long long* ll;
		double* dd;
		const char** ss;

		struct glue_arg* composite;
		glue_value* tuple;
	};

	glue_type type;
	int len;
};

/**
 * \brief Represents named Glue value.
 */
struct glue_arg
{
	const char* name;
	glue_value value;
};

VAL_BUILD(bool, glv_b, b, glue_bool);
VAL_BUILD(int, glv_i, i, glue_int);
VAL_BUILD(long long, glv_l, l, glue_long);
VAL_BUILD(double, glv_d, d, glue_double);
VAL_BUILD(const char*, glv_s, s, glue_string);
VAL_BUILD(long long, glv_dt, l, glue_datetime);

VAL_ARR_BUILD(bool*, glv_bb, bb, glue_bool);
VAL_ARR_BUILD(int*, glv_ii, ii, glue_int);
VAL_ARR_BUILD(long long*, glv_ll, ll, glue_long);
VAL_ARR_BUILD(double*, glv_dd, dd, glue_double);
VAL_ARR_BUILD(const char**, glv_ss, ss, glue_string);
VAL_ARR_BUILD(long long*, glv_dts, ll, glue_datetime);
VAL_ARR_BUILD(glue_value*, glv_tuple, tuple, glue_tuple);
VAL_ARR_BUILD(glue_arg*, glv_comp, composite, glue_composite);
VAL_ARR_BUILD(glue_arg*, glv_comps, composite, glue_composite_array);

ARG_BUILD(bool, glarg_b, b, glue_bool);
ARG_BUILD(int, glarg_i, i, glue_int);
ARG_BUILD(long, glarg_l, l, glue_long);
ARG_BUILD(double, glarg_d, d, glue_double);
ARG_BUILD(const char*, glarg_s, s, glue_string);
ARG_BUILD(long long, glarg_dt, l, glue_datetime);

ARR_BUILD(bool*, glarg_bb, bb, glue_bool);
ARR_BUILD(int*, glarg_ii, ii, glue_int);
ARR_BUILD(long long*, glarg_ll, ll, glue_long);
ARR_BUILD(double*, glarg_dd, dd, glue_double);
ARR_BUILD(const char**, glarg_ss, ss, glue_string);
ARR_BUILD(long long*, glarg_dts, ll, glue_datetime);
ARR_BUILD(glue_value*, glarg_tuple, tuple, glue_tuple);
ARR_BUILD(glue_arg*, glarg_comp, composite, glue_composite);
ARR_BUILD(glue_arg*, glarg_comps, composite, glue_composite_array);

/**
 * \brief Represents payload received in Glue contexts/streams/invocations from
 * certain origin.
 * Contains reader to aid consuming the data. Use glue_read_ methods.
 */
struct glue_payload
{
	const void* reader;
	const char* origin;
	int status;
	const glue_arg* args;
	int args_len;
};

/**
 * \brief Deep releases Glue array/composite value.
 * \param v The Glue value to be released.
 */
extern "C" GLUE_LIB_API void glue_delete_value(const glue_value* v);
/**
 * \brief Deep releases an array of named Glue values.
 * \param args The array of Glue values.
 * \param len The length of the array.
 */
extern "C" GLUE_LIB_API void glue_delete_args(const glue_arg* args, int len);

/**
 * \brief Deep releases an array of Glue payload items.
 * \param payloads The array of Glue payloads.
 * \param len The length of the array.
 */
extern "C" GLUE_LIB_API void delete_glue_payloads(const glue_payload* payloads, int len);

/**
 * \brief Optional pointer to a state to be passed in Glue callbacks functions.
 */
typedef const void* COOKIE;

enum class glue_state { none, connecting, connected, initialized, disconnected };

/**
 * \brief General glue status callback function.
 */
typedef void (*glue_init_callback_function)(glue_state state, const char* message, const glue_payload*, COOKIE);

enum class glue_window_command { init, channel_switch, data_update };

/**
 * \brief Callback functions for registered windows.
 *
 * glue_window_command	: window command
 *
 * const char*			: the name of the channel context
 *
 * COOKIE				: the optional callback cookie passed while registering via glue_register_window
 */

typedef void (*glue_window_callback_function)(glue_window_command command, const char* context_name, COOKIE);

/**
 * \brief Callback function for endpoint status changes (endpoints being registered/unregistered).
 */
typedef void (*glue_endpoint_status_callback_function)(const char* endpoint_name, const char* origin, bool state, COOKIE);

/**
 * \brief Callback for registered endpoints - gets called when an invocation has been received.
 *
 * The endpoint is registered via glue_register_endpoint.
 *
 * const char*			: the name of the registered endpoint
 *
 * COOKIE:				: the cookie passed while registering
 *
 * const glue_payload*		: the invocation payload
 *
 * const void*			: used to yield the invocation's result via glue_push_payload/glue_push_json_payload/glue_push_failure
 */
typedef void (*invocation_callback_function)(const char* endpoint_name, COOKIE, const glue_payload* payload, const void* endpoint);

/**
 * \brief Callback for accepting/rejecting subscription requests. Registered via glue_register_streaming_endpoint.
 *
 * const char* : the name of the registered stream
 *
 * COOKIE	: the cookie passed when registering the stream.
 *
 * const glue_payload*	: the subscription request's payload
 *
 * const char*&		: the branch to which the subscriber needs to be assigned. Use nullptr for main branch.
 *
 * Return true to accept or false to reject the subscription request.
 *
 */
typedef bool (*stream_callback_function)(const char* endpoint_name, COOKIE, const glue_payload* payload, const char*& branch);

/**
 * \brief Callback for receiving glue payload.
 * Registered via glue_invoke/glue_subscribe_stream/glue_subscribe_single_stream
 *
 * const char*		: the payload origin - method/stream name
 * const glue_payload* : the payload as sent from the origin
 * COOKIE:				: the cookie passed while registering
 */
typedef void (*payload_function)(const char* origin, COOKIE, const glue_payload* payload);

/**
 * \brief Callback for receiving payloads from multiple targets - via glue_invoke_all
 */
typedef void (*multiple_payloads_function)(const char* origin, COOKIE, const glue_payload* payloads, int len);


/**
 * \brief Callback for context reading - by reading/subscribing - glue_read_context/glue_subscribe_context
 */
typedef void (*context_function)(const char* context_name, const char* field_path, const glue_value*, COOKIE);

enum class glue_app_command { create, init, save, shutdown };

/**
 * \brief Callback for each app instance: create/init/save/shutdown.
 * state via glue_push_ methods. The payload is for the init state.
 * glue_app_create - create the app/window; use payload for the initial state and when app is ready - callback to announce via glue_app_announce_instance(callback,...)
 * glue_app_init - initialize the app - can be handled by the app itself; use payload as a restore state
 * glue_app_save - save app's state - can be handled by the app itself; use glue_push_payload/json_payload/failure(callback,...) methods to push state for saving
 * glue_app_shutdown - shutdown the app - release any resources held by the window/app instance
 */
typedef void (*app_callback_function)(glue_app_command command, const void* callback, const glue_payload* payload, COOKIE);

// init

/**
 * \brief Asynchronously initializes glue with the specified application name.
 * \param app_name The application name to be used when announcing in Glue
 * \param callback Status callback function - receiving glue status updates
 * \param cookie Optional callback cookie.
 * \return 0 if parameters are validated.
 */
extern "C" GLUE_LIB_API int __cdecl glue_init(const char* app_name, glue_init_callback_function callback = nullptr, COOKIE cookie = nullptr);

/**
 * \brief Subscribes to changes in endpoints' state - registered (method has been registered in a server), unregistered (method has been registered, or the server has been shutdown)
 * \param callback Pointer to the the callback function.
 * \param cookie Optional callback cookie.
 * \return Reference to the subscription. Call glue_destroy_resource to destroy the subscriptions.
 */
extern "C" GLUE_LIB_API const void* __cdecl glue_subscribe_endpoints_status(glue_endpoint_status_callback_function callback, COOKIE cookie = nullptr);

/**
 * \brief Sets a save callback - invoked when Glue needs to persist any user-specific data for this instance.
 * \param callback The callback to be called when save is needed.
 * \param cookie Optional callback cookie.
 * \return 0 if successful.
 */
extern "C" GLUE_LIB_API int __cdecl glue_set_save_state(invocation_callback_function callback = nullptr, COOKIE cookie = nullptr);

/**
 * \brief Registers a window in the Glue environment - this can be the 'main' window or a 'flier' window (if needed).
 * \param hwnd The handle of the window to be registered.
 * \param callback Called for any window updates.
 * \param title Optional title for the window.
 * \param cookie Optional callback cookie.
 * \param startup If this is the main/startup window - must be true.
 * \return reserved for future use.
 */
extern "C" GLUE_LIB_API const void* __cdecl glue_register_window(HWND hwnd, glue_window_callback_function callback = nullptr,
	const char* title = nullptr, COOKIE cookie = nullptr, bool startup = false);

/**
 * \brief Checks whether this process has been launched by Glue Desktop - either by app.Start() or by layout loading.
 * \return true if launched by GD
 */
extern "C" GLUE_LIB_API bool __cdecl glue_is_launched_by_gd();

/**
 * \brief Gets a reader of the Glue starting context.
 * \return Reference to the reader - use glue_read_ methods to read.
 */
extern "C" GLUE_LIB_API const void* __cdecl glue_get_starting_context_reader();

// registrations of methods/streaming endpoints

/**
 * \brief Registers an invocation endpoint.
 * \param endpoint_name The name of the endpoint (method name).
 * \param callback The callback to be invoked upon incoming invocations.
 * \param cookie Optional callback cookie.
 * \return 0 if successful.
 */
extern "C" GLUE_LIB_API int __cdecl glue_register_endpoint(const char* endpoint_name, invocation_callback_function callback = nullptr, COOKIE cookie = nullptr);

/**
 * \brief Registers a streaming endpoint.
 * \param endpoint_name The name of the endpoint (stream name).
 * \param stream_callback Optional streaming callback - to accept/reject subscribers and assign them to branches.k
 * \param invocation_callback Optional callback to be invoked if the endpoint is treated as an invocation target.
 * \param cookie Optional callback cookie.
 * \return Reference to the stream. Use glue_push_ methods to push data to the stream.
 */
extern "C" GLUE_LIB_API const void* __cdecl glue_register_streaming_endpoint(const char* endpoint_name, stream_callback_function stream_callback = nullptr, invocation_callback_function invocation_callback = nullptr, COOKIE cookie = nullptr);

/**
 * \brief Opens a branch by name in a stream registered via glue_register_streaming_endpoint and created in the stream_callback_function.
 * \param stream The stream registered via glue_register_streaming_endpoint.
 * \param branch The name of the branch as returned in stream_callback_function.
 * \return Reference to the branch. Use glue_push_ methods to push data to that specific branch.
 */
extern "C" GLUE_LIB_API const void* __cdecl glue_open_streaming_branch(const void* stream, const char* branch);

// invocations

/**
 * \brief Invokes a single (best) method by name.
 * \param endpoint_name The name of the method to be invoked.
 * \param args Invocation arguments.
 * \param len The size of the invocation arguments.
 * \param callback Callback to be called when the result is ready to be handled.
 * \param cookie Optional callback cookie.
 * \return 0 if successful.
 */
extern "C" GLUE_LIB_API int __cdecl glue_invoke(const char* endpoint_name, const glue_arg * args, int len, payload_function callback = nullptr, COOKIE cookie = nullptr);

/**
 * \brief Invokes all methods available at the moment of invocation.
 * \param endpoint_name The name of the method to be invoked - for all targets.
 * \param args Invocation arguments.
 * \param len The size of the invocation arguments.
 * \param callback Callback to be called when the result from all targets is ready to be handled.
 * \param cookie Optional callback cookie.
 * \return 0 if successful.
 */
extern "C" GLUE_LIB_API int __cdecl glue_invoke_all(const char* endpoint_name, const glue_arg * args, int len, multiple_payloads_function callback = nullptr, COOKIE cookie = nullptr);

// for testing purposes, will be removed
extern "C" GLUE_LIB_API int __cdecl glue_gc();

// reading
/**
 * \brief Reads json from a reader by field path
 * \param reader The reader that's returned from a glue_payload or glue_read_context_sync
 * \param field_path dot-separated field path - e.g. 'data.contact.displayName'
 * \return string with the data encoded as json - 'e.g' - '{x: 5, y: {a: 51, s: \"hello\"}}'
 */
extern "C" GLUE_LIB_API const char* __cdecl glue_read_json(const void* reader, const char* field_path);

/**
 * \brief Reads a glue_value from a reader by field path
 * \param reader The reader obtained from a glue_payload or glue_read_context_sync
 * \param field_path dot-separated field path - e.g. 'data.contact.displayName'
 * \return glue_value - this can be composite/tuple/array or value type
 */
extern "C" GLUE_LIB_API glue_value __cdecl glue_read_glue_value(const void* reader, const char* field_path);

/**
 * \brief Reads a boolean value from a field path in a reader.
 */
extern "C" GLUE_LIB_API bool __cdecl glue_read_b(const void* reader, const char* field_path);

/**
 * \brief Reads an integer value from a field path in a reader.
 */
extern "C" GLUE_LIB_API int __cdecl glue_read_i(const void* reader, const char* field_path);

/**
 * \brief Reads a long value from a field path in a reader.
 */
extern "C" GLUE_LIB_API long long __cdecl glue_read_l(const void* reader, const char* field_path);

/**
 * \brief Reads a double value from a field path in a reader.
 */
extern "C" GLUE_LIB_API double __cdecl glue_read_d(const void* reader, const char* field_path);

/**
 * \brief Reads a string value from a field path in a reader.
 */
extern "C" GLUE_LIB_API const char* __cdecl glue_read_s(const void* reader, const char* field_path);

// reading from contexts
/**
 * \brief Asynchronous opens a context by name and calls back with a reader in the ContextFunction callback.
 * \param context The name of the context to be opened
 * \param field_path Dot separated field path to open the reader with - e.g. 'data.contact.displayName'
 * \param callback The callback to receive the glue_value with the reader
 * \param cookie Optional callback cookie.
 * \return 0 if successful
 */
extern "C" GLUE_LIB_API int __cdecl glue_read_context(const char* context, const char* field_path, context_function callback, COOKIE cookie = nullptr);

/**
 * \brief Synchronously gets a reader of a glue context by name
 * \param context - the name of the context
 * \return the reader for the specified context
 */
extern "C" GLUE_LIB_API const void* __cdecl glue_read_context_sync(const char* context);

/**
 * \brief Writes value to a Glue context/channel in a certain field given by its path.
 * \param context The name of the Glue context.
 * \param field_path The field path under which the value will be written.
 * \param value The Glue value to be written.
 * \return 0 if successful 
 */
extern "C" GLUE_LIB_API int __cdecl glue_write_context(const char* context, const char* field_path, glue_value value);

/**
 * \brief Gets a context writer for a Glue context/channel and a field path. Use the glue_push_ methods to write.
 * \param context The name of the the Glue context.
 * \param field_path The field path for the context writer.
 * \return Reference of the context writer for the specified field path.
 */
extern "C" GLUE_LIB_API const void* __cdecl glue_get_context_writer(const char* context, const char* field_path);

// pushing to streams or invocations results

/**
 * \brief Pushes an array of Glue arguments to an endpoint (result for invocation request, stream, branch, context)
 * \param endpoint The reference to the endpoint returned by the corresponding register call.
 * \param args The pointer to the start of the array.
 * \param len The length of the arguments array.
 * \return 0 if the args were pushed successfully.
 */
extern "C" GLUE_LIB_API int __cdecl glue_push_payload(const void* endpoint, const glue_arg * args, int len);

/**
 * \brief Pushes a json payload to an endpoint (result for invocation request, stream, branch, context)
 * \param endpoint The reference to the endpoint returned by the corresponding register call.
 * \param json Well-formed json string - e.g. "{x: 5, y: {a: 51, s: \"hello\"}}"
 * \return 0 if the json string was parsed and pushed successfully.
 */
extern "C" GLUE_LIB_API int __cdecl glue_push_json_payload(const void* endpoint, const char* json);

/**
 * \brief Pushes a failure message to an endpoint (result for invocation request, app announce factory)
 * \param endpoint The reference to the endpoint returned by the corresponding register call.
 * \param message String message describing the failure.
 * \return 0 if the error was pushed successfully.
 */
extern "C" GLUE_LIB_API int __cdecl glue_push_failure(const void* endpoint, const char* message);

// subscribing to contexts/streams
/**
 * \brief Subscribes to data changes in a Glue context/channel
 * \param context The name of the context
 * \param field_path Optional subscription interest field path - when interested in updates in this particular field.
 * \param callback The callback to receive context updates.
 * \param cookie Optional callback cookie.
 * \return Reference to the subscription. Call glue_destroy_resource to destroy the subscription.
 */
extern "C" GLUE_LIB_API const void* __cdecl glue_subscribe_context(const char* context, const char* field_path, context_function callback, COOKIE cookie = nullptr);

/**
 * \brief Subscribes to all Glue streaming endpoints (publishing streams) with certain name.
 * \param stream The name of the streaming endpoint
 * \param stream_callback Callback to receive payloads from the streaming endpoints
 * \param args Subscription request arguments
 * \param len The length of the subscription request arguments
 * \param cookie Optional callback cookie.
 * \return Reference to the subscription. Call glue_destroy_resource to destroy the subscription.
 */
extern "C" GLUE_LIB_API const void* __cdecl glue_subscribe_stream(const char* stream, payload_function stream_callback, const glue_arg * args, int len, COOKIE cookie = nullptr);

/**
 * \brief Subscribes to single (best target) streaming endpoint.
 * \param stream The name of the streaming endpoint
 * \param stream_callback Callback to receive payloads from the streaming endpoint
 * \param args Subscription request arguments
 * \param len The length of the subscription request arguments
 * \param cookie Optional callback cookie.
 * \return Reference to the subscription. Call glue_destroy_resource to destroy the subscription.
 */
extern "C" GLUE_LIB_API const void* __cdecl glue_subscribe_single_stream(const char* stream, payload_function stream_callback, const glue_arg * args, int len, COOKIE cookie = nullptr);

// app factory

/**
 * \brief Registers an app factory.
 * \param app_factory The name of the app
 * \param callback Called when the Glue requires an instance of that app to be created
 * \param cookie Optional callback cookie.
 * \return Reference to the factory. Call glue_destroy_resource to unregister the app factory.
 */
extern "C" GLUE_LIB_API const void* __cdecl glue_app_register_factory(const char* app_factory, app_callback_function callback, COOKIE cookie = nullptr);

/**
 * \brief Announces a successful creation of a requested app.
 * \param app_factory_request The request received in the app_callback_function callback passed in glue_app_register_factory
 * \param hwnd The handle of the window
 * \param app_callback Receives - Init/Save/Shutdown events
 * \param window_callback Receives Glue window events
 * \param cookie Optional callback cookie.
 * \return 0 if successful
 */
extern "C" GLUE_LIB_API int __cdecl glue_app_announce_instance(const void* app_factory_request,
	HWND hwnd,
	app_callback_function app_callback,
	glue_window_callback_function window_callback,
	COOKIE cookie = nullptr);

/**
 * \brief Destroys subscriptions, streams, branches, methods, readers and releases any memory obtained by them.
 * \param resource the resource to be destroyed.
 * \return 0 if the resource has been successfully destroyed.
 */
extern "C" GLUE_LIB_API int __cdecl glue_destroy_resource(const void* resource);