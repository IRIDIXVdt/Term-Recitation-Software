unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, ExtCtrls, ZAbstractConnection,
  ZConnection, DB, DBCtrls, Grids, DBGrids, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractTable, ZDataset, LarryLogging, CurvyControls,
  uhtmcombo, Lucombo, dblucomb, TntStdCtrls, TntGrids, TntDBGrids, SConvert;

type
  TForm1 = class(TForm)
    SaveAndExit: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Label5: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    FormChooseTerm: TLabel;
    Label7: TLabel;
    Label8: TLabel;
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
    DeleteByIndex: TLabel;
    Label17: TLabel;
    ZQuery1: TZQuery;
    SingleInsert: TLabel;
    Memo1: TMemo;
    Edit4: TEdit;
    ZQuery2: TZQuery;
    DataSource2: TDataSource;
    StringGrid1: TStringGrid;
    TermInfoOutput: TLabel;
    ErrorMessage: TLabel;
    Label19: TLabel;
    TntTerm: TTntEdit;
    TNTList: TTntMemo;
    TntEdit2: TTntEdit;
    MultipleInsert: TLabel;
    TntEdit3: TTntEdit;
    TntEdit4: TTntEdit;
    TntEdit5: TTntEdit;
    TntEdit6: TTntEdit;
    FullInsert: TLabel;
    LabelTerm: TLabel;
    Label1: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    TntDef: TTntEdit;
    Label6: TLabel;
    TestDef: TTntLabel;
    TestPos: TTntLabel;
    TestSen: TTntLabel;
    Label9: TLabel;
    Panel5: TPanel;
    Label10: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    TntEdit7: TTntEdit;
    TntEdit8: TTntEdit;
    TntEdit9: TTntEdit;
    TntEdit10: TTntEdit;
    TntEdit11: TTntEdit;
    TntEdit1: TTntEdit;
    Label16: TLabel;
    RDBName: TLabel;
    Label22: TLabel;
    procedure ExeSQL(input:WideString);

    //procedure Exit1Click(Sender: TObject);
    procedure SaveAndExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HideAll();
    procedure Label2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure FormChooseTermClick(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure ShowMainScreen();
    procedure SingleInsertClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure SyncGrid();
    procedure DeleteByIndexClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    function getDailyNumber():String;
    procedure ShowDefinition();
    procedure HideDefinition();
    procedure Label5Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label19Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MultipleInsertClick(Sender: TObject);
    procedure TntTermClick(Sender: TObject);
    procedure TNTListClick(Sender: TObject);
    procedure TntEdit2Click(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure TntEdit7Click(Sender: TObject);
    function SearchWord(Tid:Integer):WideString;
    procedure TntEdit1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TntEdit1Change(Sender: TObject);
    procedure TntEdit1KeyPress(Sender: TObject; var Key: Char);
    function getDataBaseName():WideString;
    procedure Label22Click(Sender: TObject);
  private
    procedure InsertTerm(term:WideString;Defi:WideString;Sample:WideString);overload;
    procedure InsertTerm(term:WideString);overload;
    procedure InsertDef(term:WideString;PoS:WideString;Defi:WideString);
  public
    { Public declarations }
  end;
  Term = record //declaring the node's data field
    ID:  Integer;
    Level: Integer;
  end;

  NodePointer = ^Node;
  Node = record //we declare the type of node here
    data : Term;
    nextPointer : NodePointer;
  end;

var
  Form1: TForm1;
  Number: Integer;
  TermList: NodePointer;
  DataBaseName: WideString;

implementation


{$R *.dfm}
procedure TForm1.ShowDefinition();
begin
TestDef.Visible:=True;
TestPos.Visible:=True;
TestSen.Visible:=True;
Label3.Visible:=True;
Label5.Visible:=True;
Label19.Visible:=False;
if(TermList^.data.level =0) then
Label22.Visible:=True;
end;

procedure TForm1.HideDefinition();
begin
TestDef.Visible:=False;
TestPos.Visible:=False;
TestSen.Visible:=False;
Label3.Visible:=False;
Label5.Visible:=False;
Label19.Visible:=True;
Label22.Visible:=False;
end;

procedure TForm1.HideAll();
begin
Panel1.Visible:=False;
Panel2.Visible:=False;
Panel3.Visible:=False;
Panel4.Visible:=False;
Panel5.Visible:=False;
end;

procedure sysout(sentence : String);
begin
  Form1.TermInfoOutput.Caption := Form1.TermInfoOutput.Caption + #13 + sentence;
end;


procedure createNewList();//create form with null

begin//var sampleList : NodePointer
  //sampleList := NIL;
  New(TermList);
  TermList := NIL;
end;

procedure display();//sampleList: NodePointer
var
  currentNode : NodePointer;
begin
  Form1.TermInfoOutput.Caption:='';
  sysout('TermInfoOutput'+#13);
  sysout(Format( '%-20s %-20s' + #13,['ID','Level']));
  currentNode := TermList;
  if(currentNode = NIL) then
  begin
    sysout('List empty, nothing to display');
  end;
  while(currentNode <> NIL) do
  begin
    sysout(Format( '%-20s %-20s;'
    ,[IntToStr(currentNode^.data.ID),IntToStr(currentNode^.data.Level)]));
   currentNode := currentNode^.nextPointer;
  end;//end of while-do
end;//end of the procedure

function getLength() : Integer;//return length of array
var
current:NodePointer;
length:Integer;
begin
current:= TermList;
length:=1;
if(TermList<>NIL) then
begin
while(current^.nextPointer<>NIL)do
  begin
    current:=current^.nextPointer;
    length:= length+1;
  end;
Result := length;
end
else
Result:=0;
end;


function remove (nodeIndex : Integer): nodePointer;overload;

//it's almost always going to be called by swap()

//so assume index won't cause exceptions

var

prevNode : NodePointer;

temp : NodePointer;

isFound : boolean;

i: Integer;

begin

  Form1.ErrorMessage.Caption:=#13 + 'Removing Index ' + IntToStr(nodeIndex) + '...';

  Form1.ErrorMessage.Caption := Form1.ErrorMessage.Caption+#13+'Deleting instance found';

  if(nodeIndex=1) then //prevNode = NIL, so the first item is the string

    begin

    temp:=TermList;

    TermList:=TermList^.nextPointer;

    end

  else    //the item is somewhere in the linkedlist

    begin

    prevNode:=TermList;

    if prevNode = nil then exit;

    for i := 1 to nodeIndex-2 do

      begin

        prevNode:=prevNode^.nextPointer;

      end;

      temp := prevNode^.nextPointer;

      prevNode^.nextPointer := temp^.nextPointer;

      temp^.nextPointer:=NIL;

    end;

  display;

  Result:=temp;

end;





procedure add (newNode : NodePointer);overload;//var sampleList : NodePointer;
var
  currentNode : NodePointer;
  prevNode : NodePointer;
begin
  if(TermList = NIL) then
    begin
      TermList := newNode;
      TermList^.nextPointer := NIL;
    end
  else
    begin
      currentNode := TermList;
      while(currentNode <> NIL) do
      begin
        prevNode := currentNode;
        currentNode := currentNode^.nextPointer;
      end;//end of traversal
      prevNode^.nextPointer := newNode;
      newNode^.nextPointer := NIL;
    end;//end of case where list is not empty
    display();
end;//end of procedure add


procedure add(index : Integer; newNode : NodePointer); overload;
var
i:Integer;
prevNode,currentNode:NodePointer;
indexFound:Boolean;
begin
  if(index>=0)then         //and numberValid(IntToStr(index))
  begin
  //-----------//
  indexFound := true;
  if(TermList = NIL) then
  begin
    add(NewNode);
  end
  else if(index = 1)  then
    begin
    newNode^.nextPointer:=TermList;
    TermList:=newNode;
    Form1.ErrorMessage.Caption:= #13 + 'add successful at first';
    end
  else if(TermList^.nextPointer = NIL) then
    begin
    Form1.ErrorMessage.Caption:='Error, no such index, adding to the end';
    Add(newNode);
    end
  else
    begin
      prevNode := TermList;
      currentNode := TermList^.nextPointer;
      for i:=1 to index-2 do
      begin
        if(currentNode^.nextPointer <> NIL) then
          begin
            prevNode := currentNode;
            currentNode := currentNode^.nextPointer;
          end
        else
          begin
            Form1.ErrorMessage.Caption:='Error, no such index, adding to the end';
            indexFound := false;
            add(newNode);
            break;
          end;
      end;
      //we arrive at the target position now
      if(indexFound) then
        begin
          prevNode^.nextPointer:=newNode;
          newNode^.nextPointer:=currentNode;
          Form1.ErrorMessage.Caption:= 'add successful at index' + IntToStr(index);
        end;
  end;
  end
  else
    begin
    Form1.ErrorMessage.Caption:=#13 + 'invalid index for addition or swapping';
    end;
  display();
end;



procedure move(One : Integer; Two : Integer); //move element index 2 to index 1
var
temp: Integer;
tempNode:NodePointer;
begin
tempNode := remove(Two);
tempNode^.nextPointer:=NIL;
add(One,tempNode);

display;
end;

procedure swap(One: Integer; Two: Integer);  //swap element index 1 and 2
begin
  if(Two>One)then
  begin
    move(One,Two);
    move(Two,One+1);
    Form1.ErrorMessage.Caption:=#13+'swap successful';
  end;
end;

procedure shuffle();
var
length:Integer;
i: Integer;
begin
length:=getLength();
//ShowMessage('length is ' + IntToStr(length));
for i:=0 to  length*2 do
  begin
  swap(random(length),random(length));
  end;
end;

procedure addTerm(tid: integer;tlv: integer);
var
NewTerm:NodePointer;
begin 
New(NewTerm);
NewTerm^.data.ID:=tid;
NewTerm^.data.Level:=tlv;
Add(NewTerm);
end;

procedure TForm1.SyncGrid();
var
i:integer;
ID,T,D:WideString;
begin
i:=1;
StringGrid1.RowCount := DataSource1.DataSet.RecordCount + 1;
 with DataSource1.DataSet do 
  begin
    First;
    while not eof do
    begin
      StringGrid1.Cells[0,i] := UTF8ToWide(UTF8String(FieldByName('TermID').AsString));
      StringGrid1.Cells[1,i] := UTF8ToWide(UTF8String(FieldByName('Term').AsString));
      StringGrid1.Cells[2,i] := UTF8ToWide(UTF8String(FieldByName('Definition').AsString));
      next;
      i:=i+1;
    end;
  end;
end;

procedure TForm1.ExeSQL(input:WideString);
begin
  ZQuery1.Close;
  ZQuery1.SQL.Text:=WideToUTF8(input);
  //ZQuery1.SQL.Text:=input;
  ZQuery1.ExecSQL;
end;

procedure TForm1.InsertTerm(term:WideString;Defi:WideString;Sample:WideString); //not using it anymore
var Input:WideString;
begin Try ZConnection1.StartTransaction;Try Input:='Insert Into termslistdefault(Term,Definition,SampleSentence) VALUES(''' + term + ''',''' + Defi + ''',''' + Sample + ''');';ExeSQL(Input);ZConnection1.Commit;
  Except ZConnection1.Rollback;ShowMessage('Insert Term Failed.');end;Finally end;
end;

procedure TForm1.InsertTerm(term:WideString);
var
T:WideString;
begin
Try
  //T:=//----  ----  ----  ----  ----  ----  ----  ----  ----  ----  ----  ----  
  ZConnection1.StartTransaction;
  Try
    ExeSQL('INSERT INTO termslist ( Term, DateInsert ) VALUES( '''+term+''', CURRENT_DATE );');
    ZConnection1.Commit;
  Except
    ZConnection1.Rollback;
    ShowMessage('Insert Term: '+term+' Failed.');
  end;
Finally
  //ZConnection1.AutoCommit:=True;
end;
end;

procedure TForm1.InsertDef(term:WideString;PoS:WideString;Defi:WideString);
begin Try
ZConnection1.StartTransaction;
  Try
    ExeSQL('INSERT INTO definitionlist ( TermID, PartOfSpeech, Definition ) (SELECT TermID, '''+PoS+''', '''+Defi+''' FROM termslist WHERE termslist.term = '''+term+''');');
    ZConnection1.Commit;
  Except
    ZConnection1.Rollback;
    ShowMessage('Insert Definition: ' + Defi + ' Failed.');
  end;
Finally end;
end;



procedure TForm1.ShowMainScreen();  //hide everything except for review page
begin
HideAll();Panel1.Left:= 72;Panel1.Top:= 24;Panel1.Width:= 960;Panel1.Height:= 500;
Panel1.Visible:=True; TestDef.Caption:='';TestPos.Caption:='';TestSen.Caption:='';
if(TermList<>NIL) then
begin;
//ShowMessage('Termlist not nil');
Try
  ZConnection1.StartTransaction;
  Try ZQuery1.Close;
    //ZQuery1.SQL.Text:= 'SELECT TermID, Term, Definition,SampleSentence FROM termslistdefault WHERE  TermID =' + IntToStr(TermList^.data.ID);
    ZQuery1.SQL.Text:= 'SELECT Term FROM termslist WHERE  TermID =' + IntToStr(TermList^.data.ID);
    ZQuery1.Active:=True;
    //ExeSQL('SELECT Term FROM termslist WHERE  TermID =' + IntToStr(TermList^.data.ID));
    Label8.Caption := UTF8ToWide(DataSource1.DataSet.FieldByName('Term').AsString);
    ZQuery1.SQL.Text:= '	SELECT * FROM definitionlist WHERE  TermID =' + IntToStr(TermList^.data.ID);ZQuery1.Active:=True;
    with DataSource1.DataSet do begin First;while not eof do begin
    TestDef.Caption :=TestDef.Caption + UTF8ToWide(UTF8String(FieldByName('Definition').AsString+ #13#10));  //'[' + UTF8ToWide(UTF8String(FieldByName('PartOfSpeech').AsString)) + '] ' +
    TestPos.Caption :=TestPos.Caption + UTF8ToWide('[' + UTF8String(FieldByName('PartOfSpeech').AsString + ']' + #13#10));
    next;end;end;
    ZQuery1.SQL.Text:= '	SELECT * FROM modellist WHERE  TermID =' + IntToStr(TermList^.data.ID);ZQuery1.Active:=True;
    with DataSource1.DataSet do begin First;while not eof do begin
    TestSen.Caption :=TestSen.Caption + UTF8ToWide(UTF8String(FieldByName('Sentence').AsString+ #13#10));
    TestSen.Caption :=TestSen.Caption + UTF8ToWide(UTF8String(FieldByName('Translation').AsString+ #13#10#13#10));
    next;end;end;
    ZConnection1.Commit;
  Except
    ZConnection1.Rollback;
    ShowMessage('Exception caught. Application terminating.');
    Application.Terminate;
  end;
Finally
end;
end
else
begin
HideAll();
Panel4.Left:= 72;Panel4.Top:= 24;Panel4.Width:= 920;Panel4.Height:= 500;Panel4.Visible:=True;
//Edit3.setfocus();
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

function TForm1.getDataBaseName():WideString;
var
StrLst:TStringList;
name:String;
begin
StrLst:=TStringList.Create;
StrLst.LoadFromFile('DataBaseName.txt');
name:=UTF8ToWide(StrLst[StrLst.Count-1]);
StrLst.Free;
result:=name;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  FileHandle: Integer;
  I: Integer;
begin
//DataBaseName:='termsUser';
DataBaseName:=getDataBaseName();
RDBName.Caption:=DataBaseName;
ZConnection1.LibraryLocation:=ExtractFilePath(Application.ExeName)+'libmysql_5.dll';
Edit3.Text:=getDailyNumber; Number:=StrToInt(Edit3.Text);
//ShowMessage(getDailyNumber);
//Log:=LarryLogging.TLog.Create('DailyNumber.log');
{先准备好MySQL连接 以防出现任何库/表缺失等错误}
Try
  ZConnection1.StartTransaction;
  Try
    ExeSQL('SET NAMES utf8mb4');  //-------------------------------------------------------------
    ExeSQL('CREATE DATABASE IF NOT EXISTS ' +DataBaseName+ ' DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;');
    //没有termsDefault 就新建她
    ExeSQL('USE ' + DataBaseName );
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
    ExeSQL('CREATE TABLE IF NOT EXISTS `termslist` ('
		+'`TermID` INT ( 11 ) NOT NULL AUTO_INCREMENT,`Term` VARCHAR ( 20 ) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,`DateInsert` date NOT NULL,`DateRecite` date NOT NULL,`level` INT ( 11 ) DEFAULT ''0'','
		+'PRIMARY KEY ( `TermID`)) ENGINE = INNODB AUTO_INCREMENT = 16 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;');
    ExeSQL('CREATE TABLE IF NOT EXISTS `definitionlist` (`TermID` INT ( 11 ) NOT NULL,`PartOfSpeech` VARCHAR ( 20 ) COLLATE utf8mb4_unicode_ci DEFAULT NULL,`Definition` VARCHAR ( 255 ) COLLATE utf8mb4_unicode_ci NOT NULL,'
    +'FOREIGN KEY ( `TermID` ) REFERENCES termslist ( `TermID` ) ) ENGINE = INNODB AUTO_INCREMENT = 16 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;');
    ExeSQL('CREATE TABLE IF NOT EXISTS `modellist` (`TermID` INT ( 11 ) NOT NULL,`Sentence` VARCHAR ( 255 ) COLLATE utf8mb4_unicode_ci NOT NULL,`Translation` VARCHAR ( 255 ) COLLATE utf8mb4_unicode_ci DEFAULT NULL,'
    +'FOREIGN KEY ( `TermID` ) REFERENCES termslist ( `TermID` ) ) ENGINE = INNODB AUTO_INCREMENT = 16 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;');
    ZConnection1.Commit;
  Except
    ZConnection1.Rollback;
    ShowMessage('Exception caught. Application terminating.');
    Application.Terminate;
  end;
Finally
  //ZConnection1.AutoCommit:=True;
end;
  Form1.Width:=1080;Form1.Height:=750;//尺寸为750*1080
  Form1.Color:=clBlack; //设置背景为黑色， 默认灰色是为了方便开发
  SaveAndExit.Top:=648;Label2.Top:=648;Label4.Top:=648;FormChooseTerm.Top:=648;Label7.Top:=648;Label9.Top:=648;

Try//现在设置背诵单词的数组
  ZConnection1.StartTransaction;
  Try
    //ExeSQL('SELECT * FROM termslistdefault where DATEDIFF(DateRecite,CURRENT_DATE)<1'); //现在可以使用当天需要被的单词了
    ZQuery1.Close;
    ZQuery1.SQL.Text:= 'SELECT * FROM termslist where DATEDIFF(DateRecite,CURRENT_DATE)<1';
    ZQuery1.Active:=True;

    ZConnection1.Commit;
    createNewList();
    with DataSource1.DataSet do
      begin
      First;
      while not eof do
        begin
        AddTerm(StrToInt(UTF8ToWide(FieldByName('TermID').AsString)),  StrToInt(UTF8ToWide(FieldByName('Level').AsString)));
        next;
        end;
      end;

  Except
    ZConnection1.Rollback;
    ShowMessage('Exception caught when initializing list. Application terminating.');
    Application.Terminate;
  end;
Finally
  //ZConnection1.AutoCommit:=True;
end;
    shuffle();//打乱单词顺序
    display();//显示单词列表
    HideDefinition();//隐藏单词解释
    ShowMainScreen();//打开主界面
end;

procedure TForm1.SaveAndExitClick(Sender: TObject);//释放内存 关闭程序
var prevNode:NodePointer;
begin
while (TermList<>NIL) do
begin
prevNode:=TermList;
TermList:=TermList^.nextPointer;dispose(prevNode);
end;

Application.Terminate;
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
ShowMainScreen();
end;

procedure TForm1.Label4Click(Sender: TObject);  //录入单词
begin
HideAll();Edit1.Visible:=False;Edit2.Visible:=False;Memo1.Visible:=False;Panel2.Left:= 72;Panel2.Top:= 24;Panel2.Width:= 920;Panel2.Height:= 600;Panel2.Visible:=True;Panel2.BorderStyle:=bsNone;
LabelTerm.Visible:=False;Label1.Visible:=False;Label18.Visible:=False;Label20.Visible:=False;Label21.Visible:=False;
end;

procedure TForm1.FormChooseTermClick(Sender: TObject);//select words
begin
HideAll();Panel3.Left:= 72;Panel3.Top:= 24;Panel3.Width:= 940;Panel3.Height:= 500;Panel3.Visible:=True;

Try
  ZConnection1.StartTransaction;
  Try
    //ExeSQL('SELECT TermID, SELECT TermID, Term, Definition  FROM termslistdefault;');
    //ZQuery1.Close;ZQuery1.SQL.Text:= 'SELECT TermID, Term, Definition  FROM termslistdefault;';ZQuery1.Active:=True;ZConnection1.Commit;
    ZQuery1.Close;ZQuery1.SQL.Text:= 'SELECT t.TermID,t.Term,d.Definition FROM termslist t LEFT JOIN definitionlist d on t.termID = d.TermID ORDER BY TermID;';
    ZQuery1.Active:=True;ZConnection1.Commit;
   Label17.Visible:=False;
    SyncGrid();
  Except
    ZConnection1.Rollback;
    ShowMessage('Show List Failed.');
  end;
Finally
end;

end;

procedure TForm1.Label7Click(Sender: TObject);//Setting
begin    
HideAll();
Panel4.Left:= 72;Panel4.Top:= 24;Panel4.Width:= 920;Panel4.Height:= 500;Panel4.Visible:=True;
Edit3.setfocus();
end;

procedure TForm1.Label9Click(Sender: TObject);
begin
HideAll();Edit1.Visible:=False;Edit2.Visible:=False;Memo1.Visible:=False;
Panel5.Left:= 72;Panel5.Top:= 24;Panel5.Width:= 920;Panel5.Height:= 600;Panel5.Visible:=True;Panel5.BorderStyle:=bsNone;
//LabelTerm.Visible:=False;Label1.Visible:=False;Label18.Visible:=False;Label20.Visible:=False;Label21.Visible:=False;

end;

procedure TForm1.Label12Click(Sender: TObject);
var
//FileHandle: Integer; }
S:String;
F:TextFile;
j:LongInt;
i: integer;
begin
S := Edit3.Text;
if TryStrToInt(Edit3.Text,j) AND (StrToInt(Edit3.Text)>0) then
begin
  AssignFile(F, 'DailyNumber.txt'); // 将C:\MyFile.txt文件与F变量建立连接，后面可以使用F变量对文件进行操作。
  Rewrite(F); // 创建新文件
  Writeln(F, S); // 将S变量中的内容写入文本中
  CloseFile(F);
  ShowMessage('修改成功！');
  //------------------------------------------------------------------------------------

Try//现在设置背诵新增单词的数组
  ZConnection1.StartTransaction;
  Try
    ZQuery1.Close;
    //ZQuery1.SQL.Text:= 'SELECT * FROM termslistdefault WHERE LEVEL = 0;';
    ZQuery1.SQL.Text:='SELECT * FROM termslist WHERE LEVEL = 0;';
    ZQuery1.Active:=True;

    ZConnection1.Commit;
    createNewList();
    with DataSource1.DataSet do
      begin
      First;
      while not eof do
        begin
        AddTerm(StrToInt(UTF8ToWide(FieldByName('TermID').AsString)),  StrToInt(UTF8ToWide(FieldByName('Level').AsString)));
        next;
        end;
    //First;
      end;
  Except
    ZConnection1.Rollback;
    ShowMessage('Exception caught when initializing list for new terms. Application terminating.');
    Application.Terminate;
  end;
Finally
  //ZConnection1.AutoCommit:=True;
end;
    shuffle();//打乱单词顺序
    While(getLength>StrToInt(Edit3.Text))do
    begin
    Dispose(remove(1));
    end;
    display();//显示单词列表
    HideDefinition();//隐藏单词解释
    ShowMainScreen();//打开主界面

end
else
  ShowMessage('Invalid input, try again');

end;


procedure TForm1.SingleInsertClick(Sender: TObject);
var
T,D:WideString;
begin{InsertTerm(Edit1.Text,Edit2.Text,Memo1.Lines.Text);}
  T:=ReplaceFull(TntTerm.Text);
  D:=ReplaceFull(TntDef.Text);
  If(T<>'')then
  begin
  InsertTerm(T); //StringReplace(TNTList.Lines.Strings[i],' ','$',[rfReplaceAll])// TntTerm.Text
  //If(D<>'') then begin InsertDef(D,'',T);  ShowMessage('Adding Definition'); end;
  InsertDef(T,'',D);
  SingleInsert.Caption:='录入成功';
  TntTerm.Text:='';TntDef.Text:='';
  end;
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
Edit1.Text:='';
Edit2.Text:='';
Memo1.Text:='';
SingleInsert.Caption:='添加';
end;

procedure TForm1.DeleteByIndexClick(Sender: TObject);
var
index:Integer;
begin
Try
  ZConnection1.StartTransaction;
  //ExeSQL('DELETE FROM termslistdefault WHERE TermID = ' + Edit4.Text + ';');
  ExeSQL('delete from definitionlist WHERE TermID = ' + Edit4.Text + ';');
  ExeSQL('delete from modellist WHERE TermID = ' + Edit4.Text + ';');
  ExeSQL('delete from termslist WHERE TermID = ' + Edit4.Text + ';');
  //ZConnection1.Commit;
  {delete from termslist WHERE TermID =20
	delete from model WHERE TermID =20
	delete from termslist WHERE TermID = 20}
  ZQuery1.Close;
  //ZQuery1.SQL.Text:= 'SELECT TermID, Term, Definition  FROM termslistdefault;';
  ZQuery1.SQL.Text:='SELECT t.TermID,t.Term,d.Definition FROM termslist t LEFT JOIN definitionlist d on t.termID = d.TermID ORDER BY TermID;';
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
//ZConnection1.free;
ZTable1.Free;
DataSource1.Free;
ZQuery1.Free;
ZConnection1.Free;
end;



procedure TForm1.Label5Click(Sender: TObject); //背出来了
var
newTerm:NodePointer;
index: Integer;
Interval:Integer;
begin
HideDefinition();
if(TermList<>NIL) then
  //ShowMessage('termlist level is: '+ inttostr(TermList^.data.Level));
  begin
  case TermList^.data.Level of
    0: index:=4;
    1: index:=6;
    2: index:=8;
    else index:=0;//this means we going to remove the term
    end;
    if(index=0)then
    begin
    Case TermList^.data.Level of 0: Interval:=1;1: Interval:=1;2: Interval:=1;3:
    Interval:=1;4: Interval:=2;5: Interval:=4;6: Interval:=7;7: Interval:=15;
    ELSE Interval:=30; end;
      Try
        ZConnection1.StartTransaction;
          ExeSQL('UPDATE termslist SET LEVEL = ' + IntToStr(TermList^.data.Level) +
          ', DateRecite = DATE_ADD( CURRENT_DATE, INTERVAL ( ' + IntToStr(Interval) +
          ' ) DAY ) WHERE TermID = ' + IntToStr(TermList^.data.ID));
        ZConnection1.Commit;
      Except
        ZConnection1.Rollback;ShowMessage('Cannot update the next recite date of the term.');
      end;Remove(1);
    end
    else
      begin
      New(NewTerm);
      NewTerm^.data.ID:=TermList^.data.ID;
      NewTerm^.data.Level:=TermList^.data.Level+1;
      Remove(1);
      Add(index,NewTerm);
      end;
  end;
  ShowMainScreen();
end;

function LTD(level:integer):integer;
var day:Integer;
begin
Case level of 0: day:=1;1: day:=1;2: day:=1;3:
    day:=1;4: day:=2;5: day:=4;6: day:=7;7: day:=15;
    ELSE day:=30;
Result:=day;
end;
end;

procedure TForm1.Label22Click(Sender: TObject);
begin
HideDefinition();
  Try
    ZConnection1.StartTransaction;
    ExeSQL('UPDATE termslist SET LEVEL = 9'+
    ', DateRecite = DATE_ADD( CURRENT_DATE, INTERVAL ( 30'+
    ' ) DAY ) WHERE TermID = ' + IntToStr(TermList^.data.ID));
    ZConnection1.Commit;
  Except
    ZConnection1.Rollback;
    ShowMessage('Cannot update the next recite date of the term.');
  end;
Dispose(Remove(1));
ShowMainScreen();
end;

procedure TForm1.Label3Click(Sender: TObject); //没背出来  
var
newTerm:NodePointer;
begin
HideDefinition();
if(TermList<>NIL)then
  begin
   Try ZConnection1.StartTransaction;
   ExeSQL('UPDATE termslist SET LEVEL = ' + IntToStr(TermList^.data.Level) +
          ', DateRecite = DATE_ADD( CURRENT_DATE, INTERVAL ( 1 ) DAY ) WHERE TermID = ' + IntToStr(TermList^.data.ID));
   ZConnection1.Commit;
   Except ZConnection1.Rollback;ShowMessage('Cannot update the next recite date of the term.');
   end;
    New(NewTerm);
    NewTerm^.data.ID:=TermList^.data.ID;
    NewTerm^.data.Level:=0;
    Dispose(Remove(1));//移除
    Add(4,NewTerm);
  end;
ShowMainScreen();
end;

procedure TForm1.Label19Click(Sender: TObject); //显示单词意思
begin
ShowDefinition();
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin ReleaseCapture;Perform(WM_SYSCOMMAND, $F017 , 0);end; //使窗口可以拖动

procedure TForm1.MultipleInsertClick(Sender: TObject);
var
i:Integer;
strs: TStrings;
Defi: WideString;
Word: WideString;
begin
for i := 0 to TNTList.Lines.Count-1 do
  if(TNTList.Lines.Strings[i]<>'')then
  begin
  strs:=TStringList.Create;
  strs.Delimiter:='`';
  strs.DelimitedText:= StringReplace(TNTList.Lines.Strings[i],' ','$',[rfReplaceAll]);
  Word:= ReplaceFull(StringReplace(strs[0],'$',' ',[rfReplaceAll]));
  Defi:= ReplaceFull(StringReplace(strs[1],'$',' ',[rfReplaceAll]));
  InsertTerm(Word);
  //ShowMessage(Word);
  //ShowMessage(Defi);
  if(Defi<>'')then InsertDef(Word,'',Defi);
  strs.Destroy;
  end;
ShowMessage('Muti-insert Successful');
MultipleInsert.Caption:='添加成功';
TNTList.Clear;
end;

{
   strs := TStringList.Create;
   strs.Delimiter:='`';
   strs.DelimitedText := StringReplace(TNTList.Lines.Strings[i],' ','$',[rfReplaceAll]);
   Label1.Caption:=StringReplace(strs[0],'$',' ',[rfReplaceAll]);
   Label2.Caption:=StringReplace(strs[1],'$',' ',[rfReplaceAll]);
}

procedure TForm1.TntTermClick(Sender: TObject);
begin
SingleInsert.Caption:='单个添加';MultipleInsert.Caption:='多行添加';FullInsert.Caption:='完整添加';
TntTerm.Text:='';TntDef.Text:='';
end;

procedure TForm1.TNTListClick(Sender: TObject);
begin
SingleInsert.Caption:='单个添加';MultipleInsert.Caption:='多行添加';FullInsert.Caption:='完整添加';
TNTList.Clear;
end;

procedure TForm1.TntEdit2Click(Sender: TObject);
begin
SingleInsert.Caption:='单个添加';MultipleInsert.Caption:='多行添加';FullInsert.Caption:='完整添加';
TntEdit2.Text:='';TntEdit3.Text:='';TntEdit4.Text:='';TntEdit5.Text:='';TntEdit6.Text:='';
LabelTerm.Visible:=True;Label1.Visible:=True;Label18.Visible:=True;Label20.Visible:=True;Label21.Visible:=True;
end;



procedure TForm1.TntEdit7Click(Sender: TObject);
begin
TnTEdit7.Text:='';
TntEdit8.Text:='';
TntEdit9.Text:='';
TntEdit10.Text:='';
TntEdit11.Text:='';
end;

function TForm1.SearchWord(Tid:Integer):WideString;
var
TargetTerm:WideString;
  begin
  
   ZConnection1.StartTransaction;
   Try
   ExeSQL('Select * From Termslist WHERE TermID = ' + IntToStr(Tid)+';');
   ZQuery1.Active:=True;
   TargetTerm := UTF8ToWide(UTF8String(DataSource1.DataSet.FieldByName('Term').AsString));
   ZConnection1.Commit;
   Result:=TargetTerm;
   Except ZConnection1.Rollback;ShowMessage('Cannot find the term with id: '+ IntToStr(Tid));
   Result:='N/A';
   end;
end;

procedure TForm1.TntEdit1Click(Sender: TObject);
var j:LongInt;
begin
if TryStrToInt(TntEdit1.Text,j) AND (StrToInt(TntEdit1.Text)>0 )then
begin end
else
TntEdit1.Text:='';
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
var
j:LongInt;
begin

end;

procedure TForm1.TntEdit1Change(Sender: TObject);
var
j:LongInt;
begin
if TryStrToInt(TntEdit1.Text,j) AND (StrToInt(TntEdit1.Text)>0) then
TntEdit7.Text:=SearchWord(StrToInt(TntEdit1.Text))
end;

procedure TForm1.TntEdit1KeyPress(Sender: TObject; var Key: Char);
var
j:LongInt;
begin
if TryStrToInt(TntEdit1.Text,j) AND (StrToInt(TntEdit1.Text)>0 )then
  if(Key = 'k')then
    begin
    Key:=#0;
    TntEdit1.Text:=IntToStr(StrToInt(TntEdit1.Text)+1);
    TntEdit7.Text:=SearchWord(StrToInt(TntEdit1.Text));
    end
  else if(Key = 'j')then
    begin
    Key:=#0;
    TntEdit1.Text:=IntToStr(StrToInt(TntEdit1.Text)-1);
    TntEdit7.Text:=SearchWord(StrToInt(TntEdit1.Text));
    end;
end;




end.
