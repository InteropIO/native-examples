/// Glue42 Helper Unit
/// Exposes helper utilities for consuming Glue42 COM library.
/// - Lambda implementations for different Glue42 callback interfaces.
/// - Packing/unpacking Context Value arguments in Safe Arrays
/// - Converting from Glue Time to DateTime and vice-versa

unit GlueHelper;

interface

uses
  SysUtils, Variants, Classes, GlueCOM_TLB, ActiveX,
  ComObj, ObjAuto, Windows;

const
  VT_RECORD = 36;
  varUInt32 = $0013; { vt_ui4         19 }
  varUInt64 = $0015; { vt_ui8         21 }
  varUString = $0102; { Unicode string 258 } { not OLE compatible }
  varRecord = $0024; { VT_RECORD      36 }

  Tuple__IID: TGUID = '{93da746a-fb5d-45c4-96fb-8d7f3ca43960}';
  Instance__IID: TGuid = '{12E47256-B411-4024-BA5C-13DF4C78C31D}';
  ContextValue__IID: TGuid = '{c74dd3d8-08a3-4b68-a41e-af04acd319bd}';

type

  PVarRecord = ^TVarRecord;

  TVarRecord = record
    PRecord: Pointer;
    RecInfo: Pointer;
  end;

  UInt32 = Cardinal;

