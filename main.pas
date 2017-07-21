unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, ExtCtrls, ShellCtrls, SynEditHighlighter,
  SynHighlighterPHP, SynEdit, OleCtrls, SHDocVw, Grids, ValEdit;

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
    procedure FormActivate(Sender: TObject);
    procedure ShellTreeViewScriptsDblClick(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }
  public
    RootDir:string;
    scriptTab:array of TTabSheet;
    scriptSynEd:array of TSynEdit;
    { Public declarations }
    function  addScriptTab(filename:string):integer;
    procedure closeScriptTab(number:integer);
    function  DeleteDir(Dir: string): boolean;
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

//проверить, вдруг такая фигня уже открыта?
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
Path:=ShellTreeViewScripts.Path + '\'+ InputBox('Создать новый каталог', 'Введите название:', 'Новый каталог');
if DirectoryExists(Path) then
  ShowMessage('Каталог "'+Path+'" уже есть!')
else
  MkDir(Path);
ShellTreeViewScripts.Refresh(ShellTreeViewScripts.Selected);
end;

procedure TFormMain.N4Click(Sender: TObject);
var
  Path:string;
  tf:TextFile;
begin
Path:=ShellTreeViewScripts.Path + '\'+ InputBox('Создать новый файл', 'Введите название:', '.php');
if FileExists(Path) then
  ShowMessage('Файл "'+Path+'" уже есть!')
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
if MessageDlg('Удалить "'+ShellTreeViewScripts.Path+'"?', mtConfirmation, mbYesNoCancel, 0) = idYes then
  if DirectoryExists(ShellTreeViewScripts.Path) then
    DeleteDir(ShellTreeViewScripts.Path)
  else if FileExists(ShellTreeViewScripts.Path) then
    DeleteFile(ShellTreeViewScripts.Path);
ShellTreeViewScripts.Refresh(ShellTreeViewScripts.Selected.Parent);
end;

end.
