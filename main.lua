-- I hate lua, let's switch to c++ 
-- I wish this was simple to make

-- dirty global variables that we all hate.
-- shame on you global variables!
beganRunning = nil
runSpeedString = "savegame.mod.run_speed"
autoRunString ="savegame.mod.auto_run"
alwaysRunString = "savegame.mod.always_run"
defaultEngineWalkSpeed = 7
isMenuOpen = false

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

function init() 
    SetDefaults()
end

function tick(dt) 
    if PauseMenuButton("SimpleRun") then
		isMenuOpen = true
	end
    if InputPressed("esc") then
        isMenuOpen = false
    end
end

function IsCapableOfRunning()
    -- don't update in vehicles
    if GetPlayerVehicle() ~= 0 then
        return false
    end

    -- input checks
    if not InputDown("shift") and not GetBool(alwaysRunString) then
        -- check for autorun
        if not GetBool(autoRunString) then
            return false
        end

        -- nt you filthy global var
        if beganRunning == nil then
            return false
        end

        -- if the player was running for 1.69 then activate autorun
        if (GetTime() - beganRunning) < 1.69 then
            return false
        end
    end

    if not InputDown("up") then
        return false
    end

    if InputDown("crouch") then
        return false
    end

    if InputDown("down")  then
        return false
    end

    -- controller support / don't start running from a stand still
    local velocity = GetPlayerVelocity()
    if VecLength(velocity) < 6.7 then
        return false
    end

    return true
end


-- Called once every fixed tick, 60tps
function update(dt)
    local isRunPossible = IsCapableOfRunning()

    if not isRunPossible then
        -- no longer runnin'
        beganRunning = nil
        return
    end

    -- started runnin'
    if beganRunning == nil then
        beganRunning = GetTime()
    end

    local velocity = GetPlayerVelocity()

    -- 7 is the default walking speed
    local TargetVel = defaultEngineWalkSpeed * (1 + ( GetFloat(runSpeedString) / 100 ) )

    -- just a fail safe, don't add speed if we're already fast.
    if VecLength(velocity) > TargetVel then
        return
    end

    -- scary math below, run.

    -- get scary quat
    local rot = GetCameraTransform().rot
    -- convert to cool angles
    local x, y, z = GetQuatEuler(rot)

    -- account for sideways input.
    if InputDown("left")  then
        y = y + 30
        if y > 180 then
            y = y - 360
        end
    end
    if InputDown("right")  then
        y = y - 30
        if y < -180 then
            y = y + 360
        end
    end

    -- euler to vector
    local rady = math.rad(y)
	local siny = math.sin(rady)
	local cosy = math.cos(rady)

    -- change our cool math to something the game can use
    local forward = Vec(0,0,0)
    forward[3] = -cosy
    forward[1] = -siny

    -- apply velocity scale
    velocity = VecScale(forward, TargetVel)

    -- make sure we didn't mess up on the axis we don't care about
    velocity[2] = GetPlayerVelocity()[2]
        
    SetPlayerGroundVelocity(velocity)
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

function draw() 
    if not isMenuOpen then
        return
    end

    UiMakeInteractive()
    SetBool("game.disablepause", true)
    
    if InputPressed("pause") then
        isMenuOpen = false
    end

    UiPush()
        UiAlign("center middle")
        UiColor(0, 0, 0, 0.420)
        
        UiTranslate(UiCenter(), UiMiddle())
        UiRect(UiWidth(), UiHeight())
        
        UiBlur(0.1)
    UiPop()


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