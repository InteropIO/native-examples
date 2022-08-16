VERSION 5.00
Begin VB.Form MainForm 
   Caption         =   "VB6 Host"
   ClientHeight    =   3135
   ClientLeft      =   60
   ClientTop       =   405
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3135
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton btnStartApp 
      Caption         =   "Start App"
      Height          =   495
      Left            =   480
      TabIndex        =   2
      Top             =   1920
      Width           =   1095
   End
   Begin VB.CommandButton btnInvoke 
      Caption         =   "Invoke"
      Height          =   495
      Left            =   480
      TabIndex        =   1
      Top             =   1320
      Width           =   1095
   End
   Begin VB.CommandButton btnInitGlue 
      Caption         =   "Init Glue"
      Height          =   495
      Left            =   480
      TabIndex        =   0
      Top             =   600
      Width           =   1095
   End
End
Attribute VB_Name = "MainForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim WithEvents Glue As Glue42
Attribute Glue.VB_VarHelpID = -1
Dim WithEvents AppFactory As EventSinkAppFactory
Attribute AppFactory.VB_VarHelpID = -1
Dim WithEvents VbMethod As GlueServerMethod
Attribute VbMethod.VB_VarHelpID = -1
Dim WithEvents AppManager As GlueAppManager
Attribute AppManager.VB_VarHelpID = -1
Dim WithEvents ClientListApp As GlueApplication
Attribute ClientListApp.VB_VarHelpID = -1
Dim WithEvents ClientListAppInstance As GlueApplicationInstance
Attribute ClientListAppInstance.VB_VarHelpID = -1
Dim WithEvents Invocator As GlueMethodInvocator
Attribute Invocator.VB_VarHelpID = -1


Private Sub btnInitGlue_Click()
    Set Glue = New Glue42
    Glue.StartWithAppName "VB6 Host"
    
'    Dim r As GlueDynamicValue
'    Set r = Glue.GetGlueDynamicValueByFieldPath("{""a"": 5, ""x"": 100, ""s"": ""yes"", c: {""name"": ""John"", ""a"":44}}", "c.name")
'    MsgBox r.Value

    
    Set AppFactory = Glue.AppFactoryRegistry.RegisterAppFactoryInSink("VB6Child", "VB6Child", "", "{includeInWorkspaces: true}")
    Set VbMethod = Glue.CreateServerMethod("GlueVB6Method", "", "", "")
    Set AppManager = Glue.CreateAppManager
    AppManager.Subscribe Nothing
    Set ClientListApp = AppManager.GetApplication("ClientList")
    ClientListApp.Subscribe Nothing
    Set Invocator = Glue.CreateMethodInvocator
    VbMethod.Register
End Sub

Private Sub btnInvoke_Click()
'
    Invocator.InvokeAsync "jsmethod", "", "{""a"": 5, ""x"": 100, ""s"": ""yes"", c: {""name"": ""John"", ""a"":44}}", True, "invocation_correlation_id", 1000
End Sub

Private Sub btnStartApp_Click()
'
    If ClientListApp.IsAnnounced Then
        Set ClientListAppInstance = ClientListApp.CreateInstance
        ClientListAppInstance.StartWithJson "" & _
            "{" & _
            "   ""urlLoadOptions"": {" & _
            "       ""extraHeaders"": ""Content-Type: application/x-www-form-urlencoded"", " & _
            "       ""postData"": [" & _
            "           {" & _
            "               ""type"": ""base64""," & _
            "               ""data"": ""base64string""" & _
            "           }" & _
            "       ]" & _
            "   }" & _
            "}"
    End If
End Sub

Private Sub Invocator_HandleInvocationResult(ByVal invocationResult As IGlueInvocationResult)
'
    MsgBox invocationResult.correlationId
    
    Dim r() As VBGlueResult
    r = invocationResult.Results
    
    MsgBox r(0).GlueData.GetReflectData("c.name") & ": " & CStr(r(0).GlueData.GetReflectData("c.age"))
End Sub

Private Sub ClientListApp_OnApplicationDefinition(ByVal application As GlueApplication, ByVal announced As Boolean)
'
End Sub

Private Sub ClientListAppInstance_OnAppInstanceEvent(ByVal Instance As GlueApplicationInstance, ByVal started As Boolean, ByVal success As Boolean, ByVal Message As String)
'
End Sub

Private Sub AppManager_OnApplicationDefinition(ByVal appName As String, ByVal added As Boolean)
'
End Sub

Private Sub AppManager_OnApplicationInstance(ByVal appName As String, ByVal correlationId As String, ByVal Id As String, ByVal started As Boolean, ByVal Message As String)
'
End Sub

Private Function ReadFile(filename$) As String
    Dim handle As Integer
    handle = FreeFile
    Open filename$ For Input As #handle
    ReadFile = Input$(LOF(handle), handle)
    Close #handle
End Function

Private Sub VbMethod_HandleInvocationRequest(ByVal GlueInvocationRequest As GlueInvocationRequest)
' Glue.Log 4, "Called ... "
    
    ' json_data = ReadFile("MOCK_DATA.json")
    ' GlueInvocationRequest.SendResult json_data
    GlueInvocationRequest.SendResult "{a: 5, b: 'yes', caller: {name: 'John', age: 42}}"
End Sub

Private Sub Glue_OnException(ByVal Message As String, ByVal val As GlueDynamicValue)
' Glue.Log 4, Message
End Sub

Private Sub Glue_OnInstanceStatus(ByVal Instance As String, ByVal active As Boolean)
'
End Sub

Private Sub Glue_OnConnectionStatus(ByVal state As String, ByVal Message As String, ByVal dt As Double)
''
    Glue.Log 2, "Got connection status: " + Message
End Sub

Private Sub Glue_OnMethodStatus(ByVal Instance As String, ByVal method As String, ByVal active As Boolean)
' ignored
End Sub

Private Sub AppFactory_OnCreateApp(ByVal appDefName As String, ByVal state As IGlueValueCollection, ByVal Announcer As IAppAnnouncerInSink)
    Glue.Log 2, "Creating app " + appDefName
    
    Dim Child As New ChildForm
    Child.Announce appDefName, state, Announcer
End Sub


Private Sub Glue_BindLifetimeEvent()
''
End Sub
