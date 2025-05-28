---@diagnostic disable: lowercase-global

--!MODULES--
_G.love = require("love");
local UI = require("UI");
local Mouse = require("Mouse");
local Demo = require("Demo"); -- demo version of the framework

--!MAIN--
function love.load()
    Debugger.msg(Debugger.sep);
    Debugger.msg("love.load()\n", 1);
    Debugger.conditional(DEBUGGING, "DEBUGGING = true\n", 1);
    Debugger.msg("love.load()\n", 4);
    love.graphics.setBackgroundColor(0,0,0);
    Demo.start();
end

function love.update(dt)
    Debugger.msg("love.update()", 5);
    if DEBUGGING then
        love.window.setTitle("FPS: \n" .. love.timer.getFPS() .. " | V-sync: ".. love.window.getVSync());
    end

    Mouse.update();
    UI.update();
end

function love.draw()
    Debugger.msg("love.draw()", 5);
    if not love.window.hasFocus() or not love.window.isVisible() then -- saving resources only on rendering, but keeping the update loop live
        return;
    end
    
    UI.render();
end