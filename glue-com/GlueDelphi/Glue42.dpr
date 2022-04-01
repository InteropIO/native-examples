program Glue42;

uses
  Vcl.Forms,
  Glue42MainForm in 'Glue42MainForm.pas' {Form1} ,
  ComObj,
  Winapi.ActiveX,
  GlueHelper in 'GlueHelper.pas',
  GlueCOM_TLB in 'GlueCOM_TLB.pas';

{$R *.res}

begin
  // CoUninitialize;

  // if (Succeeded(CoInitializeEx(nil, COINIT_MULTITHREADED))) then
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TForm1, Form1);
    Application.Run;
  end;
end.
