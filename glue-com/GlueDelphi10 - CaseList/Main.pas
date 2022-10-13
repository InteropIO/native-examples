unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, GlueCOM_TLB,
  GlueHelper, System.JSON, Data.DBXJSON, System.IOUtils,
  System.Generics.Collections, StringGridEx, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm, IGlueEvents, IGlueWindowEventHandler)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Memo1: TMemo;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseLeave(Sender: TObject);
    procedure Image1MouseEnter(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
    FEnabledGluePic: TPicture;
    FDisabledGluePic: TPicture;
    glueWindow: IGlueWindow;
    G42: IGlue42;
    FInstanceId: WideString;
    FCaseListGrid: TStringGridEx;
    procedure Log(Message: string);

    procedure caseListGridCanEdit(Sender: TObject; Col, Row: Longint;
      var CanEdit: Boolean);
    procedure caseListGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure caseListGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure caseListGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);

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

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Winapi.ActiveX, Vcl.Themes,
  Vcl.Styles;

{$R *.dfm}
{ TForm1 }

procedure AutoSizeGridColumns(Grid: TStringGrid);
const
  MIN_COL_WIDTH = 35;
var
  Col: Integer;
  ColWidth, CellWidth: Integer;
  Row: Integer;
begin
  Grid.Canvas.Font.Assign(Grid.Font);
  for Col := 0 to Grid.ColCount - 1 do
  begin
    ColWidth := Grid.Canvas.TextWidth(Grid.Cells[Col, 0]);
    for Row := 0 to Grid.RowCount - 1 do
    begin
      CellWidth := Grid.Canvas.TextWidth(Grid.Cells[Col, Row]);
      if CellWidth > ColWidth then
        Grid.ColWidths[Col] := CellWidth + MIN_COL_WIDTH
      else
        Grid.ColWidths[Col] := ColWidth + MIN_COL_WIDTH;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  fileName: TFileName;
  JSONValue, jv: TJSONValue;
  JSONArray: TJSONArray;
  jo: TJSONObject;
  pair: TJSONPair;
  id: Integer;
  description: String;
  content: String;
  stringList: TList<String>;
  arrV: TJSONValue;
  arr: TJSONArray;
  v: TJSONValue;
  ExePath: String;
  Row: Integer;
  contacts: String;
  attachments: String;
begin
  FEnabledGluePic := TPicture.Create;
  FEnabledGluePic.LoadFromFile('glue42-95.png');
  FDisabledGluePic := TPicture.Create;
  FDisabledGluePic.LoadFromFile('glue42-95-disabled.png');
  Image1.Picture := FDisabledGluePic;

  ExePath := ExtractFileDir(ParamStr(0));
  FCaseListGrid := TStringGridEx.Create(Self);
  FCaseListGrid.Parent := GroupBox1;
  with FCaseListGrid do
  begin
    Left := 2;
    Top := 15;
    Width := 893;
    Height := 332;
    Align := alClient;
    FixedCols := 0;
    Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,
      goRowSizing, goColSizing, goEditing];
    TabOrder := 0;
    OnDrawCell := caseListGridDrawCell;
    OnSelectCell := caseListGridSelectCell;
    OnSetEditText := caseListGridSetEditText;
    OnCanEdit := caseListGridCanEdit;
  end;

  fileName := TPath.Combine(ExePath, 'case-list-data.json');
  JSONValue := TJSONObject.ParseJSONValue(TFile.ReadAllText(fileName));
  stringList := TList<string>.Create;
  FCaseListGrid.FixedCols := 0;
  FCaseListGrid.ColCount := 5;
  FCaseListGrid.Rows[0].AddStrings(['#', 'Description', 'Content', 'Contacts',
    'Attachments']);
  Row := 1;
  if JSONValue is TJSONArray then
  begin
    FCaseListGrid.RowCount := 1 + (JSONValue as TJSONArray).Count;
    for jv in (JSONValue as TJSONArray) do
    begin
      if not(jv is TJSONObject) then
        continue;
      jo := jv as TJSONObject;

      id := jo.GetValue<Integer>('number', -1);
      description := jo.GetValue<String>('description', '');
      content := jo.GetValue<String>('content', '');
      arrV := jo.GetValue('contacts');
      if arrV is TJSONArray then
      begin
        for v in (arrV as TJSONArray) do
        begin
          stringList.Add(v.Value);
        end;
      end;
      contacts := string.Join(',', stringList.ToArray);
      stringList.Clear;

      arrV := jo.GetValue('attachments');
      if arrV is TJSONArray then
      begin
        for v in (arrV as TJSONArray) do
        begin
          stringList.Add(v.GetValue<string>('fileName'));
        end;
      end;

      attachments := String.Join(',', stringList.ToArray);

      FCaseListGrid.Rows[Row].AddStrings([IntToStr(id), description, content,
        contacts, attachments]);
      Inc(Row);
    end;
  end;

  stringList.Destroy;

  AutoSizeGridColumns(FCaseListGrid);
