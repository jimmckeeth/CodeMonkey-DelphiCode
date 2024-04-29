(*
The MIT License (MIT)

Copyright (c) 2015 by Jim McKeeth

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*)

// WARNING:
//   This unit works from both a console app and a GUI app,
//   If you are switching between a GUI and a Console app then do a BUILD
//   or you will still be using the DCU from the last build with the wrong type.

unit JoCo;

interface

uses
  SysUtils,
  System.Classes,
  System.Threading;

type
  TActions = (BoringMeeting, buy, LongWalkBackToCubicle, WakeUp, Bath, Nap,
    KeepOnWorking, WaitingForNow, Work, GetOut);
  TAttributes = (SayItOutLoud, Crazy, Proud, BigWarmFuzzySecretHeart,
    ThinkingSoStraight, FeelingSoGreat, SoftPrettyFace, Fulfilling,
    inCreativeWay, SuchALoadOfCrap, SimpleMan, YourSoftFriendlyFace);
  TItems = (Job, Soda, cup, ice, ACoffeeCake, ThisPlace);
  TDegrees = (EveryReason, ALot);
const
  Actions: array [TActions] of string =
    ('boring meeting', 'buy', 'long walk back to cubicle', 'wake up', 'bath',
    'nap', 'keep on working', 'waiting for now', 'work', 'get out');
  Attributes: array [TAttributes] of string =
    ('say it out loud', 'crazy', 'proud', 'big warm fuzzy secret heart:',
     'thinking so straight', 'feeling so great', 'soft pretty face',
     '"fulfilling', 'in creative way"', 'Such a load of crap', 'simple man',
     'your soft friendly face');
  Items: array [TItems] of string = ('job', 'soda', 'cup', 'ice',
    'a coffee cake', 'this place');
  Degrees: array [TDegrees] of string = ('every reason', 'a lot');

type
  TLikable = record
    value: string;
    class operator LogicalAnd(const Left, Right: TLikable): TLikable;
  end;

const
  Fritos: TLikable = (value: 'Fritos');
  Tab: TLikable = (value: 'Tab');
  MountainDew: TLikable = (value: 'Mountain Dew');

type
  TLocations = class
  private
    fValue: string;
  public
    property Value: string read fValue;
    constructor Create(avalue: string);
  end;
  TLocationsPtr = ^TLocations;
  TPerson = class
  strict private
    fName: string;
  public
    procedure Say(say: array of string);
    function r(attribute: TAttributes): TAttributes;
    function Name: string;
    constructor create(aName: string);
  end;
  TManager = class(TPerson)
  end;
  TCodeMonkey = class(TPerson)
  private
    fLikeInterval: integer;
  public
    function GetUp: TCodeMonkey;
    procedure GetCoffee;
    procedure &GoTo(destination: TItems);
    function Have(action: TActions): TCodeMonkey; overload;
    function Have(action: TDegrees): TCodeMonkey; overload;
    procedure &With(boringManager: TManager); overload;
    procedure &With(attribute: TAttributes); overload;
    procedure Think(think: string);
    function &Not(attribute: TAttributes): TCodeMonkey;
    procedure Like(likable: TLikable); overload;
    procedure Like(person: TPerson); overload;
    procedure Like(person: TPerson; howMuch: TDegrees); overload;
    function HangAround(location: TLocationsPtr): TCodeMonkey;
    procedure Tell(who: TPerson; what: string);
    function Offer(action: TActions; who: TPerson; item: TItems): TCodeMonkey;
    function Bring(who: TPerson; item: TItems): TCodeMonkey;
    function He: TCodeMonkey;
    function SitDown: TCodeMonkey;
    function PretendTo(action: TActions): TCodeMonkey;
    procedure &To(action: TActions; item: TItems);
    function See(attribute: TAttributes): TCodeMonkey;
    function Just(action: TActions): TCodeMonkey; overload;
    function Just(attribute: TAttributes): TCodeMonkey; overload;
    function MuchRather(action: TActions): TCodeMonkey;
    function Eat(item: TItems): TCodeMonkey;
    function Take(action: TActions): TCodeMonkey;
    function This(item: TItems; status1, status2, status: TAttributes): TCodeMonkey;
    function Very(attribute: TAttributes): TCodeMonkey;
  end;

  Music = class
    class procedure Start;
    class procedure Stop;
  end;

procedure NonBlocking(const Proc: TThreadProcedure);

var
  CodeMonkey : TCodeMonkey;
  BoringManagerRob, Rob : TManager;
  FrontDesk : TLocations;
  you: TPerson;

implementation

{$IFNDEF CONSOLE}
uses
  FMX.Types,
  FMX.Forms,
  FMX.Memo,
  FMX.Dialogs;
{$ENDIF}

var
  Line: String;

