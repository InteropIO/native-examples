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

// PASTLWTR : 1.2
// File generated on 1/28/2022 5:57:52 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\work\tick42\stash\dot-net-glue-com\GlueCom\bin\Debug\GlueCOM.dll (1)
// LIBID: {84EF66B3-C5E2-4C58-AD95-0E956FAE7027}
// LCID: 0
// Helpfile: 
// HelpString: Tick42 Glue for COM
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
//   (2) v2.4 mscorlib, (C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorlib.tlb)
// Errors:
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Error creating palette bitmap of (TGlueException) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TGlue42) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TGlueDynamicValue) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TGlueWindowSettings) : Server mscoree.dll contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, mscorlib_TLB, OleServer, StdVCL, Variants;
  


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

  DIID_IGlueNameValuePair: TGUID = '{1F8757FA-F806-43E6-A224-6889FD77CEA2}';
  CLASS_GlueNameValuePair: TGUID = '{1D7E88AF-6603-4B94-8EBC-197B50FD6571}';
  IID__GlueException: TGUID = '{77A3400F-F4AC-3AA1-B0D9-39D704BD1949}';
  IID_IGlue42: TGUID = '{DB20C8DA-CD98-4D75-8B9A-18284B7EE0D1}';
  CLASS_GlueDynamicValueBase: TGUID = '{C4ED0287-3E7D-45E8-A42B-03851CA337EF}';
  DIID_IGlueValueCollection: TGUID = '{57F378B0-6D2A-4710-8696-DB021283A2BF}';
  CLASS_GlueDynamicValue: TGUID = '{496249AA-598F-4E57-9DD4-80C7FA55CEF3}';
  IID_IGlueContext: TGUID = '{E36214AA-00E9-4057-8DB3-B381C8839735}';
  IID_IGlueContextBuilder: TGUID = '{E6BF93F6-3277-4BFD-8F30-4B76E72745E2}';
  IID_IGlueContextHandler: TGUID = '{E7DF128A-1584-49F9-87FE-06FA062DA1FB}';
  DIID_IGlueContextEvents: TGUID = '{04506BEC-804F-4FA0-B769-8C8DF1F71293}';
  IID_IGlueContextUpdate: TGUID = '{FCA1B294-A416-4533-AFAF-3640FDE02B1A}';
  IID_IGlueEvents: TGUID = '{A9B9392C-14B9-42BC-8BCD-7B07EF36003C}';
  DIID_IGlueEventSink: TGUID = '{0EE5A248-F02A-4551-8745-437F6AFAAB4D}';
  DIID_IGlueTypedEventSink: TGUID = '{45EA39A0-D5C6-4E15-B39B-E356A646561B}';
  IID_IGlueContextBuilderCallback: TGUID = '{0856C290-92E8-49A3-ADD9-741E551BD70F}';
  IID_IGlueWindowSettings: TGUID = '{DA16AD71-DF87-4243-B85B-47CE09F6ED8F}';
  CLASS_GlueWindowSettings: TGUID = '{F7A641B7-1407-4B3D-A9EB-D3C47BB579B6}';
  DIID_IGlueServerMethod: TGUID = '{E2331307-B552-4C57-B2E1-62E6DCA380DC}';
  DIID_IGlueMethodInvocator: TGUID = '{DA0A6BAF-6967-4F6B-91C9-21743B5D23A1}';
  DIID_IGlueStreamConsumer: TGUID = '{2F7F15D5-7206-4C87-A390-ED0B42C2CA36}';
  DIID_IGlueStreamConsumerEvents: TGUID = '{45E44742-45E8-4C58-BB18-8663D4C20D11}';
  DIID_IGlueMethodInfo: TGUID = '{455FA15C-AE59-403F-A80E-5216EB975FB7}';
  CLASS_GlueMethodInfo: TGUID = '{0114F791-9F8C-4237-9368-FD9096EA0E5C}';
  DIID_IGlueData: TGUID = '{8056A674-5A37-430D-847D-C99F38721C10}';
  CLASS_GlueData: TGUID = '{B05FD585-A3D0-456A-9006-0B34AC25704B}';
  CLASS_GlueStreamConsumer: TGUID = '{E80EDB19-B149-43F4-B6CB-39E5EE4318C1}';
  DIID_IGlueMethodInvocatorEvents: TGUID = '{AA4DF44F-E91A-4C9E-8288-02D93C5B1E4C}';
  DIID_IGlueInvocationResult: TGUID = '{B73B2552-BF00-4AD9-927B-77F0DC9FBC4E}';
  CLASS_VbGlueInvocationResult: TGUID = '{ED75F977-4AD9-48D3-B85B-59E503F8F3AE}';
  CLASS_GlueMethodInvocator: TGUID = '{47C68069-F7AE-49F9-9EEA-231990D2CDE6}';
  DIID_IGlueServerMethodEvents: TGUID = '{9E690080-E140-4A99-B962-F9132AD9E4D8}';
  DIID_IGlueServerStream: TGUID = '{E3330E58-F99B-452C-BE10-1A916FACA5B4}';
  DIID_IVBGlueStreamSubscriber: TGUID = '{632317F3-E6C2-4FB9-AB8F-067DF1F113CA}';
  CLASS_VBGlueStreamSubscriber: TGUID = '{8E9B605B-E9DB-4046-A472-C11C370ECDF6}';
  IID_IGlueSubscriptionHandler: TGUID = '{DAA04777-BD8E-4180-9021-48A0807A2E1D}';
  DIID_IGlueInvocationRequest: TGUID = '{9811A276-E7E7-4C86-92F1-C4677288723B}';
  CLASS_GlueInvocationRequest: TGUID = '{593D2314-2879-4962-9427-A90FEC191648}';
  DIID_IGlueSubscriptionRequest: TGUID = '{D6E08259-D2B4-453D-B050-E9DD9F6308C8}';
  CLASS_GlueSubscriptionRequest: TGUID = '{AD97252D-47E5-41EA-978F-2BB83876FD17}';
  IID_IGlueWindow: TGUID = '{2F432B71-D338-419B-B150-E5E111F3D9A3}';
  IID_IAppFactoryRegistry: TGUID = '{B1810DB3-167B-4FBD-8852-0481B0BBFDC4}';
  IID_IGlueServerSubscriptionCallback: TGUID = '{1CE0C9B4-C1D2-4F0D-A5A5-57EA027424BE}';
  IID_IGlueStream: TGUID = '{311F7E47-8BFD-4174-B493-8FA9F9192464}';
  IID_IGlueStreamBranch: TGUID = '{C770A188-815A-4D61-89BA-5F283F698A07}';
  IID_IGlueStreamHandler: TGUID = '{A384126A-06D1-41CE-942C-4376D4574F4B}';
  IID_IGlueStreamSubscriber: TGUID = '{71587A98-0C44-4973-8EC6-74D71BA62F90}';
  IID_IGlueStreamSubscription: TGUID = '{E1ADF3C1-D11C-4E96-B9E9-D0B52B02DBCD}';
  DIID_IGlueSubscriptionHandlerEvents: TGUID = '{96E100B1-CCE8-463C-8965-2567B08ECF37}';
  CLASS_GlueServerStream: TGUID = '{C7597981-309E-41D6-BFCA-5099A6F0BD0E}';
  IID_IGlueRequestHandler: TGUID = '{81671796-A690-476B-85EA-94326B7CA2B5}';
  CLASS_GlueServerMethod: TGUID = '{E5C2164E-D3CA-4D32-92CB-029C9B214FF4}';
  IID_IGlueServerMethodResultCallback: TGUID = '{2497D4E6-C398-4DBB-904D-83B55F701E46}';
  IID_IGlueInvocationResultHandler: TGUID = '{3549297E-57A9-4F65-9183-D95232E55469}';
  DIID_IGlueInvocationResultEvents: TGUID = '{2A3E264F-C7A0-4F08-A1EF-4143D87C7087}';
  IID_IGlueWindowEventHandler: TGUID = '{FBCB4411-153C-4AAC-8DC8-DB696C931FEB}';
  DIID_IGlueWindowEvents: TGUID = '{30B72DA7-93FD-4B9F-BDA2-6EEE1F41EE30}';
  CLASS_Glue42: TGUID = '{556D7D1B-7E89-454A-8575-85B1ABE35941}';
  IID_IGlueValueReceiver: TGUID = '{1F3494B7-89BF-4392-BFAB-14B72C7556FC}';
  IID_IAppFactory: TGUID = '{505D3B9B-8ABD-4AC3-8EFE-66C64C372009}';
  IID_IGlueApp: TGUID = '{1ADA0F8C-A888-45E7-B500-59AD176A690E}';
  IID_IAppAnnouncer: TGUID = '{32EE037F-139B-4685-8BE1-AAC7A082507F}';
  CLASS_GlueStreamSubscription: TGUID = '{D4E3DD22-0EAB-4761-BE7D-7A040AE02BDE}';
  CLASS_GlueWindow: TGUID = '{7D7A8474-4855-401C-8F8A-8DA77D454443}';
  CLASS_GlueContextImage: TGUID = '{7212E737-5831-4058-88E3-4512AB60DFE2}';
  CLASS_GlueContextUpdate: TGUID = '{60B4684E-5853-41F7-821F-51EFEFDD8A45}';
  CLASS_GlueContextManager: TGUID = '{AB3721D4-2735-464E-BD79-3187B165C812}';
  CLASS_GlueException: TGUID = '{3CB2D568-58F9-44D6-83EC-472FB5AE284A}';

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

// Constants for enum GlueWindowEventType
type
  GlueWindowEventType = TOleEnum;
const
  GlueWindowEventType_Unknown = $00000000;
  GlueWindowEventType_Snapshot = $00000001;
  GlueWindowEventType_WindowFrameAdded = $00000002;
  GlueWindowEventType_WindowFrameRemoved = $00000003;
  GlueWindowEventType_WindowFrameChanged = $00000004;
  GlueWindowEventType_ButtonClicked = $00000005;
  GlueWindowEventType_ButtonRemoved = $00000006;
  GlueWindowEventType_ButtonAdded = $00000007;
  GlueWindowEventType_GroupHeaderVisibilityChanged = $00000008;
  GlueWindowEventType_CompositionChanged = $00000009;
  GlueWindowEventType_FrameColorChanged = $0000000A;
  GlueWindowEventType_Created = $0000000B;
  GlueWindowEventType_Closed = $0000000C;
  GlueWindowEventType_UrlChanged = $0000000D;
  GlueWindowEventType_ContextChanged = $0000000E;
  GlueWindowEventType_VisibilityChanged = $0000000F;
  GlueWindowEventType_BoundsChanged = $00000010;
  GlueWindowEventType_StateChanged = $00000011;
  GlueWindowEventType_FocusChanged = $00000012;
  GlueWindowEventType_TitleChanged = $00000013;
  GlueWindowEventType_WindowCanvasWindowChanged = $00000014;
  GlueWindowEventType_TabHeaderVisibilityChanged = $00000015;
  GlueWindowEventType_FrameSelectionChanged = $00000016;
  GlueWindowEventType_ShowFlydownBoundsRequested = $00000017;
  GlueWindowEventType_WindowZoomFactorChanged = $00000018;
  GlueWindowEventType_FrameIsLockedChanged = $00000019;
  GlueWindowEventType_DOMReady = $0000001A;
  GlueWindowEventType_Hibernated = $0000001B;
  GlueWindowEventType_Resumed = $0000001C;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IGlueNameValuePair = dispinterface;
  _GlueException = interface;
  _GlueExceptionDisp = dispinterface;
  IGlue42 = interface;
  IGlue42Disp = dispinterface;
  IGlueValueCollection = dispinterface;
  IGlueContext = interface;
  IGlueContextDisp = dispinterface;
  IGlueContextBuilder = interface;
  IGlueContextBuilderDisp = dispinterface;
  IGlueContextHandler = interface;
  IGlueContextEvents = dispinterface;
  IGlueContextUpdate = interface;
  IGlueContextUpdateDisp = dispinterface;
  IGlueEvents = interface;
  IGlueEventSink = dispinterface;
  IGlueTypedEventSink = dispinterface;
  IGlueContextBuilderCallback = interface;
  IGlueWindowSettings = interface;
  IGlueWindowSettingsDisp = dispinterface;
  IGlueServerMethod = dispinterface;
  IGlueMethodInvocator = dispinterface;
  IGlueStreamConsumer = dispinterface;
  IGlueStreamConsumerEvents = dispinterface;
  IGlueMethodInfo = dispinterface;
  IGlueData = dispinterface;
  IGlueMethodInvocatorEvents = dispinterface;
  IGlueInvocationResult = dispinterface;
  IGlueServerMethodEvents = dispinterface;
  IGlueServerStream = dispinterface;
  IVBGlueStreamSubscriber = dispinterface;
  IGlueSubscriptionHandler = interface;
  IGlueInvocationRequest = dispinterface;
  IGlueSubscriptionRequest = dispinterface;
  IGlueWindow = interface;
  IGlueWindowDisp = dispinterface;
  IAppFactoryRegistry = interface;
  IAppFactoryRegistryDisp = dispinterface;
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
  IGlueSubscriptionHandlerEvents = dispinterface;
  IGlueRequestHandler = interface;
  IGlueServerMethodResultCallback = interface;
  IGlueServerMethodResultCallbackDisp = dispinterface;
  IGlueInvocationResultHandler = interface;
  IGlueInvocationResultEvents = dispinterface;
  IGlueWindowEventHandler = interface;
  IGlueWindowEvents = dispinterface;
  IGlueValueReceiver = interface;
  IGlueValueReceiverDisp = dispinterface;
  IAppFactory = interface;
  IGlueApp = interface;
  IAppAnnouncer = interface;
  IAppAnnouncerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  GlueNameValuePair = IGlueNameValuePair;
  GlueDynamicValueBase = IReflect;
  GlueDynamicValue = IGlueValueCollection;
  GlueWindowSettings = IGlueWindowSettings;
  GlueMethodInfo = IGlueMethodInfo;
  GlueData = IGlueData;
  GlueStreamConsumer = IGlueStreamConsumer;
  VbGlueInvocationResult = IGlueInvocationResult;
  GlueMethodInvocator = IGlueMethodInvocator;
  VBGlueStreamSubscriber = IVBGlueStreamSubscriber;
  GlueInvocationRequest = IGlueInvocationRequest;
  GlueSubscriptionRequest = IGlueSubscriptionRequest;
  GlueServerStream = IGlueServerStream;
  GlueServerMethod = IGlueServerMethod;
  Glue42 = IGlue42;
  GlueStreamSubscription = IGlueStreamSubscription;
  GlueWindow = IGlueWindow;
  GlueContextImage = IGlueContextUpdate;
  GlueContextUpdate = IGlueContextUpdate;
  GlueContextManager = IGlueContext;
  GlueException = _GlueException;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  GlueConfiguration = record
    LoggingConfigurationPath: WideString;
    GWUri: WideString;
    AppDefinitionStartup: WideString;
    AppDefinitionStartupArgs: WideString;
    AppDefinitionTitle: WideString;
    TerminateOnShutdown: WordBool;
    InitTimeoutMsecs: Int64;
    AsyncInit: WordBool;
  end;

  GlueContext = record
    Name: WideString;
    Id: WideString;
  end;

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

  GlueMethod = record
    Name: WideString;
    Input: WideString;
    Output: WideString;
    Instance: GlueInstance;
    RegistrationCookie: WideString;
    Flags: GlueMethodFlags;
    ObjectTypes: PSafeArray;
  end;

  GlueResult = record
    Values: PSafeArray;
    Status: GlueMethodInvocationStatus;
    Message: WideString;
    LogDetails: WideString;
  end;

  GlueContextValue = record
    Name: WideString;
    Value: GlueValue;
  end;

  VBGlueInstance = record
    InstanceId: WideString;
    Version: WideString;
    MachineName: WideString;
    ProcessId: Integer;
    ProcessStartTime: Double;
    UserName: WideString;
    ApplicationName: WideString;
    Environment: WideString;
    Region: WideString;
    ServiceName: WideString;
    MetricsRepositoryId: WideString;
    Metadata: IGlueValueCollection;
  end;

  VBGlueMethod = record
    Name: WideString;
    Input: WideString;
    Output: WideString;
    Instance: VBGlueInstance;
    RegistrationCookie: WideString;
    Flags: GlueMethodFlags;
    ObjectTypes: PSafeArray;
  end;

  VBGlueResult = record
    method: VBGlueMethod;
    Status: GlueMethodInvocationStatus;
    Message: WideString;
    LogDetails: WideString;
    GlueData: IGlueData;
  end;

  GlueInvocationResult = record
    method: GlueMethod;
    result: GlueResult;
  end;

  GlueAppDefinition = record
    Name: WideString;
    Title: WideString;
    Category: WideString;
  end;