end;

function TForm1.HandleChannelChanged(const glueWindow: IGlueWindow;
  const channel: IGlueContext; prevChannel: GlueContext): HResult;
begin
  Log('Left channel ' + prevChannel.name);
  if (channel <> nil) then
  begin
    Log('Now in channel ' + channel.GetContextInfo.name);
  end;
  Result := S_OK;
end;

function TForm1.HandleChannelData(const glueWindow: IGlueWindow;
  const channelUpdate: IGlueContextUpdate): HResult;
begin
  Result := S_OK;
end;

function TForm1.HandleConnectionStatus(State: GlueState;
  const Message: WideString; date: Int64): HResult;
var
  timer: TTimer;
begin
  Log(DateTimeToStr(GlueTimeToDateTime(date)) + ' UTC: ' + Message);
  if State = GlueState_Connected then
  begin
    TStyleManager.TrySetStyle('Carbon');
    timer := TTimer.Create(nil);
    timer.Interval := 150;
    timer.OnTimer := AnonToNotifyEvent(timer,
      procedure(_: TObject)
      begin
        timer.Enabled := false;
        timer.Destroy;

        try
          // register VCL form window as Glue Window to become sticky,
          // participate in Glue Groups and consume Glue channels
          BorderStyle := bsNone;
          BorderIcons := [];
          glueWindow := G42.RegisterGlueWindow(Self.Handle, Self);
        except
          on E: Exception do
            Log(E.ClassName + ' error raised, with message : ' + E.Message);
        end;

      end);

    FInstanceId := G42.GetInstance.InstanceId;
    Log('InstanceId is ' + FInstanceId);

    // register invocation endpoint - so any other Glue peer can invoke this
    // this example shows usage of lambda handler
    // or implement IGlueRequestHandler in the VCL Form and pass self instead
    Log('Registering T42.CaseList.Update');
    G42.RegisterMethod('T42.CaseList.Update', TGlueRequestHandler.Create(
      procedure(Method: GlueMethod; caller: GlueInstance;
        requestArgs: TArray<GlueContextValue>;
        resultCallback: IGlueServerMethodResultCallback;
        requestArgsSA: PSafeArray)
      var
        gr: GlueResult;
        gv: GlueValue;
        action: string;
        Row: Integer;
      begin
        // skip self calls
        Log('Method ' + Method.name + ' invoked by ' + caller.ApplicationName);
        if caller.InstanceId <> FInstanceId then
        begin
          action := LowerCase(G42.GetValueByFieldPath(requestArgsSA, 'action')
            .StringValue);
          gv := G42.GetValueByFieldPath(requestArgsSA, 'data.id');

          // find the row
          Row := FCaseListGrid.Cols[0].IndexOf(IntToStr(gv.LongValue));
          if Row < 0 then
          begin
            ZeroMemory(@gr, sizeof(gr));
            gr.Status := GlueMethodInvocationStatus_Failed;
            gr.Values := nil; // CreateContextValues(requestArgs);
            gr.Message := 'ID ' + IntToStr(gv.LongValue) + ' does not exist';

            resultCallback.SendResult(gr);
          end;

          if action = 'select' then
          begin
            FCaseListGrid.Row := Row;
          end
          else if action = 'update' then
          begin
            gv := G42.GetValueByFieldPath(requestArgsSA, 'data.description');
            if gv.GlueType = GlueValueType_String then
              FCaseListGrid.Cells[1, Row] := gv.StringValue;

            gv := G42.GetValueByFieldPath(requestArgsSA, 'data.content');
            if gv.GlueType = GlueValueType_String then
              FCaseListGrid.Cells[2, Row] := gv.StringValue;

            gv := G42.GetValueByFieldPath(requestArgsSA, 'data.contacts');
            if gv.IsArray and (gv.GlueType = GlueValueType_String) then
              FCaseListGrid.Cells[3, Row] := string.Join(',',
                TSafeArrayExpander<WideString, string>.AsArray(gv.StringArray,
                function(ws: WideString): string
                begin
                  Result := ws;
                end));
          end;

        end;

        ZeroMemory(@gr, sizeof(gr));
        gr.Status := GlueMethodInvocationStatus_Succeeded;
        gr.Values := nil; // CreateContextValues(requestArgs);
        gr.Message := 'OK';

        resultCallback.SendResult(gr);
      end), '', '', nil);
  end;

  Result := S_OK;
end;

function TForm1.HandleException(const Message: WideString;
ex: GlueValue): HResult;
begin
  Result := S_OK;