{$IFNDEF CONSOLE}
const MusicalMemoName = 'MusicalMemo';
function GetMemo: TMemo;
begin
  Result := Application.MainForm.FindComponent(MusicalMemoName) as TMemo;
  if not Assigned(Result) then
  begin
    if Application.MainForm.Caption.StartsWith('Form') then
      Application.MainForm.Caption := 'Special Musical Number';
    Result := TMemo.Create(Application.MainForm);
    Result.Name := MusicalMemoName;
    Result.Parent := Application.MainForm;
    Result.Align := TAlignLayout.Client;
    Result.WordWrap := True;
    Result.StyledSettings := [TStyledSetting.FontColor, TStyledSetting.Style];
    {$IF DEFINED(android) OR DEFINED(ios)}
    Result.Font.Family := 'Consolas';
    Result.Font.Size := 16;
    {$ENDIF}
    Result.ReadOnly := True;
    Result.BringToFront;
    if Result.Lines.Count = 0 then
      Result.Lines.Add('');
  end;
end;
{$ENDIF}

procedure NonBlocking(const Proc: TThreadProcedure);
begin
  TTask.Create(procedure begin
    TThread.Queue(nil, Proc);
  end).Start;
end;

procedure SlowChar(const AChar: Char);
{$IFNDEF CONSOLE}
var Memo: TMemo;
{$ENDIF}
begin
  {$IFDEF CONSOLE}
  Write(AChar);
  Sleep(50);
  {$ELSE}
  if Application.Terminated then Exit;

  Memo := GetMemo;

  if AChar <> #13 then
  begin
    if AChar = #10 then
    begin
      Memo.Lines.Add(Line);
      Line := '';
    end
    else
    begin
      Memo.Lines[Memo.Lines.Count - 1] :=
        Memo.Lines[Memo.Lines.Count - 1] + AChar;
    end;
    Memo.GoToTextEnd;
    Memo.SelectWord; // to make it repaint on a partial line
  end;

  Application.ProcessMessages;
  {$ENDIF}
end;

procedure SlowWrite(const AString: string = '');
var
  c: char;
begin
  for c in AString do
  begin
    SlowChar(c);
  end;
end;

procedure SlowWriteLn(const AString: string = '');
begin
  SlowWrite(AString + sLineBreak);
end;

{ TLikable }

class operator TLikable.LogicalAnd(const Left, Right: TLikable): TLikable;
begin
  Result.value := Left.value + ' and ' + Right.value;
end;

{ TPerson }

procedure TPerson.Say(say: array of string);
var
  str: string;
begin
  SlowWrite(name + ' say ');
  for str in say do
  begin
    SlowWriteLn('"'+ str +'"');
  end;
  SlowWriteLn;
end;

function TPerson.r(attribute: TAttributes): TAttributes;
begin
  result := attribute;
end;

function TPerson.Name: string;
begin
  result := fName;
end;

constructor TPerson.Create(aName: string);
begin
  fName := aName;
end;

{ TCodeMonkey }

function TCodeMonkey.Bring(who: TPerson; item: TItems): TCodeMonkey;
begin
  if item = cup then
    SlowWrite('Bring ')
  else
    SlowWrite(' bring ');
  SlowWrite(who.Name + ' ' + items[item]);
  case item of
    Cup: SlowWrite(',');
    Ice: SlowWriteLn;
  end;
  Result := Self;
end;

function TCodeMonkey.Eat(item: TItems): TCodeMonkey;
begin
  SlowWriteLn('Eat ' + items[item]);
  Result := Self;
end;

procedure TCodeMonkey.GetCoffee;
begin
  SlowWriteLn('get coffee');
end;

function TCodeMonkey.GetUp: TCodeMonkey;
begin
  SlowWrite(self.Name  + ' get up ');
  Result := Self;
end;

procedure TCodeMonkey.&GoTo(destination: TItems);
begin
  SlowWriteLn(self.Name  + ' go to ' + items[destination]);
end;

function TCodeMonkey.HangAround(location: TLocationsPtr): TCodeMonkey;
begin
  SlowWriteLn(Name + ' hang around ' + location.Value);
  Result := Self;
end;

function TCodeMonkey.Have(action: TDegrees): TCodeMonkey;
begin
  SlowWriteLn(Name + ' have ' + degrees[action]);
  Result := Self;
end;

function TCodeMonkey.Have(action: TActions): TCodeMonkey;
begin
  SlowWriteLn(Name + ' have ' + actions[action]);
  Result := Self;
end;

function TCodeMonkey.He: TCodeMonkey;
begin
  SlowWrite('He ');
  Result := Self;
end;

