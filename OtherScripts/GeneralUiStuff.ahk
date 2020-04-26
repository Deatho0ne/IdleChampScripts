/*
By Deatho0ne
version 04.25.2020
Still early phace it should work, but do not ask about it yet
*/

/*
for later
*/
SetWorkingDir, %A_ScriptDir%
SetMouseDelay, 30

;kills the app, I cannot find a key I like it on yet, maybe one of these days
;$Esc::ExitApp

;Buy chest
$F1::
    BuyChests()
Return

;open Multiple Silver Chest
$F2::
    OpenChest("silverChest")
Return

;open Multiple Gold Chest
$F3::
    OpenChest("goldChest")
Return

;read comments below
$F6::
    ; Used for testing when needed
    ;CaptureResultsScreen()
Return

;Reload the script
$F9::
    Reload
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

BuyChests() {
    Loop {
        If FindInterfaceCue("uiWork\chestBuying\chestPrice.png", i, j, 1) Or FindInterfaceCue("chestBuying\chestPriceS.png", i, j, 1) {
            MouseClick, L, i+60, j+30, 2
            Sleep 100
            MouseClick, L, i+60, j+30, 2
        }
        If FindInterfaceCue("uiWork\chestBuying\buyNow.png", i, j, 1) Or FindInterfaceCue("chestBuying\buyNowS.png", i, j, 1) {
            MouseClick, L, i+60, j+30, 2
            Sleep 100
            MouseClick, L, i+60, j+30, 2
        }
    }
    Return
}

OpenChest(chestType) {
    chestToOpen := "uiWork\openingChest\" . chestType . ".png"
    Loop {
        If FindInterfaceCue("" . chestToOpen . "", i, j, 1) {
            MouseClick, L, i+110, j+15, 2
            Sleep 100
            MouseClick, L, i+110, j+15, 2
        }
        If FindInterfaceCue("uiWork\openingChest\multiChestOpen.png", i, j, 1) {
            MouseClick, L, i+190, j+50, 2
            Sleep 100
            MouseClick, L, i+190, j+50, 2
        }
        If FindInterfaceCue("uiWork\openingChest\openMultipleChest.png", i, j, 1) {
            MouseClick, L, i+20, j+10, 2
            Sleep 100
            MouseClick, L, i+20, j+10, 2
        }
        Sleep 3000
        Loop, 7 {
            Send, {Space}
            Sleep 100
        }
        Sleep 3000
        If FindInterfaceCue("uiWork\openingChest\closeAllLoot.png", i, j, 1) {
            Send, {Esc}
            Sleep 100
        }
    }
    ;MouseMove, i+20, j+10
}