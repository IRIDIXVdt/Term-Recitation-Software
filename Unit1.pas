unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, ExtCtrls, ZAbstractConnection,
  ZConnection, DB, DBCtrls, Grids, DBGrids, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractTable, ZDataset, LarryLogging;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Label5: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Panel2: TPanel;
    Label11: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Panel3: TPanel;
    Label14: TLabel;
    Panel4: TPanel;
    Label15: TLabel;
    Edit3: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    ZConnection1: TZConnection;
    ZTable1: TZTable;
    DataSource1: TDataSource;
    Label16: TLabel;
    Label17: TLabel;
    ZQuery1: TZQuery;
    Label18: TLabel;
    Memo1: TMemo;
    Edit4: TEdit;
    ZQuery2: TZQuery;
    DataSource2: TDataSource;
    Edit5: TEdit;
    StringGrid1: TStringGrid;
    Edit6: TEdit;
    Edit7: TEdit;
    procedure ExeSQL(input:WideString);
    procedure InsertTerm(term:WideString;Defi:WideString;Sample:WideString);
    procedure Exit1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HideAll();
    procedure Label2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure ShowMainScreen();
    procedure Label18Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure SyncGrid();
    procedure Label16Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    function getDailyNumber():String;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Term = record
    Word: WideString;
    Date: WideString;
    Level: Double;
    Def: WideString;
  end;

var
  Form1: TForm1;
  Log: LarryLogging.TLog;
  Number: Integer;
implementation

{$R *.dfm}
function WideToUTF8(const WS: WideString): UTF8String;
var
  len: integer;
  us: UTF8String;
begin
  Result:='';
  if (Length(WS) = 0) then
    exit;
  len:=WideCharToMultiByte(CP_UTF8, 0, PWideChar(WS), -1, nil, 0, nil, nil);
  SetLength(us, len);
  WideCharToMultiByte(CP_UTF8, 0, PWideChar(WS), -1, PChar(us), len, nil, nil);
  Result:=us;
end;

function WideToAnsi(const WS: WideString): AnsiString;
var len: integer;
s: AnsiString;
begin
Result:='';
if (Length(WS) = 0) then
exit;
len:=WideCharToMultiByte(CP_ACP, 0, PWideChar(WS), -1, nil, 0, nil, nil);
SetLength(s, len);
WideCharToMultiByte(CP_ACP, 0, PWideChar(WS), -1, PChar(s), len, nil, nil);
Result:=s;
end;

function UTF8ToWide(const US: UTF8String): WideString;
var
  len: integer;
  ws: WideString;
begin
  Result:='';
  if (Length(US) = 0) then
    exit;
  len:=MultiByteToWideChar(CP_UTF8, 0, PChar(US), -1, nil, 0);
  SetLength(ws, len);
  MultiByteToWideChar(CP_UTF8, 0, PChar(US), -1, PWideChar(ws), len);
  Result:=ws;
end;

procedure TForm1.SyncGrid();
var
i:integer;
begin
//Edit6.Text:=DBGrid1.Columns.Items[1].DefaultImeName;

i:=1;
 {
StringGrid1.Cells[1,1]:=UTF8ToWide(DBGrid1.DataSource.DataSet.FieldByName('Term').AsString);
StringGrid1.Cells[1,2]:=UTF8ToWide(DBGrid1.DataSource.DataSet.FieldByName('Term').AsString);
}
StringGrid1.RowCount := DataSource1.DataSet.RecordCount + 1;
 with DataSource1.DataSet do
  begin
    First;
    while not eof do
    begin
      StringGrid1.Cells[0,i] := UTF8ToWide(FieldByName('TermID').AsString);
      StringGrid1.Cells[1,i] := UTF8ToWide(FieldByName('Term').AsString);
      StringGrid1.Cells[2,i] := UTF8ToWide(FieldByName('Definition').AsString);
      next;
      i:=i+1;
    end;
    //First;
  end;


end;

procedure TForm1.ExeSQL(input:WideString);
begin
  ZQuery1.Close;
  ZQuery1.SQL.Text:=WideToUTF8(input);
  ZQuery1.ExecSQL;
end;

