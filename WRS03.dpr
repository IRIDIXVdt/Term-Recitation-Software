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
  // ReportMemoryLeaksOnShutdown := True; //������У��ڳ������в��رպ����ʾ��ʲô����������й¶��
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.