// *********************************************************************//
// DispIntf:  IGlueNameValuePair
// Flags:     (4096) Dispatchable
// GUID:      {1F8757FA-F806-43E6-A224-6889FD77CEA2}
// *********************************************************************//
  IGlueNameValuePair = dispinterface
    ['{1F8757FA-F806-43E6-A224-6889FD77CEA2}']
    property Name: WideString readonly dispid 1610743808;
    property Value: OleVariant readonly dispid 0;
  end;

// *********************************************************************//
// Interface: _GlueException
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {77A3400F-F4AC-3AA1-B0D9-39D704BD1949}
// *********************************************************************//
  _GlueException = interface(IDispatch)
    ['{77A3400F-F4AC-3AA1-B0D9-39D704BD1949}']
  end;

// *********************************************************************//
// DispIntf:  _GlueExceptionDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {77A3400F-F4AC-3AA1-B0D9-39D704BD1949}
// *********************************************************************//
  _GlueExceptionDisp = dispinterface
    ['{77A3400F-F4AC-3AA1-B0D9-39D704BD1949}']
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
    function TranslateVbObject(data: OleVariant): OleVariant; safecall;
    procedure SetLogConfigurationPath(const logConfigPath: WideString); safecall;
    procedure StartWithAppName(const ApplicationName: WideString); safecall;
    procedure Stop; safecall;
    function RegisterGlueWindow(hwnd: Integer; const windowEventHandler: IGlueWindowEventHandler): IGlueWindow; safecall;
    function RegisterStartupGlueWindow(hwnd: Integer; 
                                       const windowEventHandler: IGlueWindowEventHandler): IGlueWindow; safecall;
    function CreateDefaultVBGlueWindowSettings: IGlueWindowSettings; safecall;
    function GetStartupWindowSettings: IGlueWindowSettings; safecall;
    function RegisterGlueWindowWithSettings(hwnd: Integer; const settings: IGlueWindowSettings; 
                                            const windowEventHandler: IGlueWindowEventHandler): IGlueWindow; safecall;
    function RegisterStartupGlueWindowWithSettings(hwnd: Integer; 
                                                   const settings: IGlueWindowSettings; 
                                                   const windowEventHandler: IGlueWindowEventHandler): IGlueWindow; safecall;
    function GetInstance: GlueInstance; safecall;
    function CreateGlueValues: OleVariant; safecall;
    function CreateGlueData(data: OleVariant): IGlueData; safecall;
    function GetKnownContexts: PSafeArray; safecall;
    procedure SubscribeGlueContext(const contextName: WideString; const handler: IGlueContextHandler); safecall;
    function GetGlueContext(const contextName: WideString): IGlueContext; safecall;
    function GetAllInstances: PSafeArray; safecall;
    function GetAllMethods: PSafeArray; safecall;
    function GetMethodsForInstance(Instance: GlueInstance; identity: GlueInstanceIdentity): PSafeArray; safecall;
    procedure Subscribe(const handler: IGlueEvents); safecall;
    procedure Unsubscribe(const handler: IGlueEvents); safecall;
    function BuildGlueContextValues(const contextBuilderCallback: IGlueContextBuilderCallback): PSafeArray; safecall;
    function RegisterMethod(const methodName: WideString; 
                            const requestHandler: IGlueRequestHandler; const Input: WideString; 
                            const Output: WideString; ObjectTypes: PSafeArray): GlueMethod; safecall;
    function CreateServerMethod(const methodName: WideString; const Input: WideString; 
                                const Output: WideString; const objectTypesCSV: WideString): IGlueServerMethod; safecall;
    function CreateServerStream(const streamName: WideString; const Input: WideString; 
                                const Output: WideString; const objectTypesCSV: WideString): IGlueServerStream; safecall;
    function CreateMethodInvocator: IGlueMethodInvocator; safecall;
    function CreateStreamConsumer: IGlueStreamConsumer; safecall;
    function RegisterStream(const streamName: WideString; 
                            const subscriptionHandler: IGlueSubscriptionHandler; 
                            const Input: WideString; const Output: WideString; 
                            ObjectTypes: PSafeArray; out stream: IGlueStream): GlueMethod; safecall;
    procedure UnregisterMethod(method: GlueMethod); safecall;
    procedure BuildAndInvoke(const method: WideString; 
                             const builderCallback: IGlueContextBuilderCallback; 
                             targets: PSafeArray; all: WordBool; identity: GlueInstanceIdentity; 
                             const resultHandler: IGlueInvocationResultHandler; 
                             invocationTimeoutMsecs: Int64; const correlationId: WideString); safecall;
    procedure InvokeMethods(const method: WideString; invocationArgs: PSafeArray; 
                            targets: PSafeArray; all: WordBool; identity: GlueInstanceIdentity; 
                            const resultHandler: IGlueInvocationResultHandler; 
                            invocationTimeoutMsecs: Int64; const correlationId: WideString); safecall;
    procedure InvokeMethod(method: GlueMethod; invocationArgs: PSafeArray; 
                           const resultHandler: IGlueInvocationResultHandler; 
                           invocationTimeoutMsecs: Int64; const correlationId: WideString); safecall;
    procedure SubscribeStreams(const streamName: WideString; subscriptionRequestArgs: PSafeArray; 
                               targets: PSafeArray; all: WordBool; identity: GlueInstanceIdentity; 
                               const streamHandler: IGlueStreamHandler; 
                               invocationTimeoutMsecs: Int64); safecall;
    procedure SubscribeStreamsFilterTargets(const streamName: WideString; 
                                            subscriptionRequestArgs: PSafeArray; 
                                            const targetRegex: WideString; all: WordBool; 
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
    function GetMethodNamesForTarget(const targetRegex: WideString): PSafeArray; safecall;
    function GetTargets: PSafeArray; safecall;
    function GetChannels: PSafeArray; safecall;
    procedure InvokeAsyncVariantData(const correlationId: WideString; const methodName: WideString; 
                                     args: OleVariant; const resultFieldPath: WideString; 
                                     const targetRegex: WideString); safecall;
    procedure SubscribeChannel(const correlationId: WideString; const Channel: WideString; 
                               const resultFieldPath: WideString); safecall;
    procedure SetChannelData(const Channel: WideString; const fieldPath: WideString; 
                             const data: WideString); safecall;
    procedure G4O_XL_OpenSheet(const correlationId: WideString; const sheetName: WideString; 
                               columnNames: PSafeArray; columnValidationTypes: PSafeArray; 
                               data: OleVariant); safecall;
    procedure Log(level: Byte; const Message: WideString); safecall;
    function Get_AppFactoryRegistry: IAppFactoryRegistry; safecall;
    function GetState: GlueState; safecall;
    function IsLaunchedByGD: WordBool; safecall;
    function GetStartingContext: GlueValue; safecall;
    property AppFactoryRegistry: IAppFactoryRegistry read Get_AppFactoryRegistry;
  end;

// *********************************************************************//
// DispIntf:  IGlue42Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DB20C8DA-CD98-4D75-8B9A-18284B7EE0D1}
// *********************************************************************//
  IGlue42Disp = dispinterface
    ['{DB20C8DA-CD98-4D75-8B9A-18284B7EE0D1}']
    procedure OverrideConfiguration(configuration: {??GlueConfiguration}OleVariant); dispid 1610743808;
    procedure Start(Instance: {??GlueInstance}OleVariant); dispid 1610743809;
    function TranslateVbObject(data: OleVariant): OleVariant; dispid 1610743810;
    procedure SetLogConfigurationPath(const logConfigPath: WideString); dispid 1610743811;
    procedure StartWithAppName(const ApplicationName: WideString); dispid 1610743812;
    procedure Stop; dispid 1610743813;
    function RegisterGlueWindow(hwnd: Integer; const windowEventHandler: IGlueWindowEventHandler): IGlueWindow; dispid 1610743814;
    function RegisterStartupGlueWindow(hwnd: Integer; 
                                       const windowEventHandler: IGlueWindowEventHandler): IGlueWindow; dispid 1610743815;
    function CreateDefaultVBGlueWindowSettings: IGlueWindowSettings; dispid 1610743816;
    function GetStartupWindowSettings: IGlueWindowSettings; dispid 1610743817;
    function RegisterGlueWindowWithSettings(hwnd: Integer; const settings: IGlueWindowSettings; 
                                            const windowEventHandler: IGlueWindowEventHandler): IGlueWindow; dispid 1610743818;
    function RegisterStartupGlueWindowWithSettings(hwnd: Integer; 
                                                   const settings: IGlueWindowSettings; 
                                                   const windowEventHandler: IGlueWindowEventHandler): IGlueWindow; dispid 1610743819;
    function GetInstance: {??GlueInstance}OleVariant; dispid 1610743820;
    function CreateGlueValues: OleVariant; dispid 1610743821;
    function CreateGlueData(data: OleVariant): IGlueData; dispid 1610743822;
    function GetKnownContexts: {??PSafeArray}OleVariant; dispid 1610743823;
    procedure SubscribeGlueContext(const contextName: WideString; const handler: IGlueContextHandler); dispid 1610743824;
    function GetGlueContext(const contextName: WideString): IGlueContext; dispid 1610743825;
    function GetAllInstances: {??PSafeArray}OleVariant; dispid 1610743826;
    function GetAllMethods: {??PSafeArray}OleVariant; dispid 1610743827;
    function GetMethodsForInstance(Instance: {??GlueInstance}OleVariant; 
                                   identity: GlueInstanceIdentity): {??PSafeArray}OleVariant; dispid 1610743828;
    procedure Subscribe(const handler: IGlueEvents); dispid 1610743829;
    procedure Unsubscribe(const handler: IGlueEvents); dispid 1610743830;
    function BuildGlueContextValues(const contextBuilderCallback: IGlueContextBuilderCallback): {??PSafeArray}OleVariant; dispid 1610743831;
    function RegisterMethod(const methodName: WideString; 
                            const requestHandler: IGlueRequestHandler; const Input: WideString; 
                            const Output: WideString; ObjectTypes: {??PSafeArray}OleVariant): {??GlueMethod}OleVariant; dispid 1610743832;
    function CreateServerMethod(const methodName: WideString; const Input: WideString; 
                                const Output: WideString; const objectTypesCSV: WideString): IGlueServerMethod; dispid 1610743833;
    function CreateServerStream(const streamName: WideString; const Input: WideString; 
                                const Output: WideString; const objectTypesCSV: WideString): IGlueServerStream; dispid 1610743834;
    function CreateMethodInvocator: IGlueMethodInvocator; dispid 1610743835;
    function CreateStreamConsumer: IGlueStreamConsumer; dispid 1610743836;
    function RegisterStream(const streamName: WideString; 
                            const subscriptionHandler: IGlueSubscriptionHandler; 
                            const Input: WideString; const Output: WideString; 
                            ObjectTypes: {??PSafeArray}OleVariant; out stream: IGlueStream): {??GlueMethod}OleVariant; dispid 1610743837;
    procedure UnregisterMethod(method: {??GlueMethod}OleVariant); dispid 1610743838;
    procedure BuildAndInvoke(const method: WideString; 
                             const builderCallback: IGlueContextBuilderCallback; 
                             targets: {??PSafeArray}OleVariant; all: WordBool; 
                             identity: GlueInstanceIdentity; 
                             const resultHandler: IGlueInvocationResultHandler; 
                             invocationTimeoutMsecs: {??Int64}OleVariant; 
                             const correlationId: WideString); dispid 1610743839;
    procedure InvokeMethods(const method: WideString; invocationArgs: {??PSafeArray}OleVariant; 
                            targets: {??PSafeArray}OleVariant; all: WordBool; 
                            identity: GlueInstanceIdentity; 
                            const resultHandler: IGlueInvocationResultHandler; 
                            invocationTimeoutMsecs: {??Int64}OleVariant; 
                            const correlationId: WideString); dispid 1610743840;
    procedure InvokeMethod(method: {??GlueMethod}OleVariant; 
                           invocationArgs: {??PSafeArray}OleVariant; 
                           const resultHandler: IGlueInvocationResultHandler; 
                           invocationTimeoutMsecs: {??Int64}OleVariant; 
                           const correlationId: WideString); dispid 1610743841;
    procedure SubscribeStreams(const streamName: WideString; 
                               subscriptionRequestArgs: {??PSafeArray}OleVariant; 
                               targets: {??PSafeArray}OleVariant; all: WordBool; 
                               identity: GlueInstanceIdentity; 
                               const streamHandler: IGlueStreamHandler; 
                               invocationTimeoutMsecs: {??Int64}OleVariant); dispid 1610743842;
    procedure SubscribeStreamsFilterTargets(const streamName: WideString; 
                                            subscriptionRequestArgs: {??PSafeArray}OleVariant; 
                                            const targetRegex: WideString; all: WordBool; 
                                            const streamHandler: IGlueStreamHandler; 
                                            invocationTimeoutMsecs: {??Int64}OleVariant); dispid 1610743843;
    procedure SubscribeStream(stream: {??GlueMethod}OleVariant; 
                              subscriptionRequestArgs: {??PSafeArray}OleVariant; 
                              const streamHandler: IGlueStreamHandler; 
                              subscriptionTimeoutMsecs: {??Int64}OleVariant); dispid 1610743844;
    function InvokeSync(const methodName: WideString; const argsAsJson: WideString; 
                        const resultFieldPath: WideString; const targetRegex: WideString): WideString; dispid 1610743845;
    procedure InvokeAsync(const correlationId: WideString; const methodName: WideString; 
                          const argsAsJson: WideString; const resultFieldPath: WideString; 
                          const targetRegex: WideString); dispid 1610743846;
    procedure SubscribeStreamInSink(const correlationId: WideString; const streamName: WideString; 
                                    const argsAsJson: WideString; 
                                    const resultFieldPath: WideString; 
                                    const targetRegex: WideString; 
                                    const filterFieldPath: WideString; 
                                    const filterDataRegex: WideString); dispid 1610743847;
    procedure RegisterMethodInSink(const correlationId: WideString; const methodName: WideString; 
                                   const inputSignature: WideString; 
                                   const outputSignature: WideString; 
                                   ObjectTypes: {??PSafeArray}OleVariant; 
                                   const invocationFieldPath: WideString; 
                                   const targetRegex: WideString; 
                                   const filterFieldPath: WideString; 
                                   const filterDataRegex: WideString); dispid 1610743848;
    procedure RegisterVariantMethodInSink(const correlationId: WideString; 
                                          const methodName: WideString; 
                                          const inputSignature: WideString; 
                                          const outputSignature: WideString; 
                                          ObjectTypes: {??PSafeArray}OleVariant; 
                                          const invocationFieldPath: WideString; 
                                          const targetRegex: WideString; 
                                          const filterFieldPath: WideString; 
                                          const filterDataRegex: WideString); dispid 1610743849;
    procedure RegisterVoidMethodInSink(const correlationId: WideString; 
                                       const methodName: WideString; 
                                       const inputSignature: WideString; 
                                       ObjectTypes: {??PSafeArray}OleVariant; 
                                       const invocationFieldPath: WideString; 
                                       const targetRegex: WideString; 
                                       const filterFieldPath: WideString; 
                                       const filterDataRegex: WideString); dispid 1610743850;
    procedure RegisterSingleBranchStream(const correlationId: WideString; 
                                         const streamName: WideString; 
                                         const requestSignature: WideString; 
                                         const streamSignature: WideString); dispid 1610743851;
    procedure AddCorrelationInterest(const correlationId: WideString; const interestId: WideString; 
                                     const fieldPath: WideString; 
                                     const filterFieldPath: WideString; 
                                     const filterDataRegex: WideString); dispid 1610743852;
    procedure RegisterStreamInSink(const correlationId: WideString; const streamName: WideString; 
                                   const requestSignature: WideString; 
                                   const streamSignature: WideString; 
                                   const requestFieldPath: WideString; 
                                   const targetRegex: WideString; 
                                   const filterFieldPath: WideString; 
                                   const filterDataRegex: WideString); dispid 1610743853;
    procedure YieldCallbackData(const correlationId: WideString; const callbackId: WideString; 
                                const callbackData: WideString); dispid 1610743854;
    procedure YieldCallbackVariantData(const correlationId: WideString; 
                                       const callbackId: WideString; callbackData: OleVariant); dispid 1610743855;
    procedure RegisterGlueWindowInSink(const correlationId: WideString; const hwnd: WideString); dispid 1610743856;
    function JsonToVariant(const json: WideString): {??PSafeArray}OleVariant; dispid 1610743857;
    procedure CloseResource(const correlationId: WideString); dispid 1610743858;
    function GetMethodNamesForTarget(const targetRegex: WideString): {??PSafeArray}OleVariant; dispid 1610743859;
    function GetTargets: {??PSafeArray}OleVariant; dispid 1610743860;
    function GetChannels: {??PSafeArray}OleVariant; dispid 1610743861;
    procedure InvokeAsyncVariantData(const correlationId: WideString; const methodName: WideString; 
                                     args: OleVariant; const resultFieldPath: WideString; 
                                     const targetRegex: WideString); dispid 1610743862;
    procedure SubscribeChannel(const correlationId: WideString; const Channel: WideString; 
                               const resultFieldPath: WideString); dispid 1610743863;
    procedure SetChannelData(const Channel: WideString; const fieldPath: WideString; 
                             const data: WideString); dispid 1610743864;
    procedure G4O_XL_OpenSheet(const correlationId: WideString; const sheetName: WideString; 
                               columnNames: {??PSafeArray}OleVariant; 
                               columnValidationTypes: {??PSafeArray}OleVariant; data: OleVariant); dispid 1610743865;
    procedure Log(level: Byte; const Message: WideString); dispid 1610743866;
    property AppFactoryRegistry: IAppFactoryRegistry readonly dispid 1610743867;
    function GetState: GlueState; dispid 1610743868;
    function IsLaunchedByGD: WordBool; dispid 1610743869;
    function GetStartingContext: {??GlueValue}OleVariant; dispid 1610743870;
  end;

// *********************************************************************//
// DispIntf:  IGlueValueCollection
// Flags:     (4096) Dispatchable
// GUID:      {57F378B0-6D2A-4710-8696-DB021283A2BF}
// *********************************************************************//
  IGlueValueCollection = dispinterface
    ['{57F378B0-6D2A-4710-8696-DB021283A2BF}']
    function GetEnumerator: IEnumVARIANT; dispid -4;
    property _Default[key: OleVariant]: OleVariant readonly dispid 0; default;
    property Count: Integer readonly dispid 1610743810;
    property Names: {??PSafeArray}OleVariant readonly dispid 1610743811;
    property Values: {??PSafeArray}OleVariant readonly dispid 1610743812;
    function Contains(const Name: WideString): WordBool; dispid 1610743813;
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
    function GetReflectData(const fieldPath: WideString): OleVariant; safecall;
    procedure SetValue(const fieldPath: WideString; Value: OleVariant); safecall;
    procedure SetContextData(data: PSafeArray); safecall;
    procedure BuildAndSetContextData(const builderCallback: IGlueContextBuilderCallback); safecall;
    procedure UpdateContextData(data: PSafeArray); safecall;
    procedure SetContextDataOnFieldPath(const fieldPath: WideString; data: PSafeArray); safecall;
    function GetDataAsJson(const fieldPath: WideString): WideString; safecall;
    procedure UpdateContextDataJson(const fieldPath: WideString; const jsonEncodedData: WideString); safecall;
    procedure BuildAndUpdateContextData(const builderCallback: IGlueContextBuilderCallback); safecall;
    procedure Remove(const fieldPath: WideString); safecall;
    procedure Open; safecall;
    procedure Close; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueContextDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E36214AA-00E9-4057-8DB3-B381C8839735}
