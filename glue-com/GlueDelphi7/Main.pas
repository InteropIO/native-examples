unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GlueCOM_TLB, ActiveX, GlueHelper, ComCtrls, ExtCtrls, Menus;

type
  Exception = SysUtils.Exception;
  Pointer = System.Pointer;

  TForm1 = class(TForm, IGlueEvents, IGlueWindowEventHandler, IAppFactory)
    GroupBox4: TGroupBox;
    memLog: TMemo;
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    GroupBox3: TGroupBox;
    TreeView1: TTreeView;
    GroupBox6: TGroupBox;
    btnInit: TButton;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    TreeView2: TTreeView;
    GroupBox5: TGroupBox;
    ListBox2: TListBox;
    GroupBox7: TGroupBox;
    Edit1: TEdit;
    PopupMenu1: TPopupMenu;
    GlueInvoke1: TMenuItem;
    procedure btnInitClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure GlueInvoke1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    // The Glue42 entrypoint handle
    G42: IGlue42;
    // Handle to the Glue window that represents this form
    glueWindow: IGlueWindow;
    // Describes this Glue instance's identity
    FOwnInstance: GlueInstance;
    // list of methods (endpoints) names
    FMethods: TStringList;
    // handle to a request handler for our registered invocation endpoints
    FRequestHandler: TGlueRequestHandler;
  protected
    // implements IGlueEvents - general status changes and other
    // points of interest that occur in Glue42 environment
    function HandleConnectionStatus(State: GlueState; const Message: WideString;
      date: Int64): HResult; stdcall;
    // Glue peer has appeared/disappeared
    function HandleInstanceStatus(Instance: GlueInstance; active: WordBool)
      : HResult; stdcall;
    // Glue invocation endpoint has changed its status
    function HandleMethodStatus(Method: GlueMethod; active: WordBool)
      : HResult; stdcall;
    // Glue context discovered
    function HandleGlueContext(context: GlueContext; created: WordBool)
      : HResult; stdcall;
    // error handling
    function HandleException(const Message: WideString; ex: GlueValue): HResult; stdcall;

  protected
    function CreateApp(const appDefName: WideString; state: GlueValue;
      const announcer: IAppAnnouncer): HResult; stdcall;
    // implements IGlueWindowEventHandler - channel updates for
    // registered Glue Window

    // when our own invocation endpoints are invoked
    procedure HandleRequest(Sender: TGlueRequestHandler; Method: GlueMethod;
      Instance: GlueInstance; args: GlueContextValueArray;
      callback: IGlueServerMethodResultCallback; Cookie: TCallbackCookie;
      argsSA: PSafeArray);

    // when a result has been issued to an invocation request sent by us
    procedure HandleResult(Sender: TGlueResultHandler;
      GlueResult: TGlueInvocationResultArray; Cookie: TCallbackCookie;
      const correlationId: WideString);

    function HandleWindowReady(const GlueWindow: IGlueWindow): HResult; stdcall;

    function HandleWindowEvent(const GlueWindow: IGlueWindow; eventType: GlueWindowEventType; eventData: GlueValue): HResult; stdcall;

    // channel data change
    function HandleChannelData(const glueWindow: IGlueWindow;
      const channelUpdate: IGlueContextUpdate): HResult; stdcall;

    // new channel has been selected
    function HandleChannelChanged(const glueWindow: IGlueWindow;
      const channel: IGlueContext; prevChannel: GlueContext): HResult; stdcall;


    // cleanup
    function HandleWindowDestroyed(const glueWindow: IGlueWindow)
      : HResult; stdcall;
  public
    { Public declarations }
  end;

  TGlueMethod = class
  public
    Method: GlueMethod;
    constructor Create(Method: GlueMethod);
  end;

  TString = class
  public
    Item: string;
    constructor Create(Item: string);
  end;

var
  Form1: TForm1;

// Building Trees out of Glue values

procedure BuildTranslatedContextValueTree(arr: TGlueContextValueArray;
  tree: TTreeNodes; node: TTreeNode);
procedure BuildTranslatedValueTree(name: string; gv: TGlueValue;
  tree: TTreeNodes; node: TTreeNode);

implementation

uses ComObj, ChannelViewer;

procedure BuildTranslatedContextValueTree(arr: TGlueContextValueArray;
  tree: TTreeNodes; node: TTreeNode);
var
  gcv: TGlueContextValue;
  I: Integer;
  gv: TGlueValue;
begin
  for I := 0 to Length(arr) - 1 do
  begin
    gcv := arr[I];
    gv := gcv.Value^;
    BuildTranslatedValueTree(gcv.name, gv, tree, node);
  end;
end;

procedure BuildTranslatedValueTree(name: string; gv: TGlueValue;
  tree: TTreeNodes; node: TTreeNode);
