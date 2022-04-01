unit GlueCOM_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 2020-04-15 2:03:48 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: A:\Work\stash\dot-net-glue-com\GlueCom\bin\Debug\GlueCOM.dll (1)
// LIBID: {84EF66B3-C5E2-4C58-AD95-0E956FAE7027}
// LCID: 0
// Helpfile:
// HelpString: Tick42 Glue for COM
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
//   (2) v2.4 mscorlib, (C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorlib.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, mscorlib_TLB, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;



// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  GlueCOMMajorVersion = 2;
  GlueCOMMinorVersion = 0;

  LIBID_GlueCOM: TGUID = '{84EF66B3-C5E2-4C58-AD95-0E956FAE7027}';

  IID_IGlue42: TGUID = '{DB20C8DA-CD98-4D75-8B9A-18284B7EE0D1}';
  IID_IGlueContext: TGUID = '{E36214AA-00E9-4057-8DB3-B381C8839735}';
  IID_IGlueContextBuilder: TGUID = '{E6BF93F6-3277-4BFD-8F30-4B76E72745E2}';
  IID_IGlueContextHandler: TGUID = '{E7DF128A-1584-49F9-87FE-06FA062DA1FB}';
  IID_IGlueContextUpdate: TGUID = '{FCA1B294-A416-4533-AFAF-3640FDE02B1A}';
  IID_IGlueEvents: TGUID = '{A9B9392C-14B9-42BC-8BCD-7B07EF36003C}';
  DIID_IGlueEventSink: TGUID = '{0EE5A248-F02A-4551-8745-437F6AFAAB4D}';
  IID_IGlueContextBuilderCallback: TGUID = '{0856C290-92E8-49A3-ADD9-741E551BD70F}';
  IID_IGlueWindow: TGUID = '{2F432B71-D338-419B-B150-E5E111F3D9A3}';
  CLASS_Glue42: TGUID = '{556D7D1B-7E89-454A-8575-85B1ABE35941}';
  IID_IGlueServerSubscriptionCallback: TGUID = '{1CE0C9B4-C1D2-4F0D-A5A5-57EA027424BE}';
  IID_IGlueStream: TGUID = '{311F7E47-8BFD-4174-B493-8FA9F9192464}';
  IID_IGlueStreamBranch: TGUID = '{C770A188-815A-4D61-89BA-5F283F698A07}';
  IID_IGlueStreamHandler: TGUID = '{A384126A-06D1-41CE-942C-4376D4574F4B}';
  IID_IGlueStreamSubscriber: TGUID = '{71587A98-0C44-4973-8EC6-74D71BA62F90}';
  IID_IGlueStreamSubscription: TGUID = '{E1ADF3C1-D11C-4E96-B9E9-D0B52B02DBCD}';
  IID_IGlueSubscriptionHandler: TGUID = '{DAA04777-BD8E-4180-9021-48A0807A2E1D}';
  IID_IGlueRequestHandler: TGUID = '{81671796-A690-476B-85EA-94326B7CA2B5}';
  IID_IGlueServerMethodResultCallback: TGUID = '{2497D4E6-C398-4DBB-904D-83B55F701E46}';
  IID_IGlueInvocationResultHandler: TGUID = '{3549297E-57A9-4F65-9183-D95232E55469}';
  IID_IGlueWindowEventHandler: TGUID = '{FBCB4411-153C-4AAC-8DC8-DB696C931FEB}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library
// *********************************************************************//
// Constants for enum GlueInstanceIdentity
type
  GlueInstanceIdentity = TOleEnum;
const
  GlueInstanceIdentity_None = $00000000;
  GlueInstanceIdentity_MachineName = $00000001;
  GlueInstanceIdentity_ApplicationName = $00000002;
  GlueInstanceIdentity_UserName = $00000004;
  GlueInstanceIdentity_Environment = $00000008;
  GlueInstanceIdentity_Region = $00000010;
  GlueInstanceIdentity_ServiceName = $00000020;
  GlueInstanceIdentity_Instance = $00000007;
  GlueInstanceIdentity_LocalizedInstance = $0000001F;
  GlueInstanceIdentity_Full = $0000003F;
  GlueInstanceIdentity_Pid = $00000040;
  GlueInstanceIdentity_InstanceId = $00000080;

// Constants for enum GlueMethodFlags
type
  GlueMethodFlags = TOleEnum;
const
  GlueMethodFlags_None = $00000000;
  GlueMethodFlags_ReturnsResult = $00000001;
  GlueMethodFlags_IsGuiOperation = $00000002;
  GlueMethodFlags_IsUserSpecific = $00000004;
  GlueMethodFlags_IsMachineSpecific = $00000008;
  GlueMethodFlags_OutsideDomain = $00000010;
  GlueMethodFlags_SupportsStreaming = $00000020;

// Constants for enum GlueMethodInvocationStatus
type
  GlueMethodInvocationStatus = TOleEnum;
const
  GlueMethodInvocationStatus_Succeeded = $00000000;
  GlueMethodInvocationStatus_Failed = $00000001;
  GlueMethodInvocationStatus_TimedOut = $00000002;
  GlueMethodInvocationStatus_NotAvailable = $00000003;
  GlueMethodInvocationStatus_Started = $00000004;

// Constants for enum GlueState
type
  GlueState = TOleEnum;
const
  GlueState_Unknown = $00000000;
  GlueState_Pending = $00000001;
  GlueState_Connected = $00000002;
  GlueState_Disconnected = $00000003;
  GlueState_Inactive = $00000004;

// Constants for enum GlueValueType
type
  GlueValueType = TOleEnum;
const
  GlueValueType_Bool = $00000000;
  GlueValueType_Int = $00000001;
  GlueValueType_Double = $00000002;
  GlueValueType_Long = $00000003;
  GlueValueType_String = $00000004;
  GlueValueType_DateTime = $00000005;
  GlueValueType_Tuple = $00000006;
  GlueValueType_Composite = $00000007;