{$EXTERNALSYM tagVARIANT}

  tagVARIANT = record
    vt: TVarType;
    wReserved1: Word;
    wReserved2: Word;
    wReserved3: Word;
    case Integer of
      VT_UI1:
      (bVal: Byte);
      VT_I2:
      (iVal: Smallint);
      VT_I4:
      (lVal: Longint);
      VT_R4:
      (fltVal: Single);
      VT_R8:
      (dblVal: Double);
      VT_BOOL:
      (vbool: TOleBool);
      VT_ERROR:
      (scode: HResult);
      VT_CY:
      (cyVal: Currency);
      VT_DATE:
      (date: TOleDate);
      VT_BSTR:
      (bstrVal: PWideChar { WideString });
      VT_UNKNOWN:
      (unkVal: Pointer { IUnknown });
      VT_DISPATCH:
      (dispVal: Pointer { IDispatch });
      VT_ARRAY:
      (parray: PSafeArray);
      VT_BYREF or VT_UI1:
      (pbVal: ^Byte);
      VT_BYREF or VT_I2:
      (piVal: ^Smallint);
      VT_BYREF or VT_I4:
      (plVal: ^Longint);
      VT_BYREF or VT_R4:
      (pfltVal: ^Single);
      VT_BYREF or VT_R8:
      (pdblVal: ^Double);
      VT_BYREF or VT_BOOL:
      (pbool: ^TOleBool);
      VT_BYREF or VT_ERROR:
      (pscode: ^HResult);
      VT_BYREF or VT_CY:
      (pcyVal: ^Currency);
      VT_BYREF or VT_DATE:
      (pdate: ^TOleDate);
      VT_BYREF or VT_BSTR:
      (pbstrVal: ^WideString);
      VT_BYREF or VT_UNKNOWN:
      (punkVal: ^IUnknown);
      VT_BYREF or VT_DISPATCH:
      (pdispVal: ^IDispatch);
      VT_BYREF or VT_ARRAY:
      (pparray: ^PSafeArray);
      VT_BYREF or VT_VARIANT:
      (pvarVal: PVariant);
      VT_BYREF:
      (byRef: Pointer);
      VT_I1:
      (cVal: AnsiChar);
      VT_UI2:
      (uiVal: Word);
      VT_UI4:
      (ulVal: LongWord);
      VT_I8:
      (llVal: Int64);
      VT_UI8:
      (ullVal: UInt64);
      VT_INT:
      (intVal: Integer);
      VT_UINT:
      (uintVal: LongWord);
      VT_BYREF or VT_DECIMAL:
      (pdecVal: PDecimal);
      VT_BYREF or VT_I1:
      (pcVal: PAnsiChar);
      VT_BYREF or VT_UI2:
      (puiVal: PWord);
      VT_BYREF or VT_UI4:
      (pulVal: PInteger);
      VT_BYREF or VT_INT:
      (pintVal: PInteger);
      VT_BYREF or VT_UINT:
      (puintVal: PLongWord);
      VT_BYREF or VT_I8:
      (pllVal: ^Int64);
      VT_BYREF or VT_UI8:
      (pullVal: ^UInt64);
      VT_RECORD:
      (pvRecord: Pointer;
        pRecInfo: Pointer);
  end;

  TVarData = packed record
    case Integer of
      0:
      (VType: TVarType;
        case Integer of
          0: (Reserved1: Word;
            case Integer of
              0: (Reserved2, Reserved3: Word;
                case Integer of
                  varSmallInt: (VSmallInt: Smallint);
                  varInteger: (VInteger: Integer);
                  varSingle: (VSingle: Single);
                  varDouble: (VDouble: Double);
                  varCurrency: (VCurrency: Currency);
                  varDate: (VDate: TDateTime);
                  varOleStr: (VOleStr: PWideChar);
                  varDispatch: (VDispatch: Pointer);
                  varError: (VError: HResult);
                  varBoolean: (VBoolean: WordBool);
                  varUnknown: (VUnknown: Pointer);
                  varShortInt: (VShortInt: ShortInt);
                  varByte: (VByte: Byte);
                  varWord: (VWord: Word);
                  -1: (VLongWord: Cardinal { deprecated 'use VUInt32' });
                  varUInt32: (VUInt32: UInt32);
                  varInt64: (VInt64: Int64);
                  varUInt64: (VUInt64: UInt64);
                  varString: (VString: Pointer);
                  varAny: (VAny: Pointer);
                  varArray: (VArray: PVarArray);
                  varByRef: (VPointer: Pointer);
                  varUString: (VUString: Pointer);
                  varRecord: (VRecord: TVarRecord);
                  // $ffff:     (VLargest: TLargestVarData);
                  );
              1: (VLongs: array[0..
{$IFDEF CPU64BITS}4{$ELSE}2{$ENDIF}] of Integer);
              );
          2: (VWords: array[0..
{$IFDEF CPU64BITS}10{$ELSE}6{$ENDIF}] of Word);
          3: (VBytes: array[0..
{$IFDEF CPU64BITS}21{$ELSE}13{$ENDIF}] of Byte);
          );
      1:
      (RawData: array[0..{$IFDEF CPU64BITS}5{$ELSE}3{$ENDIF}] of Integer);
  end;

  PVOID = Pointer;
  PGlueContextValue = ^GlueContextValue;
  PGlueMethod = ^GlueMethod;
  PGlueValue = ^GlueValue;
  PGlueResult = ^GlueResult;
  PGlueInvocationResult = ^GlueInvocationResult;
  TCallbackCookie = Pointer;

  TWideStringArray = array of WideString;
  TInt64Array = array of Int64;
  TIntArray = array of Integer;
  TWordBoolArray = array of WordBool;
  TDoubleArray = array of Double;
  TDateTimeArray = array of TDateTime;
  TStrArray = array of string;
  PStr = ^string;

  PTGlueValue = ^TGlueValue;

  TGlueContextValue = packed record
    Name: WideString;
    Value: PTGlueValue;
  end;

  TGlueContextValueArray = array of TGlueContextValue;
  TGlueValueArray = array of PTGlueValue;

  TGlueValue = packed record
    GlueType: GlueValueType;
    IsArray: WordBool;
    BoolValue: WordBool;
    LongValue: Int64;
    DoubleValue: Double;
    StringValue: WideString;
    DateTimeValue: TDateTime;
    BoolArray: TWordBoolArray;
    LongArray: TInt64Array;
    DoubleArray: TDoubleArray;
    StringArray: TStrArray;
    DateTimeArray: TDateTimeArray;
    Tuple: TGlueValueArray;
    CompositeValue: TGlueContextValueArray;
  end;

  TGlueResultHandler = class;
  TGlueRequestHandler = class;
  TGlueContextBuilderCallback = class;

  TGlueMethodArray = array of GlueMethod;
  TGlueInvocationResultArray = array of GlueInvocationResult;
  GlueContextValueArray = array of GlueContextValue;
  TGlueInstanceArray = array of GlueInstance;
  GlueValueArray = array of GlueValue;
  TResultHandlerLambda = procedure(Sender: TGlueResultHandler;
    GlueResult: TGlueInvocationResultArray; Cookie: TCallbackCookie;
    const correlationId: WideString) of object;
  TRequestHandlerLambda = procedure(Sender: TGlueRequestHandler;
    Method: GlueMethod; Instance: GlueInstance; Args: GlueContextValueArray;
    callback: IGlueServerMethodResultCallback; Cookie: TCallbackCookie;
    argsSA: PSafeArray) of object;
  TStreamDataLambda = procedure(Method: GlueMethod; data: GlueContextValueArray;
    dataAsSA: PSafeArray) of object;
  TContextRemovedLambda = procedure(context: IGlueContext;
    removedNames: array of string) of object;
  TContextDataLambda = procedure(context: IGlueContext;
    data: GlueContextValueArray) of object;

  TContextBuilderLambda = procedure(Sender: TGlueContextBuilderCallback;
    const builder: IGlueContextBuilder; Cookie: TCallbackCookie) of object;

  TGlueContextBuilderCallback = class(TInterfacedObject,
      IGlueContextBuilderCallback)
  private
    FCookie: TCallbackCookie;
    FContextBuilderLambda: TContextBuilderLambda;
  protected
    function Build(const builder: IGlueContextBuilder): HResult; stdcall;
  public
    constructor Create(Cookie: TCallbackCookie; builder: TContextBuilderLambda);
  end;

  /// Lambda implementation for handling an invocation result
  TGlueResultHandler = class(TInterfacedObject, IGlueInvocationResultHandler)
  private
    FHandlerLambda: TResultHandlerLambda;
    FCookie: TCallbackCookie;
  protected
    function HandleResult(invocationResult: PSafeArray;
      const correlationId: WideString): HResult; stdcall;
  public
    constructor Create(Cookie: TCallbackCookie;
      handlerLambda: TResultHandlerLambda);
  end;

  /// Lambda implementation for handling an invocation request
  TGlueRequestHandler = class(TInterfacedObject, IGlueRequestHandler)
  private
    FCookie: TCallbackCookie;
    FHandlerLambda: TRequestHandlerLambda;
  protected
    function HandleInvocationRequest(Method: GlueMethod; caller: GlueInstance;
      requestValues: PSafeArray;
      const resultCallback: IGlueServerMethodResultCallback): HResult; stdcall;
  public
    constructor Create(Cookie: TCallbackCookie;
      handlerLambda: TRequestHandlerLambda);
  end;

  // Lambda implementation for handling Glue stream data - subscription side
  TGlueStreamHandler = class(TInterfacedObject, IGlueStreamHandler)
  private
    FDataLambda: TStreamDataLambda;
  protected
    function SubscriptionActivated(const GlueStreamSubscription: IGlueStreamSubscription): HResult; stdcall;
    function StreamOpened(stream: GlueMethod;
      const glueStreamSubscription: IGlueStreamSubscription): HResult; stdcall;
    function HandleStreamData(stream: GlueMethod; data: PSafeArray)
      : HResult; stdcall;
    function HandleStreamStatus(stream: GlueMethod; State: GlueStreamState;
      const Message: WideString; dateTime: Int64): HResult; stdcall;
    function StreamClosed(stream: GlueMethod): HResult; stdcall;
  public
    constructor Create(dataLambda: TStreamDataLambda);
  end;

  /// Lambda implementation for handling Glue contexts
  TGlueContextHandler = class(TInterfacedObject, IGlueContextHandler)
  private
    fRemovedLambda: TContextRemovedLambda;
    fAddedLambda: TContextDataLambda;
    fUpdatedLambda: TContextDataLambda;
  protected
    function HandleContext(const context: IGlueContext): HResult; stdcall;
    function HandleContextUpdate(const contextUpdate: IGlueContextUpdate)
      : HResult; stdcall;
  public
    constructor Create(removedLambda: TContextRemovedLambda;
      addedLambda: TContextDataLambda; updatedLambda: TContextDataLambda);
  end;

  IRecordInfo = interface(IUnknown)
    ['{0000002F-0000-0000-C000-000000000046}']
    function RecordInit(out pvNew): HResult; stdcall;
    function RecordClear(pvExisting: Pointer): HResult; stdcall;
    function RecordCopy(pvExisting: Pointer; out pvNew: Pointer)
      : HResult; stdcall;
    function GetGuid(out pGuid: TGUID): HResult; stdcall;
    function GetName(out pbstrName: POleStr): HResult; stdcall;
    function GetSize(out pcbSize: Cardinal): HResult; stdcall;
    function GetTypeInfo(out ppTypeInfo: ITypeInfo): HResult; stdcall;
    function GetField(pvData: Pointer; szFieldName: POleStr;
      out pvarField: TVariantArg): HResult; stdcall;
    function GetFieldNoCopy(pvData: Pointer; szFieldNamd: POleStr;
      out pvarField: TVariantArg; out ppvData: Pointer): HResult; stdcall;
    function PutField(wFlags: Cardinal; pvData: Pointer; szFieldName: POleStr;
      pvarField: PVariantArg): HResult; stdcall;
    function PutFieldNoCopy(wFlags: Cardinal; pvData: Pointer;
      szFieldName: POleStr; pvarField: TVariantArg): HResult; stdcall;
    function GetFieldNames(var pcNames: Cardinal; rgBstrNames: Pointer)
      : HResult; stdcall;
    function IsMatchingType(pRecordInfo: IRecordInfo): HResult; stdcall;
    function RecordCreate: Pointer; stdcall;
    function RecordCreateCopy(pvSource: Pointer; out ppvDest: Pointer)
      : HResult; stdcall;
    function RecordDestroy(pvRecord: Pointer): HResult; stdcall;
  end;

  TGlueVarRec = record { do not pack this record; it is compiler-generated }
    case Byte of
      GlueValueType_Int:
      (VInteger: Integer; VType: Byte);
      GlueValueType_Bool:
      (VBoolean: Boolean);
      GlueValueType_String:
      (VString: PWideString);
      GlueValueType_Long:
      (VInt64: PInt64);
  end;

  // ----- helpers for creating translated Glue values -----
function CreateValue(const Value: string): TGlueValue; overload;
function CreateValue(const Value: Integer): TGlueValue; overload;
function CreateValue(const Value: Int64): TGlueValue; overload;
function CreateValue(const Value: Double): TGlueValue; overload;
function CreateValue(const Value: TVarRec): TGlueValue; overload;

function CreateValue(const Value: TStrArray): TGlueValue; overload;
function CreateValue(const Value: TInt64Array): TGlueValue; overload;
function CreateValue(const Value: TDoubleArray): TGlueValue; overload;
function CreateValue(const Value: array of const): TGlueValue; overload;
function CreateComposite(const Value: TGlueContextValueArray; IsArray: bool)
  : TGlueValue; overload;
function CreateComposite(const Value: array of TGlueContextValue; IsArray: bool)
  : TGlueValue; overload;

function CreateTuple(const Value: TGlueValueArray): TGlueValue; overload;
function CreateTuple(const Value: array of TGlueValue): TGlueValue; overload;

