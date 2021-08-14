-- I hate lua, let's switch to c++ 
-- I wish this was simple to make

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

    velocity = GetPlayerVelocity()

    -- ghetto falling check
    if velocity[2] ~= 0 then
        do return end
    end 

    -- don't apply if our velocity is too low, use case: wall in front of our face
    if VecLength(velocity) < 6.5 then
        do return end
    end

    -- just a fail safe
    if VecLength(velocity) > 8.5 then
        do return end
    end

    -- get scary quat
    rot = GetCameraTransform().rot
    -- convert to cool angles
    x, y, z = GetQuatEuler(rot)

    -- moving left & right is cool.
    if InputDown("left")  then
        y = y + 45
        if y > 180 then
            y = y - 360
        end
    end
    if InputDown("right")  then
        y = y - 45
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

    -- default movement velocity is 7
    -- giving us nice 28% speed boost
    velocity = VecScale(forward, 9)

    velocity[2] = GetPlayerVelocity()[2]
        
    SetPlayerVelocity(velocity)
end

-- debug, don't upload to workshop this bs
function draw()
    UiPush()
	UiAlign("center middle")
	UiTranslate(UiCenter(), UiMiddle());
    UiFont("bold.ttf", 24)
    velocity = GetPlayerVelocity()
    UiText(tostring(VecLength(velocity)), true)

    rot = GetCameraTransform().rot
    x, y, z = GetQuatEuler(rot)

    UiText(tostring(x), true)
    UiText(tostring(y), true)
    UiText(tostring(velocity[1]), true)
    UiText(tostring(velocity[3]), true)

	rady = math.rad(y)
	siny = math.sin(rady)
	cosy = math.cos(rady)
    radx = math.rad(x)
	sinx = math.sin(radx)
	cosx = math.cos(radx)

    forwardx = cosx * cosy
    forwardy = cosx * siny
    forwardz = -sinx

    UiText(tostring(forwardx), true)
    UiText(tostring(forwardy), true)
    UiText(tostring(forwardz), true)

    UiPop()
end
