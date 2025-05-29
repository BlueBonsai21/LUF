--!MODULES--
local Math = require("Math");

--!ALIASES--
---@alias colour {r: number, g: number, b: number, a: number}
---@alias vector2 {x: number, y: number}
---@alias vector3 {x: number, y: number, z: number}

--!UTILITY
-- inputs
_G.KEYBOARD_ACTIVE = true;
_G.MOUSE_ACTIVE = true;

-- debugging
_G.DEBUGGING = true;
_G.PRIORITY = 3;
_G.IGNORE_LOWER_PRIORITY = false;
--!NOTE about priorities (Debugger class);
--1 used for normal debugging, ideally outside of specific functions
--2 used for specific functions
--3 used for very specific functions and checking if some conditions are present
--4 used for loops
--5 used for annoying loops (e.g. love.draw()), and as final resort
--!PRIORITY has to be set according to the needs. If one wants, they can even set a function associated to
--!key binds such that it changes PRIORITY at run-time.
--!IGNORE_LOWER_PRIORITY is especially useful in cases level 4 and 5 priorities are needed and the user wants
--!to exclude frequent Debug messages that aren't relevant, after having checked they aren't the cause of the bug.

-- UI and inputs
_G.g_activeUI = {};
_G.g_UIEvents = {};
_G.g_KeyboardCallbacks = {}; -- contains tables like: [key] = callback_function();

-- other
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

Debugger.sep = "-------------------------";

--Prints a message when global variable *DEBUGGING* is set to true.<br>
--*priority* determines the necessity of the message. It makes the print statement run only when its value 
--is lower than global variable *PRIORITY*.<br> 
--If *IGNORE_LOWER_PRIORITY* is set to true, then only priorities equal to *PRIORITY* will be printed.
---@param msg string
---@param priority number?
function Debugger.msg(msg, priority)
    priority = priority or 1;

    if DEBUGGING and PRIORITY >= priority then
        if IGNORE_LOWER_PRIORITY then
            if priority == PRIORITY then
                print(msg);
            end
            return;
        end
        print(msg);
    end
end

--Prints a message when global variable *DEBUGGING* is set to true and the condition is met, as well
--as when *priority* is lower than *PRIORITY*, and if *IGNORE_LOWER_PRIORITY* is set to true then when
--*priority* is equal to *PRIORITY*
---@param condition boolean
---@param msg string
---@param priority number?
function Debugger.conditional(condition, msg, priority)
    priority = priority or 1;

    if DEBUGGING and PRIORITY >= priority and condition then
        if IGNORE_LOWER_PRIORITY then
            if priority == PRIORITY then
                print(msg);
            end
            return;
        end
        print(msg);
    end
end