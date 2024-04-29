unit CodeMonkeyImporter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBClient, Grids, DBGrids, ExtCtrls, DBCtrls;

type
  TForm16 = class(TForm)
    btnInport: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    btnSave: TButton;
    btnLoad: TButton;
    btnCurRow: TButton;
    btnFromHere: TButton;
    btrnAbandon: TButton;
    btnGetSpace: TButton;
    DBNavigator1: TDBNavigator;
    CodeMonkeyDS: TClientDataSet;
    CodeMonkeyDSIdx: TIntegerField;
    CodeMonkeyDSOriginal: TStringField;
    CodeMonkeyDSCode: TStringField;
    CodeMonkeyDSScript: TStringField;
    CodeMonkeyDSStart: TIntegerField;
    CodeMonkeyDSFinish: TIntegerField;
    CodeMonkeyDSDuration: TIntegerField;
    CodeMonkeyDSSpace: TIntegerField;
    CodeMonkeyDSOffset: TIntegerField;
    Button1: TButton;
    procedure btnInportClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure CodeMonkeyDSCalcFields(DataSet: TDataSet);
    procedure btnCurRowClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFromHereClick(Sender: TObject);
    procedure btrnAbandonClick(Sender: TObject);
    procedure CodeMonkeyDSBeforeInsert(DataSet: TDataSet);
    procedure CodeMonkeyDSAfterInsert(DataSet: TDataSet);
    procedure CodeMonkeyDSAfterDelete(DataSet: TDataSet);
    procedure btnGetSpaceClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fNextIndex: Integer;
    procedure SaveToXML;
    procedure SendCurRow;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form16: TForm16;

implementation

{$R *.dfm}

uses
  mmsystem,
  SndKey32;

procedure SetTarget;
begin
  AppActivate('SpecialMusicalNumber - Delphi 2010 - SpecialMusicalNumber.dproj');
end;

function GetKeyDelay(const s: string; const tt: Integer): integer;
var
  i, cnt: Integer;
  ignore: Boolean;
begin
  ignore := False;
  cnt := 0;
  for i := 1 to length(s) do
  begin
    if s[i] = '{' then
      ignore := True;
    if s[i] = '}' then
      ignore := False;

    if ignore then Continue;

    inc(cnt);
  end;
  if cnt = 0 then
    result := tt
  else
    result := tt div cnt;
end;

procedure TForm16.btnInportClick(Sender: TObject);
var
  tabFile, line: TStringList;
  I: Integer;
  J: Integer;
begin
  CodeMonkeyDS.Open;
  tabFile := TStringList.Create;
  try
    tabFile.LoadFromFile('C:\Users\Jim\Documents\Camtasia Studio\CodeMonkeyCode\CodeMonkey.txt');
    line := TStringList.Create;
    try
      line.Delimiter := #8;
      for I := 1 to tabFile.Count - 1 do
      begin
        line.DelimitedText := StringReplace(tabFile[i], ' ', '_', [rfReplaceAll]);
        CodeMonkeyDS.Append;
        for J := 0 to line.Count - 1 do
        begin
          if j < CodeMonkeyDS.Fields.Count then
            CodeMonkeyDS.Fields[j].AsString := StringReplace(line[j], '_', ' ', [rfReplaceAll]);
        end;
        CodeMonkeyDS.Post;
      end;
    finally
      FreeAndNil(line);
    end;
  finally
    FreeAndNil(tabFile);
  end;
end;

const
  file_name = 'CodeMonkey.xml';

procedure TForm16.btnSaveClick(Sender: TObject);
begin
  SaveToXML;
end;

procedure TForm16.btnLoadClick(Sender: TObject);
begin
  CodeMonkeyDS.LoadFromFile(file_name);
  CodeMonkeyDS.IndexFieldNames := 'Idx';
end;

procedure TForm16.btnCurRowClick(Sender: TObject);
begin
  SendCurRow;
end;

procedure TForm16.btnFromHereClick(Sender: TObject);
begin
  while not CodeMonkeyDS.Eof do
  begin
    Sleep(CodeMonkeyDSSpace.Value);
    SendCurRow;
  end;
end;

procedure TForm16.btrnAbandonClick(Sender: TObject);
begin
  CodeMonkeyDS.Close;
end;

procedure TForm16.Button1Click(Sender: TObject);
var
  lLine, lFile: TStringList;
  I: Integer;