var
  comp: TGlueContextValueArray;
  stringRepresentation: string;
  tuple: TGlueValueArray;
  I: Integer;
  tupleNode: TTreeNode;
begin
  tuple := nil;
  comp := nil;
  if gv.IsArray then
  begin
    if gv.GlueType = GlueValueType_Tuple then
    begin
      tuple := gv.tuple;
      tupleNode := tree.AddChild(node, name);
      for I := 0 to Length(tuple) - 1 do
      begin
        BuildTranslatedValueTree(IntToStr(I), tuple[I]^, tree, tupleNode);
      end;
    end
    else if gv.GlueType = GlueValueType_Composite then
    begin
      comp := gv.CompositeValue;
      BuildTranslatedContextValueTree(comp, tree, tree.AddChild(node, name));
    end
    else
    begin
      case gv.GlueType of
        GlueValueType_String:
          stringRepresentation := JoinStrings(gv.StringArray);
        GlueValueType_Bool:
          stringRepresentation := JoinStrings(AsStringArray(gv.BoolArray));
        GlueValueType_Int:
          stringRepresentation := JoinStrings(AsStringArray(gv.LongArray));
        GlueValueType_Long:
          stringRepresentation := JoinStrings(AsStringArray(gv.LongArray));
        GlueValueType_Double:
          stringRepresentation := JoinStrings(AsStringArray(gv.DoubleArray));
        GlueValueType_DateTime:
          stringRepresentation := JoinStrings(AsStringArray(gv.DateTimeArray));
      end;
      tree.AddChild(node, name + ' = ' + stringRepresentation);
    end;
  end
  else
  begin
    if gv.GlueType = GlueValueType_Composite then
    begin
      comp := gv.CompositeValue;
      BuildTranslatedContextValueTree(comp, tree, tree.AddChild(node, name));
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

{$R *.dfm}

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

procedure TForm1.btnInitClick(Sender: TObject);
var
  inst: GlueInstance;
  cfg: GlueConfiguration;
  appDef: GlueAppDefinition;
begin
  if G42 <> nil then
  begin
    ShowMessage('Glue42 is already registered');
    Exit;
  end;
  FMethods := TStringList.Create;
  try
    // create the Glue42 com object
    G42 := CoGlue42.Create() as IGlue42;
  except
    on E: Exception do
    begin
      ShowMessage(E.ClassName + ' raised: ' + E.Message);
      Exit;
    end;
  end;
  try
    // subscribe to all events
    G42.Subscribe(Self);

    // configure own identity
    ZeroMemory(@inst, sizeof(inst));
    inst.ApplicationName := 'D7GlueSample';
    inst.Metadata := nil;

    ZeroMemory(@cfg, sizeof(cfg));
    cfg.LoggingConfigurationPath := 'GlueCOMDelphiLog.config';
    cfg.AppDefinitionTitle := 'Glue Delphi 7 Sample';
    G42.OverrideConfiguration(cfg);

    // init and start the Glue42
    G42.Start(inst);
    FOwnInstance := G42.GetInstance;
  except
    on E: Exception do
    begin
      memLog.Lines.Add(E.ClassName + ' raised: ' + E.Message);
    end;
  end;

  try
    // register VCL form window as Glue Window so it will become sticky,
    // participate in Glue Groups and consume Glue channels
    glueWindow := G42.RegisterGlueWindow(Self.Handle, Self);
    ZeroMemory(@appDef, sizeof(appDef));
    appDef.Name := 'GlueD7ChannelViewer';
    appDef.title := 'D7 Channel Viewer';
    appDef.Category := 'COM Apps';
    G42.AppFactoryRegistry.RegisterAppFactory(appDef, Self);
  except
    on E: Exception do
      ShowMessage(E.ClassName +
        ' error raised while registering Glue window, with message : ' +
        E.Message);
  end;

  try
    // this handler will be invoked when our own invocation endpoints are invoked by Glue apps
    FRequestHandler := TGlueRequestHandler.Create(Self, HandleRequest);

    // register two invocation endpoints passing the same request handler
    G42.RegisterMethod('T42.CRM.SyncContact', FRequestHandler, '', '', nil);
    G42.RegisterMethod('Delphi7Sample', FRequestHandler, '', '', nil);
  except
    on E: Exception do
      ShowMessage(E.ClassName +
        ' error raised while registering Glue method, with message : ' +
        E.Message);
  end;
end;

function TForm1.HandleChannelChanged(const glueWindow: IGlueWindow;
  const channel: IGlueContext; prevChannel: GlueContext): HResult;
begin
  if channel <> nil then
  begin
    Edit1.Text := channel.GetContextInfo.name;
  end
  else
  begin
    Edit1.Text := '';
  end;
  Result := S_OK;
end;

function TForm1.HandleChannelData(const glueWindow: IGlueWindow;
  const channelUpdate: IGlueContextUpdate): HResult;
