/*
By Deatho0ne
version 05.07.2020
Based on Gladio Stricto's https://pastebin.com/Rd8wWSVC
have mentioned a few other things he has created in here
A few things on Deatho0ne's Modified Bootch Script
which is based on Bootch's script
*/

/*
Please make sure your Steam does not take screen shots with F12
This is roughly an e20 favor script for Torm, it might be lower
    Most likely need to be able to level at least once every seat in area 1
Also need to be able to get to the specs of the champs you use before the areas you put in
If you can not do this yet, I would say try Bootch's script
    Please make sure your Steam does not take screen shots with F12
This can work with only 1 familar on leveling click damage
    but the more you have the better
Most likely need to change BuildHeroData() based on who you have
    if you have and use Havilar & Deekin
    You will want to also look at FindInterfaceCue("z14text.png", i, j, 1)
    and change what ults are cast
Deatho0ne does not plan to maintain this for you
    I will make updates though based on my needs
*/
SetWorkingDir, %A_ScriptDir%
SetMouseDelay, 30

;VARIABLES BASED NEEDED TO BE CHANGED

;your Briv slot gear %
Global slot4percent := 525.6
;if using speed Pots, manually specify your Briv farming time in minutes
Global speedBrivTime := 0
Global overrideBrivTime := 0

;Number of speed potions to use at the beginning of each run
Global speedPotSmall := 0
Global speedPotMedium := 0
Global speedPotLarge := 0
Global speedPotHuge := 0

;AreaLow used for None Strahd Patrons
;   Does use Briv has a stop at the final area to build up his stacks
;   11 complete is purely used for testing by me
Global AreaLow := 326 ;z26 to z29 has portals, z41 & z16 has a portal also
;This variable is in minutes and you need to see how fast you run the above
;   It is a saftey net incase something breaks during a FP
;   The script will build Briv stacks even if it fails
;   This is to try to maintain the best speed the script can
Global TimeTillFailLow := 33 ;based on the time I see, plus some for patrons

;AreaHigh used for Strahd, does not use Briv.
;   Is based on Click damage
;	if you lack Briv this might not be the script for you
;	It can work, but you shall have to modify
Global AreaHigh := 326
;Same as TimeTillFailLow, but for Strahd
;   I do challenges first so only run the script after done with them
;   Minutes (area at when recorded)
;       31 143, 38 178, 41 211, 44 226
Global TimeTillFailHigh := 90 ;guess based on the above numbers
;This allows for gem count at the end of each run
;	This will add about .5secs to 3secs depending on speed of your computer to all runs
;	Might not work if the gem count over 999
;		This is due to 1 is chopped wierd
;	Only tested what this does after area 11
Global RunStatsCapture := False

;VARIABLES NOT NEEDED TO BE CHANGED
;   If you make no major changes to the script
Global Specialized := 1, LevelKey := 2, SliceName := 3
Global ZoomedOut = False, ResetTest := False
Global NpVariant := False, MirtVariant := False, VajraVariant := False, StrahdVariant := False
Global HeroData := []
Global RunCount := 0, FailedCount := 0
Global dtStartTime := "00:00:00", dtLastRunTime := "00:00:00"

LoadTooltip()

;click while keys are held down
$F1::
    While GetKeyState("F1", "P") {
        MouseClick
        Sleep 0
    }
return

;start the Mad Wizard gem runs
$F2::
    Menu, Tray, Icon, %SystemRoot%\System32\setupapi.dll, 10
    ResetAdventure()
    dtStartTime := A_Now
    loop {
        dtLastRunTime := A_Now
        StartAdventure()
        WaitForLoading()
        WaitForResults()
        BuildBrivStacks()
        ResetAdventure()
    }
return

;click until Reload or Exiting the app
$F3::
    Menu, Tray, Icon, %SystemRoot%\System32\setupapi.dll, 10
    loop {
        MouseClick
        Sleep 0
    }
return

;Reload the script
$F9::
    if RunCount > 0
        DataOut()
    Reload
return

;kills the script
$F10::ExitApp

$F6::
    ; Used for testing when needed
    ;CaptureResultsScreen()
return