function CreateContextValue(const Name: string; const Value: TGlueValue)
  : TGlueContextValue; overload;

// ------ SafeArray translations

function SA_AsGlueValueArray(sa: PSafeArray): GlueValueArray; overload;
function SA_AsGlueContextValueArray(sa: PSafeArray; isVariantArray: Boolean = false): GlueContextValueArray;
function SA_AsStringArray(sa: PSafeArray): TStrArray; overload;
function SA_AsInt64Array(sa: PSafeArray): TInt64Array;
function SA_AsDateTimeArray(sa: PSafeArray): TDateTimeArray;
function SA_AsDoubleArray(sa: PSafeArray): TDoubleArray;
function SA_AsWordBoolArray(sa: PSafeArray): TWordBoolArray;
function SA_AsGlueMethodArray(sa: PSafeArray): TGlueMethodArray;
function SA_AsTranslatedContextValues(sa: PSafeArray): TGlueContextValueArray;

function AsStringArray(BoolArray: TWordBoolArray): TStrArray; overload;
function AsStringArray(int64Array: TInt64Array): TStrArray; overload;
function AsStringArray(DoubleArray: TDoubleArray): TStrArray; overload;
function AsStringArray(DateTimeArray: TDateTimeArray): TStrArray; overload;

function AsTranslatedContextValue(const cv: GlueContextValue):
  TGlueContextValue;
function AsTranslatedValue(const gv: GlueValue): PTGlueValue;

function AsGlueContextValueArray(const tgcv: TGlueContextValueArray)
  : GlueContextValueArray; overload;

function AsGlueContextValueArray(const tgcv: array of TGlueContextValue)
  : GlueContextValueArray; overload;

function AsGlueValueArray(tgcv: TGlueValueArray): GlueValueArray; overload;
function AsGlueValue(gv: TGlueValue): GlueValue;

// function CreateSafeArray(vtType: TVarType; items: array of const): PSafeArray; overload;
function CreateArray_SA(const items: TStrArray): PSafeArray; overload;
function CreateArray_SA(const items: TWordBoolArray): PSafeArray; overload;
function CreateArray_SA(const items: TDoubleArray): PSafeArray; overload;
function CreateArray_SA(const items: TInt64Array): PSafeArray; overload;

/// Creates Tuple from GlueValue array - ready to be sent to Glue COM library
function CreateTuple_SA(const GlueValues: GlueValueArray): PSafeArray; overload;

/// Creates Composite from GlueContextValue array - ready to be sent to Glue COM library
function CreateComposite_SA(const GlueContextValues: GlueContextValueArray)
  : PSafeArray; overload;

/// Creates GlueInstance safe array from Glue Instance array - ready to be sent to Glue COM library
function CreateInstanceArray_SA(const GlueInstances: TGlueInstanceArray):
  PSafeArray;

/// Creates Context Values from GlueContextValue array - ready to be sent to Glue COM library
function CreateContextValues_SA(const GlueContextValues: GlueContextValueArray)
  : PSafeArray;

function JoinStrings(const s: array of string; Delimiter: Char = ','): string;

/// Example for traversing Glue Values
procedure TraverseGlueValue(Name: string; const gv: GlueValue; lines: TStrings;
  level: Integer = 0); overload;

procedure TraverseGlueValue(Name: string; const gv: TGlueValue; lines: TStrings;
  level: Integer = 0); overload;

/// Example for traversing Glue Context Values
procedure TraverseGlueContextValuesSafeArray(const sa: PSafeArray; lines:
  TStrings;
  level: Integer = 0; isVariantArray: Boolean = False);

/// Example for traversing array of Glue Context Values
procedure TraverseGlueContextValues(const GlueContextValues:
  GlueContextValueArray;
  lines: TStrings); overload;

procedure TraverseGlueContextValues(const GlueContextValues:
  TGlueContextValueArray;
  lines: TStrings; level: Integer = 0); overload;

const
  UnixEpochStart: TDateTime = 25569.0; // 01/01/1970

  /// Converts Glue time to Delphi date-time
function GlueTimeToDateTime(msecs: Int64): TDateTime;

/// Converts Delphi date-time to Glue Time
function DateTimeToGlueTime(dt: TDateTime): Int64;

implementation

function SafeArrayCreateEx(vt: TVarType; cDims: Integer;
  rgsabound: PSafeArrayBound; pvExtra: Pointer): PSafeArray; stdcall;
  external 'OLEAUT32.DLL';

function SafeArrayCreate(vt: TVarType; cDims: Integer;
  rgsabound: PSafeArrayBound): PSafeArray; stdcall; external 'OLEAUT32.DLL';

function GetRecordInfoFromGuids(const rGuidTypeLib: TGUID; uVerMajor: Cardinal;
  uVerMinor: Cardinal; lcid: lcid; const rGuidTypeInfo: TGUID;
  var ppRecInfo: IRecordInfo): HResult; stdcall; external 'OLEAUT32.DLL';

{ Raw Args construction example }
{ function __CreateSampleArgs: PSafeArray;
  var
  gcv: GlueContextValueArray;
  argsValues: GlueContextValueArray;
  begin
  SetLength(gcv, 2);
  gcv[0].name := 'Volume';

  ZeroMemory(@gcv[0].Value, sizeof(gcv[0].Value));
  gcv[0].Value.GlueType := GlueValueType_Int;
  gcv[0].Value.LongValue := 5512;

  gcv[1].name := 'InstrumentId';

  ZeroMemory(@gcv[1].Value, sizeof(gcv[1].Value));
  gcv[1].Value.GlueType := GlueValueType_String;
  gcv[1].Value.StringValue := CreateClassID;

  SetLength(argsValues, 3);
  argsValues[0].name := 'Price';
  ZeroMemory(@argsValues[0].Value, sizeof(argsValues[0].Value));
  argsValues[0].Value.GlueType := GlueValueType_Double;
  argsValues[0].Value.DoubleValue := 4.4242;

  argsValues[1].name := 'Side';
  ZeroMemory(@argsValues[1].Value, sizeof(argsValues[1].Value));
  argsValues[1].Value.GlueType := GlueValueType_String;
  argsValues[1].Value.StringValue := 'buy';

  argsValues[2].name := 'Instrument';
  ZeroMemory(@argsValues[2].Value, sizeof(argsValues[2].Value));
  argsValues[2].Value.GlueType := GlueValueType_Composite;
  argsValues[2].Value.CompositeValue := CreateComposite_SA(gcv);

  Result := CreateContextValues_SA(argsValues);
  end;
}

function GlueTimeToDateTime(msecs: Int64): TDateTime;
begin
  Result := ((msecs / 1000.0) / 86400.0) + UnixEpochStart;
end;

function DateTimeToGlueTime(dt: TDateTime): Int64;
begin
  Result := Round((dt * 86400.0 * 1000) - UnixEpochStart);
end;

function DateTimeArrayToGlueTimeArray(dta: TDateTimeArray): TInt64Array;
var
  I: Integer;
begin
  SetLength(Result, Length(dta));

  for I := 0 to Length(dta) - 1 do
  begin
    Result[I] := DateTimeToGlueTime(dta[I]);
  end;
end;

function CreateTuple_SA(const GlueValues: GlueValueArray): PSafeArray;
var
  pri: IRecordInfo;
  hr: HResult;
  bounds: array[0..1] of SAFEARRAYBOUND;
  sa: PSafeArray;
  I: Integer;
  vItem: tagVARIANT;
