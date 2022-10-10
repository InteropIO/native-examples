/// Sample Delphi VCL Form application demonstrating Glue COM usage:
/// - Registering Glue Windows (sticky)
/// - Registering methods, receiving invocations and yielding results
/// - Registering streams, accepting subscriptions and pushing data
/// - Reacting on Glue Window channel changes
/// - Consuming Glue contexts

unit Glue42MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, GlueCOM_TLB,
  Winapi.ActiveX, ComObj,
  GlueHelper, mscorlib_TLB, Vcl.ComCtrls, DateUtils;

type
  TForm1 = class(TForm, IGlueEvents, IGlueWindowEventHandler,
    IGlueSubscriptionHandler)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    ListBox1: TListBox;
    GroupBox2: TGroupBox;
    btnGlueInvoke: TButton;
    btnSubscribe: TButton;
    btnPush: TButton;
    edtMethodName: TEdit;
    edtStreamName: TEdit;
    GroupBox3: TGroupBox;
    TreeView1: TTreeView;
    GroupBox4: TGroupBox;
    memLog: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGlueInvokeClick(Sender: TObject);
    procedure btnSubscribeClick(Sender: TObject);
    procedure btnPushClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
    glueWindow: IGlueWindow;
    stream: IGlueStream;
    G42: IGlue42;
    FMethods: TStringList;
    function CreateSampleArgs: PSafeArray;
  protected
    procedure InitializeGlue;

    // implements IGlueEvents - general status changes and other
    // points of interest that occur in Glue42 environment
    function HandleConnectionStatus(State: GlueState; const Message: WideString;
      date: Int64): HResult; stdcall;
    function HandleInstanceStatus(Instance: GlueInstance; active: WordBool)
      : HResult; stdcall;
    function HandleMethodStatus(Method: GlueMethod; active: WordBool)
      : HResult; stdcall;
    function HandleGlueContext(context: GlueContext; created: WordBool)
      : HResult; stdcall;
    function HandleException(const Message: WideString; ex: GlueValue)
      : HResult; stdcall;

    // implements IGlueWindowEventHandler - channel updates for
    // registered Glue Window
    function HandleWindowReady(const glueWindow: IGlueWindow): HResult; stdcall;
    function HandleWindowEvent(const glueWindow: IGlueWindow;
      eventType: GlueWindowEventType; eventData: GlueValue): HResult; stdcall;
    function HandleChannelData(const glueWindow: IGlueWindow;
      const channelUpdate: IGlueContextUpdate): HResult; stdcall;
    function HandleChannelChanged(const glueWindow: IGlueWindow;
      const channel: IGlueContext; prevChannel: GlueContext): HResult; stdcall;
    function HandleWindowDestroyed(const glueWindow: IGlueWindow)
      : HResult; stdcall;

    // implements IGlueSubscriptionHandler - Glue stream publishing side
    // can accept subscription requests

    // reject/accept subscription requests
    function HandleSubscriptionRequest(stream: GlueMethod; caller: GlueInstance;
      requestValues: PSafeArray;
      const callback: IGlueServerSubscriptionCallback): HResult; stdcall;

    // notification that there's new subscriber
    function HandleSubscriber(subscriberInstance: GlueInstance;
      const glueStreamSubscriber: IGlueStreamSubscriber;
      requestValues: PSafeArray): HResult; stdcall;

    // notification that the stream lost a subscriber
    function HandleSubscriberLost(streamSubscriber: GlueInstance;
      const glueStreamSubscriber: IGlueStreamSubscriber): HResult; stdcall;
  public
  end;

  TGlueMethod = class
  public
    Method: GlueMethod;
    constructor Create(Method: GlueMethod);
  end;

var
  Form1: TForm1;

  // expands Array of GlueContextValue into Tree nodes for better visualization
procedure BuildContextValueTree(arr: TArray<GlueContextValue>; tree: TTreeNodes;
  node: TTreeNode);
procedure BuildValueTree(name: string; gv: GlueValue; tree: TTreeNodes;
  node: TTreeNode);

implementation

uses
  StrUtils;

{$R *.dfm}

function TForm1.HandleConnectionStatus(State: GlueState;
  const Message: WideString; date: Int64): HResult;
begin
  memLog.Lines.Add(DateTimeToStr(GlueTimeToDateTime(date)) + ' UTC: ' +
    Message);
  Result := S_OK;
