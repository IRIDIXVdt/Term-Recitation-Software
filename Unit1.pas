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
    TermInfoOutput: TLabel;
    ErrorMessage: TLabel;
    Label19: TLabel;
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
    procedure ShowDefinition();
    procedure HideDefinition();
    procedure Label5Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label19Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TermTemp = record//probably not using it
    Word: WideString;
    Date: WideString;
    Level: Double;
    Def: WideString;
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
  Log: LarryLogging.TLog;
  Number: Integer;
  TermList: NodePointer;
implementation

{$R *.dfm}
procedure TForm1.ShowDefinition();
begin
Label9.Visible:=True;
Label10.Visible:=True;
Label3.Visible:=True;
Label5.Visible:=True;
Label19.Visible:=False;
end;

procedure TForm1.HideDefinition();
begin

Label9.Visible:=False;
Label10.Visible:=False;
Label3.Visible:=False;
Label5.Visible:=False;
Label19.Visible:=True;
end;

procedure sysout(sentence : String);
begin
  Form1.TermInfoOutput.Caption := Form1.TermInfoOutput.Caption + #13 + sentence;
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

procedure createNewList();//create form with null
begin//var sampleList : NodePointer
  //sampleList := NIL;
  New(TermList);
  TermList := NIL;
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
//-------
New(NewTerm);
NewTerm^.data.ID:=tid;
NewTerm^.data.Level:=tlv;
Add(NewTerm);
end;

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
i:=1;
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
if(TermList<>NIL) then
begin;
//ShowMessage('Termlist not nil');
Try
  ZConnection1.StartTransaction;
  Try
    //------------------------------------------
    ZQuery1.Close;
    ZQuery1.SQL.Text:= 'SELECT TermID, Term, Definition,SampleSentence FROM termslistdefault WHERE  TermID =' + IntToStr(TermList^.data.ID);
    //---------
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


Try//现在设置背诵单词的数组
  ZConnection1.StartTransaction;
  Try
    //ExeSQL('SELECT * FROM termslistdefault where DATEDIFF(DateRecite,CURRENT_DATE)<1'); //现在可以使用当天需要被的单词了
    ZQuery1.Close;
    ZQuery1.SQL.Text:= 'SELECT * FROM termslistdefault where DATEDIFF(DateRecite,CURRENT_DATE)<1';
    ZQuery1.Active:=True;

    ZConnection1.Commit;
    createNewList();
    with DataSource1.DataSet do
      begin
      First;
      while not eof do
        begin{
        New(NewTerm);
        NewTerm^.data.ID:=StrToInt(UTF8ToWide(FieldByName('TermID').AsString));
        NewTerm^.data.Level:=StrToInt(UTF8ToWide(FieldByName('Level').AsString));
        Add(NewTerm);  }
        AddTerm(StrToInt(UTF8ToWide(FieldByName('TermID').AsString)),  StrToInt(UTF8ToWide(FieldByName('Level').AsString)));
        next;
        end;
    //First;
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
end;

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
j:LongInt;
i: integer;
begin
//Log.AddLog(Edit3.Text);
//FileHandle := FileCreate('DailyNumber.log');
{ Write out the number daily recite terms. }
//FileWrite(FileHandle , Edit3.Text , SizeOf(Edit3.Text) );
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
    ZQuery1.SQL.Text:= 'SELECT * FROM termslistdefault WHERE LEVEL = 0;';
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
    remove(1);
    end;
    display();//显示单词列表
    HideDefinition();//隐藏单词解释
    ShowMainScreen();//打开主界面

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

procedure TForm1.Label5Click(Sender: TObject); //背出来了
var
newTerm:NodePointer;
index: Integer;
Interval:Integer;
begin
HideDefinition();
if(TermList<>NIL) then
  begin
  case TermList^.data.Level of
    0: index:=4;
    1: index:=6;
    2: index:=8;
    else index:=0;//this means we going to remove the term
    end;
    if(index=0)then
    begin
      //------
    Case TermList^.data.Level of
      0: Interval:=1;
      1: Interval:=1;
      2: Interval:=1;
      3: Interval:=1;
      4: Interval:=2;
      5: Interval:=4;
      6: Interval:=7;
      7: Interval:=15;
    ELSE Interval:=30;
    end;
      Try
        ZConnection1.StartTransaction;
       {ShowMessage('Update termslistdefault set level = ' + IntToStr(TermList^.data.Level) +
        ' WHERE TermID = ' + IntToStr(tid) + ';');
        ExeSQL('Update termslistdefault set level = ' + IntToStr(TermList^.data.Level) +
        ' WHERE TermID = ' + IntToStr(tid) + ';');
        ExeSQL(' Update termslistdefault set DateRecite = DATE_ADD(CURRENT_DATE,INTERVAL( ' +
          ' CASE level ' +
	          ' WHEN 0 then 1 ' +
	          ' WHEN 1 then 1 ' +
	          ' WHEN 2 then 1 ' +
	          ' WHEN 3 then 1 ' +
	          ' WHEN 4 then 2 ' +
	          ' WHEN 5 then 4 ' +
	          ' WHEN 6 then 7 ' +
	          ' WHEN 7 then 15 ' +
	          ' ELSE 30 end ) day ) ' +
          ' Where TermID = 17 ' + IntToStr(tid));}
          ExeSQL('UPDATE termslistdefault SET LEVEL = ' + IntToStr(TermList^.data.Level) +
          ', DateRecite = DATE_ADD( CURRENT_DATE, INTERVAL ( ' + IntToStr(Interval) +
          ' ) DAY ) WHERE TermID = ' + IntToStr(TermList^.data.ID));
        ZConnection1.Commit;
      Except
        ZConnection1.Rollback;
        ShowMessage('Cannot update the next recite date of the term.');
      end;
      Remove(1);
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

procedure TForm1.Label3Click(Sender: TObject); //没背出来  
var
newTerm:NodePointer;
begin
HideDefinition();
if(TermList<>NIL)then
  begin
    New(NewTerm);
    NewTerm^.data.ID:=TermList^.data.ID;
    NewTerm^.data.Level:=0;
    Remove(1);//移除
    Add(4,NewTerm);
  end;
ShowMainScreen();
end;

procedure TForm1.Label19Click(Sender: TObject); //显示单词意思
begin
ShowDefinition();
end;

end.