begin
  hr := GetRecordInfoFromGuids(LIBID_GlueCOM, GlueCOMMajorVersion,
    GlueCOMMinorVersion, LOCALE_USER_DEFAULT,
    Tuple__IID, pri);

  if Succeeded(hr) then
  begin
    bounds[0].lLbound := 0;
    bounds[0].cElements := Length(GlueValues);

    sa := SafeArrayCreate(VT_VARIANT, 1, @bounds);

    for I := 0 to Length(GlueValues) - 1 do
    begin
      ZeroMemory(@vItem, sizeof(vItem));
      vItem.vt := VT_RECORD;
      vItem.pRecInfo := Pointer(pri);
      vItem.pvRecord := @GlueValues[I];
      SafeArrayPutElement(sa, I, vItem);
    end;
    Result := sa;
    Exit;
  end;

  Result := nil;
end;

function CreateValue(const Value: string): TGlueValue; overload;
begin
  ZeroMemory(@Result, sizeof(Result));
  Result.StringValue := Value;
  Result.GlueType := GlueValueType_String;
end;

function CreateValue(const Value: Integer): TGlueValue; overload;
begin
  ZeroMemory(@Result, sizeof(Result));
  Result.LongValue := Value;
  Result.GlueType := GlueValueType_Int;
end;

function CreateValue(const Value: Int64): TGlueValue; overload;
begin
  ZeroMemory(@Result, sizeof(Result));
  Result.LongValue := Value;
  Result.GlueType := GlueValueType_Long;
end;

function CreateValue(const Value: Double): TGlueValue; overload;
begin
  ZeroMemory(@Result, sizeof(Result));
  Result.DoubleValue := Value;
  Result.GlueType := GlueValueType_Double;
end;

function CreateValue(const Value: TVarRec): TGlueValue; overload;
begin
  ZeroMemory(@Result, sizeof(Result));

  case Value.VType of
    vtInteger:
      begin
        Result.LongValue := Value.VInteger;
        Result.GlueType := GlueValueType_Int;
      end;
    vtBoolean:
      begin
        Result.BoolValue := Value.VBoolean;
        Result.GlueType := GlueValueType_Bool;
      end;
    vtExtended:
      begin
        Result.DoubleValue := Value.VExtended^;
        Result.GlueType := GlueValueType_Double;
      end;
    vtString:
      begin
        Result.StringValue := Value.VString^;
        Result.GlueType := GlueValueType_String;
      end;
    vtWideString:
      begin
        Result.StringValue := WideString(Value.VWideString^);
        Result.GlueType := GlueValueType_String;
      end;
    vtAnsiString:
      begin
        Result.StringValue := string(Value.VAnsiString);
        Result.GlueType := GlueValueType_String;
      end;
    vtCurrency:
      begin
        Result.DoubleValue := Value.VCurrency^;
        Result.GlueType := GlueValueType_Double;
      end;
  else
    raise Exception.Create('Cannot handle VType=' + IntToStr(Value.VType));
  end;
end;

function CreateValue(const Value: TStrArray): TGlueValue; overload;
begin
  ZeroMemory(@Result, sizeof(Result));
  Result.StringArray := Value;
  Result.GlueType := GlueValueType_String;
  Result.IsArray := true;
end;

function CreateValue(const Value: TInt64Array): TGlueValue; overload;
begin
  ZeroMemory(@Result, sizeof(Result));
  Result.LongArray := Value;
  Result.GlueType := GlueValueType_Long;
  Result.IsArray := true;
end;

function CreateValue(const Value: TDoubleArray): TGlueValue; overload;
begin
  ZeroMemory(@Result, sizeof(Result));
  Result.DoubleArray := Value;
  Result.GlueType := GlueValueType_Double;
  Result.IsArray := true;
end;

function CreateValue(const Value: array of const): TGlueValue; overload;
var
  gva: TGlueValueArray;
  gv: TGlueValue;
  I: Integer;
begin
  ZeroMemory(@Result, sizeof(Result));
  SetLength(gva, High(Value));

  for I := 0 to High(Value) - 1 do
  begin
    gv := CreateValue(Value[I]);
    gva[I] := @gv;
  end;

  Result.Tuple := gva;
  Result.GlueType := GlueValueType_Tuple;
  Result.IsArray := true;
end;

function CreateComposite(const Value: TGlueContextValueArray; IsArray: bool)
  : TGlueValue; overload;
begin
  ZeroMemory(@Result, sizeof(Result));
  Result.GlueType := GlueValueType_Composite;
  Result.CompositeValue := Value;
  Result.IsArray := IsArray;
end;

function CreateComposite(const Value: array of TGlueContextValue; IsArray: bool)
  : TGlueValue; overload;
var
  arr: TGlueContextValueArray;
  I: Integer;
begin
  SetLength(arr, Length(Value));

  for I := Low(Value) to High(Value) do
  begin
    arr[I] := Value[I];
  end;
  Result := CreateComposite(arr, IsArray);
end;

function CreateTuple(const Value: TGlueValueArray): TGlueValue; overload;
begin
  ZeroMemory(@Result, sizeof(Result));
  Result.GlueType := GlueValueType_Tuple;
  Result.Tuple := Value;
  Result.IsArray := true;
end;

function CopyGlueValueArray(const SourceArray: array of TGlueValue)
  : TGlueValueArray;
var
  I: Integer;
begin
  SetLength(Result, Length(SourceArray));
  for I := 0 to Length(SourceArray) - 1 do
  begin
    Result[I] := @SourceArray[I];
  end;
end;

function CreateTuple(const Value: array of TGlueValue): TGlueValue; overload;
var
  arr: TGlueValueArray;
begin
  arr := CopyGlueValueArray(Value);

  Result := CreateTuple(arr);
end;

function CreateContextValue(const Name: string; const Value: TGlueValue)
  : TGlueContextValue; overload;
begin
  ZeroMemory(@Result, sizeof(Result));
  Result.Name := Name;
  Result.Value := @Value;
end;

function CreateComposite_SA(const GlueContextValues: GlueContextValueArray)
  : PSafeArray;
var
  pri: IRecordInfo;
  hr: HResult;
  bounds: array[0..1] of SAFEARRAYBOUND;
  sa: PSafeArray;
  I: Integer;
  vItem: tagVARIANT;
begin
  hr := GetRecordInfoFromGuids(LIBID_GlueCOM, GlueCOMMajorVersion,
    GlueCOMMinorVersion, LOCALE_USER_DEFAULT,
    ContextValue__IID, pri);

  if Succeeded(hr) then
  begin
    bounds[0].lLbound := 0;
    bounds[0].cElements := Length(GlueContextValues);

    sa := SafeArrayCreate(VT_VARIANT, 1, @bounds);

    for I := 0 to Length(GlueContextValues) - 1 do
    begin
      ZeroMemory(@vItem, sizeof(vItem));
      vItem.vt := VT_RECORD;
      vItem.pRecInfo := Pointer(pri);
      vItem.pvRecord := @GlueContextValues[I];
      OleCheck(SafeArrayPutElement(sa, I, vItem));
    end;
    Result := sa;
    Exit;
  end;

  Result := nil;
end;

function CreateInstanceArray_SA(const GlueInstances: TGlueInstanceArray):
  PSafeArray;
var
  pri: IRecordInfo;
  hr: HResult;
  bounds: array[0..1] of SAFEARRAYBOUND;
  sa: PSafeArray;
  I: Integer;
begin
  hr := GetRecordInfoFromGuids(LIBID_GlueCOM, GlueCOMMajorVersion,
    GlueCOMMinorVersion, LOCALE_USER_DEFAULT,
    Instance__IID, pri);

  if Succeeded(hr) then
  begin
    bounds[0].lLbound := 0;
    bounds[0].cElements := Length(GlueInstances);

    sa := SafeArrayCreateEx(VT_RECORD, 1, @bounds, Pointer(pri));

    for I := 0 to Length(GlueInstances) - 1 do
    begin
      SafeArrayPutElement(sa, I, GlueInstances[I]);
    end;
    Result := sa;
    Exit;
  end;

  Result := nil;
