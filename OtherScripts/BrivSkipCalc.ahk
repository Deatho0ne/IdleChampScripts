;Original version by Gladio Stricto - https://pastebin.com/Rd8wWSVC
;	actually has is most of the data
Global slot4percent := 228.8, zone := 226
;130.8% is 127.8 secs vs 228.8 is 206.82
$Esc::ExitApp
$F5::Reload

$F6::
	MsgBox, % SimulateBriv(10000)
Return

SimulateBriv(i) {
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
		Until level > zone

		totalLevels += level
		totalSkips += skips
	}

	chance := Round(chance, 2)
	trueChance := Round(trueChance * 100, 2)
	
	avgSkips := Round(totalSkips / i, 2)
	
	avgSkipped := Round(avgSkips * skipLevels, 2)
	avgZones := Round(totalLevels / i, 2)
	avgSkipRate := Round((avgSkipped / avgZones) * 100, 2)
	
	avgStacks := Round((1.032**avgSkips) * 48, 2)
	roughTime := Round(((0.1422857143 * avgStacks) + 30.866667),2)+3

	message = With Briv skip %chance% until zone %zone%`n(%trueChance%`% chance to skip %skipLevels% zones)`n`n%i% simulations produced an average:`n%avgSkips% skips (%avgSkipped% zones skipped)`n%avgZones% end zone`n%avgSkipRate%`% true skip rate`n%avgStacks% required stacks with`n%roughTime% time in secs to build said stacks very rough guess
	Return message
}