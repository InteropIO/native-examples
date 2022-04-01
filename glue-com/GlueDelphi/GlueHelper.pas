/// Glue42 Helper Unit
/// Exposes helper utilities for consuming Glue42 COM library.
/// - Lambda implementations for different Glue42 callback interfaces.
/// - Packing/unpacking Context Value arguments in Safe Arrays
/// - Converting from Glue Time to DateTime and vice-versa

unit GlueHelper;

interface

uses
  System.SysUtils, System.Variants, System.Classes, GlueCOM_TLB, Winapi.ActiveX,
  ComObj;

type

  PGlueContextValue = ^GlueContextValue;
  PGlueMethod = ^GlueMethod;
  PGlueValue = ^GlueValue;
  PGlueResult = ^GlueResult;
  PGlueInvocationResult = ^GlueInvocationResult;
  TGlueInvocationResultArray = array of GlueInvocationResult;
  TGlueInstanceArray = array of GlueInstance;

  /// Lambda implementation for handling an invocation result
  TGlueResultHandler = class(TInterfacedObject, IGlueInvocationResultHandler)
  private
    FHandlerLambda: TProc<TGlueInvocationResultArray, string>;
  protected
    function HandleResult(invocationResult: PSafeArray; const correlationId: WideString): HResult; stdcall;
  public
    constructor Create(handlerLambda: TProc<TGlueInvocationResultArray, string>);
  end;

  /// Lambda implementation for handling an invocation request
  TGlueRequestHandler = class(TInterfacedObject, IGlueRequestHandler)
  private
    FHandlerLambda: TProc<GlueMethod, GlueInstance, TArray<GlueContextValue>,
      IGlueServerMethodResultCallback>;
  protected
    function HandleInvocationRequest(Method: GlueMethod; caller: GlueInstance;
      requestValues: PSafeArray;
      const resultCallback: IGlueServerMethodResultCallback): HResult; stdcall;
  public
    constructor Create(handlerLambda: TProc<GlueMethod, GlueInstance,
      TArray<GlueContextValue>, IGlueServerMethodResultCallback>);
  end;

  // Lambda implementation for handling Glue stream data - subscription side
  TGlueStreamHandler = class(TInterfacedObject, IGlueStreamHandler)
  private
    FDataLambda: TProc<GlueMethod, TArray<GlueContextValue>, PSafeArray>;
  protected
    function StreamOpened(stream: GlueMethod;
      const glueStreamSubscription: IGlueStreamSubscription): HResult; stdcall;
    function HandleStreamData(stream: GlueMethod; data: PSafeArray)
      : HResult; stdcall;
    function HandleStreamStatus(stream: GlueMethod; State: GlueStreamState;
      const Message: WideString; dateTime: Int64): HResult; stdcall;
    function StreamClosed(stream: GlueMethod): HResult; stdcall;
  public
    constructor Create(dataLambda: TProc<GlueMethod, TArray<GlueContextValue>,
      PSafeArray>);
  end;

  /// Lambda implementation for handling Glue contexts
  TGlueContextHandler = class(TInterfacedObject, IGlueContextHandler)
  private
    fRemovedLambda: TProc<IGlueContext, TArray<string>>;
    fAddedLambda: TProc<IGlueContext, TArray<GlueContextValue>>;
    fUpdatedLambda: TProc<IGlueContext, TArray<GlueContextValue>>;
  protected
    function HandleContext(const context: IGlueContext): HResult; stdcall;
    function HandleContextUpdate(const contextUpdate: IGlueContextUpdate)
      : HResult; stdcall;
  public
    constructor Create(removedLambda: TProc<IGlueContext, TArray<string>>;
      addedLambda: TProc<IGlueContext, TArray<GlueContextValue>>;
      updatedLambda: TProc < IGlueContext, TArray < GlueContextValue >> );
  end;

  /// Helper to expand/unpack SafeArray to another Type with converter
  TSafeArrayExpander<T, TA> = class
  type
    PT = ^T;
  public
    class function AsArray(sa: PSafeArray; converter: TFunc<T, TA>): TArray<TA>;
  end;

  /// Helper to expand/unpack SafeArray to another Type
  TSafeArrayExpander<T> = class(TSafeArrayExpander<T, T>)
  public
    class function AsArray(sa: PSafeArray): TArray<T>;

    class function AsPackedArray(sa: PSafeArray): TArray<T>;
  end;

  /// Creates Tuple from GlueValue array - ready to be sent to Glue COM library
function CreateTuple(GlueValues: TArray<GlueValue>): PSafeArray;

/// Creates Composite from GlueContextValue array - ready to be sent to Glue COM library
function CreateComposite(GlueContextValues: TArray<GlueContextValue>)
  : PSafeArray;