end;

function CreateContextValues_SA(const GlueContextValues: GlueContextValueArray)
  : PSafeArray;
var
  pri: IRecordInfo;
  hr: HResult;
  bounds: array[0..1] of SAFEARRAYBOUND;
  sa: PSafeArray;
  I: Integer;
begin
  hr := GetRecordInfoFromGuids(LIBID_GlueCOM, GlueCOMMajorVersion,
    GlueCOMMinorVersion, LOCALE_USER_DEFAULT,
    ContextValue__IID, pri);

  ZeroMemory(@bounds, 0);
  if Succeeded(hr) then
  begin
    bounds[0].lLbound := 0;
    bounds[0].cElements := Length(GlueContextValues);

    sa := SafeArrayCreateEx(VT_RECORD, 1, @bounds, Pointer(pri));

    for I := 0 to Length(GlueContextValues) - 1 do
    begin
      OleCheck(SafeArrayPutElement(sa, I, GlueContextValues[I]));
    end;
    Result := sa;
    Exit;
  end
  else
  begin
    OleCheck(hr);
  end;

  Result := nil;
end;

function JoinStrings(const s: array of string; Delimiter: Char): string;
var
  I, c: Integer;
  p: PChar;
begin
  c := 0;
  for I := Low(s) to High(s) do
    Inc(c, Length(s[I]));
  SetLength(Result, c + High(s));
  p := PChar(Result);
  for I := Low(s) to High(s) do
  begin
    if I > 0 then
    begin
      p^ := Delimiter;
      Inc(p);
    end;
    Move(PChar(s[I])^, p^, sizeof(Char) * Length(s[I]));
    Inc(p, Length(s[I]));
  end;
end;

procedure TraverseGlueValue(Name: string; const gv: GlueValue; lines: TStrings;
  level: Integer); overload;
var
  I: Integer;
  GlueValues: GlueValueArray;
  offset: string;
  valueTypeName: string;
  prefix: string;
begin
  GlueValues := nil;
  offset := StringOfChar(chr(9), level);

  case gv.GlueType of
    GlueValueType_Bool:
      valueTypeName := 'Bool';
    GlueValueType_Int:
      valueTypeName := 'Int';
    GlueValueType_Double:
      valueTypeName := 'Double';
    GlueValueType_Long:
      valueTypeName := 'Long';
    GlueValueType_String:
      valueTypeName := 'String';
    GlueValueType_DateTime:
      valueTypeName := 'DateTime';
    GlueValueType_Tuple:
      valueTypeName := 'Tuple';
    GlueValueType_Composite:
      valueTypeName := 'Composite';
  end;

  if (gv.IsArray) then
  begin
    prefix := offset + '(' + valueTypeName + '[])' + name + ' = ';
    case gv.GlueType of
      GlueValueType_String:
        begin
          lines.Add(JoinStrings(SA_AsStringArray(gv.StringArray), ','));
        end;
      GlueValueType_Bool:
        begin
          // TODO: join and add in lines
          SA_AsWordBoolArray(gv.BoolArray);
        end;
      GlueValueType_Int:
        begin
          SA_AsInt64Array(gv.LongArray);
        end;
      GlueValueType_Long:
        begin
          SA_AsInt64Array(gv.LongArray);
        end;
      GlueValueType_Double:
        begin
          SA_AsDoubleArray(gv.DoubleArray);
        end;
      GlueValueType_DateTime:
        begin
        end;
      GlueValueType_Tuple:
        begin
          lines.Add(prefix);
          if gv.Tuple = nil then
          begin
            lines.Add('NIL');
            Exit;
          end;
          GlueValues := SA_AsGlueValueArray(gv.Tuple);
          for I := 0 to Length(GlueValues) - 1 do
          begin
            TraverseGlueValue('Tuple', GlueValues[I], lines, level + 1);
          end;
        end;
      GlueValueType_Composite:
        begin
          lines.Add(prefix);
          TraverseGlueContextValuesSafeArray(gv.CompositeValue, lines,
            level + 1, True);
        end;
    end;
  end
  else
  begin
    prefix := offset + '(' + valueTypeName + ')' + name + ' = ';
    case gv.GlueType of
      GlueValueType_Bool:
        lines.Add(prefix + BoolToStr(gv.BoolValue));
      GlueValueType_String:
        lines.Add(prefix + gv.StringValue);
      GlueValueType_Int:
        lines.Add(prefix + IntToStr(gv.LongValue));
      GlueValueType_Long:
        lines.Add(prefix + IntToStr(gv.LongValue));
      GlueValueType_Double:
        lines.Add(prefix + FloatToStr(gv.DoubleValue));
      GlueValueType_Composite:
        begin
          lines.Add(prefix);
          TraverseGlueContextValuesSafeArray(gv.CompositeValue, lines,
            level + 1, True);
        end;
    end;
  end;
end;

procedure TraverseGlueValue(Name: string; const gv: TGlueValue; lines: TStrings;
  level: Integer = 0); overload;
var
  I: Integer;
  GlueValues: TGlueValueArray;
  offset: string;
  valueTypeName: string;
  prefix: string;
begin
  GlueValues := nil;
  offset := StringOfChar(chr(9), level);

  case gv.GlueType of
    GlueValueType_Bool:
      valueTypeName := 'Bool';
    GlueValueType_Int:
      valueTypeName := 'Int';
    GlueValueType_Double:
      valueTypeName := 'Double';
    GlueValueType_Long:
      valueTypeName := 'Long';
    GlueValueType_String:
      valueTypeName := 'String';
    GlueValueType_DateTime:
      valueTypeName := 'DateTime';
    GlueValueType_Tuple:
      valueTypeName := 'Tuple';
    GlueValueType_Composite:
      valueTypeName := 'Composite';
  end;

  if (gv.IsArray) then
  begin
    prefix := offset + '(' + valueTypeName + '[])' + name + ' = ';
    case gv.GlueType of
      GlueValueType_String:
        begin
          lines.Add(JoinStrings(gv.StringArray, ','));
        end;
      GlueValueType_Bool:
        begin
          // TODO: join and add in lines
          // gv.BoolArray;
        end;
      GlueValueType_Int:
        begin
          // gv.LongArray;
        end;
      GlueValueType_Long:
        begin
          // gv.LongArray;
        end;
      GlueValueType_Double:
        begin
          // gv.DoubleArray;
        end;
      GlueValueType_DateTime:
        begin
        end;
      GlueValueType_Tuple:
        begin
          lines.Add(prefix);
          if gv.Tuple = nil then
          begin
            lines.Add('NIL');
            Exit;
          end;
          GlueValues := gv.Tuple;
          for I := 0 to Length(GlueValues) - 1 do
          begin
            TraverseGlueValue('Tuple', GlueValues[I]^, lines, level + 1);
          end;
        end;
      GlueValueType_Composite:
        begin
          lines.Add(prefix);
          TraverseGlueContextValues(gv.CompositeValue, lines, level + 1);
        end;
    end;
  end
  else
  begin
    prefix := offset + '(' + valueTypeName + ')' + name + ' = ';
    case gv.GlueType of
      GlueValueType_Bool:
        lines.Add(prefix + BoolToStr(gv.BoolValue));
      GlueValueType_String:
        lines.Add(prefix + gv.StringValue);
      GlueValueType_Int:
        lines.Add(prefix + IntToStr(gv.LongValue));
      GlueValueType_Long:
        lines.Add(prefix + IntToStr(gv.LongValue));
      GlueValueType_Double:
        lines.Add(prefix + FloatToStr(gv.DoubleValue));
      GlueValueType_Composite:
        begin
          lines.Add(prefix);
          TraverseGlueContextValues(gv.CompositeValue, lines, level + 1);
        end;
    end;
  end;
