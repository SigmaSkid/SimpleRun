-- I hate lua, let's switch to c++ 
-- I wish this was simple to make

-- 7 is default walking speed
TargetVel = 7

function init() 
    -- force set default value just in case.
    if GetFloat("savegame.mod.simplerunscale") == 0 then
        SetFloat("savegame.mod.simplerunscale", 28)
    end
end


-- Called once every fixed tick, 60tps
function update(dt)
    -- don't update in vehicles
    if GetPlayerVehicle() ~= 0 then
        do return end
    end

    if not InputDown("shift") then
        do return end
    end

    if not InputDown("up")  then
        do return end
    end

    if InputDown("down")  then
        do return end
    end

    velocity = GetPlayerVelocity()

    -- ghetto ground check
    if velocity[2] ~= 0 then
        do return end
    end 

    -- don't apply if our velocity is too low,
    -- cuz there is wall in front of our face
    if VecLength(velocity) < 5 then
        do return end
    end

    TargetVel = 7 + (7 * GetFloat("savegame.mod.simplerunscale") / 100)

    -- just a fail safe
    if VecLength(velocity) > TargetVel then
        do return end
    end

    -- get scary quat
    rot = GetCameraTransform().rot
    -- convert to cool angles
    x, y, z = GetQuatEuler(rot)

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
    rady = math.rad(y)
	siny = math.sin(rady)
	cosy = math.cos(rady)
    radx = math.rad(x)
	cosx = math.cos(radx)

    -- change our cool math to something the game can use
    forward = Vec(0,0,0)
    forward[3] = -cosx * cosy
    forward[1] = -cosx * siny

    -- apply velocity scale
    velocity = VecScale(forward, TargetVel)

    velocity[2] = GetPlayerVelocity()[2]
        
    SetPlayerVelocity(velocity)
end