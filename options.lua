-- I hate lua, let's switch to c++ 
-- I wish this was simple to make
runSpeedString = "savegame.mod.run_speed"
autoRunString ="savegame.mod.auto_run"
alwaysRunString = "savegame.mod.always_run"

function SetDefault(string, default, type)
    if not HasKey(string) then 
		if type == 'bool' then 
			SetBool(string, default)
		end
		if type == 'int' then 
			SetInt(string, default)
		end
    end
end

function SetDefaults() 
    -- default speed + default speed * run_speed
    SetDefault(runSpeedString, 28, 'int')
    -- rust style hold for a sec and just keep running
    SetDefault(autoRunString, true, 'bool')
    -- \/ controller support
    SetDefault(alwaysRunString, false, 'bool') 
end

function optionsSlider(setting, def, mi, ma)
	UiColor(1,1,0.5)
	UiPush()
		UiTranslate(0, -8)
		local val = GetInt(setting)
		val = (val-mi) / (ma-mi)
		local w = 200
		UiRect(w, 3)
		UiAlign("center middle")
		val = UiSlider("ui/common/dot.png", "x", val*w, 0, w) / w
		val = math.floor(val*(ma-mi)+mi)

		SetInt(setting, val)
		UiTranslate(100, -20)
		UiText(val)
	UiPop()
	return val
end

-- ugliest ui possible
function draw()
	-- not sure if options calls init, so. 
    SetDefaults()

	UiTranslate(UiCenter() - 200, UiMiddle()-60)
	UiPush()
		UiPush()
			UiAlign("left")
			UiFont("bold.ttf", 48)
			UiText("Bonus Speed %")
			UiTranslate(300, 0)
			local val = optionsSlider(runSpeedString, 28, 10, 100)
			UiTranslate(-300, 100)
			if UiTextButton(GetBool(alwaysRunString) and "Always Run: Enabled" or "Always Run: Disabled", 110, 40) then
				SetBool(alwaysRunString, not GetBool(alwaysRunString))
			end
			if not GetBool(alwaysRunString) then 

				UiTranslate(0, 100)
				if UiTextButton(GetBool(autoRunString) and "Autorun: Enabled" or "Autorun: Disabled", 110, 40) then
					SetBool(autoRunString, not GetBool(autoRunString))
				end
				
			end 

		UiPop()
    UiPop()
end