procedure TForm1.InsertTerm(term:WideString;Defi:WideString;Sample:WideString);
var
Input:WideString;
begin
Try
  ZConnection1.StartTransaction;
  Try
    Input:='Insert Into termslistdefault(Term,Definition,SampleSentence) VALUES(''' + term + ''',''' + Defi + ''',''' + Sample + ''');';
    ExeSQL(Input);
    //ExeSQL('Insert Into termslistdefault(Term,Definition,SampleSentence) VALUES(''くうき'',''air, concerning'',''null'');');
    ZConnection1.Commit;
  Except
    ZConnection1.Rollback;
    ShowMessage('Insert Term Failed.');
  end;
Finally
  //ZConnection1.AutoCommit:=True;
end;
end;

procedure TForm1.HideAll();
begin
Panel1.Visible:=False;
Panel2.Visible:=False;
Panel3.Visible:=False;
Panel4.Visible:=False;
end;

procedure TForm1.ShowMainScreen();  //hide everything except for review page
begin
HideAll();
Panel1.Left:= 72;Panel1.Top:= 24;Panel1.Width:= 920;Panel1.Height:= 500;Panel1.Visible:=True;
Try
  ZConnection1.StartTransaction;
  Try
    //------------------------------------------
    ZQuery1.Close;
    ZQuery1.SQL.Text:= 'SELECT TermID, Term, Definition,SampleSentence FROM termslistdefault WHERE  TermID=24;';
    ZQuery1.Active:=True;
    ZConnection1.Commit;
    with DataSource1.DataSet do
      begin
      Label8.Caption := UTF8ToWide(FieldByName('Term').AsString);
      Label9.Caption := UTF8ToWide(FieldByName('Definition').AsString);
      Label10.Caption := UTF8ToWide(FieldByName('SampleSentence').AsString);
      end;
    //ZConnection1.Commit;
  Except
    ZConnection1.Rollback;
    ShowMessage('Exception caught. Application terminating.');
    Application.Terminate;
  end;
Finally
  //ZConnection1.AutoCommit:=True;
end;
end;

function TForm1.getDailyNumber():String;
var
StrLst:TStringList;
number:String;
begin
StrLst:=TStringList.Create;
StrLst.LoadFromFile('DailyNumber.txt');
//ShowMessage(StrLst[StrLst.Count-1]);
//number:=WideStringToString(StrLst[StrLst.Count-1]);
number:=UTF8ToWide(StrLst[StrLst.Count-1]);
StrLst.Free;
result:=number;
end;
 {
function WideToAnsi(const WS: WideString): AnsiString;
var len: integer;
s: AnsiString;
begin
Result:='';
if (Length(WS) = 0) then
exit;
len:=WideCharToMultiByte(CP_ACP, 0, PWideChar(WS), -1, nil, 0, nil, nil);
SetLength(s, len);
WideCharToMultiByte(CP_ACP, 0, PWideChar(WS), -1, PChar(s), len, nil, nil);
Result:=s;
end;
     }
procedure TForm1.FormCreate(Sender: TObject);
var
  FileHandle: Integer;
  I: Integer;
begin
Edit3.Text:=getDailyNumber;
Number:=StrToInt(Edit3.Text);
//ShowMessage(getDailyNumber);
//Log:=LarryLogging.TLog.Create('DailyNumber.log');
{先准备好MySQL连接 以防出现任何库/表缺失等错误}
Try
  ZConnection1.StartTransaction;
  Try
    ExeSQL('SET NAMES UTF8');
    ExeSQL('CREATE DATABASE IF NOT EXISTS termsDefault DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;');
    //没有termsDefault 就新建她
    ExeSQL('USE termsDefault;');
    //USE test_db; 选定库
    ExeSQL('CREATE TABLE IF NOT EXISTS `termsListDefault` ('+
  '`TermID` int(11) NOT NULL AUTO_INCREMENT,'+
  '`Term` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,'+
  '`DateInsert` date NOT NULL,'+
  '`DateRecite` date NOT NULL,'+
  '`Definition` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,'+
  '`SampleSentence` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,'+
  '`level` int(11) DEFAULT ''0'','+
  'PRIMARY KEY (`TermID`)'+
') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;');
    //没有terms list表就新建她
    ZConnection1.Commit;
  Except
    ZConnection1.Rollback;
    ShowMessage('Exception caught. Application terminating.');
    Application.Terminate;
  end;
Finally
  //ZConnection1.AutoCommit:=True;
end;
  Form1.Width:=1080;
  Form1.Height:=750;//尺寸为750*1080
  Form1.Color:=clBlack; //设置背景为黑色， 默认灰色是为了方便开发
  Label1.Top:=648;Label2.Top:=648;Label4.Top:=648;Label6.Top:=648;Label7.Top:=648;
  ShowMainScreen();

Try//现在设置背诵单词的数组
  ZConnection1.StartTransaction;
  Try
    ExeSQL('SET NAMES UTF8');
    ExeSQL('CREATE DATABASE IF NOT EXISTS termsDefault DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;');
    //没有termsDefault 就新建她
    ExeSQL('USE termsDefault;');
    //USE test_db; 选定库
    ExeSQL('CREATE TABLE IF NOT EXISTS `termsListDefault` ('+
  '`TermID` int(11) NOT NULL AUTO_INCREMENT,'+
  '`Term` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,'+
  '`DateInsert` date NOT NULL,'+
  '`DateRecite` date NOT NULL,'+
  '`Definition` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,'+
  '`SampleSentence` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,'+
  '`level` int(11) DEFAULT ''0'','+
  'PRIMARY KEY (`TermID`)'+
') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;');
    //没有terms list表就新建她
    ZConnection1.Commit;
  Except
    ZConnection1.Rollback;
    ShowMessage('Exception caught. Application terminating.');
    Application.Terminate;
  end;
Finally
  //ZConnection1.AutoCommit:=True;
end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
ShowMainScreen();
end;

procedure TForm1.Label4Click(Sender: TObject);
begin
HideAll();
Panel2.Left:= 72;Panel2.Top:= 24;Panel2.Width:= 920;Panel2.Height:= 500;Panel2.Visible:=True;
end;

procedure TForm1.Label6Click(Sender: TObject);//select words
begin
HideAll();
Panel3.Left:= 72;Panel3.Top:= 24;Panel3.Width:= 920;Panel3.Height:= 500;Panel3.Visible:=True;
//ZQuery1.SQL
Try
  ZConnection1.StartTransaction;
  Try
    //ExeSQL('SELECT TermID, SELECT TermID, Term, Definition  FROM termslistdefault;');
    ZQuery1.Close;
    ZQuery1.SQL.Text:= 'SELECT TermID, Term, Definition  FROM termslistdefault;';
    ZQuery1.Active:=True;
    ZConnection1.Commit;

    //Edit5.Text:=UTF8ToWide(DBGrid1.DataSource.DataSet.FieldByName('Term').AsString);
    //DBGrid1.Visible:=False;
    //StringGrid1.Height:=280;
    Edit5.Visible:=False;
    Edit6.Visible:=False;
    Label17.Visible:=False;
    SyncGrid();
  Except
    ZConnection1.Rollback;
    ShowMessage('Show List Failed.');
  end;
Finally
  //ZConnection1.AutoCommit:=True;
end;
   { ZQuery2.Close;
    ZQuery2.SQL.Text:= 'SELECT TermID, SELECT TermID, Term, Definition  FROM termslistdefault;';
    ZQuery2.Active:=True; }

end;

procedure TForm1.Label7Click(Sender: TObject);//Setting
begin    
HideAll();
Panel4.Left:= 72;Panel4.Top:= 24;Panel4.Width:= 920;Panel4.Height:= 500;Panel4.Visible:=True;
Edit3.setfocus();
end;


procedure TForm1.Label12Click(Sender: TObject);
var
//FileHandle: Integer; }
S:String;
F:TextFile;
i:LongInt;
begin
//Log.AddLog(Edit3.Text);
//FileHandle := FileCreate('DailyNumber.log');
{ Write out the number daily recite terms. }
//FileWrite(FileHandle , Edit3.Text , SizeOf(Edit3.Text) );
S := Edit3.Text;
if TryStrToInt(Edit3.Text,i) AND (StrToInt(Edit3.Text)>0) then
begin
  AssignFile(F, 'DailyNumber.txt'); // 将C:\MyFile.txt文件与F变量建立连接，后面可以使用F变量对文件进行操作。
  Rewrite(F); // 创建新文件
  Writeln(F, S); // 将S变量中的内容写入文本中
  CloseFile(F);
  ShowMessage('修改成功！')
end
else
  ShowMessage('Invalid input, try again');

end;


procedure TForm1.Label18Click(Sender: TObject);
begin
  InsertTerm(Edit1.Text,Edit2.Text,Memo1.Lines.Text);
  Label18.Caption:='录入成功';
  //tcaption
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
Edit1.Text:='';
Edit2.Text:='';
Memo1.Text:='';
Label18.Caption:='添加';
end;

procedure TForm1.Label16Click(Sender: TObject);
var
index:Integer;
begin
Try
  ZConnection1.StartTransaction;
  ExeSQL('DELETE FROM termslistdefault WHERE TermID = ' + Edit4.Text + ';');

  //ZConnection1.Commit;

  ZQuery1.Close;
  ZQuery1.SQL.Text:= 'SELECT TermID, Term, Definition  FROM termslistdefault;';
  ZQuery1.Active:=True;
  ZConnection1.Commit;
  SyncGrid();
  { HideAll();
  Panel3.Visible:=True;}
Except
  ZConnection1.Rollback;
  ShowMessage('Invalid Index. Cannot delete item.');
end;



end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//Log.Destroy;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin;
end;

end.