// Constants for enum GlueStreamState
type
  GlueStreamState = TOleEnum;
const
  GlueStreamState_Pending = $00000000;
  GlueStreamState_Stale = $00000001;
  GlueStreamState_Opened = $00000002;
  GlueStreamState_Closed = $00000003;
  GlueStreamState_SubscriptionRejected = $00000004;
  GlueStreamState_SubscriptionFailed = $00000005;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IGlue42 = interface;
  IGlue42Disp = dispinterface;
  IGlueContext = interface;
  IGlueContextDisp = dispinterface;
  IGlueContextBuilder = interface;
  IGlueContextBuilderDisp = dispinterface;
  IGlueContextHandler = interface;
  IGlueContextUpdate = interface;
  IGlueContextUpdateDisp = dispinterface;
  IGlueEvents = interface;
  IGlueEventSink = dispinterface;
  IGlueContextBuilderCallback = interface;
  IGlueWindow = interface;
  IGlueWindowDisp = dispinterface;
  IGlueServerSubscriptionCallback = interface;
  IGlueServerSubscriptionCallbackDisp = dispinterface;
  IGlueStream = interface;
  IGlueStreamDisp = dispinterface;
  IGlueStreamBranch = interface;
  IGlueStreamBranchDisp = dispinterface;
  IGlueStreamHandler = interface;
  IGlueStreamSubscriber = interface;
  IGlueStreamSubscriberDisp = dispinterface;
  IGlueStreamSubscription = interface;
  IGlueStreamSubscriptionDisp = dispinterface;
  IGlueSubscriptionHandler = interface;
  IGlueRequestHandler = interface;
  IGlueServerMethodResultCallback = interface;
  IGlueServerMethodResultCallbackDisp = dispinterface;
  IGlueInvocationResultHandler = interface;
  IGlueWindowEventHandler = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  Glue42 = IGlue42;


// *********************************************************************//
// Declaration of structures, unions and aliases.
// *********************************************************************//
{$ALIGN 8}
  GlueInstance = record
    InstanceId: WideString;
    Version: WideString;
    MachineName: WideString;
    ProcessId: Integer;
    ProcessStartTime: Int64;
    UserName: WideString;
    ApplicationName: WideString;
    Environment: WideString;
    Region: WideString;
    ServiceName: WideString;
    MetricsRepositoryId: WideString;
    Metadata: PSafeArray;
  end;

{$ALIGN 4}
  GlueConfiguration = record
    LoggingConfigurationPath: WideString;
    GWUri: WideString;
  end;

  GlueContext = record
    Name: WideString;
    Id: WideString;
  end;

{$ALIGN 8}
  GlueValue = record
    GlueType: GlueValueType;
    IsArray: WordBool;
    BoolValue: WordBool;
    LongValue: Int64;
    DoubleValue: Double;
    StringValue: WideString;
    BoolArray: PSafeArray;
    LongArray: PSafeArray;
    DoubleArray: PSafeArray;
    StringArray: PSafeArray;
    Tuple: PSafeArray;
    CompositeValue: PSafeArray;
  end;

  GlueMethod = record
    Name: WideString;
    Input: WideString;
    Output: WideString;
    Instance: GlueInstance;
    RegistrationCookie: WideString;
    Flags: GlueMethodFlags;
    ObjectTypes: PSafeArray;
  end;

{$ALIGN 4}
  GlueResult = record
    Values: PSafeArray;
    Status: GlueMethodInvocationStatus;
    Message: WideString;
    LogDetails: WideString;
  end;

{$ALIGN 8}
  GlueInvocationResult = record
    Method: GlueMethod;
    Result: GlueResult;
  end;

  GlueContextValue = record
    Name: WideString;
    Value: GlueValue;
  end;