var
  gc: IGlueContext;
  channelData: PSafeArray;
  contextInfo: GlueContext;
  tcv: TGlueContextValueArray;
  back: GlueContextValueArray;
  sa: PSafeArray;
begin
  gc := channelUpdate.GetContext;
  contextInfo := gc.GetContextInfo;
  // memLog.Lines.Add('Bound to channel ' + contextInfo.name);
  channelData := gc.GetData;

  TreeView1.Items.BeginUpdate;
  TreeView1.Items.Clear;

  tcv := SA_AsTranslatedContextValues(channelData);
  BuildTranslatedContextValueTree(tcv, TreeView1.Items,
    TreeView1.Items.AddChild(nil, contextInfo.name));

  back := AsGlueContextValueArray(tcv);
  sa := CreateContextValues_SA(back);

  // invoke jsmethod Glue endpoint (if existing)
  G42.InvokeMethods('jsmethod', sa, nil, true, GlueInstanceIdentity_None,
    TGlueResultHandler.Create(Self, Self.HandleResult), 5000, 'channel_invoke');

  // cleanup
  SafeArrayDestroy(sa);
  SafeArrayDestroy(channelData);

  TreeView1.Items.GetFirstNode.Collapse(true);
  ExpandNodes(TreeView1.Items.GetFirstNode, 2);
  TreeView1.Items.GetFirstNode.MakeVisible;

  TreeView1.Items.EndUpdate;

  TreeView1.Items.GetFirstNode.Focused := true;

  Result := S_OK;
end;

function TForm1.HandleWindowDestroyed(const glueWindow: IGlueWindow): HResult;
begin
  Result := S_OK;
end;

procedure TForm1.HandleResult(Sender: TGlueResultHandler;
  GlueResult: TGlueInvocationResultArray; Cookie: TCallbackCookie;
  const correlationId: WideString);
var
  r: TGlueContextValueArray;
  sa: PSafeArray;
  I: Integer;
begin
  r := nil;
  try
    for I := 0 to Length(GlueResult) - 1 do
    begin
      memLog.Lines.Add('--- Result arrived for correlationId ' + correlationId +
        ' from ' + GlueResult[I].Method.Instance.ApplicationName);
      sa := GlueResult[I].Result.Values;
      r := SA_AsTranslatedContextValues(sa);

      TraverseGlueContextValues(r, memLog.Lines);
      SafeArrayDestroy(sa);
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Handle result: ' + E.Message);
    end
  end;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var
  handler: TGlueResultHandler;
  callback: TResultHandlerLambda;
  Method: TGlueMethod;
  args: PSafeArray;
  I: Integer;
  gm: GlueMethod;
begin
  if ListBox1.ItemIndex >= 0 then
  begin
    I := FMethods.IndexOf(ListBox1.Items[ListBox1.ItemIndex]);
    if I >= 0 then
    begin
      Method := TGlueMethod(FMethods.Objects[I]);

      gm := Method.Method;

      // clean stuff
      gm.Instance.Metadata := nil;
      gm.ObjectTypes := nil;

      // create sample args - some values and composites
      args := CreateContextValues_SA(AsGlueContextValueArray([
          CreateContextValue('Instrument',
            CreateComposite([CreateContextValue('Volume',
                CreateValue(Integer(100 + System.Random(10000)))),
              CreateContextValue('InstrumentId',
                CreateValue(CreateClassID))], false)),
          CreateContextValue('Price', CreateValue(System.Random)),
          CreateContextValue('Side', CreateValue('BUY'))]));

      callback := Self.HandleResult;
      // this needs to be freed when result is received
      handler := TGlueResultHandler.Create(Self, callback);

      // invoke the selected method
      G42.InvokeMethod(gm, args, handler, 5000, DateTimeToStr(Now));

      OleCheck(SafeArrayDestroy(args));
    end;
  end;
end;

function TForm1.HandleConnectionStatus(State: GlueState;
  const Message: WideString; date: Int64): HResult;
begin
  memLog.Lines.Add(DateTimeToStr(GlueTimeToDateTime(date)) + ' UTC: ' +
    Message);
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

function TForm1.HandleException(const Message: WideString; ex: GlueValue): HResult;
begin
  memLog.Lines.Add(Message);
  Result := S_OK;
end;

function TForm1.HandleGlueContext(context: GlueContext;
  created: WordBool): HResult;
begin
  memLog.Lines.Add('Discovered Glue context ' + context.name);
  Result := S_OK;
end;

{ TGlueMethod }

constructor TGlueMethod.Create(Method: GlueMethod);
begin
  Self.Method := Method;
end;

procedure TForm1.HandleRequest(Sender: TGlueRequestHandler; Method: GlueMethod;
  Instance: GlueInstance; args: GlueContextValueArray;
  callback: IGlueServerMethodResultCallback; Cookie: TCallbackCookie;
  argsSA: PSafeArray);
