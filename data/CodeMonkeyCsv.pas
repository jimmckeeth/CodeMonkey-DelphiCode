// https://github.com/jimmckeeth/CodeMonkey-DelphiCode

unit CodeMonkeyCsv;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBClient, Grids, DBGrids, ExtCtrls, DBCtrls,
  Vcl.Buttons;

type
  TCodeMonkeyDataForm = class(TForm)
    btnInport: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    btnSave: TButton;
    btnLoad: TButton;
    btnCurRow: TButton;
    btnFromHere: TButton;
    btrnAbandon: TButton;
    btnGetSpace: TButton;
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
    Button2: TButton;
    DBNavigator: TDBNavigator;
    ckVeryFast: TRadioButton;
    ckVerySlow: TRadioButton;
    ckNormal: TRadioButton;
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
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fNextIndex: Integer;
    fAbort: Boolean;
    fLag: Integer;
    procedure SaveToXML;
    procedure SendCurRow;
    procedure ImportCSV;
    procedure ExportCSV;
    procedure LocalSleep(const delay: integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CodeMonkeyDataForm: TCodeMonkeyDataForm;

implementation

{$R *.dfm}

uses
  mmsystem,
  SndKey32;

const
  xml_file_name = 'CodeMonkey.xml';
  csv_file_name = 'CodeMonkey.csv';
  symbols: set of AnsiChar = [' ','.','(',')','''','[',']'];
  specials: set of AnsiChar = ['^','%','+'];
  symbol_mult = 2;
  pause_mult = 4;


procedure SetTarget;
begin
  AppActivate('SpecialMusicalNumber - Delphi XE2 - SpecialMusicalNumber.dproj');
end;

function BreakItDown(const s: string; const tt: Integer; const keys: TStringList): integer;
var
  i, cnt: Integer;
  ignore: Boolean;
  key: string;
begin
  ignore := False;
  cnt := 0;
  for i := 1 to length(s) do
  begin
    if s[i] = '{' then
      ignore := True;
    if s[i] = '}' then
      ignore := False;

    key := key + s[i];

    if ignore then Continue;

    if CharInSet(s[i], specials) then continue
    else if s[i] = '`' then inc(cnt, pause_mult)
    else if CharInSet(s[i], symbols) then inc(cnt, symbol_mult)
    else inc(cnt);

    keys.Add(key);
    key := '';
  end;

  if cnt = 0 then
    result := tt
  else
    result := tt div cnt;
end;

procedure TCodeMonkeyDataForm.SendCurRow;
var
  s: string;
  delay, start, finish: integer;
  keys: TStringList;
  I: Integer;
begin
  start := timeGetTime;
  SetTarget;
  s := CodeMonkeyDSScript.AsString;
  keys := TStringList.Create;
  try
    delay := BreakItDown(s, CodeMonkeyDSDuration.AsInteger, keys);
    for I := 0 to keys.Count - 1 do
    begin
      if fAbort then Break;

      s := keys[i];
      Assert(length(s) > 0);

      SetTarget;
      if s <> '`' then SendKeys(PWideChar(s), True, 0);

      if CharInSet(s[i], symbols) then
        LocalSleep(delay * symbol_mult)
      else if s = '`' then
        LocalSleep(delay * pause_mult)
      else
        LocalSleep(delay);
    end;
  finally
    keys.Free;
  end;
  Application.ProcessMessages;
  finish := timeGetTime;
  CodeMonkeyDS.Edit;
  if ckNormal.Checked then
    fLag := CodeMonkeyDSDuration.Value - (finish - start) + fLag
  else if ckVerySlow.Checked then
    fLag := CodeMonkeyDSDuration.Value - (finish - start) div 2 + fLag
  else
    fLag := 0;
  CodeMonkeyDSOffset.Value := fLag;
  CodeMonkeyDS.Next;
end;

procedure TCodeMonkeyDataForm.btnInportClick(Sender: TObject);
begin
  ImportCSV;
end;

procedure TCodeMonkeyDataForm.btnSaveClick(Sender: TObject);
begin
  SaveToXML;
end;

procedure TCodeMonkeyDataForm.btnLoadClick(Sender: TObject);
begin
  CodeMonkeyDS.LoadFromFile(xml_file_name);
  CodeMonkeyDS.IndexFieldNames := 'Idx';
end;

procedure TCodeMonkeyDataForm.btnCurRowClick(Sender: TObject);
begin
  fAbort := False;
  SendCurRow;
end;

procedure TCodeMonkeyDataForm.btnFromHereClick(Sender: TObject);
begin
  fAbort := False;
  fLag := 0;
  while not CodeMonkeyDS.Eof and not fAbort do
  begin
    fLag := CodeMonkeyDSSpace.Value + fLag;
    if fLag > 0 then
    begin
      if not ckVeryFast.Checked then
        LocalSleep(fLag);
      fLag := 0;
    end;
    SendCurRow;
  end;
end;

procedure TCodeMonkeyDataForm.btrnAbandonClick(Sender: TObject);
begin
  CodeMonkeyDS.Close;
end;

procedure TCodeMonkeyDataForm.Button1Click(Sender: TObject);
begin
  if CodeMonkeyDS.Active then
    ExportCSV;
end;

procedure TCodeMonkeyDataForm.Button2Click(Sender: TObject);
begin
  fAbort := True;
end;

procedure TCodeMonkeyDataForm.btnGetSpaceClick(Sender: TObject);
var
  currentSpace, lastFinish: integer;
begin
  CodeMonkeyDS.DisableControls;
  try
    CodeMonkeyDS.First;
    lastFinish := 0;
    while not CodeMonkeyDS.Eof do
    begin
      CodeMonkeyDS.Edit;
      currentSpace := CodeMonkeyDSStart.Value - lastFinish;
      if currentSpace < 0 then currentSpace := 0;
      CodeMonkeyDSSpace.Value := currentSpace;
      lastFinish := CodeMonkeyDSFinish.Value;
      CodeMonkeyDS.Next;
    end;
  finally
    CodeMonkeyDS.EnableControls;
  end;
end;

procedure TCodeMonkeyDataForm.CodeMonkeyDSAfterDelete(DataSet: TDataSet);
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

procedure TCodeMonkeyDataForm.CodeMonkeyDSAfterInsert(DataSet: TDataSet);
begin
  CodeMonkeyDSIdx.AsInteger := fNextIndex;
  CodeMonkeyDS.IndexFieldNames := 'Idx';
end;

procedure TCodeMonkeyDataForm.CodeMonkeyDSBeforeInsert(DataSet: TDataSet);
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

procedure TCodeMonkeyDataForm.CodeMonkeyDSCalcFields(DataSet: TDataSet);
begin
  CodeMonkeyDSDuration.AsInteger := CodeMonkeyDSFinish.AsInteger -
    CodeMonkeyDSStart.AsInteger;
end;

procedure TCodeMonkeyDataForm.FormActivate(Sender: TObject);
begin
  fAbort := True;
end;

procedure TCodeMonkeyDataForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CodeMonkeyDS.Active then
    ExportCSV;
end;

procedure TCodeMonkeyDataForm.FormCreate(Sender: TObject);
begin
  fLag := 0;
end;

procedure TCodeMonkeyDataForm.FormShow(Sender: TObject);
begin
  ImportCSV;
end;

function RenameToNext(base: string): string;
var
  fn: string;
  cnt: Integer;
begin
  fn := base;
  if FileExists(base) then
  begin
    cnt := 0;
    repeat
      inc(cnt);
      fn := ExtractFileName(base);
      delete(fn, length(fn) - length(ExtractFileExt(base)) + 1, maxint);
      fn := fn + IntToStr(cnt) + ExtractFileExt(base);
    until not fileExists(fn);
    RenameFile(base, fn);
  end;
  Result := fn;
end;

procedure TCodeMonkeyDataForm.SaveToXML;
var
  fn: string;
begin
  if not CodeMonkeyDS.Active then
    Exit;

  CodeMonkeyDS.LogChanges := False;
  CodeMonkeyDS.MergeChangeLog;

  fn := RenameToNext(xml_file_name);


  CodeMonkeyDS.SaveToFile(xml_file_name, dfXML);
end;

procedure TCodeMonkeyDataForm.ImportCSV;
var
  oldNotify: TDataSetNotifyEvent;
  I: Integer;
  csvFile: TStringList;
  J: Integer;
  line: TStringList;
begin
  oldNotify := CodeMonkeyDS.BeforeInsert;
  CodeMonkeyDS.BeforeInsert := nil;
  try
    CodeMonkeyDS.CreateDataSet;
    CodeMonkeyDS.Open;
    csvFile := TStringList.Create;
    try
      csvFile.LoadFromFile(csv_file_name);
      line := TStringList.Create;
      try
        for I := 1 to csvFile.Count - 1 do
        begin
          line.CommaText := StringReplace(csvFile[i], ' ', '_', [rfReplaceAll]);
          CodeMonkeyDS.Append;
          CodeMonkeyDS.Edit;
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
      FreeAndNil(csvFile);
    end;
  finally
    CodeMonkeyDS.BeforeInsert := oldNotify;
  end;
  CodeMonkeyDS.First;
end;

procedure TCodeMonkeyDataForm.ExportCSV;
var
  lLine: TStringList;
  lFile: TStringList;
  I: Integer;
begin
  lLine := nil;
  lFile := nil;
  try
    lLine := TStringList.Create;
    lFile := TStringList.Create;
    for I := 0 to CodeMonkeyDS.Fields.Count - 1 do
      lLine.Add(CodeMonkeyDS.Fields[i].FieldName);
    lFile.Add(lLine.CommaText);
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
    RenameToNext(csv_file_name);
    lFile.SaveToFile(csv_file_name);
  finally
    FreeAndNil(lLine);
    FreeAndNil(lFile);
  end;
  CodeMonkeyDS.First;
end;

procedure TCodeMonkeyDataForm.LocalSleep(const delay: integer);
var
  localDelay: integer;
begin
  if not ckVeryFast.Checked then
    localDelay := delay
  else
    localDelay := delay div 3;

  if localDelay < 10 then
    localDelay := 10;

  if ckVerySlow.Checked then
    localDelay := LocalDelay * 2;

  sleep(localDelay);

end;


end.
