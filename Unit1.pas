unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, ExtCtrls, ZAbstractConnection,
  ZConnection, DB, DBCtrls, Grids, DBGrids, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractTable, ZDataset;

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
    RichEdit1: TRichEdit;
    Panel4: TPanel;
    Label15: TLabel;
    Edit3: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    ZConnection1: TZConnection;
    ZTable1: TZTable;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Label16: TLabel;
    Label17: TLabel;
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

implementation

{$R *.dfm}
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
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  FileHandle: Integer;
  I: Integer;
begin
  Form1.Width:=1080;
  Form1.Height:=750;//尺寸为750*1080
  Form1.Color:=clBlack; //设置背景为黑色， 默认灰色是为了方便开发
  //12467
  Label1.Top:=648;Label2.Top:=648;Label4.Top:=648;Label6.Top:=648;Label7.Top:=648;
  //FileHandle:=FileOpen('testShowWord.txt', fmOpenWrite);
  ShowMainScreen();
  //Test Code
  //ListBox1.MultiSelect:= False;
  //Button.Caption = ’Move to Top’;
  //for I:= 1 to 10 do
    //ListBox1.Items.Add('Item' + IntToStr(I));  
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

procedure TForm1.Label6Click(Sender: TObject);
begin
HideAll();
Panel3.Left:= 72;Panel3.Top:= 24;Panel3.Width:= 920;Panel3.Height:= 500;Panel3.Visible:=True;
end;

procedure TForm1.Label7Click(Sender: TObject);//Setting
begin    
HideAll();
Panel4.Left:= 72;Panel4.Top:= 24;Panel4.Width:= 920;Panel4.Height:= 500;Panel4.Visible:=True;
Edit3.setfocus();
end;


procedure TForm1.Label12Click(Sender: TObject);
begin
ShowMainScreen();
end;

end.
