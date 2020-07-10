### Idle Champion Scripts and stuff

All images are pulled from Idle Champions and are owned by [Codename Entertainment Inc.](http://www.codenameentertainment.com/) Only the scripts/readme/logs are under the GPU lisence.

I have written a [guide](https://docs.google.com/document/d/1V3vviSagVLMXZ-pCFpraEnMpOIv9QlgFQY7J55tBt6s/edit#) which will explain some things about the game and some champs to get. This should help you understand why some of the coding is done in the scripts.

I do support this game with real money and suggest if you are reading this do so also. I do enjoy this game not only for scripting purposes, but the game itself. Making formations, talking about the game in general, and the community are some of the things that make this game fun for me.

## General Info

These are scripts to help you in Idle Champions. Scripts by Deatho0ne and others on <https://discord.gg/idlechampions>. Please do not bug the others mentioned or me for help with these scripts. Other discord members and I shall help you only in #scripting, if we feel inclined to do so. There is a good chance someone will help you, since we were most likely in your shoes at one point.

## Basic Scripts and other helpers

Most scripts use F12

- To get F12 not to take screen shots go to...

- Steam > Settings > In-Game > Screenshot shortcut keys

- Set mine to Shift+F12, but most things you would not do in any game will work

### Settings

Should help getting Pokota's Scripts, Bootch's Script, Montrose's Script, and the included (modified Bootch's script, GemFarm.ahk and EventFarm.ahk to work).

![Settings For Scripts to Follow](https://github.com/Deatho0ne/IdleChamp-Deatho0ne/blob/master/ImagesForReadme/SettingsUsed.PNG)

### BrivSkipCalc.ahk

Should give you a rough idea of stacks needed for your next run and roughly the time needed to get those stacks on a portal area before you reset. Need to edit to get your numbers.

### GeneralUiStuff.ahk

There are some user interface (UI) stuff that just feels none user experience (UX) to me and I have seen others mention some of these also. So I decided to make a script that trys to make it less of a bother to deal with these UX design choices. I would love to remove them if CNE ever makes the UX better in the areas this script deals with. This Script needs everything in uiWork to be in the same folder to work.

- Buy Chest with gems
  - You have to be on either the Silver or Gold Chest screens for this to work
    - Buys either SCs in 50 increments and GC in 1 increments
      - Does this till out of gems
  - Uses F1 to start
- Open Silver/Gold Chest
  - As long as you are on the screen to open chest this should work
    - Not sure if this will work on one chest of either type
  - Uses F2 for silvers and F3 for golds
- Use Bounty Contracts
  - Uses bounty contracts of whatever type in groups of 10
    - not sure what happens if you only have one left
  - There are some input boxes that should direct
  - Uses F4

PS: I made some changes I have not been fully test yet in this script, but just watch them for a bit. I do think they should work for the most though.

## What this repository was really created for

GemFarm.ahk and EventFarm.ahk please understand something about AHK scripts (google is your friend), if you do not I will point you to other scripts on Discord. They both need about e20 favor to run, but should be able to get away with lower favor I am just not sure how much is needed for both. They just need to get to the spec choices by the area to end, if this does not happen there is at least a time out in GemFarm to restart.

These scripts should be relatively simple to make work for you. They are very much image based and need the images to do what they do for the most part. Most images need to be pixel perfect for this to work, if failing at some point after the start use something like Snipping Tool to grab a new image and replace the ones provided. The settings should help with most of this, but all computers are differnt.

![Diretory for Mad Wizard](https://github.com/Deatho0ne/IdleChamp-Deatho0ne/blob/master/ImagesForReadme/MadWizardDirectory.PNG)

### GemFarm.ahk

Is a script that tries to speed through Mad Wizard with the best champs allowed to me depending on patrons. It can pretty much be started for outside of adventures or inside and detects the patron that it should run. In all versions of Mad Wizard, not named Strahd, it uses Briv and is mostly designed around his speed up mechanic. Please read/edit the script if you want to use it and/or are lacking any of the champs at all in the game. Should not be to hard to figure out how to make it work for you as long as you get a few things about AHK and the game. You will have to test this to make sure you are getting the best results for you.

- This script records data when you hit F9 after one run to MadWizard-Bosses.txt

  - There is another way to record the gem count that you get, but I normally do not use it

- Basic Formation I run in a None Patron that does not use ults.

  - This is formation is saved to formation save slot (1 or Q) and can be changed

    - I use Binwin in this image, he is 100% not needed, but is in the script

	- Changing up your formation is where you will get most of your speed up

	 - This is why you see Deekin has his Ult, he does not need it at all

  - If you go the ult route Havilar is going to be a pain in the neck  to make sure you get it right
  
  - Animehimo has added a few failsafes and speed potion usage
  
    - I have tested this at the lowest end, but the code seems sound

![Diretory for Mad Wizard](https://github.com/Deatho0ne/IdleChamp-Deatho0ne/blob/master/ImagesForReadme/NonePatronsNoUltsFormation.PNG)

- There is also a Briv, Celeste, Melf, & Sentry on slot 2/W for building stacks

  - I have a familiar on Briv, Celeste, and Sentry
  
  - Depending what area you want stop at should change your slot 2/W formation
  
    - This formation should work at a relatively low area, which you will have to test
    
    - You do not want anyone killing ultimately at this point

![Diretory for Mad Wizard](https://github.com/Deatho0ne/IdleChamp-Deatho0ne/blob/master/ImagesForReadme/BrivStacking.png)

### EventFarm.ahk

Is a script built off of GemFarm's images, but is built to run any event champ Free Play to area 51 and repeat. I do not use Briv in this, since it is way harder to build stacks on him at area 51 to 54 after picking his Spec. This script works mostly off of clicking a spot relative to one image to start an event FP. Please read/edit the script to get it do what you want.

Do not have a current Patron selected. You need to complete the oldest and second oldest champs variants, this is part of the reason for e20 favor, to run all event champs. Melf at roughly e10 favor will not be at spec by area 50, I do know this. If enough edits can get away with just click damage getting you past area 51, but not sure at all what this is.

- Example how to get every champ to run in any event, this part of the script has worked for two events

![Diretory for Mad Wizard](https://github.com/Deatho0ne/IdleChamp-Deatho0ne/blob/master/ImagesForReadme/ExampleOfEvent.PNG)
