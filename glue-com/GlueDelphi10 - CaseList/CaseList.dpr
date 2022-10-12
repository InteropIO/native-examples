program CaseList;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  GlueCOM_TLB in 'GlueCOM_TLB.pas',
  GlueHelper in 'GlueHelper.pas',
  mscorlib_TLB in 'mscorlib_TLB.pas',
  StringGridEx in 'StringGridEx.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
