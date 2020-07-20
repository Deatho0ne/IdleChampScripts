SetWorkingDir, %A_ScriptDir%
SetDefaultMouseSpeed, 10
SetMouseDelay, 10
SetKeyDelay, 10
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen

;VARIABLES BASED NEEDED TO BE CHANGED
Global BrivTime := 205 / 60 ;BRIV BUILD TIME
Global SpeedBrivTime := 0 ;0.5 ;potion speed
Global ResetArea := 330 ;what you set Modron to reset at
Global StackArea := 326 ;z26 to z29 has portals, z41 & z16 has a portal also

;VARIABLES TO CHANGE IF YOU ARE HAVING TIMING ISSUES
Global ScriptSpeed := 1, DefaultSleep := 50

;VARIABLES NOT NEEDED TO BE CHANGED
;   If you make no major changes to the script
Global RunCount := 0, Crashes := 0, AreaStarted := 0, Bosses := 0, BossesPerHour := 0
Global dtStartTime := "00:00:00", dtFirstResetTime := "00:00:00"

LoadTooltip()

;start the Mad Wizard gem runs
$F2::
    Menu, Tray, Icon, %SystemRoot%\System32\setupapi.dll, 10
	InputBox, areaStart, Area Started, Does not mater just enter current area
	AreaStarted := areaStart
    dtStartTime := A_Now
	dtFirstResetTime := A_Now
	WaitForResults()
return

;Reload the script
$F9::
    if RunCount > 0
        DataOut()
    Reload
return

;kills the script
$F10::
	if RunCount > 0
        DataOut()
ExitApp

