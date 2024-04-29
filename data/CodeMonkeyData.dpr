// https://github.com/jimmckeeth/CodeMonkey-DelphiCode
program CodeMonkeyData;

uses
  Forms,
  CodeMonkeyCsv in 'CodeMonkeyCsv.pas' {CodeMonkeyDataForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCodeMonkeyDataForm, CodeMonkeyDataForm);
  Application.Run;
end.
