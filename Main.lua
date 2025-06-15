_G.love = require("love");

--!LIBRARIES--
local UI = require("UI");
local Colour = require("Colour");
local Math = require("Math");

--!ENUMS--
_G.Enum = {
    mode = {
        absolute = 0,
        relative = 1,
    },
    type = {
        canvas = "canvas",
        frame = "frame",
        text = "text",
        image = "image",
    },
    fonts = {
        lollygag = "assets/fonts/font.ttf",
    }
}

--!MAIN--
function love.load()
    local settings = {
        x = .5,
        y = .5,
        size = Math.vec2(.3,.3),
        rgba = Colour.new(.3,.3,.8,1),
        anchor = Math.vec2(.5,.5),
        string = "Hello, World",
        font = Enum.fonts.lollygag,
    }
    UI.SetMode("relative");
    local rect = UI.text(settings);
    UI.SetMode("absolute");
end

function love.update()
    love.window.setTitle("LUF - FPS: "..love.timer.getFPS());
end

function love.draw()
	UI.render();
end