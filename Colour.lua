local Colour = {};

--!LIBRARIES--
local Math = require("Math");

--!MAIN--
function Colour.new(r, g, b, a)
    r,g,b,a = r or 0, g or 0, b or 0, a or 1;
    assert(type(r) == "number" and type(g) == "number" and type(b) == "number" and type(a) == "number", "Colour.new() - r,g,b,a must be numbers or nil\n");

    r,g,b,a = Math.clamp(r,0,1), Math.clamp(g,0,1), Math.clamp(b,0,1), Math.clamp(a,0,1);

    local rgba = {};
    rgba.r = r;
    rgba.g = g;
    rgba.b = b;
    rgba.a = a;

    return rgba;
end

return Colour;