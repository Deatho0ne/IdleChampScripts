;Original version by Gladio Stricto - https://pastebin.com/Rd8wWSVC
;Please make sure your Steam does not take screen shots with F12
;I run this with about e20 favor
;	all specs are done by about area 25
;	If you less look at WaitForResults() and change your champs specs
;Have no active patron
;No ults are cast besides at first to get Havilar's
;This Script uses images from both events directory and the MadWizard
;	current event does not matter
;Might have to edit the numbers in ResetTest() and StartAdventure() to get it started
;Deatho0ne does not plan to maintain this for you, but will update from time to time
SetWorkingDir, %A_ScriptDir%
SetMouseDelay, 30

;Varibale to change based on current event
;PrevPrevYear is 1, PrevYear is 2, CurrentChamp is 3, anything else is random
Global ChampToRun := 3

;Variables not needed to be changed
Global AreaWorking := "events\level_" . 51 . "_working.PNG", AreaComplete := "events\level_" . 51 . "_complete.PNG"
Global Specialized := 1, LevelKey := 2, SliceName := 3
Global ZoomedOut := False

$Del::ExitApp

$F1::
	While GetKeyState("F1", "P") {
		MouseClick
		Sleep 0
	}
Return

$F3::
	Menu, Tray, Icon, %SystemRoot%\System32\setupapi.dll, 10
	Loop {
		MouseClick
		Sleep 0
	}
Return

$F9::
	Reload
Return

$F2::
	Menu, Tray, Icon, %SystemRoot%\System32\setupapi.dll, 10
	ResetAdventure()
	Loop {
		StartAdventure()
		WaitForLoading()
		WaitForResults()
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
	If FindInterfaceCue("sword_coast_correct.png", i, j, 1) Or FindInterfaceCue("sword_coast_wrong.png", i, j, 1) {
		SafetyCheck()
		MouseClick, L, i+55, j+14
		Return False
	}
	Return True
}

ResetAdventure() {
	If ResetTest() {
		ResetStep("reset.png", 10, 10)
		Sleep 500
		ResetStep("complete.png", 40, 10)
		ResetStep("skip.png", 20, 10)
		
		ResetStep("continue.png", 50, 10)

		Loop {
			If (A_Index > 480) {
				Reload
			}
			If Not ResetTest() {
				Break
			}
		}
	}
	
	If (Not ZoomedOut) And FindInterfaceCue("sword_coast_correct.png", i, j, 1) {
		SafetyCheck()
		MouseClick, L, i+200, j+14
		Loop 15	 {
			MouseClick, WheelDown
			Sleep 5
		}
		
		ZoomedOut := True
	}
	
	ResetStep("sword_coast_correct.png", 55, 280)
}

StartAdventure() {
	If FindInterfaceCue("sword_coast_wrong.png", i, j, 1) {
		ResetStep("sword_coast_wrong.png", 652, 270)
	}
	
	firstY := 0, secondY := 75, thirdY := 150
	If (ChampToRun = 1) {
		ResetStep("events\sword_coast.PNG", 250, firstY)
	}
	Else If (ChampToRun = 2) {
		ResetStep("events\sword_coast.PNG", 250, secondY)
	}
	Else If (ChampToRun = 3) {
		ResetStep("events\sword_coast.PNG", 250, thirdY)
	}
	Else {
		Random, rand, 1, 3
		ySpot := (rand = 1) ? firstY : (rand = 2) ? secondY : (rand = 3) ? thirdY : thirdY
		ResetStep("events\sword_coast.PNG", 250, ySpot)
	}
	
	ResetStep("events\sword_coast.PNG", 750, 515)
}

WaitForLoading() {
	FindInterfaceCue("loading.png", i, j, 20)

	Loop 360 {
		If Not FindInterfaceCue("loading.png", i, j, 1) {
			Break
		}
	}

	DirectedInput("q")
	Sleep 1500
	
	If FindInterfaceCue("wait.png", i, j, 1) {
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
	HeroData.push([ False, "{F6}", "shandie.png" ])
	HeroData.push([ False, "{F12}", "melf.PNG" ])
	HeroData.push([ False, "{F8}", "hitch.png"  ])
	HeroData.push([ False, "{F4}", "sentry.png" ])
	;HeroData.push([ False, "{F5}", "briv.png" ])
	HeroData.push([ False, "{F7}", "minsc.png" ])
	HeroData.push([ False, "{F1}", "deekin.png" ])
	;HeroData.push([ False, "{F2}", "celeste.PNG" ])
	HeroData.push([ False, "{F10}", "havilar.png" ])
	
	LoopedInput := ""
	
	Loop % HeroData.Length() {
		If Not HeroData[A_Index][Specialized] {
			LoopedInput .= HeroData[A_Index][LevelKey]
		}
	}
	
	;there can be some lag issues here, but it should still eventually get all specs above
	DirectedInput("q")
	Loop 10 {
		DirectedInput(LoopedInput)
	}
	DirectedInput("{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}")
	Sleep 100
	DirectedInput("q")
	Sleep 100
	DirectedInput("1234567890")
	Sleep 100
	DirectedInput("q")
	
	Loop {
		If FullySpecialized(HeroData) {
			;simple click incase of achievement or unlock of something new
			SafetyCheck()
			MouseClick, L, 650, 450
			
			If FindInterfaceCue(AreaWorking, i, j, 1) Or FindInterfaceCue(AreaComplete, i, j, 1) {
				Break
			}

			If FindInterfaceCue("cancel.png", i, j, 1) {
				SafetyCheck()
				MouseClick, L, i+15, j+15
				Sleep 50
			}

			If FindInterfaceCue("progress.png", i, j, 1) {
				DirectedInput("g")
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