end;

procedure TraverseGlueContextValues(const GlueContextValues:
  GlueContextValueArray;
  lines: TStrings); overload;
var
  I: Integer;
begin
  for I := 0 to Length(GlueContextValues) - 1 do
  begin
    TraverseGlueValue(GlueContextValues[I].Name,
      GlueContextValues[I].Value, lines);
  end;
end;

procedure TraverseGlueContextValues(const GlueContextValues:
  TGlueContextValueArray;
  lines: TStrings; level: Integer = 0); overload;
var
  I: Integer;
begin
  for I := 0 to Length(GlueContextValues) - 1 do
  begin
    TraverseGlueValue(GlueContextValues[I].Name, GlueContextValues[I].Value^,
      lines, level);
  end;
end;

procedure TraverseGlueContextValuesSafeArray(const sa: PSafeArray; lines:
  TStrings;
  level: Integer = 0;
  isVariantArray: Boolean = False);
var
  pGCVs: PGlueContextValue;
  pv: PVOID;
  I, iLow, iHigh: Integer;
  pVar: PVariant;
  vt: TVarType;
  gcv: GlueContextValue;
  offset: string;
  gv: GlueValue;
begin
  offset := StringOfChar(chr(9), level);
  SafeArrayAccessData(sa, pv);
  pGCVs := pv;
  pVar := pv;

  SafeArrayGetLBound(sa, 1, iLow);
  SafeArrayGetUBound(sa, 1, iHigh);

  for I := iLow to iHigh do
  begin
    if isVariantArray then
    begin
      vt := varType(pVar^);
      Assert(vt = VT_RECORD);
      gcv := PGlueContextValue(TVarData(pVar^).VRecord.PRecord)^;
    end
    else
    begin
      gcv := pGCVs^;
    end;

    gv := gcv.Value;

    TraverseGlueValue(gcv.Name, gv, lines, level);

    Inc(pGCVs);
    Inc(pVar);
  end;
  SafeArrayUnaccessData(sa);
end;

constructor TGlueResultHandler.Create(Cookie: TCallbackCookie;
  handlerLambda: TResultHandlerLambda);
begin
  FCookie := Cookie;
  FHandlerLambda := handlerLambda;
end;

function TGlueResultHandler.HandleResult(invocationResult: PSafeArray;
  const correlationId: WideString): HResult; stdcall;
var
  results: PGlueInvocationResult;
  cur: GlueInvocationResult;
  pv: PVOID;
  I, iLow, iHigh: Integer;
  glueResults: TGlueInvocationResultArray;
begin
  OleCheck(SafeArrayAccessData(invocationResult, pv));
  results := pv;

  OleCheck(SafeArrayGetLBound(invocationResult, 1, iLow));
  OleCheck(SafeArrayGetUBound(invocationResult, 1, iHigh));

  SetLength(glueResults, iHigh - iLow + 1);

  for I := iLow to iHigh do
  begin
    cur := results^;
    glueResults[I] := cur;
    Inc(results);
  end;

  SafeArrayUnaccessData(invocationResult);

  FHandlerLambda(Self, glueResults, FCookie, correlationId);
  Result := S_OK;
end;

{ TGlueStreamHandler }

constructor TGlueStreamHandler.Create(dataLambda: TStreamDataLambda);
begin
  FDataLambda := dataLambda;
end;

function TGlueStreamHandler.HandleStreamData(stream: GlueMethod;
  data: PSafeArray): HResult;
begin
  FDataLambda(stream, SA_AsGlueContextValueArray(data), data);
  Result := S_OK;
end;

function TGlueStreamHandler.HandleStreamStatus(stream: GlueMethod;
  State: GlueStreamState; const Message: WideString; dateTime: Int64): HResult;
begin
  Result := S_OK;
end;

function TGlueStreamHandler.StreamClosed(stream: GlueMethod): HResult;
begin
  Result := S_OK;
end;

function TGlueStreamHandler.StreamOpened(stream: GlueMethod;
  const glueStreamSubscription: IGlueStreamSubscription): HResult;
begin
  Result := S_OK;
end;

function SA_AsInt64Array(sa: PSafeArray): TInt64Array;
var
  pws: PInt64;
  pv: PVOID;
  I, iLow, iHigh: Integer;
begin
  SafeArrayAccessData(sa, pv);
  pws := pv;
  SafeArrayGetLBound(sa, 1, iLow);
  SafeArrayGetUBound(sa, 1, iHigh);

  SetLength(Result, iHigh - iLow + 1);
  for I := 0 to iHigh - iLow do
  begin
    Result[I] := pws^;
    Inc(pws);
  end;

  SafeArrayUnaccessData(sa);
end;

function SA_AsDateTimeArray(sa: PSafeArray): TDateTimeArray;
var
  pws: PInt64;
  pv: PVOID;
  I, iLow, iHigh: Integer;
begin
  SafeArrayAccessData(sa, pv);
  pws := pv;
  SafeArrayGetLBound(sa, 1, iLow);
  SafeArrayGetUBound(sa, 1, iHigh);

  SetLength(Result, iHigh - iLow + 1);
  for I := 0 to iHigh - iLow do
  begin
    Result[I] := GlueTimeToDateTime(pws^);
    Inc(pws);
  end;

  SafeArrayUnaccessData(sa);
end;

function SA_AsDoubleArray(sa: PSafeArray): TDoubleArray;
var
  pws: PDouble;
  pv: PVOID;
  I, iLow, iHigh: Integer;
begin
  SafeArrayAccessData(sa, pv);
  pws := pv;
  SafeArrayGetLBound(sa, 1, iLow);
  SafeArrayGetUBound(sa, 1, iHigh);

  SetLength(Result, iHigh - iLow + 1);
  for I := 0 to iHigh - iLow do
  begin
    Result[I] := pws^;
    Inc(pws);
  end;

  SafeArrayUnaccessData(sa);
end;

function SA_AsWordBoolArray(sa: PSafeArray): TWordBoolArray;
var
  pws: PWordBool;
  pv: PVOID;
  I, iLow, iHigh: Integer;
begin
  SafeArrayAccessData(sa, pv);
  pws := pv;
  SafeArrayGetLBound(sa, 1, iLow);
  SafeArrayGetUBound(sa, 1, iHigh);

  SetLength(Result, iHigh - iLow + 1);
  for I := 0 to iHigh - iLow do
  begin
    Result[I] := pws^;
    Inc(pws);
  end;

  SafeArrayUnaccessData(sa);
end;

function SA_AsStringArray(sa: PSafeArray): TStrArray;
var
  pws: PWideString;
  pv: PVOID;
  I, iLow, iHigh: Integer;
begin
  SafeArrayAccessData(sa, pv);
  pws := pv;
  SafeArrayGetLBound(sa, 1, iLow);
  SafeArrayGetUBound(sa, 1, iHigh);

  SetLength(Result, iHigh - iLow + 1);
  for I := 0 to iHigh - iLow do
  begin
    Result[I] := pws^;
    Inc(pws);
  end;

  SafeArrayUnaccessData(sa);
end;

function SA_AsGlueMethodArray(sa: PSafeArray): TGlueMethodArray;
var
  pws: PGlueMethod;
  pv: PVOID;
  I, iLow, iHigh: Integer;
  cur: GlueMethod;
