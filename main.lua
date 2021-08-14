-- I hate lua, let's switch to c++ 

function init()	
end

local debugBreak = 0

-- Called once every tick
function tick(dt)
    -- don't update in vehicles
    if GetPlayerVehicle() ~= 0 then
        debugBreak = 1
        do return end
    end

    if not InputDown("shift") then
        debugBreak = 2
        do return end
    end

    if not InputDown("up")  then
        debugBreak = 3
        do return end
    end

    velocity = GetPlayerVelocity()

    -- don't apply if our velocity is too low
    if math.abs(velocity[1]) < 4.8 and math.abs(velocity[3]) < 4.8 then
        debugBreak = 4
        do return end
    end

    -- ghetto falling check
    if velocity[2] ~= 0 then
        debugBreak = 5
        do return end
    end 

    Direction = VecNormalize(velocity)
    velocity = VecScale(Direction, 10)

    velocity[2] = GetPlayerVelocity()[2]
        
    SetPlayerVelocity(velocity)
end

-- Called at a fixed update rate, 60tps
function update(dt)
end


function draw()
    UiPush()
	UiAlign("center middle")
	UiTranslate(UiCenter(), UiMiddle());
    UiFont("bold.ttf", 24)
    velocity = GetPlayerVelocity()
    UiText(tostring(velocity[1]), true)
    UiText(tostring(velocity[3]), true)
    UiText(tostring(debugBreak), true)
    UiPop()
end
