--!MODULES--
_G.love = require("love");
local UI = require("UI"); -- main framework
local Demo = require("Demo"); -- demo version of the framework
local _ = require("Inputs"); -- just to fire callbacks

--!MAIN--
function love.load()
    -- debugger setup
    Debugger.msg(Debugger.sep);
    Debugger.msg("love.load()\n", 1);
    Debugger.conditional(DEBUGGING, "DEBUGGING = true\n", 1);
    Debugger.conditional(MOUSE_ACTIVE, "MOUSE_ACTIVE = true\n",1);
    Debugger.conditional(KEYBOARD_ACTIVE, "KEYBOARD_ACTIVE = true\n", 1);

    love.graphics.setBackgroundColor(0,0,0);
    Demo.start();
end

function love.update(dt)
    if DEBUGGING then
        love.window.setTitle("FPS: \n" .. love.timer.getFPS() .. " | V-sync: ".. love.window.getVSync());
    end

    UI.update(dt);
end

function love.draw()
    if not love.window.hasFocus() or not love.window.isVisible() then -- saving resources only on rendering, but keeping the update loop live
        return;
    end
    
    UI.render();
end