$`::Pause

#c::
    WinGetPos, X, Y, Width, Height, A
    WinMove, A,, (Max(Min(Floor((X + (Width / 2)) / A_ScreenWidth), 1), 0) * A_ScreenWidth) + ((A_ScreenWidth - Width) / 2), (A_ScreenHeight - Height) / 2
return

BuildHeroData() {
    HeroData.push([ False, "{F6}", "specChoices\shandie.png" ])
    HeroData.push([ False, "{F12}", "specChoices\melf.PNG" ])
    if Not VajraVariant {
        HeroData.push([ False, "{F8}", "specChoices\hitch.png" ])
    }
    else if VajraVariant {
        ;HeroData.push([ False, "{F7}", "specChoices\minsc.png" ])
    }
    if Not StrahdVariant {
        HeroData.push([ False, "{F4}", "specChoices\sentry.png" ])
        HeroData.push([ False, "{F5}", "specChoices\briv.png" ])
        HeroData.push([ False, "{F3}", "specChoices\binwin.png" ])
    }
    if Not (MirtVariant Or StrahdVariant) {
        HeroData.push([ False, "{F1}", "specChoices\deekin.png" ])
    }
    if Not (VajraVariant Or StrahdVariant) {
        HeroData.push([ False, "{F2}", "specChoices\celeste.PNG" ])
        HeroData.push([ False, "{F10}", "specChoices\havilar.png" ])
    }
}

SafetyCheck(Skip := False) {
    While(Not WinExist("ahk_exe IdleDragons.exe")) {
        Run, "C:\Program Files (x86)\Steam\steamapps\common\IdleChampions\IdleDragons.exe"
        Sleep 30000
        ZoomedOut := False
    }
    if Not Skip {
        WinActivate, ahk_exe IdleDragons.exe
    }
}

DirectedInput(s) {
    SafetyCheck(True)
    ControlFocus,, ahk_exe IdleDragons.exe
    ControlSend,, {Blind}%s%, ahk_exe IdleDragons.exe
    Sleep 250
}

FindInterfaceCue(filename, ByRef i, ByRef j, k = 360) {
    SafetyCheck()
    WinGetPos,,, width, height, A
    loop {
        Sleep 333
        ImageSearch, i, j, 0, 0, %width%, %height%, *10 *Trans0x00FF00 %filename%
        if (ErrorLevel = 0) {
            return True
        }
        if (A_Index >= k) {
            return False
        }
    }
}

ResetStep(filename, k, l, clicks = 2) {
    if FindInterfaceCue(filename, i, j) {
        if FindInterfaceCue(filename, i, j) {
            SafetyCheck()
            MouseClick, L, i+k, j+l, clicks
            return
        }
    }
    Reload
}

ResetTest() {
    if FindInterfaceCue("noneAdventure\swordCoastCorrect.png", i, j, 1) {
        return False
    }
    else if FindInterfaceCue("noneAdventure\swordCoastWrong.png", i, j, 1) {
        SafetyCheck()
        MouseClick, L, i+55, j+14, 2
        return False
    }
    return True
}

ResetAdventure() {
    if (ResetTest Or ResetTest()) {
        if FindInterfaceCue("runAdventure\reset.png", i, j) {
            DirectedInput("r")
        }
        Sleep 500
        ResetStep("runAdventure\complete.png", 40, 10)
        ResetStep("noneAdventure\skip.png", 20, 10)
        if ((RunCount > 0) And RunStatsCapture) {
            CaptureResultsScreen()
        }
        ResetStep("noneAdventure\continue.png", 50, 10)
        
        loop {
            if (A_Index > 480) {
                Reload
            }
            if Not ResetTest() {
                break
            }
        }
    }
    
    if Not (NpVariant Or MirtVariant Or VajraVariant Or StrahdVariant) {
        if FindInterfaceCue("noneAdventure\MirtVariant.PNG", i, j, 1) {
            MirtVariant := True
        }
        else if FindInterfaceCue("noneAdventure\VajraVariant.PNG", i, j, 1) {
            VajraVariant := True
        }
        else if FindInterfaceCue("noneAdventure\StrahdVariant.PNG", i, j, 1) {
            StrahdVariant := True
        }
        else {
            NpVariant := True
        }
        BuildHeroData()
    }
    
    If(Mod(RunCount, 30) == 29) {
        PostMessage, 0x112, 0xF060,,, ahk_exe IdleDragons.exe
        Sleep 20000
        Run, "C:\Program Files (x86)\Steam\steamapps\common\IdleChampions\IdleDragons.exe"
        Sleep 30000
        ZoomedOut := False
    }

    if (Not ZoomedOut) And FindInterfaceCue("noneAdventure\swordCoastCorrect.png", i, j, 1) {
        SafetyCheck()
        MouseClick, L, i+200, j+14, 2
        loop 15	 {
            MouseClick, WheelDown
            Sleep 5
        }
        
        ResetTest := True
        ZoomedOut = True
    }
}

StartAdventure() {
    ResetStep("noneAdventure\location.png", 10, 35)
    ResetStep("noneAdventure\madWizard.png", 40, 40)
    ResetStep("noneAdventure\start.png", 60, 10)
}

WaitForLoading() {
    FindInterfaceCue("runAdventure\loading.png", i, j, 20)
    
    loop 360 {
        if Not FindInterfaceCue("runAdventure\loading.png", i, j, 1) {
            break
        }
    }
    
    DirectedInput("q")
    Sleep 1500
    
    if FindInterfaceCue("runAdventure\wait.png", i, j, 1) {
        SafetyCheck()
        MouseClick, L, i+5, j+5, 2, D
        Sleep 150
        MouseClick,,,,, U
        Sleep 100
    }
}

SearchHero(ByRef Hero) {
    if FindInterfaceCue(Hero[SliceName], i, j, 1) {
        loop {
            FindInterfaceCue(Hero[SliceName], x, y, 1)
            if (i = x And j = y) {
                break
            } else {
                i := x, j := y
            }
        }
        
        SafetyCheck()
        MouseClick, L, i+32, j+162, 2, D
        Sleep 150
        MouseClick,,,,, U
        Sleep 250
        
        if FindInterfaceCue(Hero[SliceName], x, y, 1) {
            if (i = x And j = y) {
                SafetyCheck()
                MouseClick, L, i+32, j+162, 2, D
                Sleep 150
                MouseClick,,,,, U
                Sleep 150
            }
        }
        
        Hero[Specialized] := True
        WinGetPos,,, Width, Height, A
        MouseMove, Width/2, Height/2
        return
    }
    DirectedInput(Hero[LevelKey])
}

InitializeRun() {
    LoopedInput := ""
    
    loop % HeroData.Length() {
        HeroData[A_Index][Specialized] := False
        LoopedInput .= HeroData[A_Index][LevelKey]
    }
    
    DirectedInput("q")
    loop 10 {
        DirectedInput(LoopedInput)
    }
    DirectedInput("{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}")
    Sleep 100
    DirectedInput("q")
    Sleep 100
    DirectedInput("12345678") ;assuming Melf is used, since have seen him still have his MM
    Sleep 100
    DirectedInput("q")
}

FailureWork(variants) {
    currentRunTime := round(MinuteTimeDiff(dtLastRunTime, A_Now), 2)
    timeFail := StrahdVariant ? (currentRunTime > TimeTillFailHigh) : (currentRunTime > TimeTillFailLow)
    LoopedTooltip(variants, currentRunTime)
    if timeFail {
        ;hard to test this
        ;   if it works you should never have super bad nights
        ;   if it ever fails I will come back to it
        loop, 10 {
            DirectedInput("{ESC}")
        }
        FailedCount += 1
        loop, 10 {
            ;this image should work just in case
            if FindInterfaceCue("runAdventure\escMenu.PNG", i, j, 1) {
                DirectedInput("{ESC}")
                break
            }
        }
        return True
    }
    return False
}

FullySpecialized() {
    loop % HeroData.Length() {
        if Not HeroData[A_Index][Specialized] {
            return False
        }
    }
    return True
}

SendRight() {
    Sleep 10
    DirectedInput("{Right}")
    Sleep 10
    Send {Right}
}

WaitForResults() {  
    InitializeRun()

    areaNum := StrahdVariant ? AreaHigh : AreaLow
    workingArea := "areas\" . areaNum . "working.PNG" ;meant to stop on areaNum
    completeArea := "areas\" . areaNum . "complete.PNG" ;meant if skip areaNum
    variants := "" . NpVariant . "" . MirtVariant . "" . VajraVariant . "" . StrahdVariant
    cancel2 := True
    countLoops := 0
    potionsUsed := False
    loop {
        countLoops += 1
        if (countLoops > 6) {
            if FailureWork(variants) {
                return
            }
            countLoops := 0
        }
        
        if FullySpecialized() {
            if (Not potionsUsed) {
                UsePotions()
                potionsUsed := True
            }
            ;simple click incase of fire
            
            SafetyCheck()
            MouseClick, L, 650, 450, 2
            
            if (FindInterfaceCue(workingArea, i, j, 1) Or ((Not Strahd) And FindInterfaceCue(completeArea, i, j, 1))) {
                break
            }

            SendRight()
            
            if FindInterfaceCue("runAdventure\cancel.png", i, j, 1) {
                SafetyCheck()
                MouseClick, L, i+15, j+15, 2
                Sleep 50
            }
            if cancel2 {
                ;only exist to deal with the pop ups
                if FindInterfaceCue("runAdventure\cancel2.PNG", i, j, 1) {
                    SafetyCheck()
                    MouseClick, L, i+7, j+7, 2
                    Sleep 50
                } else {
                    cancel2 := False
                }
            }
            
            SendRight()
            
            if FindInterfaceCue("runAdventure\progress.png", i, j, 1) {
                DirectedInput("g")
            }

            SendRight()

            if StrahdVariant And FindInterfaceCue("runAdventure\z14text.png", i, j, 1) {
                ;numbers are based on what I am doing, I put familars on a few champs to get them to their specs fast
                if StrahdVariant {
                    DirectedInput("123456789") ;all
                }
                /*
                if MirtVariant {
                    DirectedInput("123")
                } else if VajraVariant {
                    DirectedInput("23456789") ;not 1
                } else {
                    DirectedInput("2346789") ;not 1 or 5
                }
                */
            }

            SendRight()
            continue
        }
        
        loop % HeroData.Length() {
            if Not HeroData[A_Index][Specialized] {
                SearchHero(HeroData[A_Index])
            }
        }
    }
}

BuildBrivStacks() {
    ;no reason to wait if no Briv
    if Not StrahdVariant {
        DirectedInput("w")
        DirectedInput("g")
        ;10000 takes awhile, but should add a second or more before the sleep
        ;I actually like this, could have it be calculated once though, if you want
        ;1.05 is just meant to add a few secs on top of the stacks
        ;Use different overrides for if speed pot is active, in a failure case the pots will be inactive and need to farm longer
        if (FindInterfaceCue("runAdventure\speedUsed.png", i, j, 1) And speedBrivTime > 0)
            Sleep % speedBrivTime * 60 * 1000 * 1.05
        else if overrideBrivTime > 0 
            Sleep % overrideBrivTime * 60 * 1000 * 1.05
        else 
            Sleep % SimulateBriv(10000) * 60 * 1000 * 1.05
    }
    RunCount += 1
}

SimulateBriv(i) {
    ;Original version by Gladio Stricto - https://pastebin.com/Rd8wWSVC
    ;	this is modified to work within the GemFarm
    chance := ((slot4percent / 100) + 1) * 0.25
    trueChance := chance
    skipLevels := Floor(chance + 1)
    if (skipLevels > 1) {
        trueChance := 0.5 + ((chance - Floor(chance)) / 2)
    }
    
    totalLevels := 0
    totalSkips := 0
    
    loop % i {
        level := 0.0
        skips := 0.0
        loop {
            Random, x, 0.0, 1.0
            if (x < trueChance) {
                level += skipLevels
                skips++
            }
            
            level++
        }
        until level > AreaLow
        
        totalLevels += level
        totalSkips += skips
    }
    
    avgSkips := Round(totalSkips / i, 2)
    avgStacks := Round((1.032**avgSkips) * 48, 2)
    ;want to make these numbers better, based on real time to stack
    ;	these are based on a small data set by kyle & theMickey_
    multiplier := 0.1346894362, additve := 41.86396406
    roughTime := (multiplier * avgStacks) + additve
    brivWaitMinutes := roughTime / 60
    ;Briv normally dies if over 3 minutes
    return (brivWaitMinutes > 3) ? 3 : brivWaitMinutes
}

FindGemsCue(filename, ByRef x, ByRef y, ByRef GemsEarned) {
    ;based on Gladio Strico's https://discordapp.com/channels/357247482247380994/474639469916454922/700022596833640459
    SafetyCheck()
    
    MouseMove, x+14, y+16, 0
    fileToSearch := "gemsFound\" . filename
    ImageSearch, i,, x, y, x+14, y+16, *30 %fileToSearch%.png
    if (ErrorLevel = 0) {
        x := i + 5
        GemsEarned .= filename
    }
    return (ErrorLevel = 0)
}

CaptureResultsScreen() {
    ;based on Gladio Strico's https://discordapp.com/channels/357247482247380994/474639469916454922/700022596833640459
    SafetyCheck()
    FormatTime, CurrentTime, %A_Now%, yyyy-MM-dd HH:mm:ss
    gemsFound := "gemsFound\"
    FindInterfaceCue("gemsFound\gemsFound.png", i, j)
    GemsEarned := ""
    x := i+103
    y := j-3
    
    loop {
        Found := False
        
        Found |= FindGemsCue("1", x, y, GemsEarned)
        Found |= FindGemsCue("2", x, y, GemsEarned)
        Found |= FindGemsCue("3", x, y, GemsEarned)
        Found |= FindGemsCue("4", x, y, GemsEarned)
        Found |= FindGemsCue("5", x, y, GemsEarned)
        Found |= FindGemsCue("6", x, y, GemsEarned)
        Found |= FindGemsCue("7", x, y, GemsEarned)
        Found |= FindGemsCue("8", x, y, GemsEarned)
        Found |= FindGemsCue("9", x, y, GemsEarned)
        Found |= FindGemsCue("0", x, y, GemsEarned)
        
        if Not Found {
            break
        }
    }
    
    FileAppend, %CurrentTime%`t`t%GemsEarned%`n, MadWizard-Gems.txt
}

