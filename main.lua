-- I hate lua, let's switch to c++ 
-- I wish i could just edit max player speed/accel var

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

    --
    if VecLength(velocity) > 8.5 then
        do return end
    end

    -- this is ghetto, but I can't just get localplayer eye angles
    x, y = UiGetMousePos()
    Direction = UiPixelToWorld(x, y)

    -- default movement velocity is 7, this will increase it to 8.5
    -- giving us nice 21% speed boost
    velocity = VecScale(Direction, 9)

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
    UiText(tostring(velocity[1]), true)
    UiText(tostring(velocity[2]), true)
    velocity[2] = 0
    UiText(tostring(velocity[3]), true)
    UiText(tostring(VecLength(velocity)), true)

    x, y = UiGetMousePos()
    dir = UiPixelToWorld(x, y)
    veldir = VecNormalize(velocity)

    UiText(tostring(x), true)
    UiText(tostring(y), true)
    UiText(tostring(dir[1]), true)
    UiText(tostring(veldir[1]), true)
    UiPop()
end