// *********************************************************************//
  IGlueContextDisp = dispinterface
    ['{E36214AA-00E9-4057-8DB3-B381C8839735}']
    function GetContextInfo: {??GlueContext}OleVariant; dispid 1610743808;
    function GetData: {??PSafeArray}OleVariant; dispid 1610743809;
    function GetReflectData(const fieldPath: WideString): OleVariant; dispid 1610743810;
    procedure SetValue(const fieldPath: WideString; Value: OleVariant); dispid 1610743811;
    procedure SetContextData(data: {??PSafeArray}OleVariant); dispid 1610743812;
    procedure BuildAndSetContextData(const builderCallback: IGlueContextBuilderCallback); dispid 1610743813;
    procedure UpdateContextData(data: {??PSafeArray}OleVariant); dispid 1610743814;
    procedure SetContextDataOnFieldPath(const fieldPath: WideString; data: {??PSafeArray}OleVariant); dispid 1610743815;
    function GetDataAsJson(const fieldPath: WideString): WideString; dispid 1610743816;
    procedure UpdateContextDataJson(const fieldPath: WideString; const jsonEncodedData: WideString); dispid 1610743817;
    procedure BuildAndUpdateContextData(const builderCallback: IGlueContextBuilderCallback); dispid 1610743818;
    procedure Remove(const fieldPath: WideString); dispid 1610743819;
    procedure Open; dispid 1610743820;
    procedure Close; dispid 1610743821;
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
    procedure AddDatetime(const Name: WideString; Value: {??Int64}OleVariant); dispid 1610743809;
    procedure AddString(const Name: WideString; const Value: WideString); dispid 1610743810;
    procedure AddInt(const Name: WideString; Value: Integer); dispid 1610743811;
    procedure AddLong(const Name: WideString; Value: {??Int64}OleVariant); dispid 1610743812;
    procedure AddDouble(const Name: WideString; Value: Double); dispid 1610743813;
    procedure AddBoolArray(const Name: WideString; Value: {??PSafeArray}OleVariant); dispid 1610743814;
    procedure AddStringArray(const Name: WideString; Value: {??PSafeArray}OleVariant); dispid 1610743815;
    procedure AddIntArray(const Name: WideString; Value: {??PSafeArray}OleVariant); dispid 1610743816;
    procedure AddDatetimeArray(const Name: WideString; Value: {??PSafeArray}OleVariant); dispid 1610743817;
    procedure AddLongArray(const Name: WideString; Value: {??PSafeArray}OleVariant); dispid 1610743818;
    procedure AddDoubleArray(const Name: WideString; Value: {??PSafeArray}OleVariant); dispid 1610743819;
    procedure BuildComposite(const Name: WideString; const callback: IGlueContextBuilderCallback; 
                             IsArray: WordBool); dispid 1610743820;
    procedure BuildTuple(const Name: WideString; const callback: IGlueContextBuilderCallback); dispid 1610743821;
    procedure AddComposite(const Name: WideString; composite: {??PSafeArray}OleVariant; 
                           IsArray: WordBool); dispid 1610743822;
    procedure AddTuple(const Name: WideString; Tuple: {??PSafeArray}OleVariant); dispid 1610743823;
    procedure AddContextValue(GlueContextValue: {??GlueContextValue}OleVariant); dispid 1610743824;
    procedure AddGlueValue(const Name: WideString; Value: {??GlueValue}OleVariant); dispid 1610743825;
    procedure AddTupleValue(Value: {??GlueValue}OleVariant); dispid 1610743826;
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
// DispIntf:  IGlueContextEvents
// Flags:     (4096) Dispatchable
// GUID:      {04506BEC-804F-4FA0-B769-8C8DF1F71293}
// *********************************************************************//
  IGlueContextEvents = dispinterface
    ['{04506BEC-804F-4FA0-B769-8C8DF1F71293}']
    procedure HandleContext(const context: IGlueContext); dispid 1610743808;
    procedure HandleContextUpdate(const contextUpdate: IGlueContextUpdate); dispid 1610743809;
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
    function GetRemoved: {??PSafeArray}OleVariant; dispid 1610743809;
    function GetAdded: {??PSafeArray}OleVariant; dispid 1610743810;
    function GetUpdated: {??PSafeArray}OleVariant; dispid 1610743811;
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
    function HandleMethodStatus(method: GlueMethod; active: WordBool): HResult; stdcall;
    function HandleGlueContext(context: GlueContext; created: WordBool): HResult; stdcall;
    function HandleException(const Message: WideString; ex: GlueValue): HResult; stdcall;
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
// DispIntf:  IGlueTypedEventSink
// Flags:     (4096) Dispatchable
// GUID:      {45EA39A0-D5C6-4E15-B39B-E356A646561B}
// *********************************************************************//
  IGlueTypedEventSink = dispinterface
    ['{45EA39A0-D5C6-4E15-B39B-E356A646561B}']
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
// Interface: IGlueWindowSettings
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DA16AD71-DF87-4243-B85B-47CE09F6ED8F}
// *********************************************************************//
  IGlueWindowSettings = interface(IDispatch)
    ['{DA16AD71-DF87-4243-B85B-47CE09F6ED8F}']
    function Get_type_: WideString; safecall;
    procedure Set_type_(const pRetVal: WideString); safecall;
    function Get_Title: WideString; safecall;
    procedure Set_Title(const pRetVal: WideString); safecall;
    function Get_AllowTabClose: WordBool; safecall;
    procedure Set_AllowTabClose(pRetVal: WordBool); safecall;
    function Get_ChannelSupport: WordBool; safecall;
    procedure Set_ChannelSupport(pRetVal: WordBool); safecall;
    function Get_Channel: WideString; safecall;
    procedure Set_Channel(const pRetVal: WideString); safecall;
    function Get_ShowTaskbarIcon: WordBool; safecall;
    procedure Set_ShowTaskbarIcon(pRetVal: WordBool); safecall;
    function Get_IsSticky: WordBool; safecall;
    procedure Set_IsSticky(pRetVal: WordBool); safecall;
    function Get_AllowUnstick: WordBool; safecall;
    procedure Set_AllowUnstick(pRetVal: WordBool); safecall;
    function Get_FrameColor: WideString; safecall;
    procedure Set_FrameColor(const pRetVal: WideString); safecall;
    function Get_Icon: WideString; safecall;
    procedure Set_Icon(const pRetVal: WideString); safecall;
    function Get_StandardButtons: WideString; safecall;
    procedure Set_StandardButtons(const pRetVal: WideString); safecall;
    function Get_MaxWidth: Integer; safecall;
    procedure Set_MaxWidth(pRetVal: Integer); safecall;
    function Get_MinWidth: Integer; safecall;
    procedure Set_MinWidth(pRetVal: Integer); safecall;
    function Get_MaxHeight: Integer; safecall;
    procedure Set_MaxHeight(pRetVal: Integer); safecall;
    function Get_MinHeight: Integer; safecall;
    procedure Set_MinHeight(pRetVal: Integer); safecall;
    function Get_Maximizable: WordBool; safecall;
    procedure Set_Maximizable(pRetVal: WordBool); safecall;
    function Get_Minimizable: WordBool; safecall;
    procedure Set_Minimizable(pRetVal: WordBool); safecall;
    function Get_SynchronousDestroy: WordBool; safecall;
    procedure Set_SynchronousDestroy(pRetVal: WordBool); safecall;
    property type_: WideString read Get_type_ write Set_type_;
    property Title: WideString read Get_Title write Set_Title;
    property AllowTabClose: WordBool read Get_AllowTabClose write Set_AllowTabClose;
    property ChannelSupport: WordBool read Get_ChannelSupport write Set_ChannelSupport;
    property Channel: WideString read Get_Channel write Set_Channel;
    property ShowTaskbarIcon: WordBool read Get_ShowTaskbarIcon write Set_ShowTaskbarIcon;
    property IsSticky: WordBool read Get_IsSticky write Set_IsSticky;
    property AllowUnstick: WordBool read Get_AllowUnstick write Set_AllowUnstick;
    property FrameColor: WideString read Get_FrameColor write Set_FrameColor;
    property Icon: WideString read Get_Icon write Set_Icon;
    property StandardButtons: WideString read Get_StandardButtons write Set_StandardButtons;
    property MaxWidth: Integer read Get_MaxWidth write Set_MaxWidth;
    property MinWidth: Integer read Get_MinWidth write Set_MinWidth;
    property MaxHeight: Integer read Get_MaxHeight write Set_MaxHeight;
    property MinHeight: Integer read Get_MinHeight write Set_MinHeight;
    property Maximizable: WordBool read Get_Maximizable write Set_Maximizable;
    property Minimizable: WordBool read Get_Minimizable write Set_Minimizable;
    property SynchronousDestroy: WordBool read Get_SynchronousDestroy write Set_SynchronousDestroy;
  end;

// *********************************************************************//
// DispIntf:  IGlueWindowSettingsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DA16AD71-DF87-4243-B85B-47CE09F6ED8F}
// *********************************************************************//
  IGlueWindowSettingsDisp = dispinterface
    ['{DA16AD71-DF87-4243-B85B-47CE09F6ED8F}']
    property type_: WideString dispid 1610743808;
    property Title: WideString dispid 1610743810;
    property AllowTabClose: WordBool dispid 1610743812;
    property ChannelSupport: WordBool dispid 1610743814;
    property Channel: WideString dispid 1610743816;
    property ShowTaskbarIcon: WordBool dispid 1610743818;
    property IsSticky: WordBool dispid 1610743820;
    property AllowUnstick: WordBool dispid 1610743822;
    property FrameColor: WideString dispid 1610743824;
    property Icon: WideString dispid 1610743826;
    property StandardButtons: WideString dispid 1610743828;
    property MaxWidth: Integer dispid 1610743830;
    property MinWidth: Integer dispid 1610743832;
    property MaxHeight: Integer dispid 1610743834;
    property MinHeight: Integer dispid 1610743836;
    property Maximizable: WordBool dispid 1610743838;
    property Minimizable: WordBool dispid 1610743840;
    property SynchronousDestroy: WordBool dispid 1610743842;
  end;

// *********************************************************************//
// DispIntf:  IGlueServerMethod
// Flags:     (4096) Dispatchable
// GUID:      {E2331307-B552-4C57-B2E1-62E6DCA380DC}
// *********************************************************************//
  IGlueServerMethod = dispinterface
    ['{E2331307-B552-4C57-B2E1-62E6DCA380DC}']
    property Definition: {??VBGlueMethod}OleVariant readonly dispid 1610743808;
    procedure Register; dispid 1610743809;
    procedure Unregister; dispid 1610743810;
  end;

// *********************************************************************//
// DispIntf:  IGlueMethodInvocator
// Flags:     (4096) Dispatchable
// GUID:      {DA0A6BAF-6967-4F6B-91C9-21743B5D23A1}
// *********************************************************************//
  IGlueMethodInvocator = dispinterface
    ['{DA0A6BAF-6967-4F6B-91C9-21743B5D23A1}']
    procedure InvokeAsync(const method: WideString; const targetRegex: WideString; 
                          args: OleVariant; all: WordBool; const correlationId: WideString; 
                          timeoutMsecs: Integer); dispid 1610743808;
    function InvokeSync(const method: WideString; const targetRegex: WideString; args: OleVariant; 
                        all: WordBool; timeoutMsecs: Integer): OleVariant; dispid 1610743809;
  end;

// *********************************************************************//
// DispIntf:  IGlueStreamConsumer
// Flags:     (4096) Dispatchable
// GUID:      {2F7F15D5-7206-4C87-A390-ED0B42C2CA36}
// *********************************************************************//
  IGlueStreamConsumer = dispinterface
    ['{2F7F15D5-7206-4C87-A390-ED0B42C2CA36}']
    procedure Subscribe(const stream: WideString; const targetRegex: WideString; args: OleVariant; 
                        all: WordBool; const correlationId: WideString; timeoutMsecs: Integer); dispid 1610743808;
  end;

// *********************************************************************//
// DispIntf:  IGlueStreamConsumerEvents
// Flags:     (4096) Dispatchable
// GUID:      {45E44742-45E8-4C58-BB18-8663D4C20D11}
// *********************************************************************//
  IGlueStreamConsumerEvents = dispinterface
    ['{45E44742-45E8-4C58-BB18-8663D4C20D11}']
    procedure HandleSubscriptionActivated(const GlueStreamSubscription: IGlueStreamSubscription; 
                                          const correlationId: WideString); dispid 1610743808;
    procedure HandleStreamData(const stream: IGlueMethodInfo; const data: IGlueData); dispid 1610743809;
    procedure HandleStreamStatus(const stream: IGlueMethodInfo; state: GlueStreamState; 
                                 const Message: WideString; dateTime: Double); dispid 1610743810;
    procedure HandleStreamClosed(const stream: IGlueMethodInfo); dispid 1610743811;
  end;

// *********************************************************************//
// DispIntf:  IGlueMethodInfo
// Flags:     (4096) Dispatchable
// GUID:      {455FA15C-AE59-403F-A80E-5216EB975FB7}
// *********************************************************************//
  IGlueMethodInfo = dispinterface
    ['{455FA15C-AE59-403F-A80E-5216EB975FB7}']
    property method: {??VBGlueMethod}OleVariant readonly dispid 1610743808;
    property correlationId: WideString readonly dispid 1610743809;
  end;

// *********************************************************************//
// DispIntf:  IGlueData
// Flags:     (4096) Dispatchable
// GUID:      {8056A674-5A37-430D-847D-C99F38721C10}
// *********************************************************************//
  IGlueData = dispinterface
    ['{8056A674-5A37-430D-847D-C99F38721C10}']
    function GetReflectData(const fieldPath: WideString): OleVariant; dispid 1610743808;
  end;

// *********************************************************************//
// DispIntf:  IGlueMethodInvocatorEvents
// Flags:     (4096) Dispatchable
// GUID:      {AA4DF44F-E91A-4C9E-8288-02D93C5B1E4C}
// *********************************************************************//
  IGlueMethodInvocatorEvents = dispinterface
    ['{AA4DF44F-E91A-4C9E-8288-02D93C5B1E4C}']
    procedure HandleInvocationResult(const invocationResult: IGlueInvocationResult); dispid 1610743808;
  end;

