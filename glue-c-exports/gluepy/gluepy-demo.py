import uuid

from gluepy import *

print("Hello from Glue Python example\n")

args = create_args({
    "sum": 155,
    "something_else": 5,
    "another_key": [1, 2, 3],
    "composite": {"nested": 5, "another_level": {"value": 7}}
})

# Create the event
init_event = ctypes.windll.kernel32.CreateEventW(None, True, False, None)

def glue_init_callback(state, message, glue_payload, cookie):
    print(f"Glue Init state: {state} Message: {message.decode('utf-8')}")
    if state == GlueState.CONNECTED:
        ctypes.windll.kernel32.SeexittEvent(cookie)

callback_type = GlueInitCallback(glue_init_callback)

result = glue_lib.glue_init(b"gluepy", callback_type, None)

wait_res = ctypes.windll.kernel32.WaitForSingleObject(init_event, 10000)
if wait_res != 0:  # WAIT_OBJECT_0
    print("Glue not started")

print("Python Glue initialized. Let's do some work.")

def endpoint_status_callback(endpoint_name, origin, state, cookie):
    endpoint_name = endpoint_name.decode('utf-8') if endpoint_name else ""
    origin = origin.decode('utf-8') if origin else ""
    sign = "+" if state else "-"
    print(f"{sign}{endpoint_name} at {origin}")

endpoint_status_callback_instance = GlueEndpointStatusCallback(endpoint_status_callback)
glue_lib.glue_subscribe_endpoints_status(endpoint_status_callback_instance, None)

myContext2 = glue_lib.glue_read_context_sync(b"MyContext2")
v = glue_lib.glue_read_glue_value(myContext2, b"data.instrument.price")
print(f"MyContext2::data.instrument.price = {translate_glue_value(v)}")

write_task = glue_lib.glue_write_context(b"MyContext2", b"data.instrument.price", object_to_glue_value(3.14), False)

def sum_endpoint_callback(endpoint_name, cookie, payload_ptr, result_endpoint):
    try:
        payload = payload_ptr.contents # deref

        # Translate payload to a Python-friendly object
        py_object = payload_to_object(payload)

        print(f"Sum called with arguments: {py_object}")

        # Compute the sum
        sum_value = 0
        for key, value in py_object.items():
            # Check if the value is numeric or a list of numeric values
            if isinstance(value, (int, float)):
                sum_value += value
            elif isinstance(value, list):
                sum_value += sum(v for v in value if isinstance(v, (int, float)))
            else:
                print(f"Skipping unsupported value for key '{key}': {value}")

        # Prepare the result
        args = create_args({
            "sum": sum_value,
            "something_else": 5,
            "another_key": [1, 2, 3],
            "composite": {"nested": 5, "another_level": {"value": 7}},
            "string_value": "something",
            "string_values": [str(uuid.uuid4()), str(uuid.uuid4()), str(uuid.uuid4()), str(uuid.uuid4())]
        })
        glue_lib.glue_push_payload(
            result_endpoint,
            cast(args, POINTER(GlueArg)),
            len(args),
            False
        )

    except Exception as e:
        print(f"Exception in callback: {e}")

# Create callback instance
SumEndpointCallback = CFUNCTYPE(None, c_char_p, c_void_p, POINTER(GluePayload), c_void_p)
sum_callback_instance = SumEndpointCallback(sum_endpoint_callback)

# Register the endpoint
glue_lib.glue_register_endpoint(b"sum", sum_callback_instance, None)

def invoke_callback(origin, cookie, payload_ptr):
    origin_str = origin.decode('utf-8') if origin else "NULL"

    payload = payload_ptr.contents # deref
    print(f"Origin: {origin_str}, Cookie: {cookie}, Payload Status: {payload.status}")

    # Translate payload to a Python-friendly object
    py_object = payload_to_object(payload)

    print(f"Invocation callback with arguments: {py_object}")

# Register the callback
invoke_callback_instance = PayloadFunction(invoke_callback)

args = create_args({
            "hello": 3.14,
            "something_else": 51,
            "another_key": [1, 2, 3, 4, 5, 6],
            "composite": {"nested": 511, "another_level": {"value": 71}},
            "string_value": "something",
            "string_values": [str(uuid.uuid4()), str(uuid.uuid4()), str(uuid.uuid4()), str(uuid.uuid4())]
        })

while (method := input("What method to invoke (q to quit): ")) != "q":
    print(f"Invoking method: {method}")
    glue_lib.glue_invoke(
        method.encode('utf-8'),
        cast(args, POINTER(GlueArg)),
        len(args),
        invoke_callback_instance,  # Pass the registered callback
        None
    )

