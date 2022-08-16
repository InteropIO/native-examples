VERSION 5.00
Begin VB.Form ChildForm 
   Caption         =   "VB6 Child"
   ClientHeight    =   7500
   ClientLeft      =   60
   ClientTop       =   405
   ClientWidth     =   7200
   LinkTopic       =   "Form2"
   ScaleHeight     =   7500
   ScaleWidth      =   7200
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox LogBox 
      Height          =   7455
      Left            =   0
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   0
      Width           =   7215
   End
End
Attribute VB_Name = "ChildForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim WithEvents GlueApp As GlueAppInSink
Attribute GlueApp.VB_VarHelpID = -1
Dim Glue As Glue42
Dim WithEvents MyContext As GlueContextManager
Attribute MyContext.VB_VarHelpID = -1
Dim WithEvents OtherContext As GlueContextManager
Attribute OtherContext.VB_VarHelpID = -1
Dim WithEvents GlueWin As GlueWindow
Attribute GlueWin.VB_VarHelpID = -1
Dim FormRegistered As Boolean


Public Function DynamicValueAsTreeText(NestLevel As Integer, Name As String, Value, Optional IsArray As Boolean = False) As String
  ' Determine the nest level prefix
  Dim I As Integer
  Dim Prefix As String
  Dim PrefixSpaces As String
  If NestLevel > 0 Then
    If NestLevel > 1 Then
      Prefix = String$((NestLevel - 1) * 2, " ")
    End If
    Prefix = Prefix + "- "
    PrefixSpaces = String$(NestLevel * 2, " ")
  End If
  
  Dim TreeText As String
  If IsArray Then
    TreeText = PrefixSpaces + "(" + Name + ") "
  Else
    TreeText = Prefix + Name
  End If
  
  Dim TName As String
  TName = TypeName(Value)
  
  If Len(TName) > 2 And Right(TName, 2) = "()" Then ' we have an array or a tuple
    TName = Left(TName, Len(TName) - 2)
    Dim lower, upper As Integer
    lower = LBound(Value)
    upper = UBound(Value)
    TreeText = TreeText + "(" + TName + "(" + CStr(lower) + " to " + CStr(upper) + "))" + vbCrLf
    ' Print the array contents
    For I = lower To upper
      TreeText = TreeText + DynamicValueAsTreeText(NestLevel + 1, CStr(I), Value(I), True)
    Next I
  ElseIf TName = "GlueDynamicValue" Then
    Dim nChildren As Integer
    nChildren = Value.Count
    Dim Values
    Values = Value.Values
    Dim Names() As String
    Names = Value.Names
    
    TreeText = TreeText + "(composite:" + CStr(nChildren) + ")" + vbCrLf
    
    Dim Child
    For I = 0 To nChildren - 1
      Child = Values(I)
      ' recursively descend down the tree
      TreeText = TreeText + DynamicValueAsTreeText(NestLevel + 1, Names(I), Child)
    Next I
  Else ' we have an elementary field
    ' check for array
      TreeText = TreeText + "(" + TName + "): "
      TreeText = TreeText + CStr(Value) + vbCrLf
  End If
    
  DynamicValueAsTreeText = TreeText
  
End Function

Public Sub Announce(ByVal appDefName As String, ByRef state As GlueDynamicValue, ByRef Announcer As IAppAnnouncerInSink)
    Me.Show vbModeless
   
    Set GlueApp = Announcer.RegisterAppInstance(Me.hwnd)
    Set GlueWin = GlueApp.GetWindow
End Sub

Private Sub BtnWorkspaceCxt_Click()
On Error GoTo HandleErrors
    If GlueWin.IsInWorkspace Then
        GlueWin.GetWorkspaceContext.UpdateContextDataJson "contact.name", "{name: 'John Smith'}"
    End If
    Exit Sub
HandleErrors:
    LogMessage "Error BtnWorkspaceCxt_Click: " + Err.Description
End Sub

Private Sub GlueApp_OnInitialize(ByVal hwnd As Long, ByVal state As GlueDynamicValue, ByVal GlueWindow As IGlueWindow)
    LogMessage "OnInitialize"
   
    If GlueWindow.IsInWorkspace Then
        Set MyContext = GlueWindow.GetWorkspaceContext
        LogMessage "In workspace: " + MyContext.GetContextInfo.Name
        MyContext.Open
    Else
        LogMessage "NOT In workspace"
    End If
End Sub

Private Sub GlueApp_OnSaveState(ByVal hwnd As Long, ByVal receiver As IGlueDynamicValueReceiver)
    On Error GoTo HandleErrors
    LogMessage "OnSaveState"
        
    Dim mv As GlueDynamicValue
    Set mv = New GlueDynamicValue
    mv("age") = 55
    mv("name") = "John Smith"
    mv("id") = "123412341234"
    
    receiver.SendGlueValue mv
        
    ' receiver.SendJson "{age: 55, name: 'John Smith', id: 'FKLJKHKS2377487'}"
    Exit Sub