var
  r: GlueResult;
  comp: GlueContextValueArray;
  name: string;
  gv: GlueValueArray;
  rid: string;
begin
  comp := nil;
  gv := nil;
  memLog.Lines.Add('Local method ' + Method.name + ' invoked from ' +
    Instance.ApplicationName);

  if Method.name = 'T42.CRM.SyncContact' then
  begin
    if Instance.InstanceId <> FOwnInstance.InstanceId then
    begin
      // add the client's name
      TreeView2.Items.BeginUpdate;
      TreeView2.Items.Clear;

      BuildTranslatedContextValueTree(SA_AsTranslatedContextValues(argsSA),
        TreeView2.Items, TreeView2.Items.AddChild(nil,
        Method.name));

      ExpandNodes(TreeView2.Items.GetFirstNode, 2);
      TreeView2.Items.GetFirstNode.MakeVisible;
      TreeView2.Items.EndUpdate;

      comp := SA_AsGlueContextValueArray(args[0].Value.CompositeValue);
      name := comp[1].Value.StringValue;
      gv := SA_AsGlueValueArray(comp[4].Value.tuple);

      comp := SA_AsGlueContextValueArray(gv[1].CompositeValue);
      rid := comp[0].Value.StringValue;

      if ListBox2.Items.IndexOf(name) < 0 then
        ListBox2.Items.AddObject(name, TString.Create(rid));
    end;
  end
  else
  begin
    TraverseGlueContextValues(args, memLog.Lines);
  end;

  // reply to the invocation
  ZeroMemory(@r, sizeof(r));
  r.Status := GlueMethodInvocationStatus_Succeeded;
  r.Message := 'Handled in D7';
  // r.Values := resultArgs;
  callback.SendResult(r);
  // SafeArrayDestroy(r.Values);
end;

function CreateContactArgs(treeView: TTreeView; contactId: string): PSafeArray;
var
  args: TGlueContextValueArray;
  contactValue: TGlueValue;
begin
  // {ids:[{systemName:"rest.id", nativeId:"ID_Of_Contact"}]}

  contactValue := CreateComposite
    ([CreateContextValue('ids',
        CreateTuple([CreateComposite([CreateContextValue('systemName',
                CreateValue('rest.id')), CreateContextValue('nativeId',
                CreateValue(contactId))], false)]))], false);

  SetLength(args, 1);

  args[0] := CreateContextValue('contact', contactValue);

  { BuildTranslatedContextValueTree(args, treeView.Items,
    treeView.Items.AddChild(nil, 'Created contact args')); }

  Result := CreateContextValues_SA(AsGlueContextValueArray(args));
end;

procedure TForm1.ListBox2Click(Sender: TObject);
var
  contactArgs: PSafeArray;
  rid: string;
begin
  try
    if ListBox2.ItemIndex >= 0 then
    begin
      rid := TString(ListBox2.Items.Objects[ListBox2.ItemIndex]).Item;

      contactArgs := CreateContactArgs(TreeView1, rid);

      G42.InvokeMethods('T42.CRM.SyncContact', contactArgs, nil, true,
        GlueInstanceIdentity_None, TGlueResultHandler.Create(Self,
        Self.HandleResult), 5000, 'SyncContact ' + ListBox2.Items
        [ListBox2.ItemIndex]);

      SafeArrayDestroy(contactArgs);
    end;
  except
    on E: Exception do
    begin
      ShowMessage('SyncContact:' + E.Message);
    end;
  end;
end;

{ TString }

constructor TString.Create(Item: string);
begin
  Self.Item := Item;
end;

procedure TForm1.GlueInvoke1Click(Sender: TObject);
begin
  if PopupMenu1.PopupComponent = ListBox1 then
  begin
    ListBox1DblClick(Sender);
  end
  else if PopupMenu1.PopupComponent = ListBox2 then
  begin
    ListBox2Click(Sender);
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FRequestHandler := nil;
end;

function TForm1.CreateApp(const appDefName: WideString;
  state: GlueValue; const announcer: IAppAnnouncer): HResult;
var
  cv : TForm2;
begin
  if appDefName = 'GlueD7ChannelViewer' then
  begin
    cv := TForm2.Create(self);
    announcer.RegisterAppInstance(cv.Handle, cv);
    Result := S_OK;
  end
  else
    Result := E_FAIL;
end;
function TForm1.HandleWindowReady(const GlueWindow: IGlueWindow): HResult;
begin
  // change the Glue Window title
  glueWindow.SetTitle('Delphi Glue Window');

  Result := S_OK;
end;

function TForm1.HandleWindowEvent(const GlueWindow: IGlueWindow;
  eventType: GlueWindowEventType; eventData: GlueValue): HResult;
begin
  Result := S_OK;
end;

end.
