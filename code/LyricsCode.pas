unit LyricsCode;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs;

type
  TForm1 = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  JoCo;

procedure TForm1.FormShow(Sender: TObject);
begin
  NonBlocking(procedure begin
  Music.Start;

  CodeMonkey.GetUp.GetCoffee;
  CodeMonkey.&GoTo(Job);
  CodeMonkey.Have(BoringMeeting).
  &With(BoringManagerRob);

  Rob.Say(['Code Monkey very diligent',
    'But his output stink',
    'His code not "functional" or "elegant"',
    'What do Code Monkey think?']);
  CodeMonkey.Think(
    'maybe manager want to write login page himself!');
  CodeMonkey.&Not(SayItOutLoud);
  CodeMonkey.&Not(Crazy).Just(Proud);

  CodeMonkey.Like(Fritos);
  CodeMonkey.Like(Tab and MountainDew);
  CodeMonkey.Very(SimpleMan).
  &With(BigWarmFuzzySecretHeart);
  CodeMonkey.Like(You);
  CodeMonkey.Like(You);

  CodeMonkey.HangAround(@FrontDesk).
  Tell(You, 'sweater look nice');
  CodeMonkey.Offer(Buy, you, soda).
  Bring(You, cup).Bring(You, ice);
  You.Say(['No thank you for the soda cause',
    'Soda make you fat',
    'Anyway you busy with the telephone',
    'No time for chat']);
  CodeMonkey.Have(LongWalkBackToCubicle).
  He.SitDown.PretendTo(Work);
  CodeMonkey.&Not(ThinkingSoStraight);
  CodeMonkey.&Not(FeelingSoGreat);

  CodeMonkey.Like(Fritos);
  CodeMonkey.Like(Tab and MountainDew);
  CodeMonkey.Very(SimpleMan).
  &With(BigWarmFuzzySecretHeart);
  CodeMonkey.Like(You);
  CodeMonkey.Like(You, ALot);
  {TODO -oJim -cRefactoring : Make chorus a procedure!}

  CodeMonkey.Have(EveryReason).
  &To(GetOut, ThisPlace);
  CodeMonkey.Just(KeepOnWorking).
  See(you.r(SoftPrettyFace)).
  MuchRather(WakeUp).Eat(ACoffeeCake).
  Take(Bath).Take(Nap).
  This(job, Fulfilling, inCreativeWay,
    SuchALoadOfCrap);
  CodeMonkey.Think(
    'Someday he have everything even pretty girl like you');
  CodeMonkey.Just(WaitingForNow);
  CodeMonkey.Say(['someday, somehow']);

  CodeMonkey.Like(Fritos);
  CodeMonkey.Like(Tab and MountainDew);
  CodeMonkey.Very(SimpleMan).
  &With(BigWarmFuzzySecretHeart);
  CodeMonkey.Like(You);
  CodeMonkey.Like(You);

  // Yes, it's real Delphi code that compiles and runs!

  Music.Stop;

  end);
  // Get the code for Delphi . . .
  //
  // Visit:
  //    https://github.com/jimmckeeth/CodeMonkey-DelphiCode

  // Video licensed under Creative Commons CC-BY-NC-SA

  // Music: Code Monkey by Jonathan Coulton
  //   Used under Creative Commons CC-BY-NC License
  //   For more information visit
  //     https://www.jonathancoulton.com/

end;

end.
