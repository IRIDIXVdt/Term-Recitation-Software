unit LarryLogging;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AppEvnts, SyncObjs, Registry;
Type
  TLog = class
  private
    FFileName :string;
    FCsWriteLogFile: TCriticalSection;
    FileHandle: Integer;
    StringBuff: WideString;
  public
    constructor Create(filename :string);overload;
    constructor Create;overload;
    destructor Destroy;
    procedure AddLog(const str :WideString);overload;
    function STW(const str: string):WideString;
    procedure TestLog();
  end;

implementation

function TLog.STW(const str: string):WideString;
var
Output:WideString;
i:Integer;
begin;
  Result:=Utf8Decode(AnsiToUtf8(str));
end;

constructor TLog.Create(filename:String);
begin
  StringBuff:='';
  FFileName:=filename;
  //FLogOpened := False;
  FCsWriteLogFile := TCriticalSection.Create;
  //FileHandle:=FileCreate(fileName);
  // fmOpenWrite or fmShareDenyNone
  FileHandle:=FileOpen(fileName, fmOpenWrite);
  if(FileHandle>=0)then FileSeek(FileSeek(FileHandle,0,2),0,0)
  else FileHandle:=  FileCreate(fileName);
  inherited Create();
end;

constructor TLog.Create;
begin
  StringBuff:='';
  //FLogPath := ExtractFilePath(Application.ExeName) + 'Log\';
  FFileName:= ChangeFileExt (Application.Exename, '.log');
 // FLogOpened := False;
  FCsWriteLogFile := TCriticalSection.Create;
  FileHandle:=FileOpen('Default.log', fmOpenWrite);
  if(FileHandle>=0)then FileSeek(FileSeek(FileHandle,0,2),0,0)
  else FileHandle:=  FileOpen('Default.log', fmOpenWrite);
  
  inherited Create();
end;

destructor TLog.Destroy;
var
tmpPChar : PWideChar;
begin
   FCsWriteLogFile.Enter();//enter critical area
  try
    tmpPChar := PWideChar(StringBuff);
    //FileWrite(FileHandle, PWideChar(StringBuff)^, Length(tmpPChar) * SizeOf(WideChar)); //buffer
    FileWrite(FileHandle, tmpPChar^, Length(tmpPChar) * SizeOf(WideChar));
    //FileWrite(FileHandle, PWideChar(StringBuff)^, length(StringBuff));
  finally
    FCsWriteLogFile.Leave;
    FileClose(FileHandle);
    FCsWriteLogFile.Free();
    inherited;
  end;
end;

procedure TLog.AddLog(const str: WideString);
var
tmpStr: WideString;
tmpPChar: PWideChar;
begin
  FCsWriteLogFile.Enter();//enter critical area
  try
    //AppendStr(StringBuff, DateTimeToStr (Now)+ ', ' + Application.Exename + ' : ' + str + #13#10);
    StringBuff:=StringBuff + DateTimeToStr (Now)+ ', ' + Application.Exename + ' : ' + str + #13#10;
    if(length(StringBuff)>1000)then
      begin
      tmpPChar := PWideChar(StringBuff);
      //FileWrite(FileHandle, PWideChar(StringBuff)^, Length(tmpPChar) * SizeOf(WideChar)); //buffer
      FileWrite(FileHandle, tmpPChar^, Length(tmpPChar) * SizeOf(WideChar));
      StringBuff:='';      //wideString?
      end;
  finally
  FCsWriteLogFile.Leave;//leave critical area
  end;
  //---------test

end;

procedure TLog.TestLog();
var
tmpStr : WideString;
tmpStr2 : PWideChar;
begin

  tmpStr:='´íÎó´úÂëtestcode';
  ShowMessage(tmpStr);
  tmpStr:= DateTimeToStr (Now)+ ', ' + Application.Exename + ' : ' + tmpStr + #13#10#0;
  tmpStr2:=PWideChar(tmpStr);
  FileWrite(FileHandle, tmpStr2^, Length(tmpStr2) * SizeOf(WideChar));
  ShowMessage(tmpStr);
end;



end.



