unit StringGridEx;

interface

uses System.Classes, System.SysUtils, Vcl.Grids;

type
  TNotifyEventWrapper = class(TComponent)
  private
    FProc: TProc<TObject>;
  public
    constructor Create(Owner: TComponent; Proc: TProc<TObject>);
  published
    procedure Event(Sender: TObject);
  end;

  TCanEditEvent = procedure(Sender: TObject; Col, Row: Longint;
    var CanEdit: Boolean) of object;

  TStringGridEx = class(TStringGrid)
  private
    FOnCanEdit: TCanEditEvent;
  protected
    function CanEditShow: Boolean; override;
  public
    property OnCanEdit: TCanEditEvent read FOnCanEdit write FOnCanEdit;
  end;

function AnonToNotifyEvent(Owner: TComponent; Proc: TProc<TObject>)
  : TNotifyEvent;

implementation

constructor TNotifyEventWrapper.Create(Owner: TComponent; Proc: TProc<TObject>);
begin
  inherited Create(Owner);
  FProc := Proc;
end;

procedure TNotifyEventWrapper.Event(Sender: TObject);
begin
  FProc(Sender);
end;

function AnonToNotifyEvent(Owner: TComponent; Proc: TProc<TObject>)
  : TNotifyEvent;
begin
  Result := TNotifyEventWrapper.Create(Owner, Proc).Event;
end;

function TStringGridEx.CanEditShow: Boolean;
begin
  Result := inherited CanEditShow;

  if Result and Assigned(FOnCanEdit) then
    FOnCanEdit(Self, Col, Row, Result);
end;

end.