HandleErrors:
    LogMessage "Error OnSaveState: " + Err.Description
End Sub

Private Sub GlueApp_OnShutdown(ByVal hwnd As Long)
    On Error GoTo HandleErrors
    LogMessage "OnShutdown"
    Unload Me
    Exit Sub
HandleErrors:
    LogMessage "Error OnShutdown: " + Err.Description
End Sub

Private Sub LogMessage(text As String, Optional WithNewLine As Boolean = True)
  Dim Ending As String
  If WithNewLine Then
    Ending = vbCrLf
  End If
  With LogBox
'    .SetFocus
    .text = .text + text + Ending
    .SelStart = Len(.text)
  End With
End Sub

Private Sub UpdateControls()
'
End Sub

Private Sub RegisterGlueWindow()
' not used - demos how to register 'flier' Glue window
  On Error GoTo HandleErrors
  If Not GlueWin Is Nothing Then
    LogMessage "Glue window already registered. Nothing to do."
    Exit Sub
  End If
  LogMessage "Starting Glue window registration... ", False
  
  Dim WinSettings As GlueWindowSettings
  Set WinSettings = Glue.CreateDefaultVBGlueWindowSettings
  WinSettings.SynchronousDestroy = True     ' must always be "True" in VBA
  WinSettings.Channel = "Red"
  WinSettings.ChannelSupport = True
  WinSettings.StandardButtons = "Minimize,Maximize,Close"
  WinSettings.Title = "Custom Title"
  WinSettings.Type = "Tab"
  Set GlueWin = Glue.RegisterGlueWindowWithSettings(Me.hwnd, WinSettings, Nothing)
  LogMessage "Done."
  Exit Sub
HandleErrors:
  LogMessage "RegisterGlueWindow: " + Err.Description
End Sub

Private Sub BtnCloseContext_Click()
  On Error GoTo HandleErrors
  If MyContext Is Nothing Then
    LogMessage "Context is not open. Nothing to do."
    Exit Sub
  End If
  MyContext.Close
  Set MyContext = Nothing
  UpdateControls
  Exit Sub
HandleErrors:
  LogMessage "CloseContext: " + Err.Description
End Sub

Private Sub BtnGetContextData_Click()
  On Error GoTo HandleErrors
  If MyContext Is Nothing Then
    LogMessage "Context is not open. Nothing to do."
    Exit Sub
  End If
  
  Dim Data As GlueDynamicValue
  Set Data = MyContext.GetReflectData("")
  
  Dim TreeText As String
  TreeText = "ContextData: " + DynamicValueAsTreeText(0, "", Data)
  
  LogMessage (TreeText)
  
  Exit Sub
HandleErrors:
  LogMessage "GetContextData: " + Err.Description
End Sub

Private Sub btnInitGlue_Click()
  On Error GoTo HandleErrors
  If Glue Is Nothing Then
    LogMessage "Initializing new Glue instance... ", False
    Set Glue = New Glue42
    LogMessage "Done."
    UpdateControls
  Else
    LogMessage "Reusing existing Glue instance"
  End If
  
  LogMessage "Registering new app... ", False
  Glue.StartWithAppName "My VBA From App"
  LogMessage "Done."
  Exit Sub
HandleErrors:
  LogMessage "InitGlue: " + Err.Description
End Sub

Private Sub BtnSetContextData1_Click()
  On Error GoTo HandleErrors
  If MyContext Is Nothing Then
    LogMessage "Context is not open. Nothing to do."
    Exit Sub
  End If
  
  Dim iarr(0 To 1) As Integer
  iarr(0) = 3
  iarr(1) = 14
  
  Dim Data
  Set Data = Glue.CreateGlueValues
  Dim varr(0 To 2) As Variant
  varr(0) = 1
  varr(1) = "mystr"
  varr(2) = iarr
  Data("myTuple") = varr
  
  MyContext.SetValue "data", Data
  
  Exit Sub
HandleErrors:
  LogMessage "SetContextData1: " + Err.Description
End Sub

Private Sub BtnStopGlue_Click()
  On Error GoTo HandleErrors
  If Glue Is Nothing Then
    LogMessage "No Glue instance. Nothing to stop."
  Else
    LogMessage "Stopping Glue... ", False
    Glue.Stop
    LogMessage "Done."
  End If
  
  Set Glue = Nothing
  Set MyContext = Nothing
  UpdateControls

  Exit Sub
HandleErrors:
  LogMessage "StopGlue: " + Err.Description
End Sub

Private Sub BtnOpenContext_Click()
  On Error GoTo HandleErrors
  If Glue Is Nothing Then
    LogMessage "No Glue instance. Please initialize Glue first."
  Exit Sub
  End If
  
  'Set MyContext = Glue.GetGlueContext(BoxContextName.text)
  'MyContext.EnsureOpened 2000

  UpdateControls
  Exit Sub
HandleErrors:
  LogMessage "GetContext: " + Err.Description
End Sub

