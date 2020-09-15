unit SConvert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, ExtCtrls, ZAbstractConnection,
  ZConnection, DB, DBCtrls, Grids, DBGrids, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractTable, ZDataset, LarryLogging, CurvyControls,
  uhtmcombo, Lucombo, dblucomb, TntStdCtrls, TntGrids, TntDBGrids;

function WideToUTF8(const WS: WideString): UTF8String;
function WideToAnsi(const WS: WideString): AnsiString;
function UTF8ToWide(const US: UTF8String): WideString;
function ReplaceFull(sentence:WideString): WideString;

implementation

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

function ReplaceFull(sentence:WideString): WideString;
var
S:WideString;
begin
  S:= StringReplace(sentence,'''' ,'\''',[rfReplaceAll]);
  S:= StringReplace(S,'£¨','(' ,[rfReplaceAll]);
  S:= StringReplace(S,'£©',')' ,[rfReplaceAll]);
  Result:=S;
end;

end.