// *********************************************************************//
// DispIntf:  IGlueInvocationResult
// Flags:     (4096) Dispatchable
// GUID:      {B73B2552-BF00-4AD9-927B-77F0DC9FBC4E}
// *********************************************************************//
  IGlueInvocationResult = dispinterface
    ['{B73B2552-BF00-4AD9-927B-77F0DC9FBC4E}']
    property correlationId: WideString readonly dispid 1610743808;
    property Results: {??PSafeArray}OleVariant readonly dispid 1610743809;
  end;

// *********************************************************************//
// DispIntf:  IGlueServerMethodEvents
// Flags:     (4096) Dispatchable
// GUID:      {9E690080-E140-4A99-B962-F9132AD9E4D8}
// *********************************************************************//
  IGlueServerMethodEvents = dispinterface
    ['{9E690080-E140-4A99-B962-F9132AD9E4D8}']
    procedure HandleInvocationRequest(const GlueInvocationRequest: IGlueInvocationRequest); dispid 1610743808;
  end;

// *********************************************************************//
// DispIntf:  IGlueServerStream
// Flags:     (4096) Dispatchable
// GUID:      {E3330E58-F99B-452C-BE10-1A916FACA5B4}
// *********************************************************************//
  IGlueServerStream = dispinterface
    ['{E3330E58-F99B-452C-BE10-1A916FACA5B4}']
    procedure Push(data: {??PSafeArray}OleVariant; const branch: WideString); dispid 1610743808;
    procedure CloseBranch(const branch: WideString); dispid 1610743809;
    procedure CloseStream; dispid 1610743810;
    function GetBranchKeys: {??PSafeArray}OleVariant; dispid 1610743811;
    function GetBranch(const branchKey: WideString): IGlueStreamBranch; dispid 1610743812;
    property Definition: {??VBGlueMethod}OleVariant readonly dispid 1610743813;
    procedure Register; dispid 1610743814;
    procedure Unregister; dispid 1610743815;
    procedure PushVariantData(data: OleVariant; const branch: WideString); dispid 1610743816;
  end;

// *********************************************************************//
// DispIntf:  IVBGlueStreamSubscriber
// Flags:     (4096) Dispatchable
// GUID:      {632317F3-E6C2-4FB9-AB8F-067DF1F113CA}
// *********************************************************************//
  IVBGlueStreamSubscriber = dispinterface
    ['{632317F3-E6C2-4FB9-AB8F-067DF1F113CA}']
    function GetStream: {??VBGlueMethod}OleVariant; dispid 1610743808;
    function GetSubscriberInstance: {??VBGlueInstance}OleVariant; dispid 1610743809;
    procedure Push(data: OleVariant); dispid 1610743810;
    procedure Close(data: OleVariant); dispid 1610743811;
  end;

// *********************************************************************//
// Interface: IGlueSubscriptionHandler
// Flags:     (256) OleAutomation
// GUID:      {DAA04777-BD8E-4180-9021-48A0807A2E1D}
// *********************************************************************//
  IGlueSubscriptionHandler = interface(IUnknown)
    ['{DAA04777-BD8E-4180-9021-48A0807A2E1D}']
    function HandleSubscriptionRequest(stream: GlueMethod; Caller: GlueInstance; 
                                       requestValues: PSafeArray; 
                                       const callback: IGlueServerSubscriptionCallback): HResult; stdcall;
    function HandleSubscriber(subscriberInstance: GlueInstance; 
                              const glueStreamSubscriber: IGlueStreamSubscriber; 
                              requestValues: PSafeArray): HResult; stdcall;
    function HandleSubscriberLost(streamSubscriber: GlueInstance; 
                                  const glueStreamSubscriber: IGlueStreamSubscriber): HResult; stdcall;
  end;

// *********************************************************************//
// DispIntf:  IGlueInvocationRequest
// Flags:     (4096) Dispatchable
// GUID:      {9811A276-E7E7-4C86-92F1-C4677288723B}
// *********************************************************************//
  IGlueInvocationRequest = dispinterface
    ['{9811A276-E7E7-4C86-92F1-C4677288723B}']
    property method: {??VBGlueMethod}OleVariant readonly dispid 1610743808;
    property Caller: {??VBGlueInstance}OleVariant readonly dispid 1610743809;
    function GetReflectData(const fieldPath: WideString): OleVariant; dispid 1610743810;
    procedure SendResult(result: OleVariant); dispid 1610743811;
    procedure SendFailure(const Message: WideString; additionalData: OleVariant); dispid 1610743812;
  end;

// *********************************************************************//
// DispIntf:  IGlueSubscriptionRequest
// Flags:     (4096) Dispatchable
// GUID:      {D6E08259-D2B4-453D-B050-E9DD9F6308C8}
// *********************************************************************//
  IGlueSubscriptionRequest = dispinterface
    ['{D6E08259-D2B4-453D-B050-E9DD9F6308C8}']
    property stream: {??VBGlueMethod}OleVariant readonly dispid 1610743808;
    property Requester: {??VBGlueInstance}OleVariant readonly dispid 1610743809;
    function GetReflectData(const fieldPath: WideString): OleVariant; dispid 1610743810;
    function Accept(const branch: WideString; result: OleVariant): IGlueStreamBranch; dispid 1610743811;
    procedure Reject(result: OleVariant); dispid 1610743812;
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
    procedure SetTitle(const Title: WideString); safecall;
    function GetChannelSupport: WordBool; safecall;
    procedure SetChannelSupport(showLink: WordBool); safecall;
    procedure Activate; safecall;
    procedure Unregister; safecall;
    function GetChannelContext: IGlueContext; safecall;
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
    procedure SetTitle(const Title: WideString); dispid 1610743812;
    function GetChannelSupport: WordBool; dispid 1610743813;
    procedure SetChannelSupport(showLink: WordBool); dispid 1610743814;
    procedure Activate; dispid 1610743815;
    procedure Unregister; dispid 1610743816;
    function GetChannelContext: IGlueContext; dispid 1610743817;
  end;

// *********************************************************************//
// Interface: IAppFactoryRegistry
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1810DB3-167B-4FBD-8852-0481B0BBFDC4}
// *********************************************************************//
  IAppFactoryRegistry = interface(IDispatch)
    ['{B1810DB3-167B-4FBD-8852-0481B0BBFDC4}']
    procedure RegisterAppFactory(appDefinition: GlueAppDefinition; const factory: IAppFactory); safecall;
    procedure RegisterAppInstance(const appDefName: WideString; const GlueWindow: IGlueWindow; 
                                  const glueApp: IGlueApp); safecall;
    procedure RegisterMainInstance(const main: IGlueApp); safecall;
    function GetMainRestoreState: GlueValue; safecall;
  end;

// *********************************************************************//
// DispIntf:  IAppFactoryRegistryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B1810DB3-167B-4FBD-8852-0481B0BBFDC4}
// *********************************************************************//
  IAppFactoryRegistryDisp = dispinterface
    ['{B1810DB3-167B-4FBD-8852-0481B0BBFDC4}']
    procedure RegisterAppFactory(appDefinition: {??GlueAppDefinition}OleVariant; 
                                 const factory: IAppFactory); dispid 1610743808;
    procedure RegisterAppInstance(const appDefName: WideString; const GlueWindow: IGlueWindow; 
                                  const glueApp: IGlueApp); dispid 1610743809;
    procedure RegisterMainInstance(const main: IGlueApp); dispid 1610743810;
    function GetMainRestoreState: {??GlueValue}OleVariant; dispid 1610743811;
  end;

// *********************************************************************//
// Interface: IGlueServerSubscriptionCallback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1CE0C9B4-C1D2-4F0D-A5A5-57EA027424BE}
// *********************************************************************//
  IGlueServerSubscriptionCallback = interface(IDispatch)
    ['{1CE0C9B4-C1D2-4F0D-A5A5-57EA027424BE}']
    function Accept(const branch: WideString; result: GlueResult): IGlueStreamBranch; safecall;
    procedure Reject(result: GlueResult); safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueServerSubscriptionCallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1CE0C9B4-C1D2-4F0D-A5A5-57EA027424BE}
// *********************************************************************//
  IGlueServerSubscriptionCallbackDisp = dispinterface
    ['{1CE0C9B4-C1D2-4F0D-A5A5-57EA027424BE}']
    function Accept(const branch: WideString; result: {??GlueResult}OleVariant): IGlueStreamBranch; dispid 1610743808;
    procedure Reject(result: {??GlueResult}OleVariant); dispid 1610743809;
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
    procedure Push(data: {??PSafeArray}OleVariant; const branch: WideString); dispid 1610743808;
    procedure CloseBranch(const branch: WideString); dispid 1610743809;
    procedure CloseStream; dispid 1610743810;
    function GetBranchKeys: {??PSafeArray}OleVariant; dispid 1610743811;
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
    procedure Push(data: {??PSafeArray}OleVariant); dispid 1610743809;
    procedure Close; dispid 1610743810;
    function GetStream: IGlueStream; dispid 1610743811;
    function GetSubscribers: {??PSafeArray}OleVariant; dispid 1610743812;
  end;

// *********************************************************************//
// Interface: IGlueStreamHandler
// Flags:     (256) OleAutomation
// GUID:      {A384126A-06D1-41CE-942C-4376D4574F4B}
// *********************************************************************//
  IGlueStreamHandler = interface(IUnknown)
    ['{A384126A-06D1-41CE-942C-4376D4574F4B}']
    function SubscriptionActivated(const GlueStreamSubscription: IGlueStreamSubscription): HResult; stdcall;
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
    function GetSubscriberInstance: {??GlueInstance}OleVariant; dispid 1610743808;
    procedure Push(data: {??PSafeArray}OleVariant); dispid 1610743809;
    procedure Close(data: {??PSafeArray}OleVariant); dispid 1610743810;
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
// DispIntf:  IGlueSubscriptionHandlerEvents
// Flags:     (4096) Dispatchable
// GUID:      {96E100B1-CCE8-463C-8965-2567B08ECF37}
// *********************************************************************//
  IGlueSubscriptionHandlerEvents = dispinterface
    ['{96E100B1-CCE8-463C-8965-2567B08ECF37}']
    procedure HandleSubscriptionRequest(const GlueSubscriptionRequest: IGlueSubscriptionRequest); dispid 1610743808;
    procedure HandleSubscriber(const glueStreamSubscriber: IVBGlueStreamSubscriber; 
                               const requestValues: IGlueData); dispid 1610743809;
    procedure HandleSubscriberLost(const glueStreamSubscriber: IVBGlueStreamSubscriber); dispid 1610743810;
  end;

// *********************************************************************//
// Interface: IGlueRequestHandler
// Flags:     (256) OleAutomation
// GUID:      {81671796-A690-476B-85EA-94326B7CA2B5}
// *********************************************************************//
  IGlueRequestHandler = interface(IUnknown)
    ['{81671796-A690-476B-85EA-94326B7CA2B5}']
    function HandleInvocationRequest(method: GlueMethod; Caller: GlueInstance; 
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
    procedure SendResult(result: GlueResult); safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueServerMethodResultCallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2497D4E6-C398-4DBB-904D-83B55F701E46}
// *********************************************************************//
  IGlueServerMethodResultCallbackDisp = dispinterface
    ['{2497D4E6-C398-4DBB-904D-83B55F701E46}']
    procedure SendResult(result: {??GlueResult}OleVariant); dispid 1610743808;
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
// DispIntf:  IGlueInvocationResultEvents
// Flags:     (4096) Dispatchable
// GUID:      {2A3E264F-C7A0-4F08-A1EF-4143D87C7087}
// *********************************************************************//
  IGlueInvocationResultEvents = dispinterface
    ['{2A3E264F-C7A0-4F08-A1EF-4143D87C7087}']
    procedure HandleResult(invocationResult: {??PSafeArray}OleVariant; 
                           const correlationId: WideString); dispid 1610743808;
  end;

// *********************************************************************//
// Interface: IGlueWindowEventHandler
// Flags:     (256) OleAutomation
// GUID:      {FBCB4411-153C-4AAC-8DC8-DB696C931FEB}
// *********************************************************************//
  IGlueWindowEventHandler = interface(IUnknown)
    ['{FBCB4411-153C-4AAC-8DC8-DB696C931FEB}']
    function HandleWindowReady(const GlueWindow: IGlueWindow): HResult; stdcall;
    function HandleChannelData(const GlueWindow: IGlueWindow; 
                               const channelUpdate: IGlueContextUpdate): HResult; stdcall;
    function HandleChannelChanged(const GlueWindow: IGlueWindow; const Channel: IGlueContext; 
                                  prevChannel: GlueContext): HResult; stdcall;
    function HandleWindowDestroyed(const GlueWindow: IGlueWindow): HResult; stdcall;
    function HandleWindowEvent(const GlueWindow: IGlueWindow; eventType: GlueWindowEventType; 
                               eventData: GlueValue): HResult; stdcall;
  end;

// *********************************************************************//
// DispIntf:  IGlueWindowEvents
// Flags:     (4096) Dispatchable
// GUID:      {30B72DA7-93FD-4B9F-BDA2-6EEE1F41EE30}
// *********************************************************************//
  IGlueWindowEvents = dispinterface
    ['{30B72DA7-93FD-4B9F-BDA2-6EEE1F41EE30}']
    procedure HandleWindowReady(const GlueWindow: IGlueWindow); dispid 1610743808;
    procedure HandleChannelData(const GlueWindow: IGlueWindow; 
                                const channelUpdate: IGlueContextUpdate); dispid 1610743809;
    procedure HandleChannelChanged(const GlueWindow: IGlueWindow; const Channel: IGlueContext; 
                                   const prevChannelName: WideString); dispid 1610743810;
    procedure HandleWindowDestroyed(const GlueWindow: IGlueWindow); dispid 1610743811;
    procedure HandleWindowEvent(const GlueWindow: IGlueWindow; eventType: GlueWindowEventType; 
                                eventData: {??GlueValue}OleVariant); dispid 1610743812;
  end;

// *********************************************************************//
// Interface: IGlueValueReceiver
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F3494B7-89BF-4392-BFAB-14B72C7556FC}
// *********************************************************************//
  IGlueValueReceiver = interface(IDispatch)
    ['{1F3494B7-89BF-4392-BFAB-14B72C7556FC}']
    procedure SendGlueValue(GlueValue: GlueValue); safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlueValueReceiverDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F3494B7-89BF-4392-BFAB-14B72C7556FC}
// *********************************************************************//
  IGlueValueReceiverDisp = dispinterface
    ['{1F3494B7-89BF-4392-BFAB-14B72C7556FC}']
    procedure SendGlueValue(GlueValue: {??GlueValue}OleVariant); dispid 1610743808;
  end;

