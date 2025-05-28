MainMenu = {}

--!MODULES--
local Globals = require("Globals");
local UI = require("UI");
local Math = require("Math");

--!MAIN--
local function play(self)

end

local function settings(self)

end

local function credits(self)

end

function MainMenu.load()
    local vertical = UI.new({mode = Enum.UI.relative, pos = Math.vec3.simple(.5,0,1),
    size = Math.vec2.simple(.5,1), anchor = Math.vec2.simple(.5,0), rgba = Colour.new(1,1,1,1)});
    -- vertical.rgba = Colour.new(1,1,1,1);

    local title = UI.new({mode = Enum.UI.relative, pos = Math.vec3.simple(.5,.2,1),
    size = Math.vec2.simple(1,.2), anchor = Math.vec2.simple(.5,.5), parent = vertical,
    text = {content = "Hecstasy", rgba = Enum.Colours.gold, font = Enum.Fonts.first, size = 30}, rgba = Enum.Colours.transparent});
    -- title.rgba = Enum.Colours.transparent;

    local play = UI.new({parent = vertical, mode = Enum.UI.relative, pos = Math.vec3.simple(0,.5,1),
    size = Math.vec2.simple(1,.2), rgba = Enum.Colours.transparent});
    -- play.rgba = Enum.Colours.transparent;

    local settings = UI.new({parent = vertical, mode = Enum.UI.relative, pos = Math.vec3.simple(0,.7,1),
    size = Math.vec2.simple(1,.2), rgba = Enum.Colours.transparent});
    -- settings.rgba = Enum.Colours.transparent;
end

return MainMenu;