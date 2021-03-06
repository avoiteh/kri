unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, ExtCtrls, ShellCtrls, SynEditHighlighter,
  SynHighlighterPHP, SynEdit, OleCtrls, SHDocVw, Grids, ValEdit,
  PHPCustomLibrary, phpLibrary, PHPCommon, php4delphi, phpFunctions, MSHTML;

type
  TFormMain = class(TForm)
    PageControl: TPageControl;
    TabSheetScripts: TTabSheet;
    ShellTreeViewScripts: TShellTreeView;
    Splitter1: TSplitter;
    PageControlScripts: TPageControl;
    PopupMenuTabsScript: TPopupMenu;
    PopupMenuTreeScripts: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    SynPHPSyn1: TSynPHPSyn;
    TabSheetRun: TTabSheet;
    TabSheetReports: TTabSheet;
    ValueListEditorScripts: TValueListEditor;
    Splitter2: TSplitter;
    WebBrowserRun: TWebBrowser;
    WebBrowserReport: TWebBrowser;
    psvPHP1: TpsvPHP;
    PHPLibrary1: TPHPLibrary;
    Run1: TMenuItem;
    PHPEngine1: TPHPEngine;
    PHPSystemLibrary1: TPHPSystemLibrary;
    procedure FormActivate(Sender: TObject);
    procedure ShellTreeViewScriptsDblClick(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure PHPLibrary1Functions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure Run1Click(Sender: TObject);
  private
    { Private declarations }
  public
    RootDir:string;
    scriptTab:array of TTabSheet;
    scriptSynEd:array of TSynEdit;
    WebLoad, GloLoadingFlag:boolean;
    { Public declarations }
    function  addScriptTab(filename:string):integer;
    procedure closeScriptTab(number:integer);
    function  DeleteDir(Dir: string): boolean;
    function  LoadPage(action:string):boolean;
    function  str_replace(subst, deststr, mainstr:string):string;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.FormActivate(Sender: TObject);
begin
RootDir:= ExtractFilePath(ParamStr(0));
ShellTreeViewScripts.Root:=RootDir+'script';
//ShellTreeViewScripts.Refresh(ShellTreeViewScripts.Selected.Parent);
//PHPEngine1.DLLFolder:=RootDir;//+'PHP\extention\';
//PHPEngine1.IniPath:=RootDir;//+'PHP\';
PHPEngine.StartupEngine;
end;

procedure TFormMain.ShellTreeViewScriptsDblClick(Sender: TObject);
begin
if FileExists(ShellTreeViewScripts.Path) then
  addScriptTab(ShellTreeViewScripts.Path);
end;

function  TFormMain.addScriptTab(filename:string):integer;
var
  i,len:integer;
begin
len:=Length(scriptTab);

//���������, ����� ����� ����� ��� �������?
for i:=0 to len-1 do
begin
  if scriptTab[i].Caption=filename then
  begin
    PageControlScripts.ActivePageIndex:=i;
    exit;
  end;
end;

SetLength(scriptTab, len+1);
SetLength(scriptSynEd, len+1);

scriptTab[len]:=TTabSheet.Create(self);
scriptTab[len].PageControl:=PageControlScripts;
scriptTab[len].Align:=alClient;
scriptTab[len].Caption:=filename;

PageControlScripts.ActivePageIndex:=len;

scriptSynEd[len]:=TSynEdit.Create(self);
scriptSynEd[len].Parent:=scriptTab[len];
scriptSynEd[len].Align:=alClient;
scriptSynEd[len].Lines.LoadFromFile(filename);
scriptSynEd[len].Highlighter:=SynPHPSyn1;
scriptSynEd[len].Gutter.ShowLineNumbers:=true;
scriptSynEd[len].WordWrap:=true;

scriptSynEd[len].SetFocus;
end;

procedure TFormMain.closeScriptTab(number:integer);
var
  i,len:integer;
begin
len:=Length(scriptTab);
scriptSynEd[number].Free;
scriptTab[number].Free;
Application.ProcessMessages;

for i:=number+1 to len-1 do
begin
  scriptSynEd[i-1]:=scriptSynEd[i];
  scriptTab[i-1]:=scriptTab[i];
end;
SetLength(scriptSynEd, len-1);
SetLength(scriptTab, len-1);
end;

procedure TFormMain.N5Click(Sender: TObject);
begin
closeScriptTab(PageControlScripts.ActivePageIndex);
end;

procedure TFormMain.N6Click(Sender: TObject);
var i:integer;
begin
i:=PageControlScripts.ActivePageIndex;
scriptSynEd[i].Lines.SaveToFile(scriptTab[i].Caption);
end;

procedure TFormMain.N3Click(Sender: TObject);
var
  Path:string;
begin
Path:=ShellTreeViewScripts.Path + '\'+ InputBox('������� ����� �������', '������� ��������:', '����� �������');
if DirectoryExists(Path) then
  ShowMessage('������� "'+Path+'" ��� ����!')
else
  MkDir(Path);
ShellTreeViewScripts.Refresh(ShellTreeViewScripts.Selected);
end;

procedure TFormMain.N4Click(Sender: TObject);
var
  Path:string;
  tf:TextFile;
begin
Path:=ShellTreeViewScripts.Path;
if not DirectoryExists(Path) then
  Path:=ExtractFileDir(Path);
Path:=Path + '\'+ InputBox('������� ����� ����', '������� ��������:', '.php');
if FileExists(Path) then
  ShowMessage('���� "'+Path+'" ��� ����!')
else
begin
  AssignFile(tf,Path);
  Rewrite(tf);
  writeln(tf,'<?php');
  writeln(tf,'//'+TimeToStr(Time));
  writeln(tf,'?>');
  CloseFile(tf);
  addScriptTab(Path);
end;
ShellTreeViewScripts.Refresh(ShellTreeViewScripts.Selected);
end;

function TFormMain.DeleteDir(Dir: string): boolean;
var
Found: integer;
SearchRec: TSearchRec;
begin
result := false;
//if IOResult <> 0 then
 ChDir(Dir);
if IOResult <> 0 then
begin
 ShowMessage('?? ???? ????? ? ???????: ' + Dir);
 exit;
end;
Found := FindFirst('*.*', faAnyFile, SearchRec);
while Found = 0 do
begin
 if (SearchRec.name <> '.') and (SearchRec.name <> '..') then
  if (SearchRec.Attr and faDirectory) <> 0 then
  begin
   if not DeleteDir(SearchRec.name) then
    exit;
   end
   else
    if not DeleteFile(SearchRec.name) then
    begin
     ShowMessage('?? ???? ??????? ????: ' + SearchRec.name);
     exit;
    end;
   Found := FindNext(SearchRec);
  end;
FindClose(SearchRec);
ChDir('..');
RmDir(Dir);
result := IOResult = 0;
end;

procedure TFormMain.N2Click(Sender: TObject);
begin
if MessageDlg('������� "'+ShellTreeViewScripts.Path+'"?', mtConfirmation, mbYesNoCancel, 0) = idYes then
  if DirectoryExists(ShellTreeViewScripts.Path) then
    DeleteDir(ShellTreeViewScripts.Path)
  else if FileExists(ShellTreeViewScripts.Path) then
    DeleteFile(ShellTreeViewScripts.Path);
ShellTreeViewScripts.Refresh(ShellTreeViewScripts.Selected.Parent);
end;

procedure TFormMain.PHPLibrary1Functions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant;
  ZendVar: TZendVariable; TSRMLS_DC: Pointer);
