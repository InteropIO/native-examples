# depends on GlueCLILib which implements tcl-extension
load "GlueCLILib.dll"

console show
# globals
set glue_ready 0
set subscription ""
set invoke_method_name "jsmethod"
set register_method_name "tclmethod"

# UI
package require Tk
wm title . "Glue Extension UI"
grid columnconfigure . 0 -weight 1
grid rowconfigure . 3 -weight 1

# Entry for Invoking Method Name
label .invokeLabel -text "Invoke Method:"
entry .invokeEntry -textvariable invoke_method_name
grid .invokeLabel -row 0 -column 0 -padx 5 -pady 5 -sticky e
grid .invokeEntry -row 0 -column 1 -padx 5 -pady 5 -sticky ew

# Entry for Registering Method Name
label .registerLabel -text "Register Method:"
entry .registerEntry -textvariable register_method_name
grid .registerLabel -row 1 -column 0 -padx 5 -pady 5 -sticky e
grid .registerEntry -row 1 -column 1 -padx 5 -pady 5 -sticky ew

# Buttons for Glue methods
button .btnInit -text "Initialize Glue" -command {
    set result [glue_init "MyApp" init_callback "init_cookie"]
    log_message "glue_init called, result: $result"
}
button .btnSubscribe -text "Subscribe Endpoint Status" -command {
    set subscription [glue_subscribe_endpoints_status endpoint_status_callback]
    log_message "Subscribed to endpoint status updates"
}
button .btnInvoke -text "Invoke Method" -command {
    set argsDict [dict create \
        "someInt" 51 \
        "somestr" "hello" \
        "intArray" {1 2} \
        "stringArray" {"hello" "world"} \
        "composite" [dict create "key1" 123 "key2" "value"]
    ]
    set method [string trim [.invokeEntry get]]
    if {$method eq ""} {
        set method "jsmethod"
    }
    set result [glue_invoke $method $argsDict on_invocation_result "my_custom_data"]
    log_message "glue_invoke called with method: $method, result: $result"
}

# Button to Register a New Method
button .btnRegister -text "Register Method" -command {
    set methodName [string trim [.registerEntry get]]
    if {$methodName eq ""} {
        log_message "Error: Method name cannot be empty."
        return
    }
    
    proc $methodName {endpoint_name args correlation_obj cookie} {
        log_message "Invoked method: $endpoint_name correlation_obj: $correlation_obj with args: $args"
        
        # Simulate result data
        set resultDict [dict create "key1" "value1" "key2" 42]
        
        # Push result back to Glue
        after 1 [list glue_push_payload $correlation_obj $resultDict]
    }
    
    glue_register_endpoint $methodName $methodName "my_custom_cookie"
    log_message "Registered method: $methodName"
}

grid .btnInit -row 2 -column 0 -padx 5 -pady 5 -sticky ew
grid .btnSubscribe -row 2 -column 1 -padx 5 -pady 5 -sticky ew
grid .btnInvoke -row 2 -column 2 -padx 5 -pady 5 -sticky ew
grid .btnRegister -row 2 -column 3 -padx 5 -pady 5 -sticky ew

# Memo-like text widget for logging
text .log -wrap word -height 15 -width 80 -yscrollcommand {.scroll set}
scrollbar .scroll -command {.log yview}
grid .log -row 3 -column 0 -columnspan 4 -sticky nsew
grid .scroll -row 3 -column 4 -sticky ns

# Configure grid resizing
grid columnconfigure . 1 -weight 1
grid rowconfigure . 3 -weight 1

# Utility function to append logs
proc log_message {msg} {
    .log insert end "$msg\n"
    .log see end
}

# Callbacks
proc init_callback {state message payload cookie} {
    set msg "Init Callback - State: $state, Message: $message, Cookie: $cookie"
    log_message $msg
    if {$state == 3} {
        set glue_ready 1
    }
}

proc endpoint_status_callback {endpoint_name origin state cookie} {
    set msg "Endpoint Status Update - Endpoint: $endpoint_name, Origin: $origin, State: $state, Cookie: $cookie"
    log_message $msg
}

proc on_invocation_result {origin status args user_cookie} {
    set msg "Invocation Callback:\n  Origin: $origin\n  Status: $status\n  Args: $args\n  User Cookie: $user_cookie"
    log_message $msg
}

# Log startup message
log_message "UI Initialized - Ready for Glue operations!"