/// Creates GlueInstance safe array from Glue Instance array - ready to be sent to Glue COM library
function CreateGlueInstanceArray(GlueInstances: TGlueInstanceArray): PSafeArray;

/// Creates Context Values from GlueContextValue array - ready to be sent to Glue COM library
function CreateContextValues(GlueContextValues: TArray<GlueContextValue>)
  : PSafeArray;

/// Example for traversing Glue Values
procedure TraverseGlueValue(name: string; gv: GlueValue; lines: TStrings;
  level: Integer = 0);

/// Example for traversing Glue Context Values
procedure TraverseGlueContextValuesSafeArray(sa: PSafeArray; lines: TStrings;
  level: Integer = 0);

/// Example for traversing array of Glue Context Values
procedure TraverseGlueContextValues(GlueContextValues: TArray<GlueContextValue>;
  lines: TStrings);

const
  UnixEpochStart: TDateTime = 25569.0; // 01/01/1970

  /// Converts Glue time to Delphi date-time
function GlueTimeToDateTime(msecs: Int64): TDateTime;

/// Converts Delphi date-time to Glue Time
function DateTimeToGlueTime(dt: TDateTime): Int64;

implementation

uses
  Winapi.Windows;

function GlueTimeToDateTime(msecs: Int64): TDateTime;
begin
  Result := TDateTime(((msecs / 1000) / 86400.0) + UnixEpochStart);
end;

function DateTimeToGlueTime(dt: TDateTime): Int64;
begin
  Result := Round((dt * 86400.0 * 1000) - UnixEpochStart);
end;

function CreateTuple(GlueValues: TArray<GlueValue>): PSafeArray;
var
  pri: IRecordInfo;
  hr: HResult;
  bounds: array [0 .. 1] of SAFEARRAYBOUND;
  sa: PSafeArray;
  I: Integer;
  vItem: tagVARIANT;
begin
  hr := GetRecordInfoFromGuids(LIBID_GlueCOM, GlueCOMMajorVersion, GlueCOMMinorVersion, LOCALE_USER_DEFAULT,
    StringToGUID('{93da746a-fb5d-45c4-96fb-8d7f3ca43960}'), pri);

  if Succeeded(hr) then
  begin
    bounds[0].lLbound := 0;
    bounds[0].cElements := Length(GlueValues);

    sa := SafeArrayCreate(VT_VARIANT, 1, @bounds);

    for I := 0 to Length(GlueValues) - 1 do
    begin
      ZeroMemory(@vItem, sizeof(vItem));
      vItem.vt := VT_RECORD;
      vItem.pRecInfo := pri;
      vItem.pvRecord := @GlueValues[I];
      SafeArrayPutElement(sa, I, vItem);
    end;
    Exit(sa);
  end;

  Result := nil;
end;

function CreateComposite(GlueContextValues: TArray<GlueContextValue>)
  : PSafeArray;
var
  pri: IRecordInfo;
  hr: HResult;
  bounds: array [0 .. 1] of SAFEARRAYBOUND;
  sa: PSafeArray;
  I: Integer;
  vItem: tagVARIANT;
begin
  hr := GetRecordInfoFromGuids(LIBID_GlueCOM, GlueCOMMajorVersion, GlueCOMMinorVersion, LOCALE_USER_DEFAULT,
    StringToGUID('{c74dd3d8-08a3-4b68-a41e-af04acd319bd}'), pri);

  if Succeeded(hr) then
  begin
    bounds[0].lLbound := 0;
    bounds[0].cElements := Length(GlueContextValues);

    sa := SafeArrayCreate(VT_VARIANT, 1, @bounds);

    for I := 0 to Length(GlueContextValues) - 1 do
    begin
      ZeroMemory(@vItem, sizeof(vItem));
      vItem.vt := VT_RECORD;
      vItem.pRecInfo := pri;
      vItem.pvRecord := @GlueContextValues[I];
      SafeArrayPutElement(sa, I, vItem);
    end;
    Exit(sa);
  end;

  Result := nil;
end;

function CreateGlueInstanceArray(GlueInstances: TGlueInstanceArray): PSafeArray;
var
  pri: IRecordInfo;
  hr: HResult;
  bounds: array [0 .. 1] of SAFEARRAYBOUND;
  sa: PSafeArray;
  I: Integer;
