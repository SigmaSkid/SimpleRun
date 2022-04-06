-- I hate lua, let's switch to c++ 
-- I wish this was simple to make

-- dirty global variable that we all hate.
-- shame on you global variable!
beganRunning = nil

function init() 
    if GetFloat("savegame.mod.simplerunscale") == 0 then
        SetFloat("savegame.mod.simplerunscale", 28)
    end
end

function IsCapableOfRunning()
    -- don't update in vehicles
    if GetPlayerVehicle() ~= 0 then
        return false
    end

    -- input checks
    if not InputDown("shift") then
        -- check for autorun
        local isAutoRun = GetBool("savegame.mod.simplerunautorun")
        if not isAutoRun then
            return false
        end

        -- nt you filthy global var
        if beganRunning == nil then
            return false
        end

        -- if the player wasnt running for 1.69 then dont activate autorun
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

    local velocity = GetPlayerVelocity()
    if VecLength(velocity) < 5 then
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
    local TargetVel = 7 + (7 * GetFloat("savegame.mod.simplerunscale") / 100)

    -- just a fail safe
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