// *********************************************************************//
// Interface: IGlue42
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DB20C8DA-CD98-4D75-8B9A-18284B7EE0D1}
// *********************************************************************//
  IGlue42 = interface(IDispatch)
    ['{DB20C8DA-CD98-4D75-8B9A-18284B7EE0D1}']
    procedure OverrideConfiguration(configuration: GlueConfiguration); safecall;
    procedure Start(Instance: GlueInstance); safecall;
    procedure SetLogConfigurationPath(const logConfigPath: WideString); safecall;
    procedure StartWithAppName(const ApplicationName: WideString); safecall;
    procedure Stop; safecall;
    function RegisterGlueWindow(hwnd: Integer; const windowEventHandler: IGlueWindowEventHandler): IGlueWindow; safecall;
    function GetInstance: GlueInstance; safecall;
    function GetKnownContexts: PSafeArray; safecall;
    procedure GetGlueContext(const contextName: WideString; const handler: IGlueContextHandler); safecall;
    function GetAllInstances: PSafeArray; safecall;
    function GetAllMethods: PSafeArray; safecall;
    function GetMethodsForInstance(Instance: GlueInstance; identity: GlueInstanceIdentity): PSafeArray; safecall;
    procedure Subscribe(const handler: IGlueEvents); safecall;
    procedure Unsubscribe(const handler: IGlueEvents); safecall;
    function BuildGlueContextValues(const contextBuilderCallback: IGlueContextBuilderCallback): PSafeArray; safecall;
    function RegisterMethod(const methodName: WideString;
                            const requestHandler: IGlueRequestHandler; const Input: WideString;
                            const Output: WideString; ObjectTypes: PSafeArray): GlueMethod; safecall;
    function RegisterStream(const streamName: WideString;
                            const subscriptionHandler: IGlueSubscriptionHandler;
                            const Input: WideString; const Output: WideString;
                            ObjectTypes: PSafeArray; out stream: IGlueStream): GlueMethod; safecall;
    procedure UnregisterMethod(Method: GlueMethod); safecall;
    procedure BuildAndInvoke(const Method: WideString;
                             const builderCallback: IGlueContextBuilderCallback;
                             targets: PSafeArray; all: WordBool; identity: GlueInstanceIdentity;
                             const resultHandler: IGlueInvocationResultHandler;
                             invocationTimeoutMsecs: Int64; const correlationId: WideString); safecall;
    procedure InvokeMethods(const Method: WideString; invocationArgs: PSafeArray;
                            targets: PSafeArray; all: WordBool; identity: GlueInstanceIdentity;
                            const resultHandler: IGlueInvocationResultHandler;
                            invocationTimeoutMsecs: Int64; const correlationId: WideString); safecall;
    procedure InvokeMethod(Method: GlueMethod; invocationArgs: PSafeArray;
                           const resultHandler: IGlueInvocationResultHandler;
                           invocationTimeoutMsecs: Int64; const correlationId: WideString); safecall;
    procedure SubscribeStreams(const streamName: WideString; subscriptionRequestArgs: PSafeArray;
                               targets: PSafeArray; all: WordBool; identity: GlueInstanceIdentity;
                               const streamHandler: IGlueStreamHandler;
                               invocationTimeoutMsecs: Int64); safecall;
    procedure SubscribeStream(stream: GlueMethod; subscriptionRequestArgs: PSafeArray;
                              const streamHandler: IGlueStreamHandler;
                              subscriptionTimeoutMsecs: Int64); safecall;
    function InvokeSync(const methodName: WideString; const argsAsJson: WideString;
                        const resultFieldPath: WideString; const targetRegex: WideString): WideString; safecall;
    procedure InvokeAsync(const correlationId: WideString; const methodName: WideString;
                          const argsAsJson: WideString; const resultFieldPath: WideString;
                          const targetRegex: WideString); safecall;
    procedure SubscribeStreamInSink(const correlationId: WideString; const streamName: WideString;
                                    const argsAsJson: WideString;
                                    const resultFieldPath: WideString;
                                    const targetRegex: WideString;
                                    const filterFieldPath: WideString;
                                    const filterDataRegex: WideString); safecall;
    procedure RegisterMethodInSink(const correlationId: WideString; const methodName: WideString;
                                   const inputSignature: WideString;
                                   const outputSignature: WideString; ObjectTypes: PSafeArray;
                                   const invocationFieldPath: WideString;
                                   const targetRegex: WideString;
                                   const filterFieldPath: WideString;
                                   const filterDataRegex: WideString); safecall;
    procedure RegisterVariantMethodInSink(const correlationId: WideString;
                                          const methodName: WideString;
                                          const inputSignature: WideString;
                                          const outputSignature: WideString;
                                          ObjectTypes: PSafeArray;
                                          const invocationFieldPath: WideString;
                                          const targetRegex: WideString;
                                          const filterFieldPath: WideString;
                                          const filterDataRegex: WideString); safecall;
    procedure RegisterVoidMethodInSink(const correlationId: WideString;
                                       const methodName: WideString;
                                       const inputSignature: WideString; ObjectTypes: PSafeArray;
                                       const invocationFieldPath: WideString;
                                       const targetRegex: WideString;
                                       const filterFieldPath: WideString;
                                       const filterDataRegex: WideString); safecall;
    procedure RegisterSingleBranchStream(const correlationId: WideString;
                                         const streamName: WideString;
                                         const requestSignature: WideString;
                                         const streamSignature: WideString); safecall;
    procedure AddCorrelationInterest(const correlationId: WideString; const interestId: WideString;
                                     const fieldPath: WideString;
                                     const filterFieldPath: WideString;
                                     const filterDataRegex: WideString); safecall;
    procedure RegisterStreamInSink(const correlationId: WideString; const streamName: WideString;
                                   const requestSignature: WideString;
                                   const streamSignature: WideString;
                                   const requestFieldPath: WideString;
                                   const targetRegex: WideString;
                                   const filterFieldPath: WideString;
                                   const filterDataRegex: WideString); safecall;
    procedure YieldCallbackData(const correlationId: WideString; const callbackId: WideString;
                                const callbackData: WideString); safecall;
    procedure YieldCallbackVariantData(const correlationId: WideString;
                                       const callbackId: WideString; callbackData: OleVariant); safecall;
    procedure RegisterGlueWindowInSink(const correlationId: WideString; const hwnd: WideString); safecall;
    function JsonToVariant(const json: WideString): PSafeArray; safecall;
    procedure CloseResource(const correlationId: WideString); safecall;
    function GetMethodNamesForTarget(const target: WideString): PSafeArray; safecall;
    function GetTargets: PSafeArray; safecall;
    function GetChannels: PSafeArray; safecall;
    procedure InvokeAsyncVariantData(const correlationId: WideString; const methodName: WideString;
                                     args: OleVariant; const resultFieldPath: WideString;
                                     const targetRegex: WideString); safecall;
    procedure SubscribeChannel(const correlationId: WideString; const channel: WideString;
                               const resultFieldPath: WideString); safecall;
    procedure SetChannelData(const channel: WideString; const fieldPath: WideString;
                             const data: WideString); safecall;
    procedure G4O_XL_OpenSheet(const correlationId: WideString; const sheetName: WideString;
                               columnNames: PSafeArray; columnValidationTypes: PSafeArray;
                               data: OleVariant); safecall;
    procedure Log(level: Byte; const Message: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlue42Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DB20C8DA-CD98-4D75-8B9A-18284B7EE0D1}
