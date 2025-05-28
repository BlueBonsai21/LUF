local Mouse = {
    x = 0,
    y = 0,
    button = 1,
};

--!SETUP--
local isPressed = false
local holdStartTime = 0
local isHolding = false

local HOLD_THRESHOLD = 0.2;

--!MAIN--
local function CheckButtonClick()
    if not love.window.isVisible() then return end;
    
    for _, element in pairs(activeUI) do
        if element.clickCallback.active then
            if  Mouse.x >= element.x and Mouse.x <= element.x + element.size.x and Mouse.y >= element.y and Mouse.y <= element.y + element.size.y then
                print(element.clickCallback.callback());
                break;
            end
        end
    end
end

function Mouse.update()
    local mouseDown = love.mouse.isDown(1);
    
    if mouseDown and not isPressed then
        Mouse.x, Mouse.y = love.mouse.getPosition();
        isPressed = true
        holdStartTime = love.timer.getTime()
        isHolding = false
    elseif not mouseDown and isPressed then
        Mouse.x, Mouse.y = love.mouse.getPosition();
        isPressed = false
        isHolding = false
    elseif mouseDown and isPressed then
        Mouse.x, Mouse.y = love.mouse.getPosition();
        local currentTime = love.timer.getTime()
        if currentTime - holdStartTime >= HOLD_THRESHOLD then
            isHolding = true;
        end

        if not isHolding then
            CheckButtonClick();
        end
    end
end

function Mouse.isHolding()
    return isHolding;
end

function Mouse.isPressed()
    if not isHolding then
        Mouse.x, Mouse.y = love.mouse.getPosition();
        return isPressed;
    else
        return false;
    end
end

return Mouse;