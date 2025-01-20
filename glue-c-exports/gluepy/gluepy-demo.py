import uuid

from gluepy import *

async def main():
    print("Hello from Glue Python example\n")

    init_glue = initialize_glue(
            "gluepy",
            on_state_change=lambda state, message: print(f"State: {state}, Message: {message}")
        )

    print("Waiting for initialization...")
    result = await init_glue
    print(f"Glue initialization {'succeeded' if result else 'failed'}.")
    if not result:
        exit(-1)

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

    register_endpoint(
        "sum_and_product",
        lambda args, result_pusher: (
            print(f"Lambda invoked with args: {args}"),
            result_pusher.push({
                "sum": sum(value for arg in args for _, value in arg.items()),  # unpack
                "product": __import__("functools").reduce(lambda x, y: x * y,
                                                          (value for arg in args for _, value in arg.items()))
            })
        )
    )

    unsubscribe = subscribe_context(
        "MyContext2",
        "data.instrument.price",
        lambda context, field, value: print(f"Update in {context} at {field}: {value}")
    )

    while (method := input("What method to invoke (q to quit): ")) != "q":
        print(f"Invoking method: {method}")
        raise_notification(
            "Raising method " + method,
            "Invoking from Glue Python",
            GlueNotificationSeverity.glue_severity_low
        )
        invoke_method(
            method,
            {
                "hello": 3.14,
                "something_else": 51,
                "another_key": [1, 2, 3, 4, 5, 6],
                "composite": {"nested": 511, "another_level": {"value": 71}},
                "string_value": "something",
                "string_values": [str(uuid.uuid4()), str(uuid.uuid4()), str(uuid.uuid4()), str(uuid.uuid4())]
            },
            lambda result: print(f"Result: {result}")
        )

asyncio.run(main())