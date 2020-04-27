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

ShowHelpTip()

$F10::ExitApp

;Buy chest
$F1::
    BuyChests()
Return

;open Multiple Silver Chest
$F2::
    ;can act a bit weird
    OpenChest("silverChest")
Return

;open Multiple Gold Chest
$F3::
    ;can act a bit weird
    OpenChest("goldChest")
Return

;use Multiple bountyContracts
$F4::
    BountyContracts()
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

;do not feel this is need
;$`::Pause

#c::
    WinGetPos, X, Y, Width, Height, A
    WinMove, A,, (Max(Min(Floor((X + (Width / 2)) / A_ScreenWidth), 1), 0) * A_ScreenWidth) + ((A_ScreenWidth - Width) / 2), (A_ScreenHeight - Height) / 2
Return

{ ;tooltips
    global gShowHelpTip := ""
    ShowHelpTip() {
        gShowHelpTip := !gShowHelpTip
        
        if (gShowHelpTip) {
            ToolTip, % "F1: Buy Chest`nF2: Open Silver Chest`nF3: Open Silver Chest`nF4: Use Bounty Contracts`nF9: Reload the Script`nF10: Exit the Script", 25, 325, 3
            SetTimer, ClearToolTip, -10000 
        }
        else {
            ToolTip, , , ,3
        }
    }

    ClearToolTip:
	{
		ToolTip, , , ,2
		ToolTip, , , ,3
		;ToolTip, , , ,5
		gToolTip		:= ""
		gShowHelpTip 	:= 0
		gShowStatTip 	:= 0
		return
	}
}

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

ClickBasedFile(filename, x, y) {
    If FindInterfaceCue("" . filename . "", i, j, 1) {
        MouseClick, L, x+i, y+j, 1
        Sleep 100
        MouseClick, L, x+i, y+j, 1
        Return True
    }
    Return False
}

BuyChests() {
    Loop {
        If ClickBasedFile("uiWork\chestBuying\chestPrice.png", 60, 30) Or ClickBasedFile("chestBuying\chestPriceS.png", 60, 30) {
            Sleep 1
        }
        If ClickBasedFile("uiWork\chestBuying\buyNow.png", 60, 30) Or ClickBasedFile("chestBuying\buyNowS.png", 60, 30) {
            Sleep 1
        }
    }
    Return
}

OpenChest(chestType) {
    chestToOpen := "uiWork\openingChest\" . chestType . ".png"
    Loop {
        If ClickBasedFile(chestToOpen, 110, 15) {
            Sleep 100
            If ClickBasedFile("uiWork\rightArrow.png", -20, 15) {
                Sleep 100
                If ClickBasedFile("uiWork\openingChest\openMultipleChest.png", 20, 10) {
                    Sleep 3000
                    Loop, 7 {
                        DirectedInput("Space")
                        Sleep 100
                    }
                    Sleep 3000
                    If ClickBasedFile("uiWork\openingChest\closeAllLoot.png", 0, 0) {
                        DirectedInput("Esc")
                        Sleep 3000
                    }
                }
            }
        }
    }
    Return
}

BountyContracts() {
    InputBox, contractType, Contract type, small: 1`nmedium: 2`nlarge: 3
    InputBox, contractCount, Contracts to use, Put the number you want to use in`nbut will floor the number put in by 10`nmax of 100000
    contract := (contractType = 1) ? "small" : contractType = 2 ? "medium" : contractType = 3 ? "large" : 0

    If (contract = 0) {
        MsgBox, Wrong`nContract Type`nUser Entered: %contractType%
        Reload
    }
    Else If (Not (contractCount > 0 and contractCount <= 100000)) {
        MsgBox, Wrong`nCountract Count`nUser Entered: %contractCount%
        Reload
    }

    MsgBox, Contracts Type to use: %contracts%`nCountract Count User entered: %contractCount%`nHit F9 if this is higher wrong before hitting Enter or clicking OK

    contracts := "uiWork\bountyContracts\" . contract . ".png"
    contractCount := floor(contractCount / 10)
    
    Loop, %contractCount% {
        ;MouseMove, i+20, j+15 ;more for future reference
        If ClickBasedFile("" . contracts . "", 25, 25) {
            Sleep 100
            If ClickBasedFile("uiWork\rightArrow.png", -20, 10) {
                Sleep 100
                If ClickBasedFile("uiWork\bountyContracts\useContracts.png", 20, 15) {
                    Sleep 3000
                }
            }
        }
    }
    Return
}