begin
  SafeArrayAccessData(sa, pv);
  pws := pv;
  // pVar := pv;
  OleCheck(SafeArrayGetLBound(sa, 1, iLow));
  OleCheck(SafeArrayGetUBound(sa, 1, iHigh));

  // vt := varType(pVar^);

  SetLength(Result, iHigh - iLow + 1);
  for I := 0 to iHigh - iLow do
  begin
    // tv := TVarData(pVar^);
    // vt := tv.VType;
    cur := pws^;
    Result[I] := cur;
    Inc(pws);
  end;

  SafeArrayUnaccessData(sa);
end;

function SA_AsGlueContextValueArray(sa: PSafeArray; isVariantArray: Boolean = false): GlueContextValueArray;
var
  pv: PVOID;
  I, iLow, iHigh: Integer;
  pVar: PVariant;
  vt: TVarType;
  gcv: GlueContextValue;
  pGCVs: PGlueContextValue;
begin
  SafeArrayAccessData(sa, pv);
  pGCVs := pv;
  pVar := pv;

  SafeArrayGetLBound(sa, 1, iLow);
  SafeArrayGetUBound(sa, 1, iHigh);

  SetLength(Result, iHigh - iLow + 1);

  for I := iLow to iHigh do
  begin
    if isVariantArray then
    begin
      vt := varType(pVar^);
      Assert(vt = VT_RECORD);
      gcv := PGlueContextValue(TVarData(pVar^).VRecord.PRecord)^;
    end
    else
    begin
      gcv := pGCVs^;
    end;

    Result[I] := gcv;

    Inc(pGCVs);
    Inc(pVar);
  end;

  SafeArrayUnaccessData(sa);
end;

function SA_AsGlueValueArray(sa: PSafeArray): GlueValueArray;
var
  pv: PVOID;
  pVar: PVariant;
  I, iLow, iHigh: Integer;
begin
  if sa = nil then
  begin
    Result := nil;
    Exit;
  end;

  SafeArrayAccessData(sa, pv);
  pVar := pv;

  SafeArrayGetLBound(sa, 1, iLow);
  SafeArrayGetUBound(sa, 1, iHigh);

  SetLength(Result, iHigh - iLow + 1);

  for I := iLow to iHigh do
  begin
    Result[I] := PGlueValue(TVarData(pVar^).VRecord.PRecord)^;
    Inc(pVar);
  end;
  SafeArrayUnaccessData(sa);
end;

function AsStringArray(BoolArray: TWordBoolArray): TStrArray;
var
  I: Integer;
begin
  SetLength(Result, Length(BoolArray));
  for I := 0 to Length(BoolArray) - 1 do
  begin
    Result[I] := BoolToStr(BoolArray[I]);
  end;
end;

function AsStringArray(int64Array: TInt64Array): TStrArray;
var
  I: Integer;
begin
  SetLength(Result, Length(int64Array));
  for I := 0 to Length(int64Array) - 1 do
  begin
    Result[I] := IntToStr(int64Array[I]);
  end;
end;

function AsStringArray(DoubleArray: TDoubleArray): TStrArray;
var
  I: Integer;
begin
  SetLength(Result, Length(DoubleArray));
  for I := 0 to Length(DoubleArray) - 1 do
  begin
    Result[I] := FloatToStr(DoubleArray[I]);
  end;
end;

function AsStringArray(DateTimeArray: TDateTimeArray): TStrArray; overload;
var
  I: Integer;
begin
  SetLength(Result, Length(DateTimeArray));
  for I := 0 to Length(DateTimeArray) - 1 do
  begin
    Result[I] := DateTimeToStr(DateTimeArray[I]);
  end;
end;

function AsGlueValueArray(tgcv: TGlueValueArray): GlueValueArray;
var
  I: Integer;
begin
  SetLength(Result, Length(tgcv));
  for I := 0 to Length(tgcv) - 1 do
  begin
    Result[I] := AsGlueValue(tgcv[I]^);
  end;
end;

function CreateArray_SA(const items: TStrArray): PSafeArray;
var
  bounds: array[0..1] of SAFEARRAYBOUND;
  I: Integer;
  ws: WideString;
  pwc: PWideChar;
  bstr: TBStr;
begin
  bounds[0].lLbound := 0;
  bounds[0].cElements := Length(items);

  Result := SafeArrayCreate(VT_BSTR, 1, @bounds);

  for I := 0 to Length(items) - 1 do
  begin
    // StringToWideChar(items[I], pwc, Length(items[I]) + 1);
    ws := items[I];
    pwc := Addr(ws[1]);
    bstr := SysAllocString(pwc);
    OleCheck(SafeArrayPutElement(Result, I, bstr^));
    SysFreeString(bstr);
  end;
end;

function CreateArray_SA(const items: TWordBoolArray): PSafeArray;
var
  bounds: array[0..1] of SAFEARRAYBOUND;
  I: Integer;
begin
  bounds[0].lLbound := 0;
  bounds[0].cElements := Length(items);

  Result := SafeArrayCreate(VT_BOOL, 1, @bounds);

  for I := 0 to Length(items) - 1 do
  begin
    SafeArrayPutElement(Result, I, items[I]);
  end;
end;

function CreateArray_SA(const items: TDoubleArray): PSafeArray;
var
  bounds: array[0..1] of SAFEARRAYBOUND;
  I: Integer;
begin
  bounds[0].lLbound := 0;
  bounds[0].cElements := Length(items);

  Result := SafeArrayCreate(VT_R8, 1, @bounds);

  for I := 0 to Length(items) - 1 do
  begin
    SafeArrayPutElement(Result, I, items[I]);
  end;
end;

function CreateArray_SA(const items: TInt64Array): PSafeArray;
var
  bounds: array[0..1] of SAFEARRAYBOUND;
  I: Integer;
begin
  bounds[0].lLbound := 0;
  bounds[0].cElements := Length(items);

  Result := SafeArrayCreate(VT_I8, 1, @bounds);

  for I := 0 to Length(items) - 1 do
  begin
    SafeArrayPutElement(Result, I, items[I]);
  end;
end;

function AsGlueValue(gv: TGlueValue): GlueValue;
begin
  ZeroMemory(@Result, sizeof(Result));
  Result.GlueType := gv.GlueType;
  Result.IsArray := gv.IsArray;

  if gv.GlueType = GlueValueType_Composite then
  begin
    Result.CompositeValue := CreateComposite_SA
      (AsGlueContextValueArray(gv.CompositeValue));
    Exit;
  end;

  if gv.IsArray then
  begin
    if gv.GlueType = GlueValueType_Tuple then
    begin
      Result.Tuple := CreateTuple_SA(AsGlueValueArray(gv.Tuple));
    end
    else
    begin
      case gv.GlueType of
        GlueValueType_String:
          Result.StringArray := CreateArray_SA(gv.StringArray);
        GlueValueType_Bool:
          Result.BoolArray := CreateArray_SA(gv.BoolArray);
        GlueValueType_Int:
          Result.LongArray := CreateArray_SA(gv.LongArray);
        GlueValueType_Long:
          Result.LongArray := CreateArray_SA(gv.LongArray);
        GlueValueType_Double:
          Result.DoubleArray := CreateArray_SA(gv.DoubleArray);
        GlueValueType_DateTime:
          Result.LongArray :=
            CreateArray_SA(DateTimeArrayToGlueTimeArray(gv.DateTimeArray));
      end;
    end;
  end
  else
  begin
    case gv.GlueType of
      GlueValueType_String:
        Result.StringValue := gv.StringValue;
      GlueValueType_Bool:
        Result.BoolValue := gv.BoolValue;
      GlueValueType_Int:
        Result.LongValue := gv.LongValue;
      GlueValueType_Long:
        Result.LongValue := gv.LongValue;
      GlueValueType_Double:
        Result.DoubleValue := gv.DoubleValue;
      GlueValueType_DateTime:
        Result.LongValue := DateTimeToGlueTime(gv.DateTimeValue);
    end;
  end;

