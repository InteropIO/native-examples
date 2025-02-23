# TCL UI demo using Glue TCL _extension_

![Image Description](glue-tcl-ui.png)

# Glue TCL Functions Reference

## **1. glue_init**
**Usage:** Initializes Glue.

```tcl
set result [glue_init "MyApp" init_callback "init_cookie"]
```

## **2. glue_subscribe_endpoints_status**
**Usage:** Subscribes to endpoint status updates.

```tcl
set subscription [glue_subscribe_endpoints_status endpoint_status_callback]
```

## **3. glue_invoke**
**Usage:** Invokes a Glue method with arguments and a callback.

```tcl
set argsDict [dict create "key" "value"]
set result [glue_invoke "method" $argsDict on_invocation_result "user_cookie"]
```

## **4. glue_register_endpoint**
**Usage:** Registers a new Glue method.

```tcl
set methodName "my_tcl_method"

proc $methodName {endpoint_name args correlation_obj cookie} {
    set methodName [lindex [info level 0] 0]
    log_message "Invoked method: $methodName with args: $args"
    set resultDict [dict create "key1" "value1" "key2" 42]
    glue_push_payload $correlation_obj $resultDict
}

glue_register_endpoint $methodName $methodName "my_custom_cookie"
log_message "Registered method: $methodName"
```

## **5. glue_raise_simple_notification**
**Usage:** Raises a notification.

```tcl
set result [glue_raise_simple_notification "Title" "Description" 1 "notif_cookie"]
```

## **6. glue_invoke_all**
**Usage:** Invokes a Glue method expecting multiple payloads.

```tcl
set argsDict [dict create "key" "value"]
set result [glue_invoke_all "method" $argsDict on_invocation_result "user_cookie"]
```

## **7. glue_subscribe_context**
**Usage:** Subscribes to a Glue context field.

```tcl
proc on_context_update {context_name field_path value user_cookie} {
    log_message "Context: $context_name, FieldPath: $field_path, Value: $value"
}

set subscription [glue_subscribe_context "context" "field" on_context_update "context_cookie"]
```

## **8. glue_register_streaming_endpoint**
**Usage:** Registers a streaming endpoint that subscribers can connect to, and Tcl can push data using `glue_push_payload`.

```tcl
set stream [glue_register_streaming_endpoint "tcl_stream"]

# Push data to the stream
set payload [dict create "timestamp" [clock seconds] "data" [dict create "key1" "value1" "key2" 42]]
glue_push_payload $stream $payload
```

## **9. glue_expose_interop_commands**
**Usage:** Defines any discovered Glue interop method as a Tcl command.

```tcl
glue_expose_interop_commands
```