begin
  lLine := nil;
  lFile := nil;
  try
    lLine := TStringList.Create;
    lLine.Delimiter := ',';
    lFile := TStringList.Create;

    CodeMonkeyDS.First;
    while not CodeMonkeyDS.Eof do
    begin
      lLine.Clear;

      for I := 0 to CodeMonkeyDS.Fields.Count - 1 do
      begin
        lLine.Add(CodeMonkeyDS.Fields[i].AsString);
      end;
      lFile.Add(lLine.CommaText);

      CodeMonkeyDS.Next;
    end;

    lFile.SaveToFile('CodeMonkey.csv');

  finally
    FreeAndNil(lLine);
    FreeAndNil(lFile);
  end;
end;

procedure TForm16.btnGetSpaceClick(Sender: TObject);
var
  lastFinish: integer;
begin
  CodeMonkeyDS.DisableControls;
  try
    CodeMonkeyDS.First;
    lastFinish := 0;
    while not CodeMonkeyDS.Eof do
    begin
      CodeMonkeyDS.Edit;
      CodeMonkeyDSSpace.Value := CodeMonkeyDSStart.Value - lastFinish;
      lastFinish := CodeMonkeyDSFinish.Value;
      CodeMonkeyDS.Next;
    end;
  finally
    CodeMonkeyDS.EnableControls;
  end;
end;

procedure TForm16.CodeMonkeyDSAfterDelete(DataSet: TDataSet);
var
  recNo: Integer;
begin
  CodeMonkeyDS.IndexFieldNames := '';
  CodeMonkeyDS.DisableControls;
  recNo := CodeMonkeyDS.RecNo;
  try
    while not CodeMonkeyDS.Eof do
    begin
      CodeMonkeyDS.Edit;
      CodeMonkeyDSIdx.AsInteger := CodeMonkeyDSIdx.AsInteger - 1;
      CodeMonkeyDS.Next;
    end;
  finally
    CodeMonkeyDS.RecNo := recNo;
    CodeMonkeyDS.EnableControls;
    CodeMonkeyDS.IndexFieldNames := 'Idx';
  end;
end;

procedure TForm16.CodeMonkeyDSAfterInsert(DataSet: TDataSet);
begin
  CodeMonkeyDSIdx.AsInteger := fNextIndex;
  CodeMonkeyDS.IndexFieldNames := 'Idx';
end;

procedure TForm16.CodeMonkeyDSBeforeInsert(DataSet: TDataSet);
var
  recNo: Integer;
  idx: Integer;
begin
  CodeMonkeyDS.IndexFieldNames := '';
  CodeMonkeyDS.DisableControls;
  idx := CodeMonkeyDSIdx.AsInteger;
  recNo := CodeMonkeyDS.RecNo;
  try
    while not CodeMonkeyDS.Eof do
    begin
      CodeMonkeyDS.Edit;
      CodeMonkeyDSIdx.AsInteger := CodeMonkeyDSIdx.AsInteger + 1;
      CodeMonkeyDS.Next;
    end;
  finally
    CodeMonkeyDS.RecNo := recNo;
    CodeMonkeyDS.EnableControls;
    fNextIndex := idx;
  end;
end;

procedure TForm16.CodeMonkeyDSCalcFields(DataSet: TDataSet);
begin
  CodeMonkeyDSDuration.AsInteger := CodeMonkeyDSFinish.AsInteger -
    CodeMonkeyDSStart.AsInteger;
end;

procedure TForm16.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveToXML;
end;

procedure TForm16.SaveToXML;
var
  fn: string;
  cnt: Integer;
begin
  if not CodeMonkeyDS.Active then
    Exit;

  CodeMonkeyDS.LogChanges := False;
  CodeMonkeyDS.MergeChangeLog;

  if FileExists(file_name) then
  begin
    cnt := 0;
    repeat
      inc(cnt);
      fn := ExtractFileName(file_name);
      delete(fn, length(fn) - length(ExtractFileExt(file_name)) + 1, maxint);
      fn := fn + IntToStr(cnt) + ExtractFileExt(file_name);
    until not fileExists(fn);
    RenameFile(file_name, fn);
  end;

  CodeMonkeyDS.SaveToFile(file_name, dfXML);
end;

procedure TForm16.SendCurRow;
var
  s: string;
  start, finish, offset: integer;
begin
  start := timeGetTime;
  SetTarget;
  s := CodeMonkeyDSScript.AsString;
  SendKeys(PWideChar(s), True, GetKeyDelay(s, CodeMonkeyDSDuration.AsInteger));
  finish := timeGetTime;
  CodeMonkeyDS.Edit;
  offset := CodeMonkeyDSDuration.Value - (finish - start);
  if offset > 0 then Sleep(offset);
  CodeMonkeyDSOffset.Value := offset;
  CodeMonkeyDS.Next;
end;

end.
