/*
By Deatho0ne
version 04.15.2020
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
Most likely need to change WaitForResults() based on who you have
if you have & use Havilar & Deekin
    You will want to also look at FindInterfaceCue("z14text.png", i, j, 1)
and change what ults are cast
Deatho0ne does not plan to maintain this for you
    I will make updates though based on my needs
*/
SetWorkingDir, %A_ScriptDir%
SetMouseDelay, 30

;kills the app, I cannot find a key I like it on yet, maybe one of these days
;$Esc::ExitApp

;Variables to change
Global slot4percent := 200.0 ;your Briv slot gear %

;AreaLow used for None Strahd Patrons, does use Briv has a stop at the final area to build up his stacks
Global AreaLow := 176 ;z26 to z30 has portals, z41 & z16 has a portal also

;AreaHigh used for Strahd, does not use Briv. Is based mostly on my Click damage level of 270
;	if you lack Briv this might not be the script for you
;	It can work, but you shall have to modify
Global AreaHigh := 266

;both of these variables are used incase something breaks during running
;numbers are in minutes, change this based on how fast you run areas
Global TimeTillFailLow := 23 ;based on the time I see
Global TimeTillFailHigh := 45 ;just a total guess

;True tries reading the gem count at the end of a run
;	This will add about .5secs to 3secs depending on speed of your computer to all runs
;	Might not work if there is a 1 in the gem count or it is over 1k
;		Over 1k most likely will not happen and 1 should be okay for the most part
;	Only tested what this does after area 11, if gems are over 1k this might not get the right data
Global RunStatsCapture := False

;Variables not needed to be changed
Global Specialized := 1, LevelKey := 2, SliceName := 3
Global ZoomedOut = False, ResetTest := False
Global NpVariant := False, MirtVariant := False, VajraVariant := False, StrahdVariant := False
Global RunCount := 0
Global dtStartTime := "00:00:00", dtLastRunTime := "00:00:00"

;click while keys are held down
$F1::
    While GetKeyState("F1", "P") {
        MouseClick
        Sleep 0
    }
Return

;click until Reload or Exiting the app
$F3::
    Menu, Tray, Icon, %SystemRoot%\System32\setupapi.dll, 10
    Loop {
        MouseClick
        Sleep 0
    }
Return

;Reload the script
$F9::
    If RunCount > 0
        DataOut()
    Reload
Return

;read comments below
$F6::
    ; Used for testing when needed
    BuyChests()
    ;CaptureResultsScreen()
Return

;start the Mad Wizard gem runs
$F2::
    Menu, Tray, Icon, %SystemRoot%\System32\setupapi.dll, 10
    ResetAdventure()
    dtStartTime := A_Now
    Loop {
        dtLastRunTime := A_Now
        StartAdventure()
        WaitForLoading()
        WaitForResults()
        BuildBrivStacks()
        ResetAdventure()
    }
Return