// *********************************************************************//
// Interface: IAppFactory
// Flags:     (256) OleAutomation
// GUID:      {505D3B9B-8ABD-4AC3-8EFE-66C64C372009}
// *********************************************************************//
  IAppFactory = interface(IUnknown)
    ['{505D3B9B-8ABD-4AC3-8EFE-66C64C372009}']
    function CreateApp(const appDefName: WideString; state: GlueValue; 
                       const announcer: IAppAnnouncer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IGlueApp
// Flags:     (256) OleAutomation
// GUID:      {1ADA0F8C-A888-45E7-B500-59AD176A690E}
// *********************************************************************//
  IGlueApp = interface(IUnknown)
    ['{1ADA0F8C-A888-45E7-B500-59AD176A690E}']
    function SaveState(const receiver: IGlueValueReceiver): HResult; stdcall;
    function Initialize(state: GlueValue; const GlueWindow: IGlueWindow): HResult; stdcall;
    function Shutdown: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IAppAnnouncer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {32EE037F-139B-4685-8BE1-AAC7A082507F}
// *********************************************************************//
  IAppAnnouncer = interface(IDispatch)
    ['{32EE037F-139B-4685-8BE1-AAC7A082507F}']
    function RegisterAppInstance(hwnd: Integer; const glueApp: IGlueApp): IGlueWindow; safecall;
    procedure AnnounceAppCreationFailure(const error: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IAppAnnouncerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {32EE037F-139B-4685-8BE1-AAC7A082507F}
// *********************************************************************//
  IAppAnnouncerDisp = dispinterface
    ['{32EE037F-139B-4685-8BE1-AAC7A082507F}']
    function RegisterAppInstance(hwnd: Integer; const glueApp: IGlueApp): IGlueWindow; dispid 1610743808;
    procedure AnnounceAppCreationFailure(const error: WideString); dispid 1610743809;
  end;

// *********************************************************************//
// The Class CoGlueNameValuePair provides a Create and CreateRemote method to          
// create instances of the default interface IGlueNameValuePair exposed by              
// the CoClass GlueNameValuePair. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueNameValuePair = class
    class function Create: IGlueNameValuePair;
    class function CreateRemote(const MachineName: string): IGlueNameValuePair;
  end;

// *********************************************************************//
// The Class CoGlueDynamicValueBase provides a Create and CreateRemote method to          
// create instances of the default interface IReflect exposed by              
// the CoClass GlueDynamicValueBase. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueDynamicValueBase = class
    class function Create: IReflect;
    class function CreateRemote(const MachineName: string): IReflect;
  end;

// *********************************************************************//
// The Class CoGlueDynamicValue provides a Create and CreateRemote method to          
// create instances of the default interface IGlueValueCollection exposed by              
// the CoClass GlueDynamicValue. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueDynamicValue = class
    class function Create: IGlueValueCollection;
    class function CreateRemote(const MachineName: string): IGlueValueCollection;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGlueDynamicValue
// Help String      : 
// Default Interface: IGlueValueCollection
// Def. Intf. DISP? : Yes
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGlueDynamicValueProperties= class;
{$ENDIF}
  TGlueDynamicValue = class(TOleServer)
  private
    FIntf:        IGlueValueCollection;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TGlueDynamicValueProperties;
    function      GetServerProperties: TGlueDynamicValueProperties;
{$ENDIF}
    function      GetDefaultInterface: IGlueValueCollection;
  protected
    procedure InitServerData; override;
    function Get__Default(key: OleVariant): OleVariant;
    function Get_Count: Integer;
    function Get_Names: {??PSafeArray}OleVariant;
    function Get_Values: {??PSafeArray}OleVariant;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IGlueValueCollection);
    procedure Disconnect; override;
    function GetEnumerator: IEnumVARIANT;
    function Contains(const Name: WideString): WordBool;
    property DefaultInterface: IGlueValueCollection read GetDefaultInterface;
    property _Default[key: OleVariant]: OleVariant read Get__Default; default;
    property Count: Integer read Get_Count;
    property Names: {??PSafeArray}OleVariant read Get_Names;
    property Values: {??PSafeArray}OleVariant read Get_Values;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGlueDynamicValueProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGlueDynamicValue
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGlueDynamicValueProperties = class(TPersistent)
  private
    FServer:    TGlueDynamicValue;
    function    GetDefaultInterface: IGlueValueCollection;
    constructor Create(AServer: TGlueDynamicValue);
  protected
    function Get__Default(key: OleVariant): OleVariant;
    function Get_Count: Integer;
    function Get_Names: {??PSafeArray}OleVariant;
    function Get_Values: {??PSafeArray}OleVariant;
  public
    property DefaultInterface: IGlueValueCollection read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoGlueWindowSettings provides a Create and CreateRemote method to          
// create instances of the default interface IGlueWindowSettings exposed by              
// the CoClass GlueWindowSettings. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueWindowSettings = class
    class function Create: IGlueWindowSettings;
    class function CreateRemote(const MachineName: string): IGlueWindowSettings;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGlueWindowSettings
// Help String      : 
// Default Interface: IGlueWindowSettings
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGlueWindowSettingsProperties= class;
{$ENDIF}
  TGlueWindowSettings = class(TOleServer)
  private
    FIntf:        IGlueWindowSettings;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TGlueWindowSettingsProperties;
    function      GetServerProperties: TGlueWindowSettingsProperties;
{$ENDIF}
    function      GetDefaultInterface: IGlueWindowSettings;
  protected
    procedure InitServerData; override;
    function Get_type_: WideString;
    procedure Set_type_(const pRetVal: WideString);
    function Get_Title: WideString;
    procedure Set_Title(const pRetVal: WideString);
    function Get_AllowTabClose: WordBool;
    procedure Set_AllowTabClose(pRetVal: WordBool);
    function Get_ChannelSupport: WordBool;
    procedure Set_ChannelSupport(pRetVal: WordBool);
    function Get_Channel: WideString;
    procedure Set_Channel(const pRetVal: WideString);
    function Get_ShowTaskbarIcon: WordBool;
    procedure Set_ShowTaskbarIcon(pRetVal: WordBool);
    function Get_IsSticky: WordBool;
    procedure Set_IsSticky(pRetVal: WordBool);
    function Get_AllowUnstick: WordBool;
    procedure Set_AllowUnstick(pRetVal: WordBool);
    function Get_FrameColor: WideString;
    procedure Set_FrameColor(const pRetVal: WideString);
    function Get_Icon: WideString;
    procedure Set_Icon(const pRetVal: WideString);
    function Get_StandardButtons: WideString;
    procedure Set_StandardButtons(const pRetVal: WideString);
    function Get_MaxWidth: Integer;
    procedure Set_MaxWidth(pRetVal: Integer);
    function Get_MinWidth: Integer;
    procedure Set_MinWidth(pRetVal: Integer);
    function Get_MaxHeight: Integer;
    procedure Set_MaxHeight(pRetVal: Integer);
    function Get_MinHeight: Integer;
    procedure Set_MinHeight(pRetVal: Integer);
    function Get_Maximizable: WordBool;
    procedure Set_Maximizable(pRetVal: WordBool);
    function Get_Minimizable: WordBool;
    procedure Set_Minimizable(pRetVal: WordBool);
    function Get_SynchronousDestroy: WordBool;
    procedure Set_SynchronousDestroy(pRetVal: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IGlueWindowSettings);
    procedure Disconnect; override;
    property DefaultInterface: IGlueWindowSettings read GetDefaultInterface;
    property type_: WideString read Get_type_ write Set_type_;
    property Title: WideString read Get_Title write Set_Title;
    property AllowTabClose: WordBool read Get_AllowTabClose write Set_AllowTabClose;
    property ChannelSupport: WordBool read Get_ChannelSupport write Set_ChannelSupport;
    property Channel: WideString read Get_Channel write Set_Channel;
    property ShowTaskbarIcon: WordBool read Get_ShowTaskbarIcon write Set_ShowTaskbarIcon;
    property IsSticky: WordBool read Get_IsSticky write Set_IsSticky;
    property AllowUnstick: WordBool read Get_AllowUnstick write Set_AllowUnstick;
    property FrameColor: WideString read Get_FrameColor write Set_FrameColor;
    property Icon: WideString read Get_Icon write Set_Icon;
    property StandardButtons: WideString read Get_StandardButtons write Set_StandardButtons;
    property MaxWidth: Integer read Get_MaxWidth write Set_MaxWidth;
    property MinWidth: Integer read Get_MinWidth write Set_MinWidth;
    property MaxHeight: Integer read Get_MaxHeight write Set_MaxHeight;
    property MinHeight: Integer read Get_MinHeight write Set_MinHeight;
    property Maximizable: WordBool read Get_Maximizable write Set_Maximizable;
    property Minimizable: WordBool read Get_Minimizable write Set_Minimizable;
    property SynchronousDestroy: WordBool read Get_SynchronousDestroy write Set_SynchronousDestroy;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGlueWindowSettingsProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGlueWindowSettings
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGlueWindowSettingsProperties = class(TPersistent)
  private
    FServer:    TGlueWindowSettings;
    function    GetDefaultInterface: IGlueWindowSettings;
    constructor Create(AServer: TGlueWindowSettings);
  protected
    function Get_type_: WideString;
    procedure Set_type_(const pRetVal: WideString);
    function Get_Title: WideString;
    procedure Set_Title(const pRetVal: WideString);
    function Get_AllowTabClose: WordBool;
    procedure Set_AllowTabClose(pRetVal: WordBool);
    function Get_ChannelSupport: WordBool;
    procedure Set_ChannelSupport(pRetVal: WordBool);
    function Get_Channel: WideString;
    procedure Set_Channel(const pRetVal: WideString);
    function Get_ShowTaskbarIcon: WordBool;
    procedure Set_ShowTaskbarIcon(pRetVal: WordBool);
    function Get_IsSticky: WordBool;
    procedure Set_IsSticky(pRetVal: WordBool);
    function Get_AllowUnstick: WordBool;
    procedure Set_AllowUnstick(pRetVal: WordBool);
    function Get_FrameColor: WideString;
    procedure Set_FrameColor(const pRetVal: WideString);
    function Get_Icon: WideString;
    procedure Set_Icon(const pRetVal: WideString);
    function Get_StandardButtons: WideString;
    procedure Set_StandardButtons(const pRetVal: WideString);
    function Get_MaxWidth: Integer;
    procedure Set_MaxWidth(pRetVal: Integer);
    function Get_MinWidth: Integer;
    procedure Set_MinWidth(pRetVal: Integer);
    function Get_MaxHeight: Integer;
    procedure Set_MaxHeight(pRetVal: Integer);
    function Get_MinHeight: Integer;
    procedure Set_MinHeight(pRetVal: Integer);
    function Get_Maximizable: WordBool;
    procedure Set_Maximizable(pRetVal: WordBool);
    function Get_Minimizable: WordBool;
    procedure Set_Minimizable(pRetVal: WordBool);
    function Get_SynchronousDestroy: WordBool;
    procedure Set_SynchronousDestroy(pRetVal: WordBool);
  public
    property DefaultInterface: IGlueWindowSettings read GetDefaultInterface;
  published
    property type_: WideString read Get_type_ write Set_type_;
    property Title: WideString read Get_Title write Set_Title;
    property AllowTabClose: WordBool read Get_AllowTabClose write Set_AllowTabClose;
    property ChannelSupport: WordBool read Get_ChannelSupport write Set_ChannelSupport;
    property Channel: WideString read Get_Channel write Set_Channel;
    property ShowTaskbarIcon: WordBool read Get_ShowTaskbarIcon write Set_ShowTaskbarIcon;
    property IsSticky: WordBool read Get_IsSticky write Set_IsSticky;
    property AllowUnstick: WordBool read Get_AllowUnstick write Set_AllowUnstick;
    property FrameColor: WideString read Get_FrameColor write Set_FrameColor;
    property Icon: WideString read Get_Icon write Set_Icon;
    property StandardButtons: WideString read Get_StandardButtons write Set_StandardButtons;
    property MaxWidth: Integer read Get_MaxWidth write Set_MaxWidth;
    property MinWidth: Integer read Get_MinWidth write Set_MinWidth;
    property MaxHeight: Integer read Get_MaxHeight write Set_MaxHeight;
    property MinHeight: Integer read Get_MinHeight write Set_MinHeight;
    property Maximizable: WordBool read Get_Maximizable write Set_Maximizable;
    property Minimizable: WordBool read Get_Minimizable write Set_Minimizable;
    property SynchronousDestroy: WordBool read Get_SynchronousDestroy write Set_SynchronousDestroy;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoGlueMethodInfo provides a Create and CreateRemote method to          
// create instances of the default interface IGlueMethodInfo exposed by              
// the CoClass GlueMethodInfo. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueMethodInfo = class
    class function Create: IGlueMethodInfo;
    class function CreateRemote(const MachineName: string): IGlueMethodInfo;
  end;

// *********************************************************************//
// The Class CoGlueData provides a Create and CreateRemote method to          
// create instances of the default interface IGlueData exposed by              
// the CoClass GlueData. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueData = class
    class function Create: IGlueData;
    class function CreateRemote(const MachineName: string): IGlueData;
  end;

// *********************************************************************//
// The Class CoGlueStreamConsumer provides a Create and CreateRemote method to          
// create instances of the default interface IGlueStreamConsumer exposed by              
// the CoClass GlueStreamConsumer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueStreamConsumer = class
    class function Create: IGlueStreamConsumer;
    class function CreateRemote(const MachineName: string): IGlueStreamConsumer;
  end;

// *********************************************************************//
// The Class CoVbGlueInvocationResult provides a Create and CreateRemote method to          
// create instances of the default interface IGlueInvocationResult exposed by              
// the CoClass VbGlueInvocationResult. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoVbGlueInvocationResult = class
    class function Create: IGlueInvocationResult;
    class function CreateRemote(const MachineName: string): IGlueInvocationResult;
  end;

// *********************************************************************//
// The Class CoGlueMethodInvocator provides a Create and CreateRemote method to          
// create instances of the default interface IGlueMethodInvocator exposed by              
// the CoClass GlueMethodInvocator. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueMethodInvocator = class
    class function Create: IGlueMethodInvocator;
    class function CreateRemote(const MachineName: string): IGlueMethodInvocator;
  end;

// *********************************************************************//
// The Class CoVBGlueStreamSubscriber provides a Create and CreateRemote method to          
// create instances of the default interface IVBGlueStreamSubscriber exposed by              
// the CoClass VBGlueStreamSubscriber. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoVBGlueStreamSubscriber = class
    class function Create: IVBGlueStreamSubscriber;
    class function CreateRemote(const MachineName: string): IVBGlueStreamSubscriber;
  end;

// *********************************************************************//
// The Class CoGlueInvocationRequest provides a Create and CreateRemote method to          
// create instances of the default interface IGlueInvocationRequest exposed by              
// the CoClass GlueInvocationRequest. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueInvocationRequest = class
    class function Create: IGlueInvocationRequest;
    class function CreateRemote(const MachineName: string): IGlueInvocationRequest;
  end;

// *********************************************************************//
// The Class CoGlueSubscriptionRequest provides a Create and CreateRemote method to          
// create instances of the default interface IGlueSubscriptionRequest exposed by              
// the CoClass GlueSubscriptionRequest. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueSubscriptionRequest = class
    class function Create: IGlueSubscriptionRequest;
    class function CreateRemote(const MachineName: string): IGlueSubscriptionRequest;
  end;

// *********************************************************************//
// The Class CoGlueServerStream provides a Create and CreateRemote method to          
// create instances of the default interface IGlueServerStream exposed by              
// the CoClass GlueServerStream. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueServerStream = class
    class function Create: IGlueServerStream;
    class function CreateRemote(const MachineName: string): IGlueServerStream;
  end;

// *********************************************************************//
// The Class CoGlueServerMethod provides a Create and CreateRemote method to          
// create instances of the default interface IGlueServerMethod exposed by              
// the CoClass GlueServerMethod. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueServerMethod = class
    class function Create: IGlueServerMethod;
    class function CreateRemote(const MachineName: string): IGlueServerMethod;
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

  TGlue42OnGlueVariantResponse = procedure(ASender: TObject; const correlationId: WideString; 
                                                             data: OleVariant) of object;
  TGlue42OnGlueVariantInvoke = procedure(ASender: TObject; const correlationId: WideString; 
                                                           data: OleVariant; 
                                                           const callbackId: WideString) of object;
  TGlue42OnGlueResponse = procedure(ASender: TObject; const correlationId: WideString; 
                                                      const jsonData: WideString) of object;
  TGlue42OnGlueInvoke = procedure(ASender: TObject; const correlationId: WideString; 
                                                    const jsonData: WideString; 
                                                    const callbackId: WideString) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGlue42
// Help String      : 
// Default Interface: IGlue42
// Def. Intf. DISP? : No
// Event   Interface: IGlueEventSink
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGlue42Properties= class;
{$ENDIF}
  TGlue42 = class(TOleServer)
  private
    FOnGlueVariantResponse: TGlue42OnGlueVariantResponse;
    FOnGlueVariantInvoke: TGlue42OnGlueVariantInvoke;
    FOnGlueResponse: TGlue42OnGlueResponse;
    FOnGlueInvoke: TGlue42OnGlueInvoke;
    FIntf:        IGlue42;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TGlue42Properties;
    function      GetServerProperties: TGlue42Properties;
{$ENDIF}
    function      GetDefaultInterface: IGlue42;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_AppFactoryRegistry: IAppFactoryRegistry;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IGlue42);
    procedure Disconnect; override;
    procedure OverrideConfiguration(configuration: GlueConfiguration);
    procedure Start(Instance: GlueInstance);
    function TranslateVbObject(data: OleVariant): OleVariant;
    procedure SetLogConfigurationPath(const logConfigPath: WideString);
    procedure StartWithAppName(const ApplicationName: WideString);
    procedure Stop;
    function RegisterGlueWindow(hwnd: Integer; const windowEventHandler: IGlueWindowEventHandler): IGlueWindow;
    function RegisterStartupGlueWindow(hwnd: Integer; 
                                       const windowEventHandler: IGlueWindowEventHandler): IGlueWindow;
    function CreateDefaultVBGlueWindowSettings: IGlueWindowSettings;
    function GetStartupWindowSettings: IGlueWindowSettings;
    function RegisterGlueWindowWithSettings(hwnd: Integer; const settings: IGlueWindowSettings; 
                                            const windowEventHandler: IGlueWindowEventHandler): IGlueWindow;
    function RegisterStartupGlueWindowWithSettings(hwnd: Integer; 
                                                   const settings: IGlueWindowSettings; 
                                                   const windowEventHandler: IGlueWindowEventHandler): IGlueWindow;
    function GetInstance: GlueInstance;
    function CreateGlueValues: OleVariant;
    function CreateGlueData(data: OleVariant): IGlueData;
    function GetKnownContexts: PSafeArray;
    procedure SubscribeGlueContext(const contextName: WideString; const handler: IGlueContextHandler);
    function GetGlueContext(const contextName: WideString): IGlueContext;
    function GetAllInstances: PSafeArray;
    function GetAllMethods: PSafeArray;
    function GetMethodsForInstance(Instance: GlueInstance; identity: GlueInstanceIdentity): PSafeArray;
    procedure Subscribe(const handler: IGlueEvents);
    procedure Unsubscribe(const handler: IGlueEvents);
    function BuildGlueContextValues(const contextBuilderCallback: IGlueContextBuilderCallback): PSafeArray;
    function RegisterMethod(const methodName: WideString; 
                            const requestHandler: IGlueRequestHandler; const Input: WideString; 
                            const Output: WideString; ObjectTypes: PSafeArray): GlueMethod;
    function CreateServerMethod(const methodName: WideString; const Input: WideString; 
                                const Output: WideString; const objectTypesCSV: WideString): IGlueServerMethod;
    function CreateServerStream(const streamName: WideString; const Input: WideString; 
                                const Output: WideString; const objectTypesCSV: WideString): IGlueServerStream;
    function CreateMethodInvocator: IGlueMethodInvocator;
    function CreateStreamConsumer: IGlueStreamConsumer;
    function RegisterStream(const streamName: WideString; 
                            const subscriptionHandler: IGlueSubscriptionHandler; 
                            const Input: WideString; const Output: WideString; 
                            ObjectTypes: PSafeArray; out stream: IGlueStream): GlueMethod;
    procedure UnregisterMethod(method: GlueMethod);
    procedure BuildAndInvoke(const method: WideString; 
                             const builderCallback: IGlueContextBuilderCallback; 
                             targets: PSafeArray; all: WordBool; identity: GlueInstanceIdentity; 
                             const resultHandler: IGlueInvocationResultHandler; 
                             invocationTimeoutMsecs: Int64; const correlationId: WideString);
    procedure InvokeMethods(const method: WideString; invocationArgs: PSafeArray; 
                            targets: PSafeArray; all: WordBool; identity: GlueInstanceIdentity; 
                            const resultHandler: IGlueInvocationResultHandler; 
                            invocationTimeoutMsecs: Int64; const correlationId: WideString);
    procedure InvokeMethod(method: GlueMethod; invocationArgs: PSafeArray; 
                           const resultHandler: IGlueInvocationResultHandler; 
                           invocationTimeoutMsecs: Int64; const correlationId: WideString);
    procedure SubscribeStreams(const streamName: WideString; subscriptionRequestArgs: PSafeArray; 
                               targets: PSafeArray; all: WordBool; identity: GlueInstanceIdentity; 
                               const streamHandler: IGlueStreamHandler; 
                               invocationTimeoutMsecs: Int64);
    procedure SubscribeStreamsFilterTargets(const streamName: WideString; 
                                            subscriptionRequestArgs: PSafeArray; 
                                            const targetRegex: WideString; all: WordBool; 
                                            const streamHandler: IGlueStreamHandler; 
                                            invocationTimeoutMsecs: Int64);
    procedure SubscribeStream(stream: GlueMethod; subscriptionRequestArgs: PSafeArray; 
                              const streamHandler: IGlueStreamHandler; 
                              subscriptionTimeoutMsecs: Int64);
    function InvokeSync(const methodName: WideString; const argsAsJson: WideString; 
                        const resultFieldPath: WideString; const targetRegex: WideString): WideString;
    procedure InvokeAsync(const correlationId: WideString; const methodName: WideString; 
                          const argsAsJson: WideString; const resultFieldPath: WideString; 
                          const targetRegex: WideString);
    procedure SubscribeStreamInSink(const correlationId: WideString; const streamName: WideString; 
                                    const argsAsJson: WideString; 
                                    const resultFieldPath: WideString; 
                                    const targetRegex: WideString; 
                                    const filterFieldPath: WideString; 
                                    const filterDataRegex: WideString);
    procedure RegisterMethodInSink(const correlationId: WideString; const methodName: WideString; 
                                   const inputSignature: WideString; 
                                   const outputSignature: WideString; ObjectTypes: PSafeArray; 
                                   const invocationFieldPath: WideString; 
                                   const targetRegex: WideString; 
                                   const filterFieldPath: WideString; 
                                   const filterDataRegex: WideString);
    procedure RegisterVariantMethodInSink(const correlationId: WideString; 
                                          const methodName: WideString; 
                                          const inputSignature: WideString; 
                                          const outputSignature: WideString; 
                                          ObjectTypes: PSafeArray; 
                                          const invocationFieldPath: WideString; 
                                          const targetRegex: WideString; 
                                          const filterFieldPath: WideString; 
                                          const filterDataRegex: WideString);
    procedure RegisterVoidMethodInSink(const correlationId: WideString; 
                                       const methodName: WideString; 
                                       const inputSignature: WideString; ObjectTypes: PSafeArray; 
                                       const invocationFieldPath: WideString; 
                                       const targetRegex: WideString; 
                                       const filterFieldPath: WideString; 
                                       const filterDataRegex: WideString);
    procedure RegisterSingleBranchStream(const correlationId: WideString; 
                                         const streamName: WideString; 
                                         const requestSignature: WideString; 
                                         const streamSignature: WideString);
    procedure AddCorrelationInterest(const correlationId: WideString; const interestId: WideString; 
                                     const fieldPath: WideString; 
                                     const filterFieldPath: WideString; 
                                     const filterDataRegex: WideString);
    procedure RegisterStreamInSink(const correlationId: WideString; const streamName: WideString; 
                                   const requestSignature: WideString; 
                                   const streamSignature: WideString; 
                                   const requestFieldPath: WideString; 
                                   const targetRegex: WideString; 
                                   const filterFieldPath: WideString; 
                                   const filterDataRegex: WideString);
    procedure YieldCallbackData(const correlationId: WideString; const callbackId: WideString; 
                                const callbackData: WideString);
    procedure YieldCallbackVariantData(const correlationId: WideString; 
                                       const callbackId: WideString; callbackData: OleVariant);
    procedure RegisterGlueWindowInSink(const correlationId: WideString; const hwnd: WideString);
    function JsonToVariant(const json: WideString): PSafeArray;
    procedure CloseResource(const correlationId: WideString);
    function GetMethodNamesForTarget(const targetRegex: WideString): PSafeArray;
    function GetTargets: PSafeArray;
    function GetChannels: PSafeArray;
    procedure InvokeAsyncVariantData(const correlationId: WideString; const methodName: WideString; 
                                     args: OleVariant; const resultFieldPath: WideString; 
                                     const targetRegex: WideString);
    procedure SubscribeChannel(const correlationId: WideString; const Channel: WideString; 
                               const resultFieldPath: WideString);
    procedure SetChannelData(const Channel: WideString; const fieldPath: WideString; 
                             const data: WideString);
    procedure G4O_XL_OpenSheet(const correlationId: WideString; const sheetName: WideString; 
                               columnNames: PSafeArray; columnValidationTypes: PSafeArray; 
                               data: OleVariant);
    procedure Log(level: Byte; const Message: WideString);
    function GetState: GlueState;
    function IsLaunchedByGD: WordBool;
    function GetStartingContext: GlueValue;
    property DefaultInterface: IGlue42 read GetDefaultInterface;
    property AppFactoryRegistry: IAppFactoryRegistry read Get_AppFactoryRegistry;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGlue42Properties read GetServerProperties;
{$ENDIF}
    property OnGlueVariantResponse: TGlue42OnGlueVariantResponse read FOnGlueVariantResponse write FOnGlueVariantResponse;
    property OnGlueVariantInvoke: TGlue42OnGlueVariantInvoke read FOnGlueVariantInvoke write FOnGlueVariantInvoke;
    property OnGlueResponse: TGlue42OnGlueResponse read FOnGlueResponse write FOnGlueResponse;
    property OnGlueInvoke: TGlue42OnGlueInvoke read FOnGlueInvoke write FOnGlueInvoke;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGlue42
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGlue42Properties = class(TPersistent)
  private
    FServer:    TGlue42;
    function    GetDefaultInterface: IGlue42;
    constructor Create(AServer: TGlue42);
  protected
    function Get_AppFactoryRegistry: IAppFactoryRegistry;
  public
    property DefaultInterface: IGlue42 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoGlueStreamSubscription provides a Create and CreateRemote method to          
