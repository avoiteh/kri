unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, ExtCtrls, ShellCtrls, SynEditHighlighter,
  SynHighlighterPHP, SynEdit;

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
    procedure FormActivate(Sender: TObject);
    procedure ShellTreeViewScriptsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    RootDir:string;
    scriptTab:array of TTabSheet;
    scriptSynEd:array of TSynEdit;
    { Public declarations }
    function  addScriptTab(filename:string):integer;
    procedure closeScriptTab(number:integer);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.FormActivate(Sender: TObject);
begin
RootDir:= ExtractFilePath(ParamStr(0));
ShellTreeViewScripts.Root:=RootDir+'script';
end;

procedure TFormMain.ShellTreeViewScriptsDblClick(Sender: TObject);
begin
ShowMessage(ShellTreeViewScripts.Path);
end;

function  TFormMain.addScriptTab(filename:string):integer;
var
  len:integer;
begin
len:=Length(scriptTab);

SetLength(scriptTab, len+1);
SetLength(scriptSynEd, len+1);

scriptTab[len]:=TTabSheet.Create(self);
scriptTab[len].PageControl:=PageControlScripts;
scriptTab[len].Align:=alClient;
scriptTab[len].Caption:=filename;

scriptSynEd[len]:=TSynEdit.Create(self);
scriptSynEd[len].Parent:=scriptTab[len];
scriptSynEd[len].Align:=alClient;
scriptSynEd[len].Lines.LoadFromFile(filename);
scriptSynEd[len].SetFocus;
end;

procedure TFormMain.closeScriptTab(number:integer);
var
  i,len:integer;
begin
//
end;

end.