DataOut() {
    FormatTime, currentDateTime,, MM/dd/yyyy HH:mm:ss
    dtNow := A_Now
    toWallRunTime := DateTimeDiff(dtStartTime, dtLastRunTime)
    lastRunTime := DateTimeDiff(dtLastRunTime, dtNow)
    totBosses := Floor(AreaLow / 5) * RunCount
    currentPatron := NpVariant ? "NP" : MirtVariant ? "Mirt" : VajraVariant ? "Vajra" : StrahdVariant ? "Strahd" : "How?"
    InputBox, areaStopped, Area Stopped, Generaly stop on areas ending in`nz1 thru z4`nz6 thru z9
    ;meant for Google Sheets/Excel/Open Office
    FileAppend,%currentDateTime%`t%AreaLow%`t%toWallRunTime%`t%lastRunTime%`t%RunCount%`t%totBosses%`t%currentPatron%`t%FailedCount%`t%areaStopped%`n, MadWizard-Bosses.txt
}

UsePotions() {
    if (speedPotSmall > 0 Or speedPotMedium > 0 Or speedPotLarge > 0 Or speedPotHuge > 0) {
        while (Not FindInterfaceCue("runAdventure\potions\inventory.png", i, j, 1)) {
            Sleep 50
        }
        ResetStep("runAdventure\potions\inventory.png", 5, 5)
        sleep 50
    }
    UsePotion("runAdventure\potions\speedSmall.png", speedPotSmall)
    UsePotion("runAdventure\potions\speedMedium.png", speedPotMedium)
    UsePotion("runAdventure\potions\speedLarge.png", speedPotLarge)
    UsePotion("runAdventure\potions\speedHuge.png", speedPotHuge)
}

UsePotion(fileName, numberToUse) {
    if (numberToUse > 0) {
        Loop 10 {
            if FindInterfaceCue(fileName, x, y, 1)
                break
            ResetStep("runAdventure\potions\inventoryPage.png", 5, 5, 1)
            sleep 50
        }
        ResetStep(fileName, 5, 5)
        potionCount := 1
        while numberToUse > potionCount {
            if (potionCount = 10) {
                break
            }
            potionCount++
            ResetStep("runAdventure\potions\potionIncrement.png", 5, 5, 1)
            sleep 5
        }
        ResetStep("runAdventure\potions\potionUse.png", 5, 5, 1)
        sleep 50
    }
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
    LoopedTooltip(variants, currentRunTime) {
        ToolTip, % "NpMiVaSt: " variants "`nMins since start: " currentRunTime, 50, 200, 2
        SetTimer, RemoveToolTip, -1000
        return
    }
    RemoveToolTip:
        ToolTip
    return
}