begin
  hr := GetRecordInfoFromGuids(LIBID_GlueCOM, GlueCOMMajorVersion, GlueCOMMinorVersion, LOCALE_USER_DEFAULT,
    StringToGUID('{12E47256-B411-4024-BA5C-13DF4C78C31D}'), pri);

  if Succeeded(hr) then
  begin
    bounds[0].lLbound := 0;
    bounds[0].cElements := Length(GlueInstances);

    sa := SafeArrayCreateEx(VT_RECORD, 1, @bounds, pri);

    for I := 0 to Length(GlueInstances) - 1 do
    begin
      SafeArrayPutElement(sa, I, GlueInstances[I]);
    end;
    Exit(sa);
  end;

  Result := nil;
end;

function CreateContextValues(GlueContextValues: TArray<GlueContextValue>)
  : PSafeArray;
var
  pri: IRecordInfo;
  hr: HResult;
  bounds: array [0 .. 1] of SAFEARRAYBOUND;
  sa: PSafeArray;
  I: Integer;
begin
  hr := GetRecordInfoFromGuids(LIBID_GlueCOM, GlueCOMMajorVersion, GlueCOMMinorVersion, LOCALE_USER_DEFAULT,
    StringToGUID('{c74dd3d8-08a3-4b68-a41e-af04acd319bd}'), pri);

  if Succeeded(hr) then
  begin
    bounds[0].lLbound := 0;
    bounds[0].cElements := Length(GlueContextValues);

    sa := SafeArrayCreateEx(VT_RECORD, 1, @bounds, pri);

    for I := 0 to Length(GlueContextValues) - 1 do
    begin
      SafeArrayPutElement(sa, I, GlueContextValues[I]);
    end;
    Exit(sa);
  end;

  Result := nil;
end;

procedure TraverseGlueValue(name: string; gv: GlueValue; lines: TStrings;
  level: Integer);
var
  I: Integer;
  GlueValues: TArray<GlueValue>;
  offset: string;
  valueTypeName: string;
  prefix: string;
begin
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
          lines.Add(prefix + string.Join(',', TSafeArrayExpander<WideString,
            string>.AsArray(gv.StringArray,
            function(ws: WideString): string
            begin
              Result := ws;
            end)));
        end;
      GlueValueType_Bool:
        begin
          lines.Add(prefix + string.Join(',',
            TSafeArrayExpander<WordBool, string>.AsArray(gv.BoolArray,
            function(b: WordBool): string
            begin
              Result := BoolToStr(b);
            end)));
        end;
      GlueValueType_Int:
        lines.Add(prefix + string.Join(',',
          TSafeArrayExpander<Int64, string>.AsArray(gv.LongArray,
          function(b: Int64): string
          begin
            Result := IntToStr(b);
          end)));
      GlueValueType_Long:
        lines.Add(prefix + string.Join(',',
          TSafeArrayExpander<Int64, string>.AsArray(gv.LongArray,
          function(b: Int64): string
          begin
            Result := IntToStr(b);
          end)));
      GlueValueType_Double:
        lines.Add(prefix + string.Join(',',
          TSafeArrayExpander<Double, string>.AsArray(gv.DoubleArray,
          function(b: Double): string
          begin
            Result := FloatToStr(b);
          end)));
      GlueValueType_DateTime:
        ;
      GlueValueType_Tuple:
        begin
          lines.Add(prefix);
          if gv.Tuple = nil then
          begin
            lines.Add('NIL');
            Exit;
          end;
          GlueValues := TSafeArrayExpander<GlueValue>.AsPackedArray(gv.Tuple);
          for I := 0 to Length(GlueValues) - 1 do
          begin
            TraverseGlueValue('Tuple', GlueValues[I], lines, level + 1);
          end;
        end;
      GlueValueType_Composite:
        begin
          lines.Add(prefix);
          TraverseGlueContextValuesSafeArray(gv.CompositeValue, lines,
            level + 1);
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
            level + 1);
        end;
    end;
  end;
end;

procedure TraverseGlueContextValues(GlueContextValues: TArray<GlueContextValue>;
lines: TStrings);
var
  I: Integer;
begin
  for I := 0 to Length(GlueContextValues) - 1 do
  begin
    TraverseGlueValue(GlueContextValues[I].name,
      GlueContextValues[I].Value, lines);
  end;
end;

procedure TraverseGlueContextValuesSafeArray(sa: PSafeArray; lines: TStrings;
level: Integer = 0);
var
  pGCVs: PGlueContextValue;
  pv: PVOID;
  I, iLow, iHigh: Integer;
  pVar: PVariant;
  vt: TVarType;
  gcv: GlueContextValue;
  offset: String;
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
    vt := varType(pVar^);

    if vt = VT_RECORD then
    begin
      gcv := PGlueContextValue(TVarData(pVar^).VRecord.PRecord)^;
    end
    else
    begin
      gcv := pGCVs^;
    end;

    gv := gcv.Value;

    TraverseGlueValue(gcv.name, gv, lines, level);

    Inc(pGCVs);
    Inc(pVar);
  end;
  SafeArrayUnaccessData(sa);