// create instances of the default interface IGlueStreamSubscription exposed by              
// the CoClass GlueStreamSubscription. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueStreamSubscription = class
    class function Create: IGlueStreamSubscription;
    class function CreateRemote(const MachineName: string): IGlueStreamSubscription;
  end;

// *********************************************************************//
// The Class CoGlueWindow provides a Create and CreateRemote method to          
// create instances of the default interface IGlueWindow exposed by              
// the CoClass GlueWindow. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueWindow = class
    class function Create: IGlueWindow;
    class function CreateRemote(const MachineName: string): IGlueWindow;
  end;

// *********************************************************************//
// The Class CoGlueContextImage provides a Create and CreateRemote method to          
// create instances of the default interface IGlueContextUpdate exposed by              
// the CoClass GlueContextImage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueContextImage = class
    class function Create: IGlueContextUpdate;
    class function CreateRemote(const MachineName: string): IGlueContextUpdate;
  end;

// *********************************************************************//
// The Class CoGlueContextUpdate provides a Create and CreateRemote method to          
// create instances of the default interface IGlueContextUpdate exposed by              
// the CoClass GlueContextUpdate. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueContextUpdate = class
    class function Create: IGlueContextUpdate;
    class function CreateRemote(const MachineName: string): IGlueContextUpdate;
  end;

// *********************************************************************//
// The Class CoGlueContextManager provides a Create and CreateRemote method to          
// create instances of the default interface IGlueContext exposed by              
// the CoClass GlueContextManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueContextManager = class
    class function Create: IGlueContext;
    class function CreateRemote(const MachineName: string): IGlueContext;
  end;

// *********************************************************************//
// The Class CoGlueException provides a Create and CreateRemote method to          
// create instances of the default interface _GlueException exposed by              
// the CoClass GlueException. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlueException = class
    class function Create: _GlueException;
    class function CreateRemote(const MachineName: string): _GlueException;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGlueException
// Help String      : This object holds GlueAgm exceptions
// Default Interface: _GlueException
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGlueExceptionProperties= class;
{$ENDIF}
  TGlueException = class(TOleServer)
  private
    FIntf:        _GlueException;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TGlueExceptionProperties;
    function      GetServerProperties: TGlueExceptionProperties;
{$ENDIF}
    function      GetDefaultInterface: _GlueException;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _GlueException);
    procedure Disconnect; override;
    property DefaultInterface: _GlueException read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGlueExceptionProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGlueException
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGlueExceptionProperties = class(TPersistent)
  private
    FServer:    TGlueException;
    function    GetDefaultInterface: _GlueException;
    constructor Create(AServer: TGlueException);
  protected
  public
    property DefaultInterface: _GlueException read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoGlueNameValuePair.Create: IGlueNameValuePair;
begin
  Result := CreateComObject(CLASS_GlueNameValuePair) as IGlueNameValuePair;
end;

class function CoGlueNameValuePair.CreateRemote(const MachineName: string): IGlueNameValuePair;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueNameValuePair) as IGlueNameValuePair;
end;

class function CoGlueDynamicValueBase.Create: IReflect;
begin
  Result := CreateComObject(CLASS_GlueDynamicValueBase) as IReflect;
end;

class function CoGlueDynamicValueBase.CreateRemote(const MachineName: string): IReflect;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueDynamicValueBase) as IReflect;
end;

class function CoGlueDynamicValue.Create: IGlueValueCollection;
begin
  Result := CreateComObject(CLASS_GlueDynamicValue) as IGlueValueCollection;
end;

class function CoGlueDynamicValue.CreateRemote(const MachineName: string): IGlueValueCollection;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueDynamicValue) as IGlueValueCollection;
end;

procedure TGlueDynamicValue.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{496249AA-598F-4E57-9DD4-80C7FA55CEF3}';
    IntfIID:   '{57F378B0-6D2A-4710-8696-DB021283A2BF}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGlueDynamicValue.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IGlueValueCollection;
  end;
end;

procedure TGlueDynamicValue.ConnectTo(svrIntf: IGlueValueCollection);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGlueDynamicValue.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGlueDynamicValue.GetDefaultInterface: IGlueValueCollection;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TGlueDynamicValue.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGlueDynamicValueProperties.Create(Self);
{$ENDIF}
end;

destructor TGlueDynamicValue.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGlueDynamicValue.GetServerProperties: TGlueDynamicValueProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TGlueDynamicValue.Get__Default(key: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant._Default;
end;

function TGlueDynamicValue.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TGlueDynamicValue.Get_Names: {??PSafeArray}OleVariant;
begin
    Result := DefaultInterface.Names;
end;

function TGlueDynamicValue.Get_Values: {??PSafeArray}OleVariant;
begin
    Result := DefaultInterface.Values;
end;

function TGlueDynamicValue.GetEnumerator: IEnumVARIANT;
begin
  Result := DefaultInterface.GetEnumerator;
end;

function TGlueDynamicValue.Contains(const Name: WideString): WordBool;
begin
  Result := DefaultInterface.Contains(Name);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGlueDynamicValueProperties.Create(AServer: TGlueDynamicValue);
begin
  inherited Create;
  FServer := AServer;
end;

function TGlueDynamicValueProperties.GetDefaultInterface: IGlueValueCollection;
begin
  Result := FServer.DefaultInterface;
end;

function TGlueDynamicValueProperties.Get__Default(key: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant._Default;
end;

function TGlueDynamicValueProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TGlueDynamicValueProperties.Get_Names: {??PSafeArray}OleVariant;
begin
    Result := DefaultInterface.Names;
end;

function TGlueDynamicValueProperties.Get_Values: {??PSafeArray}OleVariant;
begin
    Result := DefaultInterface.Values;
end;

{$ENDIF}

class function CoGlueWindowSettings.Create: IGlueWindowSettings;
begin
  Result := CreateComObject(CLASS_GlueWindowSettings) as IGlueWindowSettings;
end;

class function CoGlueWindowSettings.CreateRemote(const MachineName: string): IGlueWindowSettings;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueWindowSettings) as IGlueWindowSettings;
end;

procedure TGlueWindowSettings.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F7A641B7-1407-4B3D-A9EB-D3C47BB579B6}';
    IntfIID:   '{DA16AD71-DF87-4243-B85B-47CE09F6ED8F}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGlueWindowSettings.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IGlueWindowSettings;
  end;
end;

procedure TGlueWindowSettings.ConnectTo(svrIntf: IGlueWindowSettings);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGlueWindowSettings.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGlueWindowSettings.GetDefaultInterface: IGlueWindowSettings;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TGlueWindowSettings.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGlueWindowSettingsProperties.Create(Self);
{$ENDIF}
end;

destructor TGlueWindowSettings.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGlueWindowSettings.GetServerProperties: TGlueWindowSettingsProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TGlueWindowSettings.Get_type_: WideString;
begin
    Result := DefaultInterface.type_;
end;