function TCodeMonkey.Just(action: TActions): TCodeMonkey;
begin
  if (action = KeepOnWorking) or (action = WaitingForNow) then
    SlowWrite('Code Monkey ');
  SlowWriteLn('just ' + actions[action]);
  Result := Self;
end;

function TCodeMonkey.Just(attribute: TAttributes): TCodeMonkey;
begin
  SlowWriteLn('just ' + attributes[attribute]);
  Result := Self;
end;

procedure TCodeMonkey.Like(person: TPerson);
begin
  SlowWriteLn(Name + ' like ' + person.Name);
  Inc(fLikeInterval);
  if not Odd(fLikeInterval) then
    SlowWriteLn;
end;

procedure TCodeMonkey.Like(likable: TLikable);
begin
  SlowWriteLn(Name + ' like ' + likable.value);
end;

procedure TCodeMonkey.Like(person: TPerson; howMuch: TDegrees);
begin
  SlowWriteLn(Name + ' like ' + person.Name + ' ' + degrees[howMuch]);
  Inc(fLikeInterval);
  if not Odd(fLikeInterval) then
    SlowWriteLn;
end;

function TCodeMonkey.MuchRather(action: TActions): TCodeMonkey;
begin
  SlowWriteLn('Much rather ' + actions[action]);
  Result := Self;
end;

function TCodeMonkey.&Not(attribute: TAttributes): TCodeMonkey;
begin
  SlowWrite(Name + ' not ' + attributes[Attribute]);
  if attribute <> crazy then
    SlowWriteLn(' ')
  else
    SlowWrite(', ');
  if attribute = FeelingSoGreat then
    SlowWriteLn;
  Result := Self;
end;

function TCodeMonkey.Offer(action: TActions; who: TPerson;
  item: TItems): TCodeMonkey;
begin
  SlowWriteLn(Name + ' offer ' + actions[action] + ' ' + who.Name + ' '  + items[item]);
  Result := Self;
end;

function TCodeMonkey.See(attribute: TAttributes): TCodeMonkey;
begin
  SlowWriteLn('See your ' + attributes[attribute]);
  Result := Self;
end;

function TCodeMonkey.SitDown: TCodeMonkey;
begin
  SlowWrite('sit down ');
  Result := Self;
end;

function TCodeMonkey.PretendTo(action: TActions): TCodeMonkey;
begin
  SlowWriteLn('pretend to ' + actions[action]);
  Result := Self;
end;

function TCodeMonkey.Take(action: TActions): TCodeMonkey;
begin
  if action = nap then
    SlowWrite('T')
  else
    SlowWrite('t');
  SlowWrite('ake ' + actions[action]);
  case action of
    Bath: SlowWrite(', ');
    Nap: SlowWriteLn;
  else
    SlowWrite(' ');
  end;
  Result := Self;
end;

procedure TCodeMonkey.Tell(who: TPerson; what: string);
begin
  SlowWriteLn('Tell ' + who.Name + ' ' + what)
end;

procedure TCodeMonkey.Think(think: string);
begin
  SlowWriteLn(Name + ' think ' + think);
end;

function TCodeMonkey.This(item: TItems; status1, status2, status: TAttributes): TCodeMonkey;
begin
  SlowWriteLn('This ' + items[item] + ' ' +
    attributes[status1] + ' ' +
    attributes[status2] + ' ');
  SlowWriteLn(attributes[status]);
  Result := Self;
end;

function TCodeMonkey.Very(attribute: TAttributes): TCodeMonkey;
begin
  SlowWriteLn(Name + ' very ' + attributes[attribute]);
  Result := Self;
end;

procedure TCodeMonkey.&To(action: TActions; item: TItems);
begin
  SlowWriteLn('To ' + actions[action] + ' ' + items[item]);
end;

procedure TCodeMonkey.&With(attribute: TAttributes);
begin
  SlowWriteLn('With ' + attributes[attribute]);
end;

procedure TCodeMonkey.&With(boringManager: TManager);
begin
  SlowWriteLn('With boring manager ' + boringManager.Name);
end;

{ Music }

class procedure Music.Start;
begin
  Sleep(1);
end;

class procedure Music.Stop;
{$IFDEF CONSOLE}
var
 s: string;
{$ENDIF}
begin
  {$IFDEF CONSOLE}
  Readln(s);
  {$ENDIF}
end;

{ TLocations }

constructor TLocations.Create(avalue: string);
begin
  fValue := aValue;
end;

{ Initialization / Finalization }

initialization
  CodeMonkey := TCodeMonkey.Create('Code Monkey');
  You := TPerson.Create('you');
  Rob:= TManager.Create('Rob');
  FrontDesk := TLocations.Create('at front desk');
  BoringManagerRob := Rob;
  Line := '';

finalization
  You.Free;
  CodeMonkey.Free;
  Rob.Free;
  FrontDesk.Free;

end.
