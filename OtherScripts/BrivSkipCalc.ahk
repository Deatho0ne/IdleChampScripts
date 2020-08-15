;Original version by Gladio Stricto - https://pastebin.com/Rd8wWSVC
;	actually has is most of the data
Global slot4percent := 677.7, zone := 330
;1424.0 = 95.28 triple
;940.2 = 65.01 triple
;749.4 = 53.09 triple
;677.6 = 97.2 double
;565.2 = 83.15 double ;my old
;238.8 = 83.7 single
$Esc::ExitApp
$F7::Reload

$F6::
    MsgBox, % SimulateBriv(10000)
Return

SimulateBriv(i) {
    chance := ((slot4percent / 100) + 1) * 0.25
	trueChance := chance
	skipLevels := 1
    
	if (chance > 2) {
		while chance >= 1 {
			skipLevels++
			chance /= 2
		}
		;trueChance := ((chance - Floor(chance)) / 2)
	} else {
		skipLevels := Floor(chance + 1)
		If (skipLevels > 1) {
			trueChance := 0.5 + ((chance - Floor(chance)) / 2)
		}
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
        Until level > zone
        
        totalLevels += level
        totalSkips += skips
    }
    
	;chance := Round(chance, 2)
	if skipLevels < 3
		trueChance := Round(trueChance * 100, 2)
    else
		trueChance := Round(chance * 100, 2)
	
    avgSkips := Round(totalSkips / i, 2)
    
    avgSkipped := Round(avgSkips * skipLevels, 2)
    avgZones := Round(totalLevels / i, 2)
    avgSkipRate := Round((avgSkipped / avgZones) * 100, 2)
    
    avgStacks := Round((1.032**avgSkips) * 48, 2)
    multiplier := 0.1346894362, additve := 41.86396406
    roughTime := Round(((multiplier * avgStacks) + additve), 2)
    
    message = With Briv skip %skipLevels% until zone %zone%`n(%trueChance%`% chance to skip %skipLevels% zones)`n`n%i% simulations produced an average:`n%avgSkips% skips (%avgSkipped% zones skipped)`n%avgZones% end zone`n%avgSkipRate%`% true skip rate`n%avgStacks% required stacks with`n%roughTime% time in secs to build said stacks very rough guess
	Return message
}