$`::Pause

#c::
    WinGetPos, X, Y, Width, Height, A
    WinMove, A,, (Max(Min(Floor((X + (Width / 2)) / A_ScreenWidth), 1), 0) * A_ScreenWidth) + ((A_ScreenWidth - Width) / 2), (A_ScreenHeight - Height) / 2
return


SafetyCheck(Skip := False) {
    While(Not WinExist("ahk_exe IdleDragons.exe")) {
        Run, "C:\Program Files (x86)\Steam\steamapps\common\IdleChampions\IdleDragons.exe"
        Sleep 30000
        Crashes++
		DirectedInput("2345678")
		Sleep, 5000
		DirectedInput("2345678")
    }
    if Skip {
        WinActivate, ahk_exe IdleDragons.exe
    }
}

DirectedInput(s) {
	SafetyCheck()
	ControlFocus,, ahk_exe IdleDragons.exe
	ControlSend, ahk_parent, {Blind}%s%, ahk_exe IdleDragons.exe
	Sleep, %ScriptSpeed%
}

FindInterfaceCue(filename, ByRef i, ByRef j, time = 0) {
	SafetyCheck()
	WinGetPos, x, y, width, height, ahk_exe IdleDragons.exe
	start := A_TickCount
	Loop {
		ImageSearch, outx, outy, x, y, % x + width, % y + height, *15 *Trans0x00FF00 %filename%
		If (ErrorLevel = 0) {
			i := outx - x, j := outy - y
			Return True
		}
		If ((A_TickCount - start)/1000 >= time) {
			Return False
		}
		Sleep, %ScriptSpeed%
	}
}

FindAndClick(filename, k, l, timeToRun := 0) {
    If FindInterfaceCue(filename, i, j, timeToRun) {
		SafetyCheck(true)
		MouseClick, L, i+k, j+l, clicks
		Sleep, 10
	}
	Else If (bool) {
		Reload
	}
}

CalcBossesPerHour() {
	if (RunCount) > 0 {
		Bosses := round((RunCount - 1) * ResetArea / 5, 0)
		Bosses += ceil((ResetArea - AreaStarted) / 5)
	} else {
		Bosses := 0
	}
	BossesPerHour := round(Bosses / (MinuteTimeDiff(dtStartTime, A_Now) / 60), 0)
}

WaitForResults() {  
    workingArea := "areas\" . StackArea . "working.PNG" ;meant to stop on areaNum
    completeArea := "areas\" . StackArea . "complete.PNG" ;meant if skip areaNum
    brivStacked := false
	dtLastRunTime := A_Now
	num := 255
    loop {
        if FindInterfaceCue("areas\1start.png", i, j) and brivStacked {
            RunCount += 1
            dtLastRunTime := A_Now
			CalcBossesPerHour()
            Sleep, 15000
            DirectedInput("23456")
			Sleep, 5000
			DirectedInput("23456")
            brivStacked := false
			Sleep, 5000
			DirectedInput("e")
			Sleep, 10
			DirectedInput("e")
        }

        if (Not brivStacked And (FindInterfaceCue(workingArea, i, j) Or FindInterfaceCue(completeArea, i, j))) {
            BuildBrivStacks()
            brivStacked := true
        }

		FindAndClick("runAdventure\Okay.png", 5, 5)
            
        if FindInterfaceCue("runAdventure\progress.png", i, j) {
            DirectedInput("g")
        }
		
		if (num > 29) {
			LoopedTooltip(round(MinuteTimeDiff(dtLastRunTime, A_Now), 2))
			num := 0
		} else {
			num++
		}
    }
}

BuildBrivStacks() {
    DirectedInput("w")
    DirectedInput("g")
    Sleep 5
    DirectedInput("w")
    Sleep 5
    DirectedInput("w")
    if (FindInterfaceCue("runAdventure\speedUsed.png", i, j, 1) And SpeedBrivTime > 0)
        Sleep % SpeedBrivTime * 60 * 1000 * 1.05
    else
        Sleep % BrivTime * 60 * 1000 * 1.05
    DirectedInput("q")
    DirectedInput("g")
    Sleep, 6000
    DirectedInput("q")
}

DataOut() {
    FormatTime, currentDateTime,, MM/dd/yyyy HH:mm:ss
	totTime := DateTimeDiff(dtStartTime, A_Now)
    currentPatron := "Modron" ;not really a Patron any more
	InputBox, areaStopped, Area Stopped, Generaly stop on areas ending in`nz1 thru z4`nz6 thru z9
    ;meant for Google Sheets/Excel/Open Office
    FileAppend,%currentDateTime%`t%currentPatron%`t%ResetArea%`t%totTime%`t%RunCount%`t%AreaStarted%`t%areaStopped%`t%Crashes%`n, MadWizard-BossesMod.txt
}

{ ;time HELPERS
    ;return String HH:mm:ss of the timespan
    DateTimeDiff(dtStart, dtEnd) {
        dtResult := dtEnd
        
        EnvSub, dtResult, dtStart, Seconds
        
        return TimeResult(dtResult)
    }
    
    ;might use later
    TimeSpanAverage(ts1, nCount) {
        time_parts1 := StrSplit(ts1, ":")
        t1_seconds := (((time_parts1[1] * 60) + time_parts1[2]) * 60) + time_parts1[3]
        if (!nCount) {
            return "00:00:00"
        }
        return TimeResult(t1_seconds / nCount)
    }
    
    TimeResult(dtResult) {
        nSeconds := Floor(Mod(dtResult, 60))
        nMinutes := Floor(dtResult / 60)
        nHours := Floor(nMinutes / 60)
        nMinutes := Mod(nMinutes, 60)
        
        sResult := (StrLen(nHours) = 1 ? "0" : "") nHours ":" (StrLen(nMinutes) = 1 ? "0" : "") nMinutes ":" (StrLen(nSeconds) = 1 ? "0" : "") nSeconds
        
        return sResult
    }
    
    MinuteTimeDiff(dtStart, dtEnd) {
        dtResult := dtEnd
        EnvSub, dtResult, dtStart, Seconds
        nSeconds := Floor(Mod(dtResult, 60))
        nMinutes := Floor(dtResult / 60)
        nHours := Floor(nMinutes / 60)
        nMinutes := Mod(nMinutes, 60)
        
        return (nMinutes + (nHours * 60) + (nSeconds / 60))
    }
}

{ ;tooltips
    LoadTooltip() {
        ToolTip, % "Shortcuts`nF2: Run MW`nF9: Reload`nF10: Kill the script`nThere are others", 50, 250, 1
        SetTimer, RemoveToolTip, -5000
        return
    }
    LoopedTooltip(currentRunTime) {
        WinGetPos, x, y, width, height, ahk_exe IdleDragons.exe
        ToolTip, % "Resets: " RunCount "`nCrashes: " Crashes "`nMins since start: " currentRunTime "`nBosses: " Bosses "`nBosses per hour: " BossesPerHour, % x + 50, % y + 200, 2
        SetTimer, RemoveToolTip, -1000
        return
    }
    RemoveToolTip:
        ToolTip,,,,
    return
}