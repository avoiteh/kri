unit phpscript;

interface

type
  TPHPscript = class
  public
    baseDir:string;

    script:string;
    filename:string;
    path:string;
    title:string;
    note:string;

    inputData:string;
    outputData:string;

    constructor Create(_filename, _baseDir:string);
    procedure Run;
    function RunAppAndWait(CmdLine, WorkDir: string): boolean;
  end;

implementation

uses
  SysUtils,Windows;

constructor TPHPscript.Create(_filename, _baseDir:string);
var
  tf:TextFile;
  s:string;
  p0:integer;
  flagIsNote:boolean;
begin
filename:=ExtractFileName(_filename);
path:=ExtractFilePath(_filename);

baseDir:=_baseDir;

title:='';
note:='';
flagIsNote:=false;

AssignFile(tf, _filename);
Reset(tf);
while ((title='') or (note='')) and not eof(tf) do
begin
  readln(tf,s);
  if Length(s)>0 then
    if s[1]='@' then
    begin
      p0:=pos('@title:',s);
      if p0=1 then
        title:=copy(s,8, Length(s));

      p0:=pos('@note',s);
      if p0=1 then
      begin
        flagIsNote:=true;
        note:=copy(s,6,Length(s));
      end
      else if flagIsNote then
      begin
        p0:=pos('@note',s);
        if p0=1 then
          flagIsNote:=false
        else
          note:=note+#13#10+s;
      end;
    end;
end;

CloseFile(tf);
end;

procedure TPHPscript.Run;
var
  tf:textfile;
begin
AssignFile(tf, baseDir+'php/tmp/input_data.php');
Rewrite(tf);
writeln(tf,'<?php');
writeln(tf, inputData);
writeln(tf,'?>');
CloseFile(tf);

CopyFile(PChar(path+filename), PChar(baseDir+'php/tmp/'+filename), true);
end;


function TPHPscript.RunAppAndWait(CmdLine, WorkDir: string): boolean;
var
  SI: TStartupInfo;
  PI : TProcessInformation;
begin
  ZeroMemory(@SI, SizeOf(SI));
  SI.cb := SizeOf(SI);
  Result := CreateProcess(nil, PChar(CmdLine), nil, nil, false, 0, nil, PChar(WorkDir), SI, PI); 
  if Result then
  begin
    CloseHandle(PI.hThread);
    WaitForSingleObject(PI.hProcess, INFINITE);
    CloseHandle(PI.hProcess)
  end
end;

end.
 