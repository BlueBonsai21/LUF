--!MOUSE--
local clickCooldown = .1;
local lastTime = 0;
love.mousereleased = function(x,y,button,istouch, presses)
    if not MOUSE_ACTIVE then return end;

    Debugger.msg("Mouse released callback", 3);
    if button ~= 1 then return end; -- for now detecting only left mouse button
    if love.timer.getTime() >= clickCooldown + lastTime then
        lastTime = love.timer.getTime();
    end
    if not love.window.isVisible then return end;
    lastTime = love.timer.getTime();

    for _, element in ipairs(g_activeUI) do
        if element.clickCallback.active then
            if  x >= element.x and x <= element.x + element.size.x and y >= element.y and y <= element.y + element.size.y then
                element.clickCallback.callback();
                break;
            end
        end
    end 
end

--!KEYBOARD--
local keys = {};
love.keypressed = function(key, scancode, isrepeat)
    if not KEYBOARD_ACTIVE then return end;

    for i, callback in pairs(g_KeyboardCallbacks) do
        if i == key then
            callback();
        end
    end
end

love.keyreleased = function(key, scancode, isrepeat)
    if not KEYBOARD_ACTIVE then return end;

    for _, pressed in pairs(keys) do
        if pressed == key then
            pressed = nil;
        end
    end
end

--!DEFAULT--
g_KeyboardCallbacks["escape"] = love.event.quit;