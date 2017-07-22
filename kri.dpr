program kri;

uses
  Forms,
  main in 'main.pas' {FormMain},
  phpscript in 'phpscript.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