end;

function TForm1.HandleGlueContext(context: GlueContext;
created: WordBool): HResult;
begin
  Log('Discovered Glue context ' + context.name);
  Result := S_OK;
end;

function TForm1.HandleInstanceStatus(Instance: GlueInstance;
active: WordBool): HResult;
begin
  Log(Instance.ApplicationName + ' is ' + BoolToStr(active, true));
  Result := S_OK;
end;

function TForm1.HandleMethodStatus(Method: GlueMethod;
active: WordBool): HResult;
begin
  Result := S_OK;
end;

function TForm1.HandleWindowDestroyed(const glueWindow: IGlueWindow): HResult;
begin
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
  glueWindow.SetTitle('Case List');
  Result := S_OK;
  Cursor := crDefault;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  Image1.Enabled := false;
  Image1.Picture := FEnabledGluePic;
  InitializeGlue;
end;

procedure TForm1.Image1MouseEnter(Sender: TObject);
begin
  if G42 <> nil then
    exit;

  Image1.Picture := FEnabledGluePic;
end;

procedure TForm1.Image1MouseLeave(Sender: TObject);
begin
  if G42 <> nil then
    exit;
  Image1.Picture := FDisabledGluePic;
end;

procedure TForm1.InitializeGlue;
var
  inst: GlueInstance;
  cfg: GlueConfiguration;
begin
  Log('Intializing Glue');
  try
    // create the Glue42 com object
    G42 := CoGlue42.Create() as IGlue42;
  except
    on E: Exception do
    begin
      Log(E.ClassName + ' raised: ' + E.Message);
      exit;
    end;
  end;
  try
    // subscribe to all events
    G42.Subscribe(Self);

    // configure own identity
    ZeroMemory(@inst, sizeof(inst));
    inst.ApplicationName := 'CaseList';
    inst.Metadata := nil;

    ZeroMemory(@cfg, sizeof(cfg));
    cfg.LoggingConfigurationPath := 'GlueCOMDelphiLog.config';
    cfg.AsyncInit := true;
    G42.OverrideConfiguration(cfg);

    Log('Starting Glue...');
    // init and start the Glue42
    G42.Start(inst);
  except
    on E: Exception do
    begin
      Log(E.ClassName + ' raised: ' + E.Message);
      exit;
    end;
  end;
end;

procedure TForm1.Log(Message: string);
begin
  Memo1.Lines.Add(Message);
end;

procedure TForm1.caseListGridCanEdit(Sender: TObject; Col, Row: Longint;
var CanEdit: Boolean);
begin
  CanEdit := (Row > 0) and (Col = 1);
end;

procedure TForm1.caseListGridDrawCell(Sender: TObject; ACol, ARow: Integer;
Rect: TRect; State: TGridDrawState);
var
  Grid: TStringGrid;
begin
  Grid := TStringGrid(Sender);
  if ARow = Grid.Row then
  begin
    with Grid.Canvas do
    begin
      if G42 <> nil then
        Brush.Color := clBlue
      else
        Brush.Color := clDkGray;
      Brush.Style := bsSolid;
      Dec(Rect.Left, 4);
      FillRect(Rect);
      TextRect(Rect, Rect.Left + 6, Rect.Top + 5, Grid.Cells[ACol, ARow]);

      if gdFocused in State then
        DrawFocusRect(Rect);
    end;
  end;
end;

procedure TForm1.caseListGridSelectCell(Sender: TObject; ACol, ARow: Integer;
var CanSelect: Boolean);
var
  id: Integer;
  args: String;
begin
  if G42 <> nil then
  begin
    id := StrToInt(FCaseListGrid.Cells[0, ARow]);
    args := '{action: "select", data:{id: ' + IntToStr(id) + '}}';
    OutputDebugStringW(PWideChar(args));
    G42.InvokeMethodsWithJson('T42.CaseList.Update', args, nil, true,
      GlueInstanceIdentity_None, nil, 5000, '');
  end;
  FCaseListGrid.Invalidate;
  Cursor := crDefault;
end;

procedure TForm1.caseListGridSetEditText(Sender: TObject; ACol, ARow: Integer;
const Value: string);
var
  id: Integer;
  args: String;
begin
  if G42 = nil then
    exit;

  if not FCaseListGrid.EditorMode then
  begin
    id := StrToInt(FCaseListGrid.Cells[0, ARow]);
    args := '{action: "update", data:{id: ' + IntToStr(id) + ', description: "'
      + Value + '"}}';
    OutputDebugStringW(PWideChar(args));
    G42.InvokeMethodsWithJson('T42.CaseList.Update', args, nil, true,
      GlueInstanceIdentity_None, nil, 5000, '');
  end;
end;

end.
