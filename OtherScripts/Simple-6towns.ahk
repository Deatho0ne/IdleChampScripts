#SingleInstance force
;Change of @Montrose Script by @CirusDane
;Simply here for newer players

;  ------ READ THIS SECTION ----- READ THIS SECTION ----- READ THIS SECTION ----- READ THIS SECTION ----- READ THIS SECTION ------ 	;
;																																	;
;     REQUIREMENTS																													;
;       -- Resolution Setting must be 1280x720																						;		
;       -- You must have a formation saved to the "Q"																				;
;       -- You must have the champions that you wish to be in your formation, in their appropriatte places in the "Q" formation		;
;       -- You must have at least two familiars saved in your "Q" formation --> One on click damage and one on the field clicking	;
;       -- You must not have a familiar levelling a champion. If you do, their special dialog will pop and the script will fail		;
;		-- You should not place a familiar on ultimates, as champions will not be levelled to the point that they have ultimates	;
;																																	;
;  ------ READ THIS SECTION ----- READ THIS SECTION ----- READ THIS SECTION ----- READ THIS SECTION ----- READ THIS SECTION ------ 	;

;-----------------------------------------------------------------------------------------------------------------------------------;
;	Mad Wizard Gem Farming Script																									;
;	This script is designed to farm gems through low level areas, then reset and start over again									;
;	This script is based on a fantastic script by Bootch, thanks Bootch! 															;
;	The original script was written by Hikibla, thanks Hikibla!																		; 
;-----------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------;
; Known issues - Known problems with the script																						;
;	Having the title bar turned off will create a shift in the Y values and script won't be able find several Locations.			;
;	Pausing the script while on a boss level may confuse the level counter. The script may still work but will run an extra level.	;
;	The script may not work if you are running game in full screen mode																;
;	Updates from CNE occassionally break the script																					;
;-----------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------;
;	Hotkeys - Controls for the script																								;
;	`		: Pause the script																										;	
;	F1		: Toggle the tooltip with the hotkey Info																				; 
;	F2		: Start the script to farm Mad Wizard																					;
;   F5		: Nothing to see here (Reserved for debugging)																			;	
;	F9		: Reload the script																										;
;	F10		: Exit the script																										;
;	Up		: Increase the Target Level by 10																						;			
;	DOWN	: Decrease the Target Level by 10																						;
;	Q/W/E	: Temporarily use the Q/W/E formation until the next script reload														;	
;-----------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------;
;	User Settings - Settings to allow the user to customize how the script behaves													;
;-----------------------------------------------------------------------------------------------------------------------------------;

; This variable controls the maximum level that the script will run to. You should lower this if your champions cannot complete to level 30
global nMax_Level 			:= 30	;sets the level that the script will run to for each iteration

; These variables control the mouse behavior. You can set whether or not you want to continually click and/or sweep the mouse 
global gEnableAutoClick 		:= 1	;script will auto-click 10x for 100ms (upto 60 clicks/second)
global gEnableMouseSweep 		:= 1	;script will sweep to collect gold/items 

; These variables control the formation to use during your gem farming. Don't change these unless you are confident you know what you're doing
global gFormation_NP 			:= "Q"	;Values: Q/W/E sets which formation to use when No Patron is Active 	(if changing use capital letters)
global gFormation_M 			:= "Q"	;Values: Q/W/E sets which formation to use when Mirt is Active Patron 	(if changing use capital letters)
global gFormation_V 			:= "Q"	;Values: Q/W/E sets which formation to use when Vajra is Active Active 	(if changing use capital letters)
	
;-----------------------------------------------------------------------------------------------------------------------------------;
;	Script Settings - DO NOT MODIFY THESE UNLESS YOU KNOW WHAT YOU ARE DOING OR THE SCRIPT MAY (will) BREAK							; 
;-----------------------------------------------------------------------------------------------------------------------------------;

; Seriously though. Don't mess with these unless you are confident.

;design window sizes
	global gWindowWidth_Default 	:= 1296 
	global gWindowHeight_Default	:= 759	

;campaign buttons/locations
	global worldmap_favor_x := 1250			; pixel in favor box (top right of world map screen)
	global worldmap_favor_y := 115					
	global worldmap_favor_c1 := 0x282827	;dark brown/gray
	global worldmap_favor_c2 := 0x282827	;second color added to correct for possible error when last campaign was an Event 

	global swordcoast_x	:= 50				; horizontal location of the tomb button
	global swordcoast_y	:= 115				; vertical location of the tomb button
	global toa_x 		:= 50				; horizontal location of the sword coast button	
	global toa_y		:= 185				; vertical location of the sword coast button

;Sword Coast Town with Mad Wizard Adventure
	global townsearch_L		:= 400 	
	global townsearch_R		:= 1100
	global townsearch_T		:= 135
	global townsearch_B		:= 700
	global townsearch_C		:= 0xB5AFA9 		

;Patron Detect
	global patron_X 		:= 1105		
	global patron_Y			:= 245		
	global patron_NP_C		:= 0x303030
	global patron_M_C		:= 0xBB9E97
	global patron_V_C		:= 0xA37051
	
; red pixel for the Close Button on the Adventure Select window
	global select_win_x 	:= 1043			
	global select_win_y 	:= 56	
	global select_win_c1	:= 0xAF0202 	

; pixel to check if list is scrolled to the top (if valid then list needs to scroll up)
	global list_top_x		:= 550			
	global list_top_y		:= 115
	global list_top_c1		:= 0x0A0A0A						

;searchbox for a pixel in the MadWizard FP Picture displayed in the Adventure Select List
	global MW_Find_L 	:= 255				
	global MW_Find_R 	:= 475
	global MW_Find_T 	:= 65
	global MW_Find_B 	:= 670
	global MW_Find_C 	:= 0x728E57			;pixel in Mad Wizard's Eye
	global MW_Find_C2	:= 0x7C9861			;pixel in Mad Wizard's Eye (when hovered)

;searchbox to find Blue-ish pixel in the Mad Wizard Start Button
	global MW_Start_L	:= 575				
	global MW_Start_R	:= 1025
	global MW_Start_T	:= 550
	global MW_Start_B	:= 700
	global MW_Start_C	:= 0x4175B4			; pixel in middle of the 'O' in Objective	
		
;adventure window pixel (redish pixel in the Redish Flag behind the gold coin in the DPS/Gold InfoBox)
	global adventure_dps_x	:= 70
	global adventure_dps_y	:= 35
	global adventure_dps_c1	:= 0x90181C
	global adventure_dps_c2 := 0x731316

;search box for 1st mob
	global mob_area_L	:= 750
	global mob_area_R	:= 1225
	global mob_area_T	:= 225
	global mob_area_B	:= 525
	global mob_area_C 	:= 0xFEFEFE			
	
;variables for checking if a transition is occurring (center of screen and towards top)
	global transition_y 	:= 35 				
	global transition_c1	:= 0x000000 		

;Searchbox to find the Reset Button
	global reset_complete_T		:= 475
	global reset_complete_B		:= 600
	global reset_complete_L		:= 500
	global reset_complete_R		:= 625
	global reset_complete_C		:= 0x54B42D		
	global reset_complete_C2	:= 0x5AC030		

;Pixel location for the Skip Button (During Reset)
    global reset_skip_x            := 1148
    global reset_skip_y            := 664    
    global reset_skip_c1           := 0x54B42D

;Pixel location for the Continue Button (During Reset)
	global reset_continue_x		:= 560
	global reset_continue_y		:= 615	
	global reset_continue_c1	:= 0x4A9E2A		

;internal globals
	global gFound_Error 	:= 0
	global gFormation		:= "-1"
	global gLevel_Number 	:= 0
	global dtPrevRunTime 	:= "00:00:00"
	global dtLoopStartTime 	:= "00:00:00"
	
;-----------------------------------------------------------------------------------------------------------------------------------;
; The mechanics of the script begin below.																							; 
; DO NOT EDIT ANYTHING BELOW THIS COMMENT BOX UNLESS YOU ARE CONFIDENT YOU KNOW WHAT YOU ARE DOING!!								;
;-----------------------------------------------------------------------------------------------------------------------------------;

GetWindowSettings() 
Adjust_YValues()
Init()
ShowHelpTip()
return

;HotKeys
{	
	#IfWinActive Idle Champions
	F1:: ;Show Help
	{	
		ShowHelpTip()
		return
	}
	
	#IfWinActive Idle Champions
	F2:: ; Start the gem farm
	{	
		Loop_GemRuns()
		return
	}
	
	#IfWinActive Idle Champions
	F5:: ;testing hotkey -- Ignore this if you are not doing script development on this script! By default (and by design) this does nothing
	{	
		return ; Whee! Wasn't that fun?
	}
	
	#IfWinActive Idle Champions
	F9:: ;Reset/Reload Script
	{
		Reload
		return
	}

	#IfWinActive Idle Champions
	F10:: ; Quit the script
	{
		Send {Shift Up}
		Send {Alt Up}
		exitapp
	}

	#IfWinActive Idle Champions
	~Q::
	{
		gFormation := "Q"
		return
	}

	#IfWinActive Idle Champions
	~W::
	{
		gFormation := "W"
		return
	}
	
	#IfWinActive Idle Champions
	~E::
	{
		gFormation := "E"	
		return
	}

	#IfWinActive Idle Champions
	~Up:: ;+10 levels to Target Level
	{
		nMax_Level := nMax_Level + 10
		ToolTip, % "Max Level: " nMax_Level, 25, 475, 2
		SetTimer, ClearToolTip, -1000 
		
		UpdateToolTip()
		
		return
	}

	#IfWinActive Idle Champions
	~Down:: ;-10 levels to Target Level
	{
		nMax_Level := nMax_Level - 10
		ToolTip, % "Max Level: " nMax_Level, 25, 475, 2
		SetTimer, ClearToolTip, -1000 
		
		UpdateToolTip()
		
		return
	}

	#IfWinActive Idle Champions
	~`:: ;toggle Pause on/off
	{
		Pause, , 1	
		return
	}
}