end;

function AsGlueContextValueArray(const tgcv: TGlueContextValueArray)
  : GlueContextValueArray; overload;
var
  I: Integer;
  gv: TGlueValue;
begin
  SetLength(Result, Length(tgcv));

  for I := 0 to Length(tgcv) - 1 do
  begin
    Result[I].Name := tgcv[I].Name;
    ZeroMemory(@Result[I].Value, sizeof(Result[I].Value));
    if not Assigned(tgcv[I].Value) then
    begin
      raise Exception.Create('Value at index ' + IntToStr(I) +
        ' is null. Name is ' + tgcv[I].Name);
    end;
    gv := tgcv[I].Value^;
    Result[I].Value := AsGlueValue(gv);
  end;
end;

function AsGlueContextValueArray(const tgcv: array of TGlueContextValue)
  : GlueContextValueArray; overload;
var
  I: Integer;
  gv: TGlueValue;
begin
  SetLength(Result, Length(tgcv));

  for I := 0 to Length(tgcv) - 1 do
  begin
    Result[I].Name := tgcv[I].Name;
    ZeroMemory(@Result[I].Value, sizeof(Result[I].Value));
    gv := tgcv[I].Value^;
    Result[I].Value := AsGlueValue(gv);
  end;
end;

function SA_AsTranslatedContextValues(sa: PSafeArray): TGlueContextValueArray;
var
  gcva: GlueContextValueArray;
  I: Integer;
begin
  gcva := SA_AsGlueContextValueArray(sa);

  SetLength(Result, Length(gcva));

  for I := 0 to Length(gcva) - 1 do
  begin
    Result[I] := AsTranslatedContextValue(gcva[I]);
  end;
end;

function AsTranslatedValue(const gv: GlueValue): PTGlueValue;
var
  composite: GlueContextValueArray;
  Tuple: GlueValueArray;
  I: Integer;
  translatedTuple: TGlueValueArray;
  translatedComposite: TGlueContextValueArray;
  ptgv: PTGlueValue;
begin
  Tuple := nil;
  composite := nil;

  New(Result);
  ZeroMemory(Result, sizeof(Result^));

  Result^.GlueType := gv.GlueType;
  Result^.IsArray := gv.IsArray;

  if gv.GlueType = GlueValueType_Composite then
  begin
    composite := SA_AsGlueContextValueArray(gv.CompositeValue, True);
    SetLength(translatedComposite, Length(composite));
    for I := 0 to Length(composite) - 1 do
    begin
      translatedComposite[I] := AsTranslatedContextValue(composite[I]);
    end;
    Result^.CompositeValue := translatedComposite;
    Exit;
  end;

  if gv.IsArray then
  begin
    if gv.GlueType = GlueValueType_Tuple then
    begin
      Tuple := SA_AsGlueValueArray(gv.Tuple);
      SetLength(translatedTuple, Length(Tuple));
      for I := 0 to Length(Tuple) - 1 do
      begin
        ptgv := AsTranslatedValue(Tuple[I]);
        translatedTuple[I] := ptgv;
      end;
      Result^.Tuple := translatedTuple;
    end
    else
    begin
      case gv.GlueType of
        GlueValueType_String:
          Result^.StringArray := SA_AsStringArray(gv.StringArray);
        GlueValueType_Bool:
          Result^.BoolArray := SA_AsWordBoolArray(gv.BoolArray);
        GlueValueType_Int:
          Result^.LongArray := SA_AsInt64Array(gv.LongArray);
        GlueValueType_Long:
          Result^.LongArray := SA_AsInt64Array(gv.LongArray);
        GlueValueType_Double:
          Result^.DoubleArray := SA_AsDoubleArray(gv.DoubleArray);
        GlueValueType_DateTime:
          Result^.DateTimeArray := SA_AsDateTimeArray(gv.LongArray);
      end;
    end;
  end
  else
  begin
    case gv.GlueType of
      GlueValueType_String:
        Result^.StringValue := gv.StringValue;
      GlueValueType_Bool:
        Result^.BoolValue := gv.BoolValue;
      GlueValueType_Int:
        Result^.LongValue := gv.LongValue;
      GlueValueType_Long:
        Result^.LongValue := gv.LongValue;
      GlueValueType_Double:
        Result^.DoubleValue := gv.DoubleValue;
      GlueValueType_DateTime:
        Result^.DateTimeValue := GlueTimeToDateTime(gv.LongValue);
    end;
  end;
end;

function AsTranslatedContextValue(const cv: GlueContextValue):
  TGlueContextValue;
var
  ptgv: PTGlueValue;
begin
  ZeroMemory(@Result, sizeof(Result));
  Result.Name := cv.Name;
  ptgv := AsTranslatedValue(cv.Value);
  Result.Value := ptgv;
end;

function TGlueStreamHandler.SubscriptionActivated(
  const GlueStreamSubscription: IGlueStreamSubscription): HResult;
begin
  Result := S_OK;
end;

{ TGlueContextHandler }

constructor TGlueContextHandler.Create(removedLambda: TContextRemovedLambda;
  addedLambda, updatedLambda: TContextDataLambda);
begin
  fAddedLambda := addedLambda;
  fRemovedLambda := removedLambda;
  fUpdatedLambda := updatedLambda;
end;

function TGlueContextHandler.HandleContext(const context: IGlueContext)
  : HResult;
begin
  if Assigned(fUpdatedLambda) then
  begin
    fUpdatedLambda(context, SA_AsGlueContextValueArray(context.GetData));
  end;

  Result := S_OK;
end;

function TGlueContextHandler.HandleContextUpdate(const contextUpdate
  : IGlueContextUpdate): HResult;
var
  context: IGlueContext;
  added: PSafeArray;
begin
  if Assigned(fRemovedLambda) then
  begin
    fRemovedLambda(contextUpdate.GetContext,
      SA_AsStringArray(contextUpdate.GetRemoved));
  end;

  if Assigned(fAddedLambda) then
  begin
    context := contextUpdate.GetContext;
    added := contextUpdate.GetAdded;
    fAddedLambda(context, SA_AsGlueContextValueArray(added));
  end;

  if Assigned(fUpdatedLambda) then
  begin
    fUpdatedLambda(contextUpdate.GetContext,
      SA_AsGlueContextValueArray(contextUpdate.GetUpdated));
  end;

  Result := S_OK;
end;

{ TGlueRequestHandler }

constructor TGlueRequestHandler.Create(Cookie: TCallbackCookie;
  handlerLambda: TRequestHandlerLambda);
begin
  FCookie := Cookie;
  FHandlerLambda := handlerLambda;
end;

function TGlueRequestHandler.HandleInvocationRequest(Method: GlueMethod;
  caller: GlueInstance; requestValues: PSafeArray;
  const resultCallback: IGlueServerMethodResultCallback): HResult;
begin
  FHandlerLambda(Self, Method, caller,
    SA_AsGlueContextValueArray(requestValues), resultCallback, FCookie,
    requestValues);

  Result := S_OK;
end;

{ TGlueContextBuilderCallback }

function TGlueContextBuilderCallback.Build(const builder
  : IGlueContextBuilder): HResult;
begin
  FContextBuilderLambda(Self, builder, FCookie);
  Result := S_OK;
end;

constructor TGlueContextBuilderCallback.Create(Cookie: TCallbackCookie;
  builder: TContextBuilderLambda);
begin
  FCookie := Cookie;
  FContextBuilderLambda := builder;
end;

end.
