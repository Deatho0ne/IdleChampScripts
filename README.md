### Idle Champion Scripts and stuff

I have written a [guide](https://docs.google.com/document/d/1V3vviSagVLMXZ-pCFpraEnMpOIv9QlgFQY7J55tBt6s/edit#) which will explain some things about the game and some champs to get. This should help you understand why some of the things to follow.

## General Info

These are scripts to help you in Idle Champions. Scripts by Deatho0ne and others on <https://discord.gg/idlechampions>. Please do not bug the others mentioned for help with these scripts. Other discord members and I shall help you only in #scripting, if we feel inclined to do so. There is a good chance someone will help you, since we were most likely in your shoes at one point.

## Basic Scripts and other helpers

### GeneralLeveling.ahk

Should work no matter the favor you have: pushing, run variants, or do almost anything you want in the game without doing to much. Can edit it to make it click and even not level champs.

- To get F12 not to take screen shots go to...

- Steam > Settings > In-Game > Screenshot shortcut keys

- Set mine to Shift+F12, but most things you would not do in any game will work

### BrivSkipCalc.ahk

Should give you a rough idea of stacks needed for your next run and roughly the time needed to get those stacks on a portal area before you reset. Need to edit to get your numbers.

### Settings

Should help getting Bootch's Script, Montrose's Script, and the included (modified Bootch's script, GemFarm.ahk and EventFarm.ahk to work).

![Settings For Scripts to Follow](https://github.com/Deatho0ne/IdleChamp-Deatho0ne/blob/master/ImagesForReadme/SettingsUsed.PNG)

## What this repository was really created for

GemFarm.ahk and EventFarm.ahk please understand something about AHK scripts (google is your friend), if you do not I will point you to other scripts on Discord. They both need about e20 favor to run, but should be able to get away with lower favor I am just not sure how much is needed for both. They just need to get to the spec choices by the area to end, if this does not happen there is at least a time out in GemFarm to restart.

These scripts should be relatively simple to make work for you. They are very much image based and need the images to do what they do for the most part. Most images need to be pixel perfect for this to work, if failing at some point after the start use something like Snipping Tool to grab a new image and replace the ones provided. The settings should help with most of this, but all computers are differnt.

![Diretory for Mad Wizard](https://github.com/Deatho0ne/IdleChamp-Deatho0ne/blob/master/ImagesForReadme/MadWizardDirectory.PNG)

### GemFarm.ahk

Is a script that tries to speed through Mad Wizard with the best champs allowed to me depending on patrons. It can pretty much be started for outside of adventures or inside and detects the patron that it should run. In all versions of Mad Wizard, not named Strahd, it uses Briv and is mostly designed around his speed up mechanic. Please read/edit the script if you want to use it and/or are lacking any of the champs. Should not be to hard to figure out how to make it work for you as long as you get a few things about AHK.

- There is a buy silver or gold chest in this Script. It only works from their respective screens and you hit F6. It will buy keep buying till it runs out of gems.

- Basic Formation I run in a None Patron that does not use ults.

  - This is saved to formation slot 1/Q and can be changed

    - I use Binwin in this image, he is 100% not needed, but is in the script

	- Changing up your formation is where you will get most of your speed up

	 - This is why you see Deekin has his Ult, he does not need it at all

  - If you go the ult route Havilar is going to be a pain in the neck  to make sure you get it right

![Diretory for Mad Wizard](https://github.com/Deatho0ne/IdleChamp-Deatho0ne/blob/master/ImagesForReadme/NonePatronsNoUltsFormation.PNG)

- There is also a Briv, Celeste, and maybe Melf/Sentry on slot 2/W for building stacks

  - I have a familiar on both Briv and Celeste
  
  - Depending what area you want stop at should change your slot 2/W formation
  
    - This formation should work at a relatively low area, which you will have to test
    
    - You do not want anyone killing ultimately at this point

![Diretory for Mad Wizard](https://github.com/Deatho0ne/IdleChamp-Deatho0ne/blob/master/ImagesForReadme/BrivStacking.png)

### EventFarm.ahk

Is a script built off of GemFarm's images, but is built to run any event champ Free Play to area 51 and repeat. I do not use Briv in this, since it is way harder to build stacks on him at area 51 to 54 after picking his Spec. This script works mostly off of clicking a spot relative to one image to start an event FP. Please read/edit the script to get it do what you want.

Do not have a current Patron selected. You need to complete the oldest and second oldest champs variants, this is part of the reason for e20 favor, to run all event champs. Melf at roughly e10 favor will not be at spec by area 50, I do know this. If enough edits can get away with just click damage getting you past area 51, but not sure at all what this is.