end;

function TForm1.HandleException(const Message: WideString;
  ex: GlueValue): HResult;
begin
  // NOTE: log exception
  Result := S_OK;
end;

function TForm1.HandleInstanceStatus(Instance: GlueInstance;
  active: WordBool): HResult;
begin
  memLog.Lines.Add(Instance.ApplicationName + ' is ' + BoolToStr(active, true));
  Result := S_OK;
end;

function TForm1.HandleMethodStatus(Method: GlueMethod;
  active: WordBool): HResult;
var
  glueMethodKey: System.WideString;
  ind: Integer;
begin
  try
    glueMethodKey := Method.name + ' at ' + Method.Instance.ApplicationName;
    if active then
    begin
      FMethods.AddObject(glueMethodKey, TGlueMethod.Create(Method));
    end
    else
    begin
      ind := FMethods.IndexOf(glueMethodKey);
      if ind >= 0 then
      begin
        FMethods.Objects[ind].Free;
        FMethods.Delete(ind);
      end;
    end;

    ListBox1.Items.Assign(FMethods);
  except
    on E: Exception do
      ShowMessage(E.ClassName + ' error raised, with message : ' + E.Message);
  end;

  Result := S_OK;
end;

function TForm1.HandleSubscriber(subscriberInstance: GlueInstance;
  const glueStreamSubscriber: IGlueStreamSubscriber;
  requestValues: PSafeArray): HResult;
begin
  Result := S_OK;
end;

function TForm1.HandleSubscriberLost(streamSubscriber: GlueInstance;
  const glueStreamSubscriber: IGlueStreamSubscriber): HResult;
begin
  Result := S_OK;
end;

function TForm1.CreateSampleArgs: PSafeArray;
var
  gcv: TArray<GlueContextValue>;
  argsValues: TArray<GlueContextValue>;
begin
  SetLength(gcv, 2);
  gcv[0].name := 'One';

  ZeroMemory(@gcv[0].Value, sizeof(gcv[0].Value));
  gcv[0].Value.GlueType := GlueValueType_Int;
  gcv[0].Value.LongValue := 5;
  gcv[1].name := 'Two';

  ZeroMemory(@gcv[1].Value, sizeof(gcv[1].Value));
  gcv[1].Value.GlueType := GlueValueType_String;
  gcv[1].Value.StringValue := 'And a string for you, sirs';

  SetLength(argsValues, 1);
  argsValues[0].name := 'Level 0';

  ZeroMemory(@argsValues[0].Value, sizeof(argsValues[0].Value));
  argsValues[0].Value.GlueType := GlueValueType_Composite;
  argsValues[0].Value.CompositeValue := CreateComposite(gcv);

  Result := CreateContextValues(argsValues);
end;

procedure TForm1.Edit1Change(Sender: TObject);
var
  I: Integer;
  S: String;
begin
  ListBox1.Items.BeginUpdate;
  try
    ListBox1.Clear;
    S := Edit1.Text;
    for I := 0 to FMethods.Count - 1 do
    begin
      if (Edit1.GetTextLen <= 0) or ContainsText(FMethods[I], S) then
        ListBox1.Items.Add(FMethods[I]);
    end;
  finally
    ListBox1.Items.EndUpdate;
  end;
end;

function TForm1.HandleSubscriptionRequest(stream: GlueMethod;
  caller: GlueInstance; requestValues: PSafeArray;
  const callback: IGlueServerSubscriptionCallback): HResult;
var
  r: GlueResult;
begin
  ZeroMemory(@r, sizeof(r));
  callback.Accept('', r);
  Result := S_OK;
end;

function TForm1.HandleGlueContext(context: GlueContext;
  created: WordBool): HResult;
begin
  memLog.Lines.Add('Discovered Glue context ' + context.name);
  Result := S_OK;
end;

procedure TForm1.btnGlueInvokeClick(Sender: TObject);
var
  handler: IGlueInvocationResultHandler;
  args: PSafeArray;
  // targets: TGlueInstanceArray;