procedure TGlueWindowSettings.Set_type_(const pRetVal: WideString);
  { Warning: The property type_ has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.type_ := pRetVal;
end;

function TGlueWindowSettings.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TGlueWindowSettings.Set_Title(const pRetVal: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := pRetVal;
end;

function TGlueWindowSettings.Get_AllowTabClose: WordBool;
begin
    Result := DefaultInterface.AllowTabClose;
end;

procedure TGlueWindowSettings.Set_AllowTabClose(pRetVal: WordBool);
begin
  DefaultInterface.Set_AllowTabClose(pRetVal);
end;

function TGlueWindowSettings.Get_ChannelSupport: WordBool;
begin
    Result := DefaultInterface.ChannelSupport;
end;

procedure TGlueWindowSettings.Set_ChannelSupport(pRetVal: WordBool);
begin
  DefaultInterface.Set_ChannelSupport(pRetVal);
end;

function TGlueWindowSettings.Get_Channel: WideString;
begin
    Result := DefaultInterface.Channel;
end;

procedure TGlueWindowSettings.Set_Channel(const pRetVal: WideString);
  { Warning: The property Channel has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Channel := pRetVal;
end;

function TGlueWindowSettings.Get_ShowTaskbarIcon: WordBool;
begin
    Result := DefaultInterface.ShowTaskbarIcon;
end;

procedure TGlueWindowSettings.Set_ShowTaskbarIcon(pRetVal: WordBool);
begin
  DefaultInterface.Set_ShowTaskbarIcon(pRetVal);
end;

function TGlueWindowSettings.Get_IsSticky: WordBool;
begin
    Result := DefaultInterface.IsSticky;
end;

procedure TGlueWindowSettings.Set_IsSticky(pRetVal: WordBool);
begin
  DefaultInterface.Set_IsSticky(pRetVal);
end;

function TGlueWindowSettings.Get_AllowUnstick: WordBool;
begin
    Result := DefaultInterface.AllowUnstick;
end;

procedure TGlueWindowSettings.Set_AllowUnstick(pRetVal: WordBool);
begin
  DefaultInterface.Set_AllowUnstick(pRetVal);
end;

function TGlueWindowSettings.Get_FrameColor: WideString;
begin
    Result := DefaultInterface.FrameColor;
end;

procedure TGlueWindowSettings.Set_FrameColor(const pRetVal: WideString);
  { Warning: The property FrameColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FrameColor := pRetVal;
end;

function TGlueWindowSettings.Get_Icon: WideString;
begin
    Result := DefaultInterface.Icon;
end;

procedure TGlueWindowSettings.Set_Icon(const pRetVal: WideString);
  { Warning: The property Icon has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Icon := pRetVal;
end;

function TGlueWindowSettings.Get_StandardButtons: WideString;
begin
    Result := DefaultInterface.StandardButtons;
end;

procedure TGlueWindowSettings.Set_StandardButtons(const pRetVal: WideString);
  { Warning: The property StandardButtons has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.StandardButtons := pRetVal;
end;

function TGlueWindowSettings.Get_MaxWidth: Integer;
begin
    Result := DefaultInterface.MaxWidth;
end;

procedure TGlueWindowSettings.Set_MaxWidth(pRetVal: Integer);
begin
  DefaultInterface.Set_MaxWidth(pRetVal);
end;

function TGlueWindowSettings.Get_MinWidth: Integer;
begin
    Result := DefaultInterface.MinWidth;
end;

procedure TGlueWindowSettings.Set_MinWidth(pRetVal: Integer);
begin
  DefaultInterface.Set_MinWidth(pRetVal);
end;

function TGlueWindowSettings.Get_MaxHeight: Integer;
begin
    Result := DefaultInterface.MaxHeight;
end;

procedure TGlueWindowSettings.Set_MaxHeight(pRetVal: Integer);
begin
  DefaultInterface.Set_MaxHeight(pRetVal);
end;

function TGlueWindowSettings.Get_MinHeight: Integer;
begin
    Result := DefaultInterface.MinHeight;
end;

procedure TGlueWindowSettings.Set_MinHeight(pRetVal: Integer);
begin
  DefaultInterface.Set_MinHeight(pRetVal);
end;

function TGlueWindowSettings.Get_Maximizable: WordBool;
begin
    Result := DefaultInterface.Maximizable;
end;

procedure TGlueWindowSettings.Set_Maximizable(pRetVal: WordBool);
begin
  DefaultInterface.Set_Maximizable(pRetVal);
end;

function TGlueWindowSettings.Get_Minimizable: WordBool;
begin
    Result := DefaultInterface.Minimizable;
end;

procedure TGlueWindowSettings.Set_Minimizable(pRetVal: WordBool);
begin
  DefaultInterface.Set_Minimizable(pRetVal);
end;

function TGlueWindowSettings.Get_SynchronousDestroy: WordBool;
begin
    Result := DefaultInterface.SynchronousDestroy;
end;

procedure TGlueWindowSettings.Set_SynchronousDestroy(pRetVal: WordBool);
begin
  DefaultInterface.Set_SynchronousDestroy(pRetVal);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGlueWindowSettingsProperties.Create(AServer: TGlueWindowSettings);
begin
  inherited Create;
  FServer := AServer;
end;

function TGlueWindowSettingsProperties.GetDefaultInterface: IGlueWindowSettings;
begin
  Result := FServer.DefaultInterface;
end;

function TGlueWindowSettingsProperties.Get_type_: WideString;
begin
    Result := DefaultInterface.type_;
end;

procedure TGlueWindowSettingsProperties.Set_type_(const pRetVal: WideString);
  { Warning: The property type_ has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.type_ := pRetVal;
end;

function TGlueWindowSettingsProperties.Get_Title: WideString;
begin
    Result := DefaultInterface.Title;
end;

procedure TGlueWindowSettingsProperties.Set_Title(const pRetVal: WideString);
  { Warning: The property Title has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Title := pRetVal;
end;

function TGlueWindowSettingsProperties.Get_AllowTabClose: WordBool;
begin
    Result := DefaultInterface.AllowTabClose;
end;

procedure TGlueWindowSettingsProperties.Set_AllowTabClose(pRetVal: WordBool);
begin
  DefaultInterface.Set_AllowTabClose(pRetVal);
end;

function TGlueWindowSettingsProperties.Get_ChannelSupport: WordBool;
begin
    Result := DefaultInterface.ChannelSupport;
end;

procedure TGlueWindowSettingsProperties.Set_ChannelSupport(pRetVal: WordBool);
begin
  DefaultInterface.Set_ChannelSupport(pRetVal);
end;

function TGlueWindowSettingsProperties.Get_Channel: WideString;
begin
    Result := DefaultInterface.Channel;
end;

procedure TGlueWindowSettingsProperties.Set_Channel(const pRetVal: WideString);
  { Warning: The property Channel has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Channel := pRetVal;
end;

function TGlueWindowSettingsProperties.Get_ShowTaskbarIcon: WordBool;
begin
    Result := DefaultInterface.ShowTaskbarIcon;
end;

procedure TGlueWindowSettingsProperties.Set_ShowTaskbarIcon(pRetVal: WordBool);
begin
  DefaultInterface.Set_ShowTaskbarIcon(pRetVal);
end;

function TGlueWindowSettingsProperties.Get_IsSticky: WordBool;
begin
    Result := DefaultInterface.IsSticky;
end;

procedure TGlueWindowSettingsProperties.Set_IsSticky(pRetVal: WordBool);
begin
  DefaultInterface.Set_IsSticky(pRetVal);
end;

function TGlueWindowSettingsProperties.Get_AllowUnstick: WordBool;
begin
    Result := DefaultInterface.AllowUnstick;
end;

procedure TGlueWindowSettingsProperties.Set_AllowUnstick(pRetVal: WordBool);
begin
  DefaultInterface.Set_AllowUnstick(pRetVal);
end;

function TGlueWindowSettingsProperties.Get_FrameColor: WideString;
begin
    Result := DefaultInterface.FrameColor;
end;

procedure TGlueWindowSettingsProperties.Set_FrameColor(const pRetVal: WideString);
  { Warning: The property FrameColor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FrameColor := pRetVal;
end;

function TGlueWindowSettingsProperties.Get_Icon: WideString;
begin
    Result := DefaultInterface.Icon;
end;

procedure TGlueWindowSettingsProperties.Set_Icon(const pRetVal: WideString);
  { Warning: The property Icon has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Icon := pRetVal;
end;

function TGlueWindowSettingsProperties.Get_StandardButtons: WideString;
begin
    Result := DefaultInterface.StandardButtons;
end;

procedure TGlueWindowSettingsProperties.Set_StandardButtons(const pRetVal: WideString);
  { Warning: The property StandardButtons has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.StandardButtons := pRetVal;
end;

function TGlueWindowSettingsProperties.Get_MaxWidth: Integer;
begin
    Result := DefaultInterface.MaxWidth;
end;

procedure TGlueWindowSettingsProperties.Set_MaxWidth(pRetVal: Integer);
begin
  DefaultInterface.Set_MaxWidth(pRetVal);
end;

function TGlueWindowSettingsProperties.Get_MinWidth: Integer;
begin
    Result := DefaultInterface.MinWidth;
end;

procedure TGlueWindowSettingsProperties.Set_MinWidth(pRetVal: Integer);
begin
  DefaultInterface.Set_MinWidth(pRetVal);
end;

function TGlueWindowSettingsProperties.Get_MaxHeight: Integer;
begin
    Result := DefaultInterface.MaxHeight;
end;

procedure TGlueWindowSettingsProperties.Set_MaxHeight(pRetVal: Integer);
begin
  DefaultInterface.Set_MaxHeight(pRetVal);
end;

function TGlueWindowSettingsProperties.Get_MinHeight: Integer;
begin
    Result := DefaultInterface.MinHeight;
end;

procedure TGlueWindowSettingsProperties.Set_MinHeight(pRetVal: Integer);
begin
  DefaultInterface.Set_MinHeight(pRetVal);
end;

function TGlueWindowSettingsProperties.Get_Maximizable: WordBool;
begin
    Result := DefaultInterface.Maximizable;
end;

procedure TGlueWindowSettingsProperties.Set_Maximizable(pRetVal: WordBool);
begin
  DefaultInterface.Set_Maximizable(pRetVal);
end;

function TGlueWindowSettingsProperties.Get_Minimizable: WordBool;
begin
    Result := DefaultInterface.Minimizable;
end;

procedure TGlueWindowSettingsProperties.Set_Minimizable(pRetVal: WordBool);
begin
  DefaultInterface.Set_Minimizable(pRetVal);
end;

function TGlueWindowSettingsProperties.Get_SynchronousDestroy: WordBool;
begin
    Result := DefaultInterface.SynchronousDestroy;
end;

procedure TGlueWindowSettingsProperties.Set_SynchronousDestroy(pRetVal: WordBool);
begin
  DefaultInterface.Set_SynchronousDestroy(pRetVal);
end;

{$ENDIF}

class function CoGlueMethodInfo.Create: IGlueMethodInfo;
begin
  Result := CreateComObject(CLASS_GlueMethodInfo) as IGlueMethodInfo;
end;

class function CoGlueMethodInfo.CreateRemote(const MachineName: string): IGlueMethodInfo;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueMethodInfo) as IGlueMethodInfo;
end;

class function CoGlueData.Create: IGlueData;
begin
  Result := CreateComObject(CLASS_GlueData) as IGlueData;
end;

class function CoGlueData.CreateRemote(const MachineName: string): IGlueData;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueData) as IGlueData;
end;

class function CoGlueStreamConsumer.Create: IGlueStreamConsumer;
begin
  Result := CreateComObject(CLASS_GlueStreamConsumer) as IGlueStreamConsumer;
end;

class function CoGlueStreamConsumer.CreateRemote(const MachineName: string): IGlueStreamConsumer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueStreamConsumer) as IGlueStreamConsumer;
end;

class function CoVbGlueInvocationResult.Create: IGlueInvocationResult;
begin
  Result := CreateComObject(CLASS_VbGlueInvocationResult) as IGlueInvocationResult;
end;

class function CoVbGlueInvocationResult.CreateRemote(const MachineName: string): IGlueInvocationResult;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_VbGlueInvocationResult) as IGlueInvocationResult;
end;

class function CoGlueMethodInvocator.Create: IGlueMethodInvocator;
begin
  Result := CreateComObject(CLASS_GlueMethodInvocator) as IGlueMethodInvocator;
end;

class function CoGlueMethodInvocator.CreateRemote(const MachineName: string): IGlueMethodInvocator;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueMethodInvocator) as IGlueMethodInvocator;
end;

class function CoVBGlueStreamSubscriber.Create: IVBGlueStreamSubscriber;
begin
  Result := CreateComObject(CLASS_VBGlueStreamSubscriber) as IVBGlueStreamSubscriber;
end;

class function CoVBGlueStreamSubscriber.CreateRemote(const MachineName: string): IVBGlueStreamSubscriber;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_VBGlueStreamSubscriber) as IVBGlueStreamSubscriber;
end;

class function CoGlueInvocationRequest.Create: IGlueInvocationRequest;
begin
  Result := CreateComObject(CLASS_GlueInvocationRequest) as IGlueInvocationRequest;
end;

class function CoGlueInvocationRequest.CreateRemote(const MachineName: string): IGlueInvocationRequest;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueInvocationRequest) as IGlueInvocationRequest;
end;

class function CoGlueSubscriptionRequest.Create: IGlueSubscriptionRequest;
begin
  Result := CreateComObject(CLASS_GlueSubscriptionRequest) as IGlueSubscriptionRequest;
end;

class function CoGlueSubscriptionRequest.CreateRemote(const MachineName: string): IGlueSubscriptionRequest;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueSubscriptionRequest) as IGlueSubscriptionRequest;
end;

class function CoGlueServerStream.Create: IGlueServerStream;
begin
  Result := CreateComObject(CLASS_GlueServerStream) as IGlueServerStream;
end;

class function CoGlueServerStream.CreateRemote(const MachineName: string): IGlueServerStream;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueServerStream) as IGlueServerStream;
end;

class function CoGlueServerMethod.Create: IGlueServerMethod;
begin
  Result := CreateComObject(CLASS_GlueServerMethod) as IGlueServerMethod;
end;

class function CoGlueServerMethod.CreateRemote(const MachineName: string): IGlueServerMethod;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueServerMethod) as IGlueServerMethod;
end;

class function CoGlue42.Create: IGlue42;
begin
  Result := CreateComObject(CLASS_Glue42) as IGlue42;
end;

class function CoGlue42.CreateRemote(const MachineName: string): IGlue42;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Glue42) as IGlue42;
end;

procedure TGlue42.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{556D7D1B-7E89-454A-8575-85B1ABE35941}';
    IntfIID:   '{DB20C8DA-CD98-4D75-8B9A-18284B7EE0D1}';
    EventIID:  '{0EE5A248-F02A-4551-8745-437F6AFAAB4D}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGlue42.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IGlue42;
  end;
end;

procedure TGlue42.ConnectTo(svrIntf: IGlue42);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TGlue42.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TGlue42.GetDefaultInterface: IGlue42;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TGlue42.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGlue42Properties.Create(Self);
{$ENDIF}
end;

destructor TGlue42.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGlue42.GetServerProperties: TGlue42Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TGlue42.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
(*{The DispID for this method is DISPID_UNKNOWN!?. }
    -1: if Assigned(FOnGlueVariantResponse) then
         FOnGlueVariantResponse(Self,
                                Params[0] {const WideString},
                                Params[1] {OleVariant});
*)
(*{The DispID for this method is DISPID_UNKNOWN!?. }
    -1: if Assigned(FOnGlueVariantInvoke) then
         FOnGlueVariantInvoke(Self,
                              Params[0] {const WideString},
                              Params[1] {OleVariant},
                              Params[2] {const WideString});
*)
(*{The DispID for this method is DISPID_UNKNOWN!?. }
    -1: if Assigned(FOnGlueResponse) then
         FOnGlueResponse(Self,
                         Params[0] {const WideString},
                         Params[1] {const WideString});
*)
(*{The DispID for this method is DISPID_UNKNOWN!?. }
    -1: if Assigned(FOnGlueInvoke) then
         FOnGlueInvoke(Self,
                       Params[0] {const WideString},
                       Params[1] {const WideString},
                       Params[2] {const WideString});
*)
  end; {case DispID}
end;

function TGlue42.Get_AppFactoryRegistry: IAppFactoryRegistry;
begin
    Result := DefaultInterface.AppFactoryRegistry;
end;

procedure TGlue42.OverrideConfiguration(configuration: GlueConfiguration);
begin
  DefaultInterface.OverrideConfiguration(configuration);
end;

procedure TGlue42.Start(Instance: GlueInstance);
begin
  DefaultInterface.Start(Instance);
end;

function TGlue42.TranslateVbObject(data: OleVariant): OleVariant;
begin
  Result := DefaultInterface.TranslateVbObject(data);
end;

procedure TGlue42.SetLogConfigurationPath(const logConfigPath: WideString);
begin
  DefaultInterface.SetLogConfigurationPath(logConfigPath);
end;

procedure TGlue42.StartWithAppName(const ApplicationName: WideString);
begin
  DefaultInterface.StartWithAppName(ApplicationName);
end;

procedure TGlue42.Stop;
begin
  DefaultInterface.Stop;
end;

function TGlue42.RegisterGlueWindow(hwnd: Integer; const windowEventHandler: IGlueWindowEventHandler): IGlueWindow;
begin
  Result := DefaultInterface.RegisterGlueWindow(hwnd, windowEventHandler);
end;

function TGlue42.RegisterStartupGlueWindow(hwnd: Integer; 
                                           const windowEventHandler: IGlueWindowEventHandler): IGlueWindow;
begin
  Result := DefaultInterface.RegisterStartupGlueWindow(hwnd, windowEventHandler);
end;

function TGlue42.CreateDefaultVBGlueWindowSettings: IGlueWindowSettings;
begin
  Result := DefaultInterface.CreateDefaultVBGlueWindowSettings;
end;

function TGlue42.GetStartupWindowSettings: IGlueWindowSettings;
begin
  Result := DefaultInterface.GetStartupWindowSettings;
end;

function TGlue42.RegisterGlueWindowWithSettings(hwnd: Integer; const settings: IGlueWindowSettings; 
                                                const windowEventHandler: IGlueWindowEventHandler): IGlueWindow;
begin
  Result := DefaultInterface.RegisterGlueWindowWithSettings(hwnd, settings, windowEventHandler);
end;

function TGlue42.RegisterStartupGlueWindowWithSettings(hwnd: Integer; 
                                                       const settings: IGlueWindowSettings; 
                                                       const windowEventHandler: IGlueWindowEventHandler): IGlueWindow;
begin
  Result := DefaultInterface.RegisterStartupGlueWindowWithSettings(hwnd, settings, 
                                                                   windowEventHandler);
end;

function TGlue42.GetInstance: GlueInstance;
begin
  Result := DefaultInterface.GetInstance;
end;

function TGlue42.CreateGlueValues: OleVariant;
begin
  Result := DefaultInterface.CreateGlueValues;
end;

function TGlue42.CreateGlueData(data: OleVariant): IGlueData;
begin
  Result := DefaultInterface.CreateGlueData(data);
end;

function TGlue42.GetKnownContexts: PSafeArray;
begin
  Result := DefaultInterface.GetKnownContexts;
end;

procedure TGlue42.SubscribeGlueContext(const contextName: WideString; 
                                       const handler: IGlueContextHandler);
begin
  DefaultInterface.SubscribeGlueContext(contextName, handler);
end;

function TGlue42.GetGlueContext(const contextName: WideString): IGlueContext;
begin
  Result := DefaultInterface.GetGlueContext(contextName);
end;

function TGlue42.GetAllInstances: PSafeArray;
begin
  Result := DefaultInterface.GetAllInstances;
end;

function TGlue42.GetAllMethods: PSafeArray;
begin
  Result := DefaultInterface.GetAllMethods;
end;

function TGlue42.GetMethodsForInstance(Instance: GlueInstance; identity: GlueInstanceIdentity): PSafeArray;
begin
  Result := DefaultInterface.GetMethodsForInstance(Instance, identity);
end;

procedure TGlue42.Subscribe(const handler: IGlueEvents);
begin
  DefaultInterface.Subscribe(handler);
end;

procedure TGlue42.Unsubscribe(const handler: IGlueEvents);
begin
  DefaultInterface.Unsubscribe(handler);
end;

function TGlue42.BuildGlueContextValues(const contextBuilderCallback: IGlueContextBuilderCallback): PSafeArray;
begin
  Result := DefaultInterface.BuildGlueContextValues(contextBuilderCallback);
end;

function TGlue42.RegisterMethod(const methodName: WideString; 
                                const requestHandler: IGlueRequestHandler; const Input: WideString; 
                                const Output: WideString; ObjectTypes: PSafeArray): GlueMethod;
begin
  Result := DefaultInterface.RegisterMethod(methodName, requestHandler, Input, Output, ObjectTypes);
end;

function TGlue42.CreateServerMethod(const methodName: WideString; const Input: WideString; 
                                    const Output: WideString; const objectTypesCSV: WideString): IGlueServerMethod;
begin
  Result := DefaultInterface.CreateServerMethod(methodName, Input, Output, objectTypesCSV);
end;

function TGlue42.CreateServerStream(const streamName: WideString; const Input: WideString; 
                                    const Output: WideString; const objectTypesCSV: WideString): IGlueServerStream;
begin
  Result := DefaultInterface.CreateServerStream(streamName, Input, Output, objectTypesCSV);
end;

function TGlue42.CreateMethodInvocator: IGlueMethodInvocator;
begin
  Result := DefaultInterface.CreateMethodInvocator;
end;

function TGlue42.CreateStreamConsumer: IGlueStreamConsumer;
begin
  Result := DefaultInterface.CreateStreamConsumer;
end;

function TGlue42.RegisterStream(const streamName: WideString; 
                                const subscriptionHandler: IGlueSubscriptionHandler; 
                                const Input: WideString; const Output: WideString; 
                                ObjectTypes: PSafeArray; out stream: IGlueStream): GlueMethod;
begin
  Result := DefaultInterface.RegisterStream(streamName, subscriptionHandler, Input, Output, 
                                            ObjectTypes, stream);
end;

procedure TGlue42.UnregisterMethod(method: GlueMethod);
begin
  DefaultInterface.UnregisterMethod(method);
end;

procedure TGlue42.BuildAndInvoke(const method: WideString; 
                                 const builderCallback: IGlueContextBuilderCallback; 
                                 targets: PSafeArray; all: WordBool; 
                                 identity: GlueInstanceIdentity; 
                                 const resultHandler: IGlueInvocationResultHandler; 
                                 invocationTimeoutMsecs: Int64; const correlationId: WideString);
begin
  DefaultInterface.BuildAndInvoke(method, builderCallback, targets, all, identity, resultHandler, 
                                  invocationTimeoutMsecs, correlationId);
end;

procedure TGlue42.InvokeMethods(const method: WideString; invocationArgs: PSafeArray; 
                                targets: PSafeArray; all: WordBool; identity: GlueInstanceIdentity; 
                                const resultHandler: IGlueInvocationResultHandler; 
                                invocationTimeoutMsecs: Int64; const correlationId: WideString);
begin
  DefaultInterface.InvokeMethods(method, invocationArgs, targets, all, identity, resultHandler, 
                                 invocationTimeoutMsecs, correlationId);
end;

procedure TGlue42.InvokeMethod(method: GlueMethod; invocationArgs: PSafeArray; 
                               const resultHandler: IGlueInvocationResultHandler; 
                               invocationTimeoutMsecs: Int64; const correlationId: WideString);
begin
  DefaultInterface.InvokeMethod(method, invocationArgs, resultHandler, invocationTimeoutMsecs, 
                                correlationId);
end;

procedure TGlue42.SubscribeStreams(const streamName: WideString; 
                                   subscriptionRequestArgs: PSafeArray; targets: PSafeArray; 
                                   all: WordBool; identity: GlueInstanceIdentity; 
                                   const streamHandler: IGlueStreamHandler; 
                                   invocationTimeoutMsecs: Int64);
begin
  DefaultInterface.SubscribeStreams(streamName, subscriptionRequestArgs, targets, all, identity, 
                                    streamHandler, invocationTimeoutMsecs);
end;

procedure TGlue42.SubscribeStreamsFilterTargets(const streamName: WideString; 
                                                subscriptionRequestArgs: PSafeArray; 
                                                const targetRegex: WideString; all: WordBool; 
                                                const streamHandler: IGlueStreamHandler; 
                                                invocationTimeoutMsecs: Int64);
begin
  DefaultInterface.SubscribeStreamsFilterTargets(streamName, subscriptionRequestArgs, targetRegex, 
                                                 all, streamHandler, invocationTimeoutMsecs);
end;

procedure TGlue42.SubscribeStream(stream: GlueMethod; subscriptionRequestArgs: PSafeArray; 
                                  const streamHandler: IGlueStreamHandler; 
                                  subscriptionTimeoutMsecs: Int64);
begin
  DefaultInterface.SubscribeStream(stream, subscriptionRequestArgs, streamHandler, 
                                   subscriptionTimeoutMsecs);
end;

function TGlue42.InvokeSync(const methodName: WideString; const argsAsJson: WideString; 
                            const resultFieldPath: WideString; const targetRegex: WideString): WideString;
begin
  Result := DefaultInterface.InvokeSync(methodName, argsAsJson, resultFieldPath, targetRegex);
end;

procedure TGlue42.InvokeAsync(const correlationId: WideString; const methodName: WideString; 
                              const argsAsJson: WideString; const resultFieldPath: WideString; 
                              const targetRegex: WideString);
begin
  DefaultInterface.InvokeAsync(correlationId, methodName, argsAsJson, resultFieldPath, targetRegex);
end;

procedure TGlue42.SubscribeStreamInSink(const correlationId: WideString; 
                                        const streamName: WideString; const argsAsJson: WideString; 
                                        const resultFieldPath: WideString; 
                                        const targetRegex: WideString; 
                                        const filterFieldPath: WideString; 
                                        const filterDataRegex: WideString);
begin
  DefaultInterface.SubscribeStreamInSink(correlationId, streamName, argsAsJson, resultFieldPath, 
                                         targetRegex, filterFieldPath, filterDataRegex);
end;

procedure TGlue42.RegisterMethodInSink(const correlationId: WideString; 
                                       const methodName: WideString; 
                                       const inputSignature: WideString; 
                                       const outputSignature: WideString; ObjectTypes: PSafeArray; 
                                       const invocationFieldPath: WideString; 
                                       const targetRegex: WideString; 
                                       const filterFieldPath: WideString; 
                                       const filterDataRegex: WideString);
begin
  DefaultInterface.RegisterMethodInSink(correlationId, methodName, inputSignature, outputSignature, 
                                        ObjectTypes, invocationFieldPath, targetRegex, 
                                        filterFieldPath, filterDataRegex);
end;

procedure TGlue42.RegisterVariantMethodInSink(const correlationId: WideString; 
                                              const methodName: WideString; 
                                              const inputSignature: WideString; 
                                              const outputSignature: WideString; 
                                              ObjectTypes: PSafeArray; 
                                              const invocationFieldPath: WideString; 
                                              const targetRegex: WideString; 
                                              const filterFieldPath: WideString; 
                                              const filterDataRegex: WideString);
begin
  DefaultInterface.RegisterVariantMethodInSink(correlationId, methodName, inputSignature, 
                                               outputSignature, ObjectTypes, invocationFieldPath, 
                                               targetRegex, filterFieldPath, filterDataRegex);
end;

procedure TGlue42.RegisterVoidMethodInSink(const correlationId: WideString; 
                                           const methodName: WideString; 
                                           const inputSignature: WideString; 
                                           ObjectTypes: PSafeArray; 
                                           const invocationFieldPath: WideString; 
                                           const targetRegex: WideString; 
                                           const filterFieldPath: WideString; 
                                           const filterDataRegex: WideString);
begin
  DefaultInterface.RegisterVoidMethodInSink(correlationId, methodName, inputSignature, ObjectTypes, 
                                            invocationFieldPath, targetRegex, filterFieldPath, 
                                            filterDataRegex);
end;

procedure TGlue42.RegisterSingleBranchStream(const correlationId: WideString; 
                                             const streamName: WideString; 
                                             const requestSignature: WideString; 
                                             const streamSignature: WideString);
begin
  DefaultInterface.RegisterSingleBranchStream(correlationId, streamName, requestSignature, 
                                              streamSignature);
end;

procedure TGlue42.AddCorrelationInterest(const correlationId: WideString; 
                                         const interestId: WideString; const fieldPath: WideString; 
                                         const filterFieldPath: WideString; 
                                         const filterDataRegex: WideString);
begin
  DefaultInterface.AddCorrelationInterest(correlationId, interestId, fieldPath, filterFieldPath, 
                                          filterDataRegex);
end;

procedure TGlue42.RegisterStreamInSink(const correlationId: WideString; 
                                       const streamName: WideString; 
                                       const requestSignature: WideString; 
                                       const streamSignature: WideString; 
                                       const requestFieldPath: WideString; 
                                       const targetRegex: WideString; 
                                       const filterFieldPath: WideString; 
                                       const filterDataRegex: WideString);
begin
  DefaultInterface.RegisterStreamInSink(correlationId, streamName, requestSignature, 
                                        streamSignature, requestFieldPath, targetRegex, 
                                        filterFieldPath, filterDataRegex);
end;

procedure TGlue42.YieldCallbackData(const correlationId: WideString; const callbackId: WideString; 
                                    const callbackData: WideString);
begin
  DefaultInterface.YieldCallbackData(correlationId, callbackId, callbackData);
end;

procedure TGlue42.YieldCallbackVariantData(const correlationId: WideString; 
                                           const callbackId: WideString; callbackData: OleVariant);
begin
  DefaultInterface.YieldCallbackVariantData(correlationId, callbackId, callbackData);
end;

procedure TGlue42.RegisterGlueWindowInSink(const correlationId: WideString; const hwnd: WideString);
begin
  DefaultInterface.RegisterGlueWindowInSink(correlationId, hwnd);
end;

function TGlue42.JsonToVariant(const json: WideString): PSafeArray;
begin
  Result := DefaultInterface.JsonToVariant(json);
end;

procedure TGlue42.CloseResource(const correlationId: WideString);
begin
  DefaultInterface.CloseResource(correlationId);
end;

function TGlue42.GetMethodNamesForTarget(const targetRegex: WideString): PSafeArray;
begin
  Result := DefaultInterface.GetMethodNamesForTarget(targetRegex);
end;

function TGlue42.GetTargets: PSafeArray;
begin
  Result := DefaultInterface.GetTargets;
end;

function TGlue42.GetChannels: PSafeArray;
begin
  Result := DefaultInterface.GetChannels;
end;

procedure TGlue42.InvokeAsyncVariantData(const correlationId: WideString; 
                                         const methodName: WideString; args: OleVariant; 
                                         const resultFieldPath: WideString; 
                                         const targetRegex: WideString);
begin
  DefaultInterface.InvokeAsyncVariantData(correlationId, methodName, args, resultFieldPath, 
                                          targetRegex);
end;

procedure TGlue42.SubscribeChannel(const correlationId: WideString; const Channel: WideString; 
                                   const resultFieldPath: WideString);
begin
  DefaultInterface.SubscribeChannel(correlationId, Channel, resultFieldPath);
end;

procedure TGlue42.SetChannelData(const Channel: WideString; const fieldPath: WideString; 
                                 const data: WideString);
begin
  DefaultInterface.SetChannelData(Channel, fieldPath, data);
end;

procedure TGlue42.G4O_XL_OpenSheet(const correlationId: WideString; const sheetName: WideString; 
                                   columnNames: PSafeArray; columnValidationTypes: PSafeArray; 
                                   data: OleVariant);
begin
  DefaultInterface.G4O_XL_OpenSheet(correlationId, sheetName, columnNames, columnValidationTypes, 
                                    data);
end;

procedure TGlue42.Log(level: Byte; const Message: WideString);
begin
  DefaultInterface.Log(level, Message);
end;

function TGlue42.GetState: GlueState;
begin
  Result := DefaultInterface.GetState;
end;

function TGlue42.IsLaunchedByGD: WordBool;
begin
  Result := DefaultInterface.IsLaunchedByGD;
end;

function TGlue42.GetStartingContext: GlueValue;
begin
  Result := DefaultInterface.GetStartingContext;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGlue42Properties.Create(AServer: TGlue42);
begin
  inherited Create;
  FServer := AServer;
end;

function TGlue42Properties.GetDefaultInterface: IGlue42;
begin
  Result := FServer.DefaultInterface;
end;

function TGlue42Properties.Get_AppFactoryRegistry: IAppFactoryRegistry;
begin
    Result := DefaultInterface.AppFactoryRegistry;
end;

{$ENDIF}

class function CoGlueStreamSubscription.Create: IGlueStreamSubscription;
begin
  Result := CreateComObject(CLASS_GlueStreamSubscription) as IGlueStreamSubscription;
end;

class function CoGlueStreamSubscription.CreateRemote(const MachineName: string): IGlueStreamSubscription;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueStreamSubscription) as IGlueStreamSubscription;
end;