$`::Pause

#c::
    WinGetPos, X, Y, Width, Height, A
    WinMove, A,, (Max(Min(Floor((X + (Width / 2)) / A_ScreenWidth), 1), 0) * A_ScreenWidth) + ((A_ScreenWidth - Width) / 2), (A_ScreenHeight - Height) / 2
Return

SafetyCheck(Skip := False) {
    If Not WinExist("ahk_exe IdleDragons.exe") {
        ExitApp
    }
    If Not Skip {
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
    Loop {
        Sleep 333
        ImageSearch, i, j, 0, 0, %width%, %height%, *10 *Trans0x00FF00 %filename%
        If (ErrorLevel = 0) {
            Return True
        }
        If (A_Index >= k) {
            Return False
        }
    }
}

ResetStep(filename, k, l) {
    If FindInterfaceCue(filename, i, j) {
        If FindInterfaceCue(filename, i, j) {
            SafetyCheck()
            MouseClick, L, i+k, j+l
            Return
        }
    }
    Reload
}

ResetTest() {
    If FindInterfaceCue("noneAdventure\swordCoastCorrect.png", i, j, 1) {
        Return False
    }
    If FindInterfaceCue("noneAdventure\swordCoastWrong.png", i, j, 1) {
        SafetyCheck()
        MouseClick, L, i+55, j+14
        Return False
    }
Return True
}

ResetAdventure() {
    If (ResetTest Or ResetTest()) {
        ResetStep("runAdventure\reset.png", 10, 10)
        Sleep 500
        ResetStep("runAdventure\complete.png", 40, 10)
        ResetStep("noneAdventure\skip.png", 20, 10)
        If ((RunCount > 0) And RunStatsCapture) {
            CaptureResultsScreen()
        }
        ResetStep("noneAdventure\continue.png", 50, 10)
        
        Loop {
            If (A_Index > 480) {
                Reload
            }
            If Not ResetTest() {
                Break
            }
        }
    }
    
    if Not (NpVariant Or MirtVariant Or VajraVariant Or StrahdVariant) {
        If FindInterfaceCue("noneAdventure\MirtVariant.PNG", i, j, 1) {
            MirtVariant := True
        }
        Else If FindInterfaceCue("noneAdventure\VajraVariant.PNG", i, j, 1) {
            VajraVariant := True
        }
        Else If FindInterfaceCue("noneAdventure\StrahdVariant.PNG", i, j, 1) {
            StrahdVariant := True
        }
        Else {
            NpVariant := True
        }
    }
    
    If (Not ZoomedOut) And FindInterfaceCue("noneAdventure\swordCoastCorrect.png", i, j, 1) {
        SafetyCheck()
        MouseClick, L, i+200, j+14
        Loop 15	 {
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
    
    Loop 360 {
        If Not FindInterfaceCue("runAdventure\loading.png", i, j, 1) {
            Break
        }
    }
    
    DirectedInput("q")
    Sleep 1500
    
    If FindInterfaceCue("runAdventure\wait.png", i, j, 1) {
        SafetyCheck()
        MouseClick, L, i+5, j+5,, D
        Sleep 150
        MouseClick,,,,, U
        Sleep 100
    }
}

SearchHero(ByRef HeroData) {
    If FindInterfaceCue(HeroData[SliceName], i, j, 1) {
        Loop {
            FindInterfaceCue(HeroData[SliceName], x, y, 1)
            If (i = x And j = y) {
                Break
            }
            Else {
                i := x, j := y
            }
        }
        
        SafetyCheck()
        MouseClick, L, i+32, j+162,, D
        Sleep 150
        MouseClick,,,,, U
        Sleep 250
        
        If FindInterfaceCue(HeroData[SliceName], x, y, 1) {
            If (i = x And j = y) {
                SafetyCheck()
                MouseClick, L, i+32, j+162,, D
                Sleep 150
                MouseClick,,,,, U
                Sleep 150
            }
        }
        
        HeroData[Specialized] := True
        WinGetPos,,, Width, Height, A
        MouseMove, Width/2, Height/2
    }
    Else {
        DirectedInput(HeroData[LevelKey])
    }
}

FullySpecialized(HeroData) {
    Loop % HeroData.Length() {
        If Not HeroData[A_Index][Specialized] {
            Return False
        }
    }
Return True
}

WaitForResults() {
    HeroData := []
    HeroData.push([ False, "{F6}", "specChoices\shandie.png" ])
    HeroData.push([ False, "{F12}", "specChoices\melf.PNG" ])
    If Not VajraVariant {
        HeroData.push([ False, "{F8}", "specChoices\hitch.png" ])
    }
    If Not StrahdVariant {
        HeroData.push([ False, "{F4}", "specChoices\sentry.png" ])
        HeroData.push([ False, "{F5}", "specChoices\briv.png" ])
        HeroData.push([ False, "{F7}", "specChoices\minsc.png" ])
    }
    If Not (MirtVariant Or StrahdVariant) {
        HeroData.push([ False, "{F1}", "specChoices\deekin.png" ])
    }
    If Not (VajraVariant Or StrahdVariant) {
        HeroData.push([ False, "{F2}", "specChoices\celeste.PNG" ])
        HeroData.push([ False, "{F10}", "specChoices\havilar.png" ])
    }
    
    LoopedInput := ""
    
    Loop % HeroData.Length() {
        If Not HeroData[A_Index][Specialized] {
            LoopedInput .= HeroData[A_Index][LevelKey]
        }
    }
    
    DirectedInput("q")
    Loop 10 {
        DirectedInput(LoopedInput)
    }
    DirectedInput("{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}")
    Sleep 100
    DirectedInput("q")
    Sleep 100
    DirectedInput("123456789")
    Sleep 100
    DirectedInput("q")
    
    areaNum := StrahdVariant ? AreaHigh : AreaLow
    workingArea := "areas\" . areaNum . "working.PNG" ;meant to stop on areaNum
    completeArea := "areas\" . areaNum . "complete.PNG" ;meant if skip areaNum
    cancel2 := True
    countLoops := 0
    Loop {
        countLoops += 1
        If (countLoops > 6) {
            currentRunTime := MinuteTimeDiff(dtLastRunTime, A_Now)
            ;ToolTip, % "currentRunTime: " currentRunTime "", 50, 250, 4
            If ((Strahd And (currentRunTime > TimeTillFailHigh)) Or (currentRunTime > TimeTillFailLow)) {
                ;hard to test this
                ;   if it works you should never have bad nights
                ;   if it ever fails I will come back to it
                Loop, 10 {
                    DirectedInput("{ESC}")
                }
                Loop, 10 {
                    ;this image should work just in case
                    If FindInterfaceCue("runAdventure\escMenu.PNG", i, j, 1) {
                        DirectedInput("{ESC}")
                        Break
                    }
                }
                Break
            }
            countLoops := 0
        }
        
        If FullySpecialized(HeroData) {
            ;simple click incase of fire
            SafetyCheck()
            MouseClick, L, 650, 450
            
            If (FindInterfaceCue(workingArea, i, j, 1) Or ((Not Strahd) And FindInterfaceCue(completeArea, i, j, 1))) {
                Break
            }
            
            If FindInterfaceCue("runAdventure\cancel.png", i, j, 1) {
                SafetyCheck()
                MouseClick, L, i+15, j+15
                Sleep 50
            }
            If cancel2 {
                ;only exist to deal with the pop ups
                If FindInterfaceCue("runAdventure\cancel2.PNG", i, j, 1) {
                    SafetyCheck()
                    MouseClick, L, i+15, j+15
                    Sleep 50
                }
                Else {
                    cancel2 := False
                }
            }
            
            If FindInterfaceCue("runAdventure\progress.png", i, j, 1) {
                DirectedInput("g")
            }
            
            If FindInterfaceCue("runAdventure\z14text.png", i, j, 1) {
                ;numbers are based on what I am doing, I put familars on a few champs to get them to their specs fast
                If MirtVariant
                    DirectedInput("123")
                Else If VajraVariant
                    DirectedInput("23456789") ;not 1
                Else If StrahdVariant
                    DirectedInput("123456789") ;all
                Else
                    DirectedInput("2346789") ;not 1 or 5
            }
            
            Loop 4 {
                DirectedInput("{right}")
                Sleep 250
            }
            
            Continue
        }
        
        Loop % HeroData.Length() {
            If Not HeroData[A_Index][Specialized] {
                SearchHero(HeroData[A_Index])
            }
        }
    }
}

BuildBrivStacks() {
    ;no reason to wait if no Briv
    If Not StrahdVariant {
        DirectedInput("w")
        ;10000 takes awhile, but should add a second or more before the sleep
        ;I actually like this, could have it be calculated once though, if you want
        Sleep % SimulateBriv(10000)*60*1000
    }
    RunCount += 1
}

SimulateBriv(i) {
    ;Original version by Gladio Stricto - https://pastebin.com/Rd8wWSVC
    ;	this is modified to work within the GemFarm
    chance := ((slot4percent / 100) + 1) * 0.25
    trueChance := chance
    skipLevels := Floor(chance + 1)
    If (skipLevels > 1) {
        trueChance := 0.5 + ((chance - Floor(chance)) / 2)
    }
    
    totalLevels := 0
    totalSkips := 0
    
    Loop % i {
        level := 0.0
        skips := 0.0
        Loop {
            Random, x, 0.0, 1.0
            If (x < trueChance) {
                level += skipLevels
                skips++
            }
            
            level++
        }
        Until level > AreaLow
        
        totalLevels += level
        totalSkips += skips
    }
    
    avgSkips := Round(totalSkips / i, 2)
    avgStacks := Round((1.032**avgSkips) * 48, 2)
    ;want to make these numbers better, based on real time to stack
    ;	they are based on a small data set by kyle
    ;	https://discordapp.com/channels/357247482247380994/474639469916454922/698194507937873983
    ;	please read around that message
    multiplier := 0.1343575531, additve := 41.27234204
    roughTime := (multiplier * avgStacks) + additve
    brivWaitMinutes := roughTime / 60
    ;Briv normally dies if over 3 minutes
return (brivWaitMinutes > 3) ? 3 : brivWaitMinutes
}

BuyChests() {
    Loop {
        If FindInterfaceCue("chestBuying\chestPrice.png", i, j, 1) Or FindInterfaceCue("chestBuying\chestPriceS.png", i, j, 1) {
            MouseClick, L, i+60, j+30
            Sleep 100
            MouseClick, L, i+60, j+30
        }
        If FindInterfaceCue("chestBuying\buyNow.png", i, j, 1) Or FindInterfaceCue("chestBuying\buyNowS.png", i, j, 1) {
            MouseClick, L, i+60, j+30
            Sleep 100
            MouseClick, L, i+60, j+30
        }
    }
Return
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
    
    Loop {
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
        
        If Not Found {
            Break
        }
    }
    
    FileAppend, %CurrentTime%`t`t%GemsEarned%`n, MadWizard-Gems.txt
}

