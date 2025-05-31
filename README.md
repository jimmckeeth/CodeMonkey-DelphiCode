# Code Monkey - Delphi Code
The original program that writes the lyrics to Code Monkey as Delphi Code

Here is the [video of the program in action](https://youtube.com/watch?v=-nGvMbQKS7U):

[![Code Monkey as Code in Delphi by Jim McKeeth](https://img.youtube.com/vi/-nGvMbQKS7U/0.jpg)](https://www.youtube.com/watch?v=-nGvMbQKS7U)

And here is a [behind the scenes, making of video](https://youtu.be/RA5tfPHAL4k?t=309):

[![The Making of the CodeMonkey in Delphi Code by Jim McKeeth](https://img.youtube.com/vi/RA5tfPHAL4k/0.jpg)](http://youtube.com/watch?v=RA5tfPHAL4k?t=309)

and here is the [lyrics/code](https://github.com/jimmckeeth/CodeMonkey-DelphiCode/blob/main/code/LyricsCode.pas):

```Delphi
uses
  JoCo;

procedure TMusicalNumber.FormShow(Sender: TObject);
begin
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

  Music.Stop;
end;
```
