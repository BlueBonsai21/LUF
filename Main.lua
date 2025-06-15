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
        circle = "circle",
        text = "text",
        image = "image",
    },
    fonts = {
        lollygag = "assets/fonts/font.ttf",
    }
}

--!MAIN--
function love.load()
    UI.Autocentre(true);
    local settings = {
        x = .5,
        y = .5,
        size = Math.vec2(.3,.3),
        rgba = Colour.new(.3,.3,.8,1),
        string = "Hello, World",
        font = Enum.fonts.lollygag,
        radius = 50,
    }
    UI.SetMode("relative");
    plr = UI.circle(settings);
    UI.SetMode("absolute");
    UI.Autocentre();
    print(plr)
end

function love.update()
    love.window.setTitle("LUF - FPS: "..love.timer.getFPS());

    if love.keyboard.isDown("w") then
        plr.y = plr.y - 1;
    elseif love.keyboard.isDown("s") then
        plr.y = plr.y + 1;
    elseif love.keyboard.isDown("a") then
        plr.x = plr.x - 1;
    elseif love.keyboard.isDown("d") then
        plr.x = plr.x + 1;
    end
end

function love.draw()
	UI.render();
end