begin
  handler := TGlueResultHandler.Create(
    procedure(results: TGlueInvocationResultArray; correlationId: string)
    var
      I: Integer;
    begin
      for I := 0 to Length(results) - 1 do
      begin
        memLog.Lines.Add('Received result from ' + results[I]
          .Method.Instance.ApplicationName);
        TraverseGlueContextValuesSafeArray(results[I].Result.Values,
          memLog.Lines);
      end;
    end);
  args := CreateSampleArgs;

  // optionally pass a target filter selection - so e.g. only call app1, app2, app3
  // SetLength(targets, 1);
  // ZeroMemory(@targets[0], sizeof(targets[0]));
  // targets[0].ApplicationName := 'SomeApp';

  // invoke ALL methods matching this name and handle the result in the lambda
  G42.InvokeMethods(edtMethodName.Text, args, nil, true,
    GlueInstanceIdentity_None, handler, 5000, '');

  SafeArrayDestroy(args);
end;

procedure TForm1.btnPushClick(Sender: TObject);
begin
  stream.Push(CreateSampleArgs, '');
end;

procedure TForm1.btnSubscribeClick(Sender: TObject);
var
  sub: TGlueStreamHandler;
begin
  sub := TGlueStreamHandler.Create(
    procedure(stream: GlueMethod; dataValues: TArray<GlueContextValue>;
      data: PSafeArray)
    begin
      memLog.Lines.Add('Received data pushed from ' +
        stream.Instance.ApplicationName);

      TraverseGlueContextValuesSafeArray(data, memLog.Lines);
    end);

  // make a stream subscription and handle the streaming data with a lambda
  G42.SubscribeStreams(edtStreamName.Text, nil, nil, false,
    GlueInstanceIdentity_None, sub, -1);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(glueWindow) then
  begin
    glueWindow.Unregister;
  end;

  if Assigned(G42) then
  begin
    G42.Stop;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FMethods := TStringList.Create;
  Hide;
  try
    InitializeGlue;
  finally
    Show;
  end;
end;

function TForm1.HandleWindowDestroyed(const glueWindow: IGlueWindow)
  : HResult; stdcall;
begin
  // Glue Window Manager said that this window is destroyed, so clean up
  Close;
  Result := S_OK;
end;

function TForm1.HandleWindowEvent(const glueWindow: IGlueWindow;
eventType: GlueWindowEventType; eventData: GlueValue): HResult;
begin
  Result := S_OK;
end;

function TForm1.HandleWindowReady(const glueWindow: IGlueWindow): HResult;
begin
  // change the Glue Window title
  glueWindow.SetTitle('Delphi Glue Window');
  Result := S_OK;
end;

procedure BuildValueTree(name: string; gv: GlueValue; tree: TTreeNodes;
node: TTreeNode);
var
  comp: TArray<GlueContextValue>;
  stringRepresentation: string;
  tuple: TArray<GlueValue>;
  I: Integer;
  tupleNode: TTreeNode;