end;

constructor TGlueResultHandler.Create(handlerLambda
  : TProc<TGlueInvocationResultArray, string>);
begin
  FHandlerLambda := handlerLambda;
end;

function TGlueResultHandler.HandleResult(invocationResult: PSafeArray;const correlationId: WideString)
  : HResult; stdcall;
var
  results: PGlueInvocationResult;
  pv: PVOID;
  I, iLow, iHigh: Integer;
  glueResults: TGlueInvocationResultArray;
begin
  SafeArrayAccessData(invocationResult, pv);
  results := pv;

  SafeArrayGetLBound(invocationResult, 1, iLow);
  SafeArrayGetUBound(invocationResult, 1, iHigh);

  SetLength(glueResults, iHigh - iLow + 1);

  for I := iLow to iHigh do
  begin
    glueResults[I] := results^;
    Inc(results);
  end;

  SafeArrayUnaccessData(invocationResult);

  FHandlerLambda(glueResults, correlationId);
  Result := S_OK;
end;

{ TGlueStreamHandler }

constructor TGlueStreamHandler.Create(dataLambda
  : TProc<GlueMethod, TArray<GlueContextValue>, PSafeArray>);
begin
  FDataLambda := dataLambda;
end;

function TGlueStreamHandler.HandleStreamData(stream: GlueMethod;
data: PSafeArray): HResult;
begin
  FDataLambda(stream, TSafeArrayExpander<GlueContextValue>.AsArray(data), data);
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

{ TSafeArrayExpander<T> }

class function TSafeArrayExpander<T, TA>.AsArray(sa: PSafeArray;
converter: TFunc<T, TA>): TArray<TA>;
var
  pws: PT;
  pv: PVOID;
  I, iLow, iHigh: Integer;
begin
  Result := TArray<TA>.Create();

  SafeArrayAccessData(sa, pv);
  pws := pv;
  SafeArrayGetLBound(sa, 1, iLow);
  SafeArrayGetUBound(sa, 1, iHigh);

  SetLength(Result, iHigh - iLow + 1);
  for I := 0 to iHigh - iLow do
  begin
    Result[I] := converter(pws^);
    Inc(pws);
  end;

  SafeArrayUnaccessData(sa);
end;

class function TSafeArrayExpander<T>.AsPackedArray(sa: PSafeArray): TArray<T>;
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
    Result[I] := PT(TVarData(pVar^).VRecord.PRecord)^;
    Inc(pVar);
  end;
  SafeArrayUnaccessData(sa);
end;

{ TSafeArrayExpander<T> }

class function TSafeArrayExpander<T>.AsArray(sa: PSafeArray): TArray<T>;
begin
  Result := TSafeArrayExpander<T, T>.AsArray(sa,
    function(I: T): T
    begin
      Result := I;
    end)
end;

{ TGlueContextHandler }

constructor TGlueContextHandler.Create(removedLambda
  : TProc<IGlueContext, TArray<string>>;
addedLambda, updatedLambda: TProc < IGlueContext,
  TArray < GlueContextValue >> );
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
    fUpdatedLambda(context, TSafeArrayExpander<GlueContextValue>.AsArray
      (context.GetData));
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
      TSafeArrayExpander<WideString, string>.AsArray(contextUpdate.GetRemoved,
      function(ws: WideString): string
      begin
        Result := ws;
      end));
  end;

  if Assigned(fAddedLambda) then
  begin
    context := contextUpdate.GetContext;
    added := contextUpdate.GetAdded;
    fAddedLambda(context, TSafeArrayExpander<GlueContextValue>.AsArray(added));
  end;

  if Assigned(fUpdatedLambda) then
  begin
    fUpdatedLambda(contextUpdate.GetContext,
      TSafeArrayExpander<GlueContextValue>.AsArray(contextUpdate.GetUpdated));
  end;

  Result := S_OK;
end;

{ TGlueRequestHandler }

constructor TGlueRequestHandler.Create(handlerLambda
  : TProc<GlueMethod, GlueInstance, TArray<GlueContextValue>,
  IGlueServerMethodResultCallback>);
begin
  FHandlerLambda := handlerLambda;
end;

function TGlueRequestHandler.HandleInvocationRequest(Method: GlueMethod;
caller: GlueInstance; requestValues: PSafeArray;
const resultCallback: IGlueServerMethodResultCallback): HResult;
begin
  FHandlerLambda(Method, caller, TSafeArrayExpander<GlueContextValue>.AsArray
    (requestValues), resultCallback);

  Result := S_OK;
end;

end.
