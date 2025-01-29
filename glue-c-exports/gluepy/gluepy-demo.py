import uuid
import platform

from gluepy import *

async def main():
    print(platform.architecture()[0])
    print("Hello from Glue Python example\n")

    result = glue_ensure_clr()
    if result == 0:
        print("glue clr successfully initialized.")
    else:
        print(f"Failed to initialize glue clr, error code: {result}")

    init_glue = initialize_glue(
            "gluepy",
            on_state_change=lambda state, message: print(f"State: {state}, Message: {message}")
        )

    print("Waiting for initialization...")
    result = await init_glue
    print(f"Glue initialization {'succeeded' if result else 'failed'}.")
    if not result:
        exit(-1)

    subscribe_endpoint_status(
        lambda endpoint_name, origin, state: print(f"{'+' if state else '-'}{endpoint_name} at {origin}")
    )

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

        notification = {
            "notification": {
                "title": "Something something dark side",
                "severity": "Low",
                "type": "Notification",
                "category": "category",
                "source": "source",
                "description": "Come to the dark side.",
                "glueRoutingDetailCallback": {
                    "name": "NotificationRoutingDetail",
                    "parameters": [
                        {
                            "customerId": "41234",
                            "notification": "$(this)"
                        }
                    ],
                },
                "actions": [
                    {
                        "name": "AcceptNotification",
                        "displayName": "Accept",
                        "description": "Accept",
                        "parameters": [
                            {
                                "customerId": "41234",
                                "customerPrice": 3.14
                            }
                        ]
                    },
                    {
                        "name": "RejectNotification",
                        "displayName": "Reject",
                        "description": "Reject",
                        "parameters": [
                            {
                                "customerId": "41234",
                                "customerPrice": 3.14
                            }
                        ]
                    }
                ],
            }
        }

        # raise complex notification with callbacks etc.
        invoke_method("T42.GNS.Publish.RaiseNotification", notification, None)

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

    print("Happy end")

asyncio.run(main())