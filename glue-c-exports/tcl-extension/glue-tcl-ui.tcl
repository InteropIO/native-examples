# Load the Glue TCL extension
load "GlueCLILib.dll"

# Global variables
set glue_ready 0
set subscription ""
set invoke_method_name "jsmethod"  
set register_method_name "tclmethod"         
set notif_title "Test Notification"  
set notif_description "This is a test."  
set context_name "___channel___Red"                 
set field_path "data.partyPortfolio.ric"                    
set context_value "VOD:LN"

# Create the main UI
package require Tk
wm title . "Glue CLI UI"
grid columnconfigure . 0 -weight 1
grid rowconfigure . 9 -weight 1

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
    
    proc $methodName {correlation_obj args} {
        log_message "Invoked method: $methodName with args: $args"
        
        set resultDict [dict create "key1" "value1" "key2" 42]
        glue_push_result $correlation_obj $resultDict
    }
    
    glue_register_endpoint $methodName $methodName "my_custom_cookie"
    log_message "Registered method: $methodName"
}

grid .btnInit -row 2 -column 0 -padx 5 -pady 5 -sticky ew
grid .btnSubscribe -row 2 -column 1 -padx 5 -pady 5 -sticky ew
grid .btnInvoke -row 2 -column 2 -padx 5 -pady 5 -sticky ew
grid .btnRegister -row 2 -column 3 -padx 5 -pady 5 -sticky ew

# Entry fields for Notification Title and Description
label .notifTitleLabel -text "Notification Title:"
entry .notifTitleEntry -textvariable notif_title
grid .notifTitleLabel -row 3 -column 0 -padx 5 -pady 5 -sticky e
grid .notifTitleEntry -row 3 -column 1 -padx 5 -pady 5 -sticky ew

label .notifDescLabel -text "Notification Description:"
entry .notifDescEntry -textvariable notif_description
grid .notifDescLabel -row 4 -column 0 -padx 5 -pady 5 -sticky e
grid .notifDescEntry -row 4 -column 1 -padx 5 -pady 5 -sticky ew

# Button to Raise Notification
button .btnRaiseNotif -text "Raise Notification" -command {
    set title [string trim [.notifTitleEntry get]]
    set description [string trim [.notifDescEntry get]]
    if {$title eq "" || $description eq ""} {
        log_message "Error: Title and Description cannot be empty."
        return
    }
    
    set result [glue_raise_simple_notification $title $description 1 "notif_cookie"]
    log_message "Notification raised: Title='$title', Description='$description'"
}
grid .btnRaiseNotif -row 5 -column 0 -columnspan 2 -padx 5 -pady 5 -sticky ew

# Entry fields for Context Name and Field Path
label .contextLabel -text "Context Name:"
entry .contextEntry -textvariable context_name
grid .contextLabel -row 6 -column 0 -padx 5 -pady 5 -sticky e
grid .contextEntry -row 6 -column 1 -padx 5 -pady 5 -sticky ew

label .fieldPathLabel -text "Field Path:"
entry .fieldPathEntry -textvariable field_path
grid .fieldPathLabel -row 7 -column 0 -padx 5 -pady 5 -sticky e
grid .fieldPathEntry -row 7 -column 1 -padx 5 -pady 5 -sticky ew

label .contextValueLabel -text "Value to write:"
entry .contextValueEntry -textvariable context_value
grid .contextValueLabel -row 7 -column 2 -padx 5 -pady 5 -sticky e
grid .contextValueEntry -row 7 -column 3 -padx 5 -pady 5 -sticky ew


# Button to Subscribe to Context
button .btnSubscribeContext -text "Subscribe Context" -command {
    set context [string trim [.contextEntry get]]
    set fieldPath [string trim [.fieldPathEntry get]]
    if {$context eq "" || $fieldPath eq ""} {
        log_message "Error: Context and Field Path cannot be empty."
        return
    }

    proc on_context_update {context_name field_path value user_cookie} {
		global context_value; #get it in
		set context_value $value
        log_message "Context Update: Context='$context_name', FieldPath='$field_path', Value=$value, Cookie=$user_cookie"
    }

    set subscription [glue_subscribe_context $context $fieldPath on_context_update "context_cookie"]
    log_message "Subscribed to Context: $context, FieldPath: $fieldPath"
}

button .btnReadContext -text "Read Context" -command {
    set context [string trim [.contextEntry get]]
    set fieldPath [string trim [.fieldPathEntry get]]
    if {$context eq "" || $fieldPath eq ""} {
        log_message "Error: Context and Field Path cannot be empty."
        return
    }
    set result [glue_read_context_sync $context $fieldPath]
    log_message "Context read result: $result"
}

button .btnWriteContext -text "Write Context" -command {
    set context [string trim [.contextEntry get]]
    set fieldPath [string trim [.fieldPathEntry get]]
    if {$context eq "" || $fieldPath eq ""} {
        log_message "Error: Context and Field Path cannot be empty."
        return
    }
    set result [glue_write_context $context $fieldPath $context_value]
    log_message "Context write result: $result"
}


grid .btnSubscribeContext -row 8 -column 0 -columnspan 2 -padx 5 -pady 5 -sticky ew
grid .btnReadContext -row 8 -column 2 -columnspan 1 -padx 5 -pady 5 -sticky ew
grid .btnWriteContext -row 8 -column 3 -columnspan 1 -padx 5 -pady 5 -sticky ew

# Memo-like text widget for logging
text .log -wrap word -height 15 -width 80 -yscrollcommand {.scroll set}
scrollbar .scroll -command {.log yview}
grid .log -row 9 -column 0 -columnspan 4 -sticky nsew
grid .scroll -row 9 -column 4 -sticky ns

# Configure grid resizing
grid columnconfigure . 1 -weight 1
grid rowconfigure . 9 -weight 1

# Utility function to append logs
proc log_message {msg} {
    .log insert end "$msg\n"
    .log see end
}

# Callbacks (Restored & Working)
proc init_callback {state message payload cookie} {
    log_message "Init Callback - State: $state, Message: $message, Cookie: $cookie"
}
proc endpoint_status_callback {endpoint_name origin state cookie} {
    log_message "Endpoint Status Update - Endpoint: $endpoint_name, Origin: $origin, State: $state, Cookie: $cookie"
}
proc on_invocation_result {origin status args user_cookie} {
    log_message "Invocation Callback - Origin: $origin, Status: $status, Args: $args, User Cookie: $user_cookie"
}

# Log startup message
log_message "UI Initialized - Ready for Glue operations!"
