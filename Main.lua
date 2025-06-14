_G.love = require("love");

--!LIBRARIES--
local UI = require("UI");
local Colour = require("Colour");
local Math = require("Math");

--!ENUMS--
_G.Enum = {
    mode = {
        absolute = 0,
        relative = 0,
    },
    type = {
        canvas = "canvas",
        frame = "frame",
        text = "text",
        image = "image",
    },
}

--!MAIN--
function love.load()
    local settings = {
        x = .5,
        y = .5,
        size = Math.vec2(.3,.3);
        rgba = Colour.new(.3,.3,.8,1);
    }
    UI.ChangeMode("relative");
    local rect = UI.rect(settings);
    UI.ChangeMode("absolute");
end

function love.update()
end

function love.draw()
	UI.render();
end