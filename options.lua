-- I hate lua, let's switch to c++ 
-- I wish this was simple to make

-- 1:1 stolen game function
function optionsSlider(setting, def, mi, ma)
	UiColor(1,1,0.5)
	UiPush()
		UiTranslate(0, -8)
		local val = GetInt(setting)
		val = (val-mi) / (ma-mi)
		local w = 100
		UiRect(w, 3)
		UiAlign("center middle")
		val = UiSlider("dot.png", "x", val*w, 0, w) / w
		val = math.floor(val*(ma-mi)+mi)
		SetInt(setting, val)
	UiPop()
	return val
end

-- ugliest ui possible
function draw()
	UiTranslate(UiCenter(), 250)
	UiAlign("center middle")
	UiPush()
	UiFont("bold.ttf", 48)
    UiPush()
	UiFont("bold.ttf", 48)
    UiText("Speed Bonus %")
    UiTranslate(220, 0)
    UiAlign("left")
    local val = optionsSlider("savegame.mod.simplerunscale", 28, 10, 100)
    UiTranslate(120, 0)
    UiText(val)
    UiPop()
    UiPop()
end