// *********************************************************************//
  IGlue42Disp = dispinterface
    ['{DB20C8DA-CD98-4D75-8B9A-18284B7EE0D1}']
    procedure OverrideConfiguration(configuration: {NOT_OLEAUTO(GlueConfiguration)}OleVariant); dispid 1610743808;
    procedure Start(Instance: {NOT_OLEAUTO(GlueInstance)}OleVariant); dispid 1610743809;
    procedure SetLogConfigurationPath(const logConfigPath: WideString); dispid 1610743810;
    procedure StartWithAppName(const ApplicationName: WideString); dispid 1610743811;
    procedure Stop; dispid 1610743812;
    function RegisterGlueWindow(hwnd: Integer; const windowEventHandler: IGlueWindowEventHandler): IGlueWindow; dispid 1610743813;
    function GetInstance: {NOT_OLEAUTO(GlueInstance)}OleVariant; dispid 1610743814;
    function GetKnownContexts: {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743815;
    procedure GetGlueContext(const contextName: WideString; const handler: IGlueContextHandler); dispid 1610743816;
    function GetAllInstances: {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743817;
    function GetAllMethods: {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743818;
    function GetMethodsForInstance(Instance: {NOT_OLEAUTO(GlueInstance)}OleVariant;
                                   identity: GlueInstanceIdentity): {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743819;
    procedure Subscribe(const handler: IGlueEvents); dispid 1610743820;
    procedure Unsubscribe(const handler: IGlueEvents); dispid 1610743821;
    function BuildGlueContextValues(const contextBuilderCallback: IGlueContextBuilderCallback): {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743822;
    function RegisterMethod(const methodName: WideString;
                            const requestHandler: IGlueRequestHandler; const Input: WideString;
                            const Output: WideString;
                            ObjectTypes: {NOT_OLEAUTO(PSafeArray)}OleVariant): {NOT_OLEAUTO(GlueMethod)}OleVariant; dispid 1610743823;
    function RegisterStream(const streamName: WideString;
                            const subscriptionHandler: IGlueSubscriptionHandler;
                            const Input: WideString; const Output: WideString;
                            ObjectTypes: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                            out stream: IGlueStream): {NOT_OLEAUTO(GlueMethod)}OleVariant; dispid 1610743824;
    procedure UnregisterMethod(Method: {NOT_OLEAUTO(GlueMethod)}OleVariant); dispid 1610743825;
    procedure BuildAndInvoke(const Method: WideString;
                             const builderCallback: IGlueContextBuilderCallback;
                             targets: {NOT_OLEAUTO(PSafeArray)}OleVariant; all: WordBool;
                             identity: GlueInstanceIdentity;
                             const resultHandler: IGlueInvocationResultHandler;
                             invocationTimeoutMsecs: Int64; const correlationId: WideString); dispid 1610743826;
    procedure InvokeMethods(const Method: WideString;
                            invocationArgs: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                            targets: {NOT_OLEAUTO(PSafeArray)}OleVariant; all: WordBool;
                            identity: GlueInstanceIdentity;
                            const resultHandler: IGlueInvocationResultHandler;
                            invocationTimeoutMsecs: Int64; const correlationId: WideString); dispid 1610743827;
    procedure InvokeMethod(Method: {NOT_OLEAUTO(GlueMethod)}OleVariant;
                           invocationArgs: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                           const resultHandler: IGlueInvocationResultHandler;
                           invocationTimeoutMsecs: Int64; const correlationId: WideString); dispid 1610743828;
    procedure SubscribeStreams(const streamName: WideString;
                               subscriptionRequestArgs: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                               targets: {NOT_OLEAUTO(PSafeArray)}OleVariant; all: WordBool;
                               identity: GlueInstanceIdentity;
                               const streamHandler: IGlueStreamHandler;
                               invocationTimeoutMsecs: Int64); dispid 1610743829;
    procedure SubscribeStream(stream: {NOT_OLEAUTO(GlueMethod)}OleVariant;
                              subscriptionRequestArgs: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                              const streamHandler: IGlueStreamHandler;
                              subscriptionTimeoutMsecs: Int64); dispid 1610743830;
    function InvokeSync(const methodName: WideString; const argsAsJson: WideString;
                        const resultFieldPath: WideString; const targetRegex: WideString): WideString; dispid 1610743831;
    procedure InvokeAsync(const correlationId: WideString; const methodName: WideString;
                          const argsAsJson: WideString; const resultFieldPath: WideString;
                          const targetRegex: WideString); dispid 1610743832;
    procedure SubscribeStreamInSink(const correlationId: WideString; const streamName: WideString;
                                    const argsAsJson: WideString;
                                    const resultFieldPath: WideString;
                                    const targetRegex: WideString;
                                    const filterFieldPath: WideString;
                                    const filterDataRegex: WideString); dispid 1610743833;
    procedure RegisterMethodInSink(const correlationId: WideString; const methodName: WideString;
                                   const inputSignature: WideString;
                                   const outputSignature: WideString;
                                   ObjectTypes: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                                   const invocationFieldPath: WideString;
                                   const targetRegex: WideString;
                                   const filterFieldPath: WideString;
                                   const filterDataRegex: WideString); dispid 1610743834;
    procedure RegisterVariantMethodInSink(const correlationId: WideString;
                                          const methodName: WideString;
                                          const inputSignature: WideString;
                                          const outputSignature: WideString;
                                          ObjectTypes: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                                          const invocationFieldPath: WideString;
                                          const targetRegex: WideString;
                                          const filterFieldPath: WideString;
                                          const filterDataRegex: WideString); dispid 1610743835;
    procedure RegisterVoidMethodInSink(const correlationId: WideString;
                                       const methodName: WideString;
                                       const inputSignature: WideString;
                                       ObjectTypes: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                                       const invocationFieldPath: WideString;
                                       const targetRegex: WideString;
                                       const filterFieldPath: WideString;
                                       const filterDataRegex: WideString); dispid 1610743836;
    procedure RegisterSingleBranchStream(const correlationId: WideString;
                                         const streamName: WideString;
                                         const requestSignature: WideString;
                                         const streamSignature: WideString); dispid 1610743837;
    procedure AddCorrelationInterest(const correlationId: WideString; const interestId: WideString;
                                     const fieldPath: WideString;
                                     const filterFieldPath: WideString;
                                     const filterDataRegex: WideString); dispid 1610743838;
    procedure RegisterStreamInSink(const correlationId: WideString; const streamName: WideString;
                                   const requestSignature: WideString;
                                   const streamSignature: WideString;
                                   const requestFieldPath: WideString;
                                   const targetRegex: WideString;
                                   const filterFieldPath: WideString;
                                   const filterDataRegex: WideString); dispid 1610743839;
    procedure YieldCallbackData(const correlationId: WideString; const callbackId: WideString;
                                const callbackData: WideString); dispid 1610743840;
    procedure YieldCallbackVariantData(const correlationId: WideString;
                                       const callbackId: WideString; callbackData: OleVariant); dispid 1610743841;
    procedure RegisterGlueWindowInSink(const correlationId: WideString; const hwnd: WideString); dispid 1610743842;
    function JsonToVariant(const json: WideString): {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743843;
    procedure CloseResource(const correlationId: WideString); dispid 1610743844;
    function GetMethodNamesForTarget(const target: WideString): {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743845;
    function GetTargets: {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743846;
    function GetChannels: {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743847;
    procedure InvokeAsyncVariantData(const correlationId: WideString; const methodName: WideString;
                                     args: OleVariant; const resultFieldPath: WideString;
                                     const targetRegex: WideString); dispid 1610743848;
    procedure SubscribeChannel(const correlationId: WideString; const channel: WideString;
                               const resultFieldPath: WideString); dispid 1610743849;
    procedure SetChannelData(const channel: WideString; const fieldPath: WideString;
                             const data: WideString); dispid 1610743850;
    procedure G4O_XL_OpenSheet(const correlationId: WideString; const sheetName: WideString;
                               columnNames: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                               columnValidationTypes: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                               data: OleVariant); dispid 1610743851;
    procedure Log(level: Byte; const Message: WideString); dispid 1610743852;
  end;

// *********************************************************************//
// Interface: IGlueContext
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E36214AA-00E9-4057-8DB3-B381C8839735}
// *********************************************************************//
  IGlueContext = interface(IDispatch)
    ['{E36214AA-00E9-4057-8DB3-B381C8839735}']
    function GetContextInfo: GlueContext; safecall;
    function GetData: PSafeArray; safecall;
    procedure SetContextData(data: PSafeArray); safecall;
    procedure BuildAndSetContextData(const builderCallback: IGlueContextBuilderCallback); safecall;
    procedure UpdateContextData(data: PSafeArray); safecall;
    procedure BuildAndUpdateContextData(const builderCallback: IGlueContextBuilderCallback); safecall;
    procedure Close; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueContextDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E36214AA-00E9-4057-8DB3-B381C8839735}
// *********************************************************************//
  IGlueContextDisp = dispinterface
    ['{E36214AA-00E9-4057-8DB3-B381C8839735}']
    function GetContextInfo: {NOT_OLEAUTO(GlueContext)}OleVariant; dispid 1610743808;
    function GetData: {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743809;
    procedure SetContextData(data: {NOT_OLEAUTO(PSafeArray)}OleVariant); dispid 1610743810;
    procedure BuildAndSetContextData(const builderCallback: IGlueContextBuilderCallback); dispid 1610743811;
    procedure UpdateContextData(data: {NOT_OLEAUTO(PSafeArray)}OleVariant); dispid 1610743812;
    procedure BuildAndUpdateContextData(const builderCallback: IGlueContextBuilderCallback); dispid 1610743813;
    procedure Close; dispid 1610743814;
  end;

// *********************************************************************//
// Interface: IGlueContextBuilder
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E6BF93F6-3277-4BFD-8F30-4B76E72745E2}
// *********************************************************************//
  IGlueContextBuilder = interface(IDispatch)
    ['{E6BF93F6-3277-4BFD-8F30-4B76E72745E2}']
    procedure AddBool(const Name: WideString; Value: WordBool); safecall;
    procedure AddDatetime(const Name: WideString; Value: Int64); safecall;
    procedure AddString(const Name: WideString; const Value: WideString); safecall;
    procedure AddInt(const Name: WideString; Value: Integer); safecall;
    procedure AddLong(const Name: WideString; Value: Int64); safecall;
    procedure AddDouble(const Name: WideString; Value: Double); safecall;
    procedure AddBoolArray(const Name: WideString; Value: PSafeArray); safecall;
    procedure AddStringArray(const Name: WideString; Value: PSafeArray); safecall;
    procedure AddIntArray(const Name: WideString; Value: PSafeArray); safecall;
    procedure AddDatetimeArray(const Name: WideString; Value: PSafeArray); safecall;
    procedure AddLongArray(const Name: WideString; Value: PSafeArray); safecall;
    procedure AddDoubleArray(const Name: WideString; Value: PSafeArray); safecall;
    procedure BuildComposite(const Name: WideString; const callback: IGlueContextBuilderCallback;
                             IsArray: WordBool); safecall;
    procedure BuildTuple(const Name: WideString; const callback: IGlueContextBuilderCallback); safecall;
    procedure AddComposite(const Name: WideString; composite: PSafeArray; IsArray: WordBool); safecall;
    procedure AddTuple(const Name: WideString; Tuple: PSafeArray); safecall;
    procedure AddContextValue(GlueContextValue: GlueContextValue); safecall;
    procedure AddGlueValue(const Name: WideString; Value: GlueValue); safecall;
    procedure AddTupleValue(Value: GlueValue); safecall;
    procedure Clear; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueContextBuilderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E6BF93F6-3277-4BFD-8F30-4B76E72745E2}
// *********************************************************************//
  IGlueContextBuilderDisp = dispinterface
    ['{E6BF93F6-3277-4BFD-8F30-4B76E72745E2}']
    procedure AddBool(const Name: WideString; Value: WordBool); dispid 1610743808;
    procedure AddDatetime(const Name: WideString; Value: Int64); dispid 1610743809;
    procedure AddString(const Name: WideString; const Value: WideString); dispid 1610743810;
    procedure AddInt(const Name: WideString; Value: Integer); dispid 1610743811;
    procedure AddLong(const Name: WideString; Value: Int64); dispid 1610743812;
    procedure AddDouble(const Name: WideString; Value: Double); dispid 1610743813;
    procedure AddBoolArray(const Name: WideString; Value: {NOT_OLEAUTO(PSafeArray)}OleVariant); dispid 1610743814;
    procedure AddStringArray(const Name: WideString; Value: {NOT_OLEAUTO(PSafeArray)}OleVariant); dispid 1610743815;
    procedure AddIntArray(const Name: WideString; Value: {NOT_OLEAUTO(PSafeArray)}OleVariant); dispid 1610743816;
    procedure AddDatetimeArray(const Name: WideString; Value: {NOT_OLEAUTO(PSafeArray)}OleVariant); dispid 1610743817;
    procedure AddLongArray(const Name: WideString; Value: {NOT_OLEAUTO(PSafeArray)}OleVariant); dispid 1610743818;
    procedure AddDoubleArray(const Name: WideString; Value: {NOT_OLEAUTO(PSafeArray)}OleVariant); dispid 1610743819;
    procedure BuildComposite(const Name: WideString; const callback: IGlueContextBuilderCallback;
                             IsArray: WordBool); dispid 1610743820;
    procedure BuildTuple(const Name: WideString; const callback: IGlueContextBuilderCallback); dispid 1610743821;
    procedure AddComposite(const Name: WideString; composite: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                           IsArray: WordBool); dispid 1610743822;
    procedure AddTuple(const Name: WideString; Tuple: {NOT_OLEAUTO(PSafeArray)}OleVariant); dispid 1610743823;
    procedure AddContextValue(GlueContextValue: {NOT_OLEAUTO(GlueContextValue)}OleVariant); dispid 1610743824;
    procedure AddGlueValue(const Name: WideString; Value: {NOT_OLEAUTO(GlueValue)}OleVariant); dispid 1610743825;
    procedure AddTupleValue(Value: {NOT_OLEAUTO(GlueValue)}OleVariant); dispid 1610743826;
    procedure Clear; dispid 1610743827;
  end;

// *********************************************************************//
// Interface: IGlueContextHandler
// Flags:     (256) OleAutomation
// GUID:      {E7DF128A-1584-49F9-87FE-06FA062DA1FB}
// *********************************************************************//
  IGlueContextHandler = interface(IUnknown)
    ['{E7DF128A-1584-49F9-87FE-06FA062DA1FB}']
    function HandleContext(const context: IGlueContext): HResult; stdcall;
    function HandleContextUpdate(const contextUpdate: IGlueContextUpdate): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IGlueContextUpdate
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FCA1B294-A416-4533-AFAF-3640FDE02B1A}
// *********************************************************************//
  IGlueContextUpdate = interface(IDispatch)
    ['{FCA1B294-A416-4533-AFAF-3640FDE02B1A}']
    function GetContext: IGlueContext; safecall;
    function GetRemoved: PSafeArray; safecall;
    function GetAdded: PSafeArray; safecall;
    function GetUpdated: PSafeArray; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueContextUpdateDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FCA1B294-A416-4533-AFAF-3640FDE02B1A}
// *********************************************************************//
  IGlueContextUpdateDisp = dispinterface
    ['{FCA1B294-A416-4533-AFAF-3640FDE02B1A}']
    function GetContext: IGlueContext; dispid 1610743808;
    function GetRemoved: {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743809;
    function GetAdded: {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743810;
    function GetUpdated: {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743811;
  end;

// *********************************************************************//
// Interface: IGlueEvents
// Flags:     (256) OleAutomation
// GUID:      {A9B9392C-14B9-42BC-8BCD-7B07EF36003C}
// *********************************************************************//
  IGlueEvents = interface(IUnknown)
    ['{A9B9392C-14B9-42BC-8BCD-7B07EF36003C}']
    function HandleConnectionStatus(state: GlueState; const Message: WideString; date: Int64): HResult; stdcall;
    function HandleInstanceStatus(Instance: GlueInstance; active: WordBool): HResult; stdcall;
    function HandleMethodStatus(Method: GlueMethod; active: WordBool): HResult; stdcall;
    function HandleGlueContext(context: GlueContext; created: WordBool): HResult; stdcall;
    function HandleException(const ex: _Exception): HResult; stdcall;
  end;

// *********************************************************************//
// DispIntf:  IGlueEventSink
// Flags:     (4096) Dispatchable
// GUID:      {0EE5A248-F02A-4551-8745-437F6AFAAB4D}
// *********************************************************************//
  IGlueEventSink = dispinterface
    ['{0EE5A248-F02A-4551-8745-437F6AFAAB4D}']
    procedure OnGlueVariantResponse(const correlationId: WideString; data: OleVariant); dispid 1610743808;
    procedure OnGlueVariantInvoke(const correlationId: WideString; data: OleVariant;
                                  const callbackId: WideString); dispid 1610743809;
    procedure OnGlueResponse(const correlationId: WideString; const jsonData: WideString); dispid 1610743810;
    procedure OnGlueInvoke(const correlationId: WideString; const jsonData: WideString;
                           const callbackId: WideString); dispid 1610743811;
  end;

// *********************************************************************//
// Interface: IGlueContextBuilderCallback
// Flags:     (256) OleAutomation
// GUID:      {0856C290-92E8-49A3-ADD9-741E551BD70F}
// *********************************************************************//
  IGlueContextBuilderCallback = interface(IUnknown)
    ['{0856C290-92E8-49A3-ADD9-741E551BD70F}']
    function Build(const builder: IGlueContextBuilder): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IGlueWindow
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2F432B71-D338-419B-B150-E5E111F3D9A3}
// *********************************************************************//
  IGlueWindow = interface(IDispatch)
    ['{2F432B71-D338-419B-B150-E5E111F3D9A3}']
    function GetId: WideString; safecall;
    function IsVisible: WordBool; safecall;
    procedure SetVisible(visible: WordBool); safecall;
    function GetTitle: WideString; safecall;
    procedure SetTitle(const title: WideString); safecall;
    function GetChannelSupport: WordBool; safecall;
    procedure SetChannelSupport(showLink: WordBool); safecall;
    procedure Unregister; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueWindowDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2F432B71-D338-419B-B150-E5E111F3D9A3}
// *********************************************************************//
  IGlueWindowDisp = dispinterface
    ['{2F432B71-D338-419B-B150-E5E111F3D9A3}']
    function GetId: WideString; dispid 1610743808;
    function IsVisible: WordBool; dispid 1610743809;
    procedure SetVisible(visible: WordBool); dispid 1610743810;
    function GetTitle: WideString; dispid 1610743811;
    procedure SetTitle(const title: WideString); dispid 1610743812;
    function GetChannelSupport: WordBool; dispid 1610743813;
    procedure SetChannelSupport(showLink: WordBool); dispid 1610743814;
    procedure Unregister; dispid 1610743815;
  end;

// *********************************************************************//
// Interface: IGlueServerSubscriptionCallback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1CE0C9B4-C1D2-4F0D-A5A5-57EA027424BE}
// *********************************************************************//
  IGlueServerSubscriptionCallback = interface(IDispatch)
    ['{1CE0C9B4-C1D2-4F0D-A5A5-57EA027424BE}']
    function Accept(const branch: WideString; Result: GlueResult): IGlueStreamBranch; safecall;
    procedure Reject(Result: GlueResult); safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueServerSubscriptionCallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1CE0C9B4-C1D2-4F0D-A5A5-57EA027424BE}
// *********************************************************************//
  IGlueServerSubscriptionCallbackDisp = dispinterface
    ['{1CE0C9B4-C1D2-4F0D-A5A5-57EA027424BE}']
    function Accept(const branch: WideString; Result: {NOT_OLEAUTO(GlueResult)}OleVariant): IGlueStreamBranch; dispid 1610743808;
    procedure Reject(Result: {NOT_OLEAUTO(GlueResult)}OleVariant); dispid 1610743809;
  end;

// *********************************************************************//
// Interface: IGlueStream
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {311F7E47-8BFD-4174-B493-8FA9F9192464}
// *********************************************************************//
  IGlueStream = interface(IDispatch)
    ['{311F7E47-8BFD-4174-B493-8FA9F9192464}']
    procedure Push(data: PSafeArray; const branch: WideString); safecall;
    procedure CloseBranch(const branch: WideString); safecall;
    procedure CloseStream; safecall;
    function GetBranchKeys: PSafeArray; safecall;
    function GetBranch(const branchKey: WideString): IGlueStreamBranch; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueStreamDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {311F7E47-8BFD-4174-B493-8FA9F9192464}
// *********************************************************************//
  IGlueStreamDisp = dispinterface
    ['{311F7E47-8BFD-4174-B493-8FA9F9192464}']
    procedure Push(data: {NOT_OLEAUTO(PSafeArray)}OleVariant; const branch: WideString); dispid 1610743808;
    procedure CloseBranch(const branch: WideString); dispid 1610743809;
    procedure CloseStream; dispid 1610743810;
    function GetBranchKeys: {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743811;
    function GetBranch(const branchKey: WideString): IGlueStreamBranch; dispid 1610743812;
  end;

// *********************************************************************//
// Interface: IGlueStreamBranch
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C770A188-815A-4D61-89BA-5F283F698A07}
// *********************************************************************//
  IGlueStreamBranch = interface(IDispatch)
    ['{C770A188-815A-4D61-89BA-5F283F698A07}']
    function GetKey: WideString; safecall;
    procedure Push(data: PSafeArray); safecall;
    procedure Close; safecall;
    function GetStream: IGlueStream; safecall;
    function GetSubscribers: PSafeArray; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueStreamBranchDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C770A188-815A-4D61-89BA-5F283F698A07}
// *********************************************************************//
  IGlueStreamBranchDisp = dispinterface
    ['{C770A188-815A-4D61-89BA-5F283F698A07}']
    function GetKey: WideString; dispid 1610743808;
    procedure Push(data: {NOT_OLEAUTO(PSafeArray)}OleVariant); dispid 1610743809;
    procedure Close; dispid 1610743810;
    function GetStream: IGlueStream; dispid 1610743811;
    function GetSubscribers: {NOT_OLEAUTO(PSafeArray)}OleVariant; dispid 1610743812;
  end;

// *********************************************************************//
// Interface: IGlueStreamHandler
// Flags:     (256) OleAutomation
// GUID:      {A384126A-06D1-41CE-942C-4376D4574F4B}
// *********************************************************************//
  IGlueStreamHandler = interface(IUnknown)
    ['{A384126A-06D1-41CE-942C-4376D4574F4B}']
    function StreamOpened(stream: GlueMethod; const glueStreamSubscription: IGlueStreamSubscription): HResult; stdcall;
    function HandleStreamData(stream: GlueMethod; data: PSafeArray): HResult; stdcall;
    function HandleStreamStatus(stream: GlueMethod; state: GlueStreamState;
                                const Message: WideString; dateTime: Int64): HResult; stdcall;
    function StreamClosed(stream: GlueMethod): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IGlueStreamSubscriber
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {71587A98-0C44-4973-8EC6-74D71BA62F90}
// *********************************************************************//
  IGlueStreamSubscriber = interface(IDispatch)
    ['{71587A98-0C44-4973-8EC6-74D71BA62F90}']
    function GetSubscriberInstance: GlueInstance; safecall;
    procedure Push(data: PSafeArray); safecall;
    procedure Close(data: PSafeArray); safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueStreamSubscriberDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {71587A98-0C44-4973-8EC6-74D71BA62F90}
// *********************************************************************//
  IGlueStreamSubscriberDisp = dispinterface
    ['{71587A98-0C44-4973-8EC6-74D71BA62F90}']
    function GetSubscriberInstance: {NOT_OLEAUTO(GlueInstance)}OleVariant; dispid 1610743808;
    procedure Push(data: {NOT_OLEAUTO(PSafeArray)}OleVariant); dispid 1610743809;
    procedure Close(data: {NOT_OLEAUTO(PSafeArray)}OleVariant); dispid 1610743810;
  end;

// *********************************************************************//
// Interface: IGlueStreamSubscription
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E1ADF3C1-D11C-4E96-B9E9-D0B52B02DBCD}
// *********************************************************************//
  IGlueStreamSubscription = interface(IDispatch)
    ['{E1ADF3C1-D11C-4E96-B9E9-D0B52B02DBCD}']
    procedure Close; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueStreamSubscriptionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E1ADF3C1-D11C-4E96-B9E9-D0B52B02DBCD}
// *********************************************************************//
  IGlueStreamSubscriptionDisp = dispinterface
    ['{E1ADF3C1-D11C-4E96-B9E9-D0B52B02DBCD}']
    procedure Close; dispid 1610743808;
  end;

// *********************************************************************//
// Interface: IGlueSubscriptionHandler
// Flags:     (256) OleAutomation
// GUID:      {DAA04777-BD8E-4180-9021-48A0807A2E1D}
// *********************************************************************//
  IGlueSubscriptionHandler = interface(IUnknown)
    ['{DAA04777-BD8E-4180-9021-48A0807A2E1D}']
    function HandleSubscriptionRequest(stream: GlueMethod; caller: GlueInstance;
                                       requestValues: PSafeArray;
                                       const callback: IGlueServerSubscriptionCallback): HResult; stdcall;
    function HandleSubscriber(subscriberInstance: GlueInstance;
                              const glueStreamSubscriber: IGlueStreamSubscriber;
                              requestValues: PSafeArray): HResult; stdcall;
    function HandleSubscriberLost(streamSubscriber: GlueInstance;
                                  const glueStreamSubscriber: IGlueStreamSubscriber): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IGlueRequestHandler
// Flags:     (256) OleAutomation
// GUID:      {81671796-A690-476B-85EA-94326B7CA2B5}
// *********************************************************************//
  IGlueRequestHandler = interface(IUnknown)
    ['{81671796-A690-476B-85EA-94326B7CA2B5}']
    function HandleInvocationRequest(Method: GlueMethod; caller: GlueInstance;
                                     requestValues: PSafeArray;
                                     const resultCallback: IGlueServerMethodResultCallback): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IGlueServerMethodResultCallback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2497D4E6-C398-4DBB-904D-83B55F701E46}