FindGemsCue(filename, ByRef x, ByRef y, ByRef GemsEarned) {
    ;based on Gladio Strico's https://discordapp.com/channels/357247482247380994/474639469916454922/700022596833640459
    SafetyCheck()
    
    MouseMove, x+14, y+16, 0
    fileToSearch := "gemsFound\" . filename
    ImageSearch, i,, x, y, x+14, y+16, *30 %fileToSearch%.png
    If (ErrorLevel = 0) {
        x := i + 5
        GemsEarned .= filename
    }
Return (ErrorLevel = 0)
}

DataOut() {
    FormatTime, currentDateTime,, MM/dd/yyyy HH:mm:ss
    dtNow := A_Now
    toWallRunTime := DateTimeDiff(dtStartTime, dtLastRunTime)
    lastRunTime := DateTimeDiff(dtLastRunTime, dtNow)
    totBosses := Floor(AreaLow / 5) * RunCount
    currentPatron := NpVariant ? "NP" : MirtVariant ? "Mirt" : VajraVariant ? "Vajra" : StrahdVariant ? "Strahd" : "How?"
    ;meant for Google Sheets/Excel/Open Office
    FileAppend,%currentDateTime%`t%AreaLow%`t%toWallRunTime%`t%lastRunTime%`t%RunCount%`t%totBosses%`t%currentPatron%`n, MadWizard-Bosses.txt
}

;time HELPERS
{
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