begin
  if gv.IsArray then
  begin
    if gv.GlueType = GlueValueType_Tuple then
    begin
      tuple := TSafeArrayExpander<GlueValue>.AsPackedArray(gv.tuple);
      tupleNode := tree.AddChild(node, name);
      for I := 0 to Length(tuple) - 1 do
      begin
        BuildValueTree(IntToStr(I), tuple[I], tree, tupleNode);
      end;
    end
    else if gv.GlueType = GlueValueType_Composite then
    begin
      comp := TSafeArrayExpander<GlueContextValue>.AsPackedArray
        (gv.CompositeValue);
      BuildContextValueTree(comp, tree, tree.AddChild(node, name));
    end
    else
    begin
      case gv.GlueType of
        GlueValueType_String:
          begin
            stringRepresentation :=
              string.Join(',', TSafeArrayExpander<WideString, string>.AsArray
              (gv.StringArray,
              function(ws: WideString): string
              begin
                Result := ws;
              end));
          end;
        GlueValueType_Bool:
          begin
            stringRepresentation :=
              string.Join(',', TSafeArrayExpander<WordBool, string>.AsArray
              (gv.BoolArray,
              function(b: WordBool): string
              begin
                Result := BoolToStr(b);
              end));
          end;
        GlueValueType_Int:
          stringRepresentation :=
            string.Join(',', TSafeArrayExpander<Int64, string>.AsArray
            (gv.LongArray,
            function(b: Int64): string
            begin
              Result := IntToStr(b);
            end));
        GlueValueType_Long:
          stringRepresentation :=
            string.Join(',', TSafeArrayExpander<Int64, string>.AsArray
            (gv.LongArray,
            function(b: Int64): string
            begin
              Result := IntToStr(b);
            end));
        GlueValueType_Double:
          stringRepresentation :=
            string.Join(',', TSafeArrayExpander<Double, string>.AsArray
            (gv.DoubleArray,
            function(b: Double): string
            begin
              Result := FloatToStr(b);
            end));
        GlueValueType_DateTime:
          stringRepresentation :=
            string.Join(',', TSafeArrayExpander<Int64, string>.AsArray
            (gv.LongArray,
            function(d: Int64): string
            begin
              Result := DateTimeToStr(GlueTimeToDateTime(d));
            end));
      end;
      tree.AddChild(node, name + ' = ' + stringRepresentation);
    end;
  end
  else
  begin
    if gv.GlueType = GlueValueType_Composite then
    begin
      comp := TSafeArrayExpander<GlueContextValue>.AsPackedArray
        (gv.CompositeValue);
      BuildContextValueTree(comp, tree, tree.AddChild(node, name));
    end
    else
    begin
      case gv.GlueType of
        GlueValueType_String:
          stringRepresentation := gv.StringValue;
        GlueValueType_Bool:
          stringRepresentation := BoolToStr(gv.BoolValue);
        GlueValueType_Int:
          stringRepresentation := IntToStr(gv.LongValue);
        GlueValueType_Long:
          stringRepresentation := IntToStr(gv.LongValue);
        GlueValueType_Double:
          stringRepresentation := FloatToStr(gv.DoubleValue);
        GlueValueType_DateTime:
          stringRepresentation :=
            DateTimeToStr(GlueTimeToDateTime(gv.LongValue));
        GlueValueType_Tuple:
          // never - tuple is always an array
          ;
      end;
      tree.AddChild(node, name + ' = ' + stringRepresentation);
    end;
  end;
end;

procedure BuildContextValueTree(arr: TArray<GlueContextValue>; tree: TTreeNodes;
node: TTreeNode);
var
  gcv: GlueContextValue;
  I: Integer;
  gv: GlueValue;
  name: string;
begin
  for I := 0 to Length(arr) - 1 do
  begin
    gcv := arr[I];
    gv := gcv.Value;
    name := gcv.name;
    BuildValueTree(gcv.name, gv, tree, node);
  end;
end;

procedure ExpandNodes(const node: TTreeNode; level: Integer);
var
  ANode, CNode: TTreeNode;
begin
  if level <= 0 then
  begin
    Exit;
  end;

  node.Expand(false);
  ANode := node;
  while ANode <> nil do
  begin
    CNode := node.getFirstChild;
    while CNode <> nil do
    begin
      CNode.Expand(false);
      ExpandNodes(CNode, level - 1);
      CNode := CNode.GetNextSibling;
    end;
    ANode := ANode.GetNextSibling;
  end;
end;

function TForm1.HandleChannelData(const glueWindow: IGlueWindow;
const channelUpdate: IGlueContextUpdate): HResult;
var
  gc: IGlueContext;
  channelData: PSafeArray;
  contextInfo: GlueContext;
begin
  gc := channelUpdate.GetContext;
  contextInfo := gc.GetContextInfo;
  // memLog.Lines.Add('Bound to channel ' + contextInfo.name);
  channelData := gc.GetData;
  // TraverseGlueContextValuesSafeArray(channelData, memLog.Lines);

  TreeView1.Items.BeginUpdate;

  TreeView1.Items.Clear;
  BuildContextValueTree(TSafeArrayExpander<GlueContextValue>.AsArray
    (channelData), TreeView1.Items, TreeView1.Items.AddChild(nil,
    contextInfo.name));

  TreeView1.Items.GetFirstNode.Collapse(true);
  ExpandNodes(TreeView1.Items.GetFirstNode, 2);

  TreeView1.Items.EndUpdate;

  TreeView1.Items.GetFirstNode.Focused := true;
  TreeView1.Items.GetFirstNode.Selected := true;

  Result := S_OK;
end;

function TForm1.HandleChannelChanged(const glueWindow: IGlueWindow;
const channel: IGlueContext; prevChannel: GlueContext): HResult;
begin
  memLog.Lines.Add('Left channel ' + prevChannel.name);
  if (channel <> nil) then
  begin
    memLog.Lines.Add('Now in channel ' + channel.GetContextInfo.name);
  end;
  Result := S_OK;