var
  s:string;
begin
PageControl.ActivePageIndex:=1;
Application.ProcessMessages;
s:=Parameters[0].Value;
ReturnValue:=LoadPage(s);
end;

procedure TFormMain.Run1Click(Sender: TObject);
var
  s:string;
  Document: IHtmlDocument2;
begin
s:=psvPHP1.Execute(scriptTab[PageControlScripts.ActivePageIndex].Caption);
PageControl.ActivePageIndex:=2;
Application.ProcessMessages;
WebBrowserReport.Navigate('about:'+s);
//ShowMessage(s);
end;

function  TFormMain.LoadPage(action:string):boolean;
var
  tmpdoc: IHTMLDocument2;
  s, test_URL:string;
  k,p1,ng,p0,TimeOut:integer;
  fl,goodload, ress:boolean;
  tt, oneSec:real;
begin
WebLoad:=true;
goodload:=false;
ng:=1;
TimeOut:=3;
GloLoadingFlag:=false;
oneSec:=1/24/60/60;
//�������� ������� ��������
while (not goodload) and WebLoad do
begin
   //MessageBox(0,PChar(action),'',MB_OK);
   GloLoadingFlag:=true;
   WebBrowserRun.Silent:=true;
   WebBrowserRun.Navigate(action);
   fl:=true;
   //������ ��������
   tt:=Time;
   Application.ProcessMessages;
   while (tt+TimeOut*oneSec>Time) and WebLoad do
   begin
     Sleep(100);
     Application.ProcessMessages;
   end;
   //���������� ����� �������� �������� �������� - 30 ������
   //���� �� ��� ����� �� ������� ���������� ��������, �� ��������� �������
   Cursor:=crHourGlass;
   while WebBrowserRun.Busy and (tt+30*oneSec>Time) and WebLoad do
     Application.ProcessMessages;
   Cursor:=crDefault;

   tmpdoc:=IHTMLDocument2(WebBrowserRun.Document);

   while fl and WebLoad do
   begin
     try
       s:=AnsiUpperCase(tmpdoc.body.outerHTML);
       fl:=false;
     except
       Application.ProcessMessages;
     end;
   end;

   s:=AnsiUpperCase(tmpdoc.body.innerHTML);
   p1:=pos(AnsiUpperCase('</body>'),s);
   while (p1=0) and WebLoad do
   begin
     Application.ProcessMessages;
     tmpdoc:=IHTMLDocument2(WebBrowserRun.Document);
     fl:=true;
     while fl and WebLoad do
     begin
       try
         s:=AnsiUpperCase(tmpdoc.body.outerHTML);
         fl:=false;
       except
         Application.ProcessMessages;
       end;
     end;
     p1:=pos(AnsiUpperCase('</body>'),s);
   end;

   p1:=pos(AnsiUpperCase('<td id="tableProps" valign="top" align="left"><img id="pagerrorImg" SRC="res://shdoclc.dll/pagerror.gif"'),s);
   test_URL:=tmpdoc.url;
   //���������� �� ����� http:// && www.
   p0:=pos('://',test_URL);
   if p0>0 then test_URL:=copy(test_URL,p0+3,Length(test_URL));
   p0:=pos('WWW.',AnsiUpperCase(test_URL));
   if p0>0 then test_URL:=copy(test_URL,p0+4,Length(test_URL));
   p0:=pos('://',action);
   if p0>0 then action:=copy(action,p0+3,Length(action));
   p0:=pos('WWW.',AnsiUpperCase(action));
   if p0>0 then action:=copy(action,p0+4,Length(action));

   if (test_URL[Length(test_URL)]='\') or
      (test_URL[Length(test_URL)]='/') then
   begin
      test_URL[Length(test_URL)]:=' ';
      test_URL:=Trim(test_URL);
   end;
   if (action[Length(action)]='\') or
      (action[Length(action)]='/') then
   begin
      action[Length(action)]:=' ';
      action:=Trim(action);
   end;
   //���������� %xy � �������� � �������
   test_URL:=str_replace('%20',' ', test_URL);
   test_URL:=str_replace('\','/',test_URL);
   action  :=str_replace('\','/',action);
   //BackPercentToChar(action);
   if ((AnsiUpperCase(test_URL) = AnsiUpperCase(action)) and
       (p1=0)) or
      (ng=0) then
   begin
     if ng>0 then ress:=true;
     goodload:=true;
     Application.ProcessMessages;
   end
   else
   begin
     goodload:=false;
     ress:=false;
     ng:=ng-1;
   end;
end;
Result:=ress;
end;

function TFormMain.str_replace(subst, deststr, mainstr:string):string;
var
  s,rs:string;
  p0,p1:integer;
begin
s:=mainstr;
rs:='';
p1:=length(subst);
while pos(subst, s)>0 do
begin
  p0:=pos(subst, s);
  rs:=rs+copy(s,1,p0-1)+deststr;
  s:=copy(s,p0+p1,length(s));
end;
rs:=rs+s;
Result:=rs;
end;
end.