Private Sub BtnToggleChannels_Click()
  On Error GoTo HandleErrors
  If Not FormRegistered Then
    LogMessage "Glue window not yet registered. Nothing to do."
    Exit Sub
  End If
  GlueWin.SetChannelSupport Not GlueWin.GetChannelSupport
  Exit Sub
HandleErrors:
  LogMessage "ToggleChannels: " + Err.Description
End Sub

Private Sub GlueWin_HandleChannelChanged(ByVal window As IGlueWindow, ByVal Channel As IGlueContext, ByVal prevChannelName As String)
  On Error GoTo HandleErrors
  Dim newChannelName As String
  If Channel Is Nothing Then
    newChannelName = "Nothing"
  Else
    newChannelName = Channel.GetReflectData("name")
    
    Dim ContextData As GlueDynamicValue
    Dim ChannelData As GlueDynamicValue
   
    Set ContextData = Channel.GetReflectData("")
    newChannelName = ContextData("name")
    Set ChannelData = ContextData("data")
    Dim x
    x = ChannelData("xxx")
   End If
  
  If prevChannelName = "" Then
    prevChannelName = "Nothing"
  End If
    
  LogMessage "ChannelChanged: " + prevChannelName + " -> " + newChannelName
  Exit Sub
HandleErrors:
  LogMessage "HandleChannelChanged: " + Err.Description
End Sub

Private Sub GlueWin_HandleChannelData(ByVal window As IGlueWindow, ByVal channelUpdate As IGlueContextUpdate)
  On Error GoTo HandleErrors
  LogMessage "Channel Data Changed"
  LogMessage DynamicValueAsTreeText(0, "", channelUpdate.GetContext.GetReflectData(""))
  Exit Sub
HandleErrors:
  LogMessage "HandleChannelData: " + Err.Description
End Sub

Private Sub GlueWin_HandleWindowDestroyed(ByVal GlueWindow As IGlueWindow)
  If Not Glue Is Nothing Then
    Glue.Stop
  End If
  Unload Me
End Sub

Private Sub GlueWin_HandleWindowReady(ByVal window As IGlueWindow)
  On Error GoTo HandleErrors
  FormRegistered = True
  LogMessage "Glue window registered."
  LogMessage "Window Id: " + window.GetId()
  LogMessage "Window Title: " + window.GetTitle()
  UpdateControls
  Exit Sub
HandleErrors:
  LogMessage "HandleWindowReady: " + Err.Description
End Sub

Private Sub GlueWin_HandleWindowEvent(ByVal window As IGlueWindow, ByVal eventType As GlueWindowEventType, ByVal eventData As GlueDynamicValue)
    If Not Me.Visible Then
        Exit Sub
    End If
    On Error GoTo HandleErrors
    LogMessage "Glue window event (" + CStr(eventType) + ")"
    LogMessage "eventData:" + DynamicValueAsTreeText(0, "", eventData)
HandleErrors:
    LogMessage "HandleWindowEvent: " + Err.Description
End Sub

Private Sub MyContext_HandleContext(ByVal context As IGlueContext)
' Empty
End Sub

Private Sub MyContext_HandleContextUpdate(ByVal contextUpdate As IGlueContextUpdate)
  On Error GoTo HandleErrors
  
  Dim context As GlueContextManager
  Set context = contextUpdate.GetContext
  
  LogMessage "HandleContextUpdate invoked for '" + context.GetContextInfo.Name + "'"
  
  Dim json As String
  json = context.GetDataAsJson("contact.name.name")
  
  Dim Data
  Set Data = context.GetReflectData("contact.name")
  
  ' Examine the updated data
  Dim TreeText As String
  TreeText = "ContextData: " + DynamicValueAsTreeText(0, "", Data)
  LogMessage TreeText
  
  Exit Sub
HandleErrors:
  LogMessage ("HandleContextUpdate: " + Err.Description)
End Sub

Private Sub OtherContext_HandleContext(ByVal context As IGlueContext)
' Empty
End Sub

Private Sub OtherContext_HandleContextUpdate(ByVal contextUpdate As IGlueContextUpdate)
  On Error GoTo HandleErrors
  
  Dim context As GlueContextManager
  Set context = contextUpdate.GetContext
  
  LogMessage "HandleContextUpdate invoked for '" + context.GetContextInfo.Name + "'"
  
  Dim json As String
  json = context.GetDataAsJson("contact.name.name")
  
  Dim Data
  Set Data = context.GetReflectData("contact.name")
  
  ' Examine the updated data
  Dim TreeText As String
  TreeText = "ContextData: " + DynamicValueAsTreeText(0, "", Data)
  LogMessage TreeText
  
  Exit Sub
HandleErrors:
  LogMessage ("HandleContextUpdate: " + Err.Description)
End Sub

Private Sub UserForm_Initialize()
  'BoxContextName.text = "MyContext"
  UpdateControls
End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
' No blocking calls or setting "Cancel" here
  If Not GlueWin Is Nothing Then
    GlueWin.Unregister
  End If
End Sub


Private Sub Form_Load()
'
End Sub