// *********************************************************************//
  IGlueServerMethodResultCallback = interface(IDispatch)
    ['{2497D4E6-C398-4DBB-904D-83B55F701E46}']
    procedure SendResult(Result: GlueResult); safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueServerMethodResultCallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2497D4E6-C398-4DBB-904D-83B55F701E46}
// *********************************************************************//
  IGlueServerMethodResultCallbackDisp = dispinterface
    ['{2497D4E6-C398-4DBB-904D-83B55F701E46}']
    procedure SendResult(Result: {NOT_OLEAUTO(GlueResult)}OleVariant); dispid 1610743808;
  end;

// *********************************************************************//
// Interface: IGlueInvocationResultHandler
// Flags:     (256) OleAutomation
// GUID:      {3549297E-57A9-4F65-9183-D95232E55469}
// *********************************************************************//
  IGlueInvocationResultHandler = interface(IUnknown)
    ['{3549297E-57A9-4F65-9183-D95232E55469}']
    function HandleResult(invocationResult: PSafeArray; const correlationId: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IGlueWindowEventHandler
// Flags:     (256) OleAutomation
// GUID:      {FBCB4411-153C-4AAC-8DC8-DB696C931FEB}
// *********************************************************************//
  IGlueWindowEventHandler = interface(IUnknown)
    ['{FBCB4411-153C-4AAC-8DC8-DB696C931FEB}']
    function HandleChannelData(const glueWindow: IGlueWindow;
                               const channelUpdate: IGlueContextUpdate): HResult; stdcall;
    function HandleChannelChanged(const glueWindow: IGlueWindow; const channel: IGlueContext;
                                  prevChannel: GlueContext): HResult; stdcall;
    function HandleWindowDestroyed(const glueWindow: IGlueWindow): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoGlue42 provides a Create and CreateRemote method to
// create instances of the default interface IGlue42 exposed by
// the CoClass Glue42. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoGlue42 = class
    class function Create: IGlue42;
    class function CreateRemote(const MachineName: string): IGlue42;
  end;

implementation

uses System.Win.ComObj;

class function CoGlue42.Create: IGlue42;
begin
  Result := CreateComObject(CLASS_Glue42) as IGlue42;
end;

class function CoGlue42.CreateRemote(const MachineName: string): IGlue42;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Glue42) as IGlue42;
end;

end.