end;

procedure TForm1.InitializeGlue;
var
  inst: GlueInstance;
  cfg: GlueConfiguration;
begin
  try
    // create the Glue42 com object
    G42 := CoGlue42.Create() as IGlue42;
  except
    on E: Exception do
    begin
      memLog.Lines.Add(E.ClassName + ' raised: ' + E.Message);
      Exit;
    end;
  end;
  try
    // subscribe to all events
    G42.Subscribe(Self);

    // configure own identity
    ZeroMemory(@inst, sizeof(inst));
    inst.ApplicationName := 'DelphiRulez';
    inst.Metadata := nil;

    ZeroMemory(@cfg, sizeof(cfg));
    cfg.LoggingConfigurationPath := 'GlueCOMDelphiLog.config';
    G42.OverrideConfiguration(cfg);

    // init and start the Glue42
    G42.Start(inst);

  except
    on E: Exception do
    begin
      memLog.Lines.Add(E.ClassName + ' raised: ' + E.Message);
      Exit;
    end;
  end;

  try
    // register VCL form window as Glue Window so it will become sticky,
    // participate in Glue Groups and consume Glue channels
    glueWindow := G42.RegisterGlueWindow(Self.Handle, Self);
  except
    on E: Exception do
      ShowMessage(E.ClassName + ' error raised, with message : ' + E.Message);
  end;

  // register invocation endpoint - so any other Glue peer can invoke this
  // this example shows usage of lambda handler
  // or implement IGlueRequestHandler in the VCL Form and pass self instead
  G42.RegisterMethod('GlueDelphi', TGlueRequestHandler.Create(
    procedure(Method: GlueMethod; caller: GlueInstance;
      requestArgs: TArray<GlueContextValue>;
      resultCallback: IGlueServerMethodResultCallback)
    var
      gr: GlueResult;
    begin
      memLog.Lines.Add('Method ' + Method.name + ' invoked by ' +
        caller.ApplicationName);

      TraverseGlueContextValues(requestArgs, memLog.Lines);
      ZeroMemory(@gr, sizeof(gr));
      gr.Status := GlueMethodInvocationStatus_Succeeded;
      gr.Values := CreateContextValues(requestArgs);
      gr.Message := 'Here, take it';
      resultCallback.SendResult(gr);

    end), '', '', nil);

  // register stream - publishing side, passing self as IGlueSubscriptionHandler
  G42.RegisterStream('GlueDelphiStream', Self, '', '', nil, stream);

  memLog.Lines.Add('InstanceId is ' + G42.GetInstance.InstanceId);

  try
    // Get-or-create a context by name - in this case this is the Green channel
    G42.SubscribeGlueContext('___channel___Green',
      TGlueContextHandler.Create(nil,
      procedure(gc: IGlueContext; gcv: TArray<GlueContextValue>)
      begin
        // show the Context data
        TraverseGlueContextValuesSafeArray(gc.GetData, memLog.Lines);
      end, nil));
  except
    on E: Exception do
    begin
      memLog.Lines.Add(E.ClassName + ' raised: ' + E.Message);
      Exit;
    end;
  end;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var
  I: Integer;
  gm: GlueMethod;
begin
  if ListBox1.ItemIndex >= 0 then
  begin
    I := FMethods.IndexOf(ListBox1.Items[ListBox1.ItemIndex]);
    if I >= 0 then
    begin
      gm := TGlueMethod(FMethods.Objects[I]).Method;

      gm.Instance.Metadata := nil;
      gm.ObjectTypes := nil;

      // invoke this particular method and handle the result with a lambda
      G42.InvokeMethod(gm, CreateSampleArgs, TGlueResultHandler.Create(
        procedure(results: TGlueInvocationResultArray; correlationId: string)
        var
          I: Integer;
        begin
          for I := 0 to Length(results) - 1 do
          begin
            memLog.Lines.Add('Received result from ' + results[I]
              .Method.Instance.ApplicationName);
            TraverseGlueContextValuesSafeArray(results[I].Result.Values,
              memLog.Lines);
          end;
        end), -1, '');
    end;
  end;
end;

{ TGlueMethod }

constructor TGlueMethod.Create(Method: GlueMethod);
begin
  Self.Method := Method;
end;

end.
