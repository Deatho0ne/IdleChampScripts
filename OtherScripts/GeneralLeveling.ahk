#SingleInstance force
target = IdleDragons.exe
/*
there are some issues with allowing multi instances of this script, but not all the time
	and not 100% sure why

Script for Idle Champions
This is a very basic script for the most part and just helps you get to your wall
	This does not pick Specilations as of yet and not sure, if I plan to due to a future update
		at e18ish favor you should be able to past most specs, Avren's 2nd needs about e26 and 15 areas though
		so that should not matter to much
	There are 3 modes that this can go through ult/level, just ult, and just level
		ults do not go off based on area, but almost as soon as they can
	1 familiar would help with leveling click damage, which cost 1k gems, but not needed
	Any after the first familiar on click can just go to the field or ults
	This script can take care of clicking if needed in 2 different spots
	Advice is once you start to not really move the mouse away from Idle Champions
		due to clicking and sending keys for the game can/will mess up other things
		It does try to prevent that, but if the game errors out or something pops up it can still happen
	some of this is taken from booth's script, but with my flair on things

Some globals for Editing
If not using Deekin set to 1 else set to 0 or lower
*/
global noDeekin := 0

;champs to level and there specilizations, if doing specs
;set to 1 or higher for leveling and 0 or lower if not
;seat taken				1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
global ChampSpecs	:= [1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  1,  1]

;click during ults and LevelUp: set to 1 for and 0 if not
global clicking := 0

;move the mouse location; 1 for center and 0 to about the spawn point
global mouseCenter := 1

;should not need to edit anything below this line, if you do not understand AHK yet
;there is no harm looking though if you want to learn
global gWindowSettings := ""

GetWindowSettings()
ShowHelpTip()
return

;HotKeys
{
	#IfWinActive Idle Champions
	F1::
	{
		ShowHelpTip()
		return
	}
	
	;From the Start
	#IfWinActive Idle Champions
	F2::
	{
		BasicRun(2)
		return
	}
	
	;Post soft cap
	#IfWinActive Idle Champions
	F3::
	{
		BasicRun(3)
		return
	}
	
	;Just leveling
	#IfWinActive Idle Champions
	F4::
	{
		BasicRun(4)
		return
	}
	
	#IfWinActive Idle Champions
	F9::
	{
		Reload
		return
	}
	
	;toggle Pause on/off
	#IfWinActive Idle Champions
	~`::
	{
		Pause, , 1	
		return
	}
	
	return
}

BasicRun(num) {
	counter := 0
	sleep, 100
	loop {
		ControlFocus,, ahk_exe %target%
		Send {Right}
		sleep, 100
		if(num != 4) {
			Ultimates(counter)
		}
		ControlFocus,, ahk_exe %target%
		Send {Right}
		sleep, 100
		if(num != 3) {
			LevelUp(counter)
		}
		if(clicking > 0) {
			click
		}
		sleep, 100
		counter := (counter > 100) ? 0 : counter + 1
	}
	return
}

Ultimates(num1) {
	if(mod(num1, 25) = 0) {
		if(noDeekin > 0) {
			ControlFocus,, ahk_exe %target%
			CenterMouse()
			if(clicking > 0) {
				click
			}
			Send, 1
			sleep, 100
		}
		loop, 9 { ;9 due to formations of 10
			ControlFocus,, ahk_exe %target%
			CenterMouse()
			if(clicking > 0) {
				click
			}
			num2 := A_Index + 1
			if(num2 < 10) {
				Send, {%num2%}
			} else {
				Send, {0}
			}
			sleep, 100
		}
	}
	return
}

LevelUp(num1) {
	if(mod(num1, 5) = 0) {
		num2 := 13
		while 0 < num2 {
			num2 := num2 - 1
			if(mod(num1, 2) = mod(num2, 2) && ChampSpecs[num2] > 0) {
				ControlFocus,, ahk_exe %target%
				CenterMouse()
				if(clicking > 0) {
					click
				}
				Send {F%num2%}
				;check if special window open
				sleep, 100
			}
		}
	}
	return
}

;tooltips
{
	global gShowHelpTip := ""
	ShowHelpTip() {
		gShowHelpTip := !gShowHelpTip
		
		if (gShowHelpTip) {
			ToolTip, % "F1: Show Help`nF2: Start leveling and ulting`nF3: Start only ulting`nF4: Just leveling`nF9: Reload Sript", 25, 325, 3
			SetTimer, ClearToolTip, -5000 
		}
		else {
			ToolTip, , , ,3
		}
	}
	
	ClearToolTip:
	{
		ToolTip, , , ,2
		ToolTip, , , ,3
		gToolTip		:= ""
		gShowHelpTip 	:= 0
		gShowStatTip 	:= 0
		return
	}
}

;HELPERS
{
	CenterMouse() {
		nX := gWindowSettings.Width / (mouseCenter > 0 ? 2 : 1.1)
		nY := gWindowSettings.Height / 2
		MouseMove, nX, nY
		Return
	}
}

GetWindowSettings() {
	if (!gWindowSettings) {
		if WinExist("Idle Champions") {
			WinActivate
			WinGetPos, outWinX, outWinY, outWidth, outHeight, Idle Champions 
		
			gWindowSettings := []		
			gWindowSettings.X := outWinX
			gWindowSettings.Y := outWinY 
			gWindowSettings.Width := (outWidth - 1)
			gWindowSettings.Height := (outHeight - 1)
			gWindowSettings.HeightAdjust := (outHeight - gWindowHeight_Default)
		}
		else {
			MsgBox Idle Champions not running
			return
		}
	}
	return gWindowSettings
}