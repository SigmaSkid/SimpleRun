-- I hate lua, let's switch to c++ 
-- I wish this was simple to make

function init() 
    if GetFloat("savegame.mod.simplerunscale") == 0 then
        SetFloat("savegame.mod.simplerunscale", 28)
    end
end


-- Called once every fixed tick, 60tps
function update(dt)
    -- don't update in vehicles
    if GetPlayerVehicle() ~= 0 then
        return
    end

    -- input checks
    if not InputDown("shift") then
        return
    end

    if not InputDown("up") then
        return
    end

    if InputDown("crouch") then 
        return
    end

    if InputDown("down")  then
        return
    end

    local velocity = GetPlayerVelocity()

    -- don't apply if our velocity is too low
    if VecLength(velocity) < 5 then
        return
    end

    -- 7 is default walking speed
    local TargetVel = 7 + (7 * GetFloat("savegame.mod.simplerunscale") / 100)

    -- just a fail safe
    if VecLength(velocity) > TargetVel then
        return
    end

    -- get scary quat
    local rot = GetCameraTransform().rot
    -- convert to cool angles
    local x, y, z = GetQuatEuler(rot)

    -- moving left & right is cool.
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

    -- never again
    -- cool euler to vector
    local rady = math.rad(y)
	local siny = math.sin(rady)
	local cosy = math.cos(rady)

    -- change our cool math to something the game can use
    local forward = Vec(0,0,0)
    forward[3] = -cosy
    forward[1] = -siny

    -- apply velocity scale
    velocity = VecScale(forward, TargetVel)

    velocity[2] = GetPlayerVelocity()[2]
        
    SetPlayerGroundVelocity(velocity)
end

function draw()
    UiPush()
	UiAlign("center middle")
	UiTranslate(UiCenter(), UiMiddle());
    UiFont("bold.ttf", 24)
    local velocity = GetPlayerVelocity()
    UiText(tostring(VecLength(velocity)), true)

    local rot = GetCameraTransform().rot
    local x, y, z = GetQuatEuler(rot)

    UiText(tostring(x), true)
    UiText(tostring(y), true)
    UiText(tostring(velocity[1]), true)
    UiText(tostring(velocity[3]), true)

	local rady = math.rad(y)
	local siny = math.sin(rady)
	local cosy = math.cos(rady)
    local radx = math.rad(x)
	local sinx = math.sin(radx)
	local cosx = math.cos(radx)

    local forwardx = cosx * cosy
    local forwardy = cosx * siny
    local forwardz = -sinx

    UiText(tostring(forwardx), true)
    UiText(tostring(forwardy), true)
    UiText(tostring(forwardz), true)

    UiPop()
end