;ToolTips
{
	UpdateToolTip()
	{
		dtNow := A_Now
		dtCurrentRunTime := DateTimeDiff(dtLoopStartTime, dtNow)		
			
		sToolTip := "Prev Run: " dtPrevRunTime 	
		sToolTip := sToolTip "`nCurrent Run: " dtCurrentRunTime
		sToolTip := sToolTip "`nTarget Level: " nMax_Level		
		sToolTip := sToolTip "`nCurrent Level: " gLevel_Number
		sToolTip := sToolTip "`nPatron: " (gCurrentPatron = "NP" ? "None" : (gCurrentPatron = "M" ? "Mirt" : (gCurrentPatron = "V" ? "Vajra" : "None")))
		
		ToolTip, % sToolTip, 25, 475, 1
	}

	global gShowHelpTip := ""
	ShowHelpTip()
	{
		gShowHelpTip := !gShowHelpTip
		
		if (gShowHelpTip)
		{
			ToolTip, % "F1: Show Help`nF2: Start Gem Farm`nF9: Reload Script`nF10: Quit the script`nUP: +10 to Target Levels`nDOWN: -10 to Target Levels`n``: Pause Script", 25, 325, 3
			SetTimer, ClearToolTip, -5000 
		}
		else
		{
			ToolTip, , , ,3
		}
	}

	; A common tooltip with up to 5 lines
	; limits the tooltip to last 5 messages in event script is spamming messages
	global gToolTip := ""
	ShowToolTip(sText := "")
	{	
		if (!sText)
		{
			gToolTip := ""
		}
		
		dataitems := StrSplit(gToolTip, "`n")
		nCount := dataitems.Count()
		gToolTip := ""
		
		nMaxLineCount := 5
		nStartIndex := 0
		if (nCount >= nMaxLineCount)
		{
			nStartIndex := nCount - nMaxLineCount + 1
		}
		
		for k,v in dataitems
		{
			if (A_Index > nStartIndex)
			{
				if (gToolTip)
				{
					gToolTip := gToolTip "`n"
				}
				gToolTip := gToolTip v
			}
		}
		
		if (gToolTip)
		{
			gToolTip := gToolTip "`n" sText
		}
		else
		{
			gToolTip := sText
		}
		
		ToolTip, % gToolTip, 50, 150, 5
		return
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

global gWindowSettings := ""
GetWindowSettings()
{
	if (!gWindowSettings)
	{
		if WinExist("Idle Champions")
		{
			WinActivate
			WinGetPos, outWinX, outWinY, outWidth, outHeight, Idle Champions 
		
			gWindowSettings := []		
			gWindowSettings.X := outWinX
			gWindowSettings.Y := outWinY 
			gWindowSettings.Width := (outWidth - 1)
			gWindowSettings.Height := (outHeight - 1)
			gWindowSettings.HeightAdjust := (outHeight - gWindowHeight_Default)
		}
		else
		{
			MsgBox Idle Champions not running
			return
		}
	}
	
	return gWindowSettings
}

;Init Globals/Settings
{
	Adjust_YValues()
	{
		worldmap_favor_y 		:= worldmap_favor_y + gWindowSettings.HeightAdjust
		swordcoast_y 			:= swordcoast_y + gWindowSettings.HeightAdjust
		toa_y 					:= toa_y + gWindowSettings.HeightAdjust		
		select_win_y 			:= select_win_y + gWindowSettings.HeightAdjust
		list_top_y 				:= list_top_y + gWindowSettings.HeightAdjust
		adventure_dps_y 		:= adventure_dps_y + gWindowSettings.HeightAdjust
		transition_y 			:= transition_y + gWindowSettings.HeightAdjust
		reset_continue_y 		:= reset_continue_y + gWindowSettings.HeightAdjust
		patron_Y				:= patron_Y + gWindowSettings.HeightAdjust		
	}
	
	global oPixReset_Complete := ""		;pixel search box to find green Complete Button (1st window on reset)
	global oPixReset_Skip := ""		;pixel object to find green Continue Button (2nd window on reset)
	global oPixReset_Continue := ""		;pixel object to find green Continue Button (2nd window on reset)

	Init()
	{
		gFound_Error := 0
		
		oPixReset_Complete := {}
		oPixReset_Complete.StartX 	:= reset_complete_L
		oPixReset_Complete.EndX 	:= reset_complete_R
		oPixReset_Complete.StartY 	:= reset_complete_T
		oPixReset_Complete.EndY 	:= reset_complete_B
		oPixReset_Complete.Color_1 	:= reset_complete_C
		oPixReset_Complete.Color_2 	:= reset_complete_C2
		
		oPixReset_Skip := {}
        oPixReset_Skip.X           := reset_skip_x
        oPixReset_Skip.Y           := reset_skip_y
        oPixReset_Skip.Color_1     := reset_skip_c1
		
		oPixReset_Continue := {}
		oPixReset_Continue.X 		:= reset_continue_x
		oPixReset_Continue.Y 		:= reset_continue_y
		oPixReset_Continue.Color_1 	:= reset_continue_c1		
	}
}

;Main Loop
Loop_GemRuns()
{
	; Check to see if there is already an adventure running. If so, this will force a reset
	bAdventureWindowFound := AdventureWindow_Check(1)
	if (bAdventureWindowFound)
	{
		ResetAdventure()
	}
	
	while (!gFound_Error)
	{
		dtStart := A_Now
		dtLoopStartTime := A_Now
		dtPrevRunTime := DateTimeDiff(dtPrev, dtStart)		
		UpdateToolTip()		
		dtPrev := dtStart			
				
		bAdventureSelected := SelectAdventure()
		if (bAdventureSelected)
		{			
			RunAdventure()
		}
					
		bAdventureWindowFound := AdventureWindow_Check(1)
		if (bAdventureWindowFound)
		{
			ResetAdventure()
		}						
	}	
}

;Start a Run
{	
	SelectAdventure()
	{
		bAdventureWindowFound := AdventureWindow_Check(1)
		if (bAdventureWindowFound)
			return 0
		
		; Ensure we are on the world map before trying find/click buttons  
		if (!WorldMapWindow_Check())
			return 0
		
		; Zooms out campaign map
		CenterMouse()
		Loop 15											
		{
			MouseClick, WheelDown
			Sleep 5
		}	
		Sleep 100		
		
		;get Current Patron
		FindPatron()
		Sleep, 100
		
		; Campaign switching to force world map resets/positions		
		; Select Tomb of Annihilation
		Click %toa_x%, %toa_y%      			
		Sleep 100
		
		; Select A Grand Tour
		Click %swordcoast_x%, %swordcoast_y%	
		Sleep 500
		
		if (!FindTown(town_x, town_y))
		{
			MsgBox, ERROR: Failed to find the Town
			return 0
		}
		MouseClick, L, town_x, town_y
		Sleep 250
		
		if (!StartAdventure(townX, townY))
			return 0

		return 1		
	}

	global oCornerPixel := ""
	
	WorldMapWindow_Check()
	{
		if (!oCornerPixel)
		{
			oCornerPixel := {}
			oCornerPixel.X := worldmap_favor_x
			oCornerPixel.Y := worldmap_favor_y
		
		
			oCornerPixel.Color_1 := worldmap_favor_c1	
			oCornerPixel.Color_2 := worldmap_favor_c2
		}
		
		; Wait for up to 5 second with 4 checks per second for the pixel to show
		if (!WaitForPixel(oCornerPixel, 5000))
		{			
			return 0
		}
		return 1
	}
	
	global gCurrentPatron := ""
	FindPatron()
	{
		oPatron_NP := {}
		oPatron_NP.X 		:= patron_X
		oPatron_NP.Y 		:= patron_Y
		oPatron_NP.Color_1 	:= patron_NP_C
		
		oPatron_M := {}
		oPatron_M.X 		:= patron_X
		oPatron_M.Y 		:= patron_Y
		oPatron_M.Color_1 	:= patron_M_C
		
		oPatron_V := {}
		oPatron_V.X 		:= patron_X
		oPatron_V.Y 		:= patron_Y
		oPatron_V.Color_1 	:= patron_V_C
		
		gCurrentPatron := "NP"
		if (CheckPixel(oPatron_M))
		{	
			gCurrentPatron := "M"
			gFormation := gFormation_M
			return
		}
		if (CheckPixel(oPatron_V))
		{
			gCurrentPatron := "V"
			gFormation := gFormation_V
			return
		}
		
		if (gFormation = -1)
		{
			gFormation := gFormation_%gCurrentPatron%
		}		
		return		
	}
	
	global oTown := ""
	FindTown(ByRef townX, ByRef townY)
	{
		if(!oTown)
		{
			oTown := {}
			oTown.StartX 	:= townsearch_L 
			oTown.EndX 		:= townsearch_R
			oTown.StartY 	:= townsearch_T
			oTown.EndY 		:= townsearch_B
			oTown.Color_1 	:= townsearch_C
			oTown.HasFound 	:= -1
			oTown.FoundX 	:= ""
			oTown.FoundY	:= ""
		}
				
		if (oTown.HasFound = 1)
		{
			townX := oTown.FoundX
			townY := oTown.FoundY
			return 1
		}
		
		oTown.StartY 	:= townsearch_T
		nTownCount 	:= 0
		bFound 		:= 1
		bFoundTown 	:= 0
		
		while (bFound = 1)
		{		
			bFound := FindPixel(oTown, found%A_Index%_X, found%A_Index%_Y)
			if (bFound = 1)
			{
				nTownCount := nTownCount + 1
				oTown.StartY := found%A_Index%_Y + 25	
				
				bFoundTown := 1				
			}
			
			sleep, 50
		}
		if (nTownCount = 6)
		{
			townX := found5_X
			townY := found5_Y			
		}
		if (nTownCount = 5)
		{
			townX := found4_X
			townY := found4_Y			
		}
		
		else if (nTownCount = 4)
		{
			townX := found3_X
			townY := found3_Y			
		}
		
		; NOTE: for current map this should not occur and handled by (nTownCount = 2)
		else if (nTownCount = 3)	
		{
			townX := found3_X
			townY := found3_Y
		}
		
		else if (nTownCount = 2)	 
		{
			; An arbitrary position between the location of Town2 for Newer Players
			; for brand new players 	-> Town1 is Tutorial and Town2 is MadWizard
			; when WaterDeep unlocks -> Town1 is MadWizard and Town2 is WaterDeep (tutorial is off top of map)
			nX := 600
			
			;2 Towns Total - Tutorial + MadWizard
			if (found2_X < nX)	
			{
				townX := found2_X
				townY := found2_Y
			}
			; 3 Towns Total - Tutorial + MadWizard + WaterDeep
			; Tutorial Town off/at edge top of screen
			else				
			{
				townX := found1_X
				townY := found1_Y
			}			
		}
		
		else if (nTownCount = 1)	;MadWizard not available yet
		{
			bFoundTown := 0
			MsgBox, Error: It appears that you haven't completed the tutorial yet.
		}
		
		if (bFoundTown = 1)
		{
			oTown.HasFound := 1
			townY := townY + 10 ;move the Y locations slightly lower
			oTown.FoundX := townX
			oTown.FoundY := townY
			return 1
		}
		
		return 0
	}

	global oSelect_WinChecker := ""
	global oListScroll_Checker := ""
	global oAdventureSelect := ""
	global oAdventureStart := ""
	
	StartAdventure(townX, townY)
	{
		; Ensure the adventure select window is open
		if (!oSelect_WinChecker)
		{
			oSelect_WinChecker := {}
			oSelect_WinChecker.X 		:= select_win_x
			oSelect_WinChecker.Y 		:= select_win_y
			oSelect_WinChecker.Color_1 	:= select_win_c1
		}
			
		; Check 10 times in 5s intervals for the adventure select window
		; Server lag can cause issues between clicking the town and selector window displaying
		ctr := 0
		while (!bFound and ctr < 10)
		{
			; Open the adventure select window
			Click %town_x%, %town_y%				; Click the town button for mad wizard adventure
			Sleep 100
			
			; Wait for 10 seconds for the selector window to show
			if (WaitForPixel(oSelect_WinChecker, 5000))
				bFound := 1
			
			ctr := ctr + 1
		}
		
		ctr := 0
			
		if (!bFound)
		{
			return 0
		}
		
		; Ensure the adventure select window is scrolled to top
		if (!oListScroll_Checker)
		{
			oListScroll_Checker := {}
			oListScroll_Checker.X 		:= list_top_x
			oListScroll_Checker.Y 		:= list_top_y
			oListScroll_Checker.Color_1 := list_top_c1
		}
		
		; Select mad wizard
		if (!oAdventureSelect)
		{
			oAdventureSelect := {}
			oAdventureSelect.StartX 	:= MW_Find_L 
			oAdventureSelect.EndX 		:= MW_Find_R 
			oAdventureSelect.StartY 	:= MW_Find_T 
			oAdventureSelect.EndY 		:= MW_Find_B 
			oAdventureSelect.Color_1	:= MW_Find_C
			oAdventureSelect.HasFound 	:= -1
			oAdventureSelect.FoundX 	:= ""
			oAdventureSelect.FoundY		:= ""
		}
		
		nX := ((MW_Find_L + MW_Find_R) / 2)
		nY := ((MW_Find_T + MW_Find_B) / 2)
		MouseMove, %nX%, %nY%
		
		bIsNotAtTop := CheckPixel(oListScroll_Checker)
		while (bIsNotAtTop)
		{
			MouseClick, WheelUp
			
			bIsNotAtTop := CheckPixel(oListScroll_Checker)
			
			if (bIsNotAtTop)
				sleep, 50
		}
		
		if (oAdventureSelect.HasFound = 1)
		{
			foundX := oAdventureSelect.FoundX
			foundY := oAdventureSelect.FoundY
			
			MouseClick, Left, %foundX%,%foundY%
			sleep, 500
		}
		else
		{
			CenterMouse()
			sleep, 250				
			
			if (FindPixel(oAdventureSelect, foundX, foundY))
			{
				oAdventureSelect.HasFound 	:= 1
				oAdventureSelect.FoundX 	:= foundX
				oAdventureSelect.FoundY		:= foundY
				
				MouseClick, Left, %foundX%,%foundY%
				sleep, 500
			}
			else
			{
				MsgBox, Error Failed to find Mad Wizard in the Select List
				return 0
			}
		}

		if (!oAdventureStart)
		{
			oAdventureStart := {}
			oAdventureStart.StartX 		:= MW_Start_L 
			oAdventureStart.EndX 		:= MW_Start_R
			oAdventureStart.StartY 		:= MW_Start_T
			oAdventureStart.EndY 		:= MW_Start_B
			oAdventureStart.Color_1		:= MW_Start_C
			oAdventureStart.HasFound	:= -1
			oAdventureStart.FoundX 		:= ""
			oAdventureStart.FoundY		:= ""
		}	
		
		if (oAdventureStart.HasFound = 1)
		{
			foundX := oAdventureStart.FoundX
			foundY := oAdventureStart.FoundY
			
			MouseClick, L, foundX, foundY
			return 1
		}
		else
		{
			if (FindPixel(oAdventureStart, foundX, foundY))
			{
				oAdventureStart.HasFound := 1
				oAdventureStart.FoundX := foundX
				oAdventureStart.FoundY := foundY
				
				MouseClick, L, foundX, foundY
				return 1
			}
			else
			{
				return 0
			}
		}
	
		return 0
	}
}	

; Handle Start/Transition/Reset
{
	RunAdventure()
	{
		; Allow up to 30 seconds to find the Adventure Window as server/game lag can cause varying time delays
		bAdventureWindowFound := AdventureWindow_Check(30000)
		if (!bAdventureWindowFound)
			return 0
		
		; Wait for 1st mob to enter screen. Will wait up to 1min before failing
		if (FindFirstMob())
		{			
			sleep, 100			
			Send, %gFormation%
			sleep, 100
			Send, %gFormation% ; Send twice, just in case.
		}
		else
		{
			return 0
		}			
		
		bContinueRun := 1
		gLevel_Number := 1
		UpdateToolTip()
		
		while (bContinueRun)
		{
			bRunComplete := DoLevel(gLevel_Number)		
			if (bRunComplete)
			{
				gLevel_Number := gLevel_Number + 1
				UpdateToolTip()
				
				if (gLevel_Number > nMax_Level)
				{
					bContinueRun := 0
				}			
			}
			else
			{
				bContinueRun := 0
			}
		}
	}

	global oAdventureWindowCheck := 0
	
	; Allow up to 5 seconds to find the adventure window		
	AdventureWindow_Check(wait_time := 5000)
	{
		; Redish pixel in the Gold/Dps InfoBox while an adventure is running
		if (!oAdventureWindowCheck)
		{
			oAdventureWindowCheck := {}
			oAdventureWindowCheck.X := adventure_dps_x
			oAdventureWindowCheck.Y := adventure_dps_y
			oAdventureWindowCheck.Color_1 := adventure_dps_c1
			oAdventureWindowCheck.Color_2 := adventure_dps_c2
		}
		
		; Wait for up to 5 second with 4 checks per second for the pixel to show
		if (!WaitForPixel(oAdventureWindowCheck, wait_time))
		{			
			return 0
		}
		return 1
	}
	
	global oMobName := ""
	FindFirstMob()
	{
		if (!gMobName)
		{
			oMobName := {}
			oMobName.StartX := mob_area_L
			oMobName.EndX 	:= mob_area_R
			oMobName.StartY := mob_area_T
			oMobName.EndY 	:= mob_area_B	
			oMobName.Color_1 := mob_area_C
		}
		
		bFound := 0		
		bFound := WaitForFindPixel(oMobName, outX, outY)
		
		return bFound	
	}
	
	DoLevel(nLevel_Number)
	{	
		; Wait until level 4 to buy champs to allow more gold to accumulate. This helps low-favor players.
		if (nLevel_Number = 4)
		{			
			; Buy all the champs at level one. Or try to anyway. Skip f12 because that can conflict with screenshots
			Send {F1}
			Send {F2}
			Send {F3}
			Send {F4}
			Send {F5}
			Send {F6}
			Send {F7}
			Send {F8}
			Send {F9}
			Send {F10}
			Send {F11}
			
			;Now set the users preferred formation since all the champs have been bought
			Send, %gFormation%
			sleep, 100
			Send, %gFormation%
			
			sleep, 100				
		}
		
		; Get the wave number and mod it to be 1 through 5
		nWaveNumber := Mod(nLevel_Number, 5) 
		
		bContinueWave := 1
		while (bContinueWave)
		{
			IfWinActive, Idle Champions
			{
				Send, {Right}
			}
			else
			{	
				return
			}		
			
			bFoundTransition := CheckTransition()
			if (bFoundTransition)
			{
				; Wait for a black pixel to pass this point (right side of screen)
				while(CheckTransition())
				{
					sleep, 100
				}
				bContinueWave := 0
			}
			else
			{
				if (gEnableMouseSweep = 1 and nWaveNumber)
				{
					MouseSweep()
				}
				
				if (gEnableAutoClick = 1)
				{
					MouseAutoClick()
				}
				
				if( !gEnableMouseSweep and !gEnableAutoClick )
				{
					sleep, 100
				}
			}
		}
		
		if (bFoundTransition)
		{			
			return 1
		}
		else
		{
			return 0
		}
	}
	
	MouseSweep()
	{
		startx 	:= mob_area_L
		endx 	:= mob_area_R
		starty 	:= mob_area_T			
		endy	:= mob_area_B		
		vertical_step := ((endy - starty) / 4)    	
		horizontal_step := ((endx - startx) / 4)	
			
		Loop, 4
		{
			if (CheckTransition())
			{
				return
			}
			MouseMove, (startx + (horizontal_step * A_Index)), starty, 5
			MouseMove, (startx + (horizontal_step * A_Index)), endy, 5
		}					
	}
	
	MouseAutoClick()
	{
		CenterMouse()
		Loop, 10
		{
			if (CheckTransition())
			{
				return
			}
			Click
			sleep, 10
		}
	}
		
	ResetAdventure()
	{
		IfWinActive, Idle Champions
		{
			Send, R
		}
		else
		{	
			return
		}
		
		bFound := 0		
		
		if (WaitForFindPixel_Moving(oPixReset_Complete, outX, outY))
		{
			bFound := 1		
			oClickPixel := {}
			oClickPixel.X := outX + 15
			oClickPixel.Y := outY + 15
			
		
			ClickPixel(oClickPixel)		
		}
						
		if (bFound and WaitForPixel(oPixReset_Skip))
        {
			bFound := 2		
			ClickPixel(oPixReset_Skip)    
        }
		
		if (bFound = 2 and WaitForPixel(oPixReset_Continue))
		{			
			ClickPixel(oPixReset_Continue)	
		}
		
		return 
	}

	gTransitionPixel_Left := ""
	gTransitionPixel_Right := ""

; Level Transition Check
	CheckTransition()
	{
		if (!gTransitionPixel_Left)
		{
			gTransitionPixel_Left := {}
			gTransitionPixel_Left.X 		:= 10
			gTransitionPixel_Left.Y 		:= transition_y
			gTransitionPixel_Left.Color_1 	:= transition_c1
		}
		
		if (!gTransitionPixel_Right)
		{
			gTransitionPixel_Right := {}
			gTransitionPixel_Right.X 		:= gWindowSettings.Width - 10
			gTransitionPixel_Right.Y 		:= transition_y
			gTransitionPixel_Right.Color_1 	:= transition_c1
		}
		
		return (CheckPixel(gTransitionPixel_Left) or CheckPixel(gTransitionPixel_Right))
	}

}

; Pixel Functions
{
	ClickPixel(oPixel)
	{
		MoveToPixel(oPixel)
		sleep, 10
		Click
	}

	MoveToPixel(oPixel)
	{
		nX := oPixel.X
		nY := oPixel.Y
		
		IfWinActive, Idle Champions
			MouseMove, nX, nY
	}

	CheckPixel(oPixel)
	{		
		nX := oPixel.X
		nY := oPixel.Y
		sColor_1 := oPixel.Color_1
		sColor_2 := oPixel.Color_2
		sColor_B1 := oPixel.Color_B1
		sColor_B2 := oPixel.Color_B2
		
		PixelGetColor, oColor, nX, nY, RGB	
		
		bFound := 0
		bFound := ((oColor = sColor_1) or bFound)
			
		if (sColor_2) 	
			bFound :=((oColor = sColor_2) or bFound)
		
		if (sColor_B1) 	
			bFound := ((oColor = sColor_B1) or bFound)
		
		if (sColor_B2) 	
			bFound := ((oColor = sColor_B2) or bFound)
		
		if(bFound)
		{
			return 1
		}
		else
		{
			return 0
		}
	}
	
	; Searchs for a pixel within a rectangle
	FindPixel(oPixel, ByRef foundX, ByRef foundY)
	{
		
		nStartX := oPixel.StartX
		nStartY := oPixel.StartY
		nEndX := oPixel.EndX
		nEndY := oPixel.EndY
		
		if (!nStartX) 	
			nStartX := 0
		
		if (!nStartY) 	
			nStartY := 0
		
		if (!nEndX) 	
			nEndX := gWindowSettings.Width
		
		if (!nEndY) 	
			nEndY := gWindowSettings.Height
				
		PixelSearch, foundX, foundY,  nStartX, nStartY, nEndX, nEndY, oPixel.Color_1, , Fast|RGB
		if !(ErrorLevel = 1 or ErrorLevel = 2)
		{
			return 1
		}
		
		return 0
	}
		
	WaitForPixel(oPixel, timer := 60000, interval := 250)
	{
		ctr := 0
		while (ctr < timer)
		{		
			ctr :=  ctr + interval			
			if (CheckPixel(oPixel))
				return 1

			sleep, %interval%	
		}
		return 0
	}	

	WaitForFindPixel(oPixel, ByRef foundX, ByRef foundY, timer := 60000, interval := 250)
	{
		ctr := 0
		while (ctr < timer)
		{		
			ctr :=  ctr + interval			
			if (FindPixel(oPixel, foundX, foundY))
				return 1
			
			sleep, %interval%	
		}
		return 0
	}

	WaitForFindPixel_Moving(oPixel, ByRef foundX, ByRef foundY, timer := 60000, interval := 250)
	{
		ctr := 0
		prevX := 0
		prevY := 0		
		
		; Look for a pixel in seach area and ensure it has stopped moving (i.e. we found color in box with same X and Y values)
		while (ctr < timer)
		{		
			ctr :=  ctr + interval
			if (FindPixel(oPixel, foundX, foundY))
			{
				if (prevX = foundX and prevY = foundY)
				{
					return 1
				}
				else
				{
					prevX := foundX
					prevY := foundY
				}
			}
			sleep, %interval%	
		}
		
		return 0		
	}
}

; HHelper functions
{
		CenterMouse()
	{
		nX := gWindowSettings.Width / 2
		nY := gWindowSettings.Height / 2
		MouseMove, nX, nY
		return
	}
		
	DateTimeDiff(dtStart, dtEnd)
	{
		dtResult := dtEnd
		
		EnvSub, dtResult, dtStart, Seconds
		
		nSeconds := Mod(dtResult, 60)
		nMinutes := Floor(dtResult / 60)
		nHours := Floor(nMinutes / 60)
		nMinutes := Mod(nMinutes, 60)
		
		sResult := (StrLen(nHours) = 1 ? "0" : "") nHours ":" (StrLen(nMinutes) = 1 ? "0" : "") nMinutes ":" (StrLen(nSeconds) = 1 ? "0" : "") nSeconds
		
		return sResult
	}

	TimeSpanAdd(ts1, ts2)
	{
		time_parts1 := StrSplit(ts1, ":")
		time_parts2 := StrSplit(ts2, ":")
		
		t1_seconds := (((time_parts1[1] * 60) + time_parts1[2]) * 60) + time_parts1[3]
		t2_seconds := (((time_parts2[1] * 60) + time_parts2[2]) * 60) + time_parts2[3]
		
		dtResult := t1_seconds + t2_seconds
		
		nSeconds := Mod(dtResult, 60)
		nMinutes := Floor(dtResult / 60)
		nHours := Floor(nMinutes / 60)
		nMinutes := Mod(nMinutes, 60)
		
		sResult := (StrLen(nHours) = 1 ? "0" : "") nHours ":" (StrLen(nMinutes) = 1 ? "0" : "") nMinutes ":" (StrLen(nSeconds) = 1 ? "0" : "") nSeconds
		
		return sResult
	}

	TimeSpanAverage(ts1, nCount)
	{
		time_parts1 := StrSplit(ts1, ":")
			
		t1_seconds := (((time_parts1[1] * 60) + time_parts1[2]) * 60) + time_parts1[3]
			
		if (!nCount)
		{
			return "00:00:00"
		}
		
		dtResult := t1_seconds / nCount	
		
		nSeconds := Floor(Mod(dtResult, 60))
		nMinutes := Floor(dtResult / 60)
		nHours := Floor(nMinutes / 60)
		nMinutes := Mod(nMinutes, 60)
		
		sResult := (StrLen(nHours) = 1 ? "0" : "") nHours ":" (StrLen(nMinutes) = 1 ? "0" : "") nMinutes ":" (StrLen(nSeconds) = 1 ? "0" : "") nSeconds
		
		return sResult
	}
}
