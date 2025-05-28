local Demo = {};

--!MODULE--
local UI = require("UI");
local Math = require("Math");
local Globals = require("Globals");

--!MAIN--

function Demo.start()
    Debugger.msg("Demo.start()");
    -- element is defaulted to Enum.UI.Canvas
    -- mode can also be assigned via Enum.UI.relative
    UI.new({mode = "relative", pos = Math.vec3.simple(.5,.1,1), size = Math.vec2.simple(0.8,.1),
    anchor = Math.vec2.simple(.5,.5), rgba = Enum.Colours.white});
end

return Demo;