class function CoGlueWindow.Create: IGlueWindow;
begin
  Result := CreateComObject(CLASS_GlueWindow) as IGlueWindow;
end;

class function CoGlueWindow.CreateRemote(const MachineName: string): IGlueWindow;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueWindow) as IGlueWindow;
end;

class function CoGlueContextImage.Create: IGlueContextUpdate;
begin
  Result := CreateComObject(CLASS_GlueContextImage) as IGlueContextUpdate;
end;

class function CoGlueContextImage.CreateRemote(const MachineName: string): IGlueContextUpdate;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueContextImage) as IGlueContextUpdate;
end;

class function CoGlueContextUpdate.Create: IGlueContextUpdate;
begin
  Result := CreateComObject(CLASS_GlueContextUpdate) as IGlueContextUpdate;
end;

class function CoGlueContextUpdate.CreateRemote(const MachineName: string): IGlueContextUpdate;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueContextUpdate) as IGlueContextUpdate;
end;

class function CoGlueContextManager.Create: IGlueContext;
begin
  Result := CreateComObject(CLASS_GlueContextManager) as IGlueContext;
end;

class function CoGlueContextManager.CreateRemote(const MachineName: string): IGlueContext;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueContextManager) as IGlueContext;
end;

class function CoGlueException.Create: _GlueException;
begin
  Result := CreateComObject(CLASS_GlueException) as _GlueException;
end;

class function CoGlueException.CreateRemote(const MachineName: string): _GlueException;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlueException) as _GlueException;
end;

procedure TGlueException.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{3CB2D568-58F9-44D6-83EC-472FB5AE284A}';
    IntfIID:   '{77A3400F-F4AC-3AA1-B0D9-39D704BD1949}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGlueException.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _GlueException;
  end;
end;

procedure TGlueException.ConnectTo(svrIntf: _GlueException);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGlueException.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGlueException.GetDefaultInterface: _GlueException;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TGlueException.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGlueExceptionProperties.Create(Self);
{$ENDIF}
end;

destructor TGlueException.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGlueException.GetServerProperties: TGlueExceptionProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGlueExceptionProperties.Create(AServer: TGlueException);
begin
  inherited Create;
  FServer := AServer;
end;

function TGlueExceptionProperties.GetDefaultInterface: _GlueException;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TGlueDynamicValue, TGlueWindowSettings, TGlue42, TGlueException]);
end;

end.
