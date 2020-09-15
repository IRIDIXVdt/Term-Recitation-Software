program WRS03;

uses
  ExceptionLog,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  SConvert in 'SConvert.pas',
  TermLinkedList in 'TermLinkedList.pas';

{$R *.res}

begin
  Application.Initialize;
  // ReportMemoryLeaksOnShutdown := True; //加入该行，在程序运行并关闭后会提示你什么对象在哪里泄露了
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
