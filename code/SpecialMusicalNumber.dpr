program SpecialMusicalNumber;

uses
  System.StartUpCopy,
  FMX.Forms,
  LyricsCode in 'LyricsCode.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
