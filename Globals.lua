--!MODULES--
local Math = require("Math");

--!ALIASES--
---@alias colour {r: number, g: number, b: number, a: number}
---@alias vector2 {x: number, y: number}
---@alias vector3 {x: number, y: number, z: number}

-- utility
_G.Colour = {};
_G.Debugger = {};

--!FUNCTIONS--
---@param r number?
---@param g number?
---@param b number?
---@param a number?
---@return colour
function Colour.new(r, g, b , a)
    r,g,b,a = r or 0, g or 0, b or 0, a or 1;
    local colour = {};
    local max = 1;
    if math.max(r, g, b) > 1 then
        max = 255;
    end
    r,g,b, a = Math.clamp(r/max,0,max),Math.clamp(g/max,0,max),Math.clamp(b/max,0,max), Math.clamp(a,0,1);
    
    if max == 255 then
        r,g,b,a = Math.round(r), Math.round(g), Math.round(b), Math.round(a);
    end

    colour.r = r;
    colour.g = g;
    colour.b = b;
    colour.a = a;

    function colour:invert()
        return Colour.new(1-self.r, 1-self.g, 1-self.b, 1);
    end

    setmetatable(colour, {
        __tostring = function(t)
            return t.r.." "..t.g.." "..t.b.." "..t.a.."\n";
        end
    });

    return colour;
end

---@param c1 colour
---@param c2 colour
---@return colour
function Colour.mix(c1, c2)
    return Colour.new((c1.r+c2.r)/2, (c1.g+c2.g)/2, (c1.b+c2.b)/2, (c1.a+c2.a)/2);
end

---@type table
_G.Enum = {
    UI = {
        -- element
        canvas = "canvas",
        frame = "frame",
        button = "button",
        
        -- mode
        absolute = "absolute",
        relative = "relative",
    },
    Fonts = { -- TODO: assign new name to fonts
        first = "assets/fonts/font.ttf",
    },
    Colours = {
        transparent = Colour.new(0,0,0,0),
        black = Colour.new(0,0,0,1),
        white = Colour.new(1,1,1,1),
        red = Colour.new(1,0,0,1),
        green = Colour.new(0,1,0,1),
        blue = Colour.new(0,0,1,1),
        mint = Colour.new(157,225,154,1),
        light_sky = Colour.new(164,197,234,1),
        blue_sky = Colour.new(152,167,242,1),
        lilla = Colour.new(188,169,225,1),
        light_yellow = Colour.new(231,236,163,1),
        gold = Colour.new(255,215,0,1),
    },
}

--Prints a message when global variable *DEBUGGING* is set to true
function Debugger.msg(msg)
    if DEBUGGING then
        print(msg);
    end
end

--Prints a message when global variable *DEBUGGING* is set to true and the condition is met
function Debugger.conditional(condition, msg)
    if condition and DEBUGGING then
        print(msg);
    end
end