Math = {}

function Math.clamp(n, bottom, top)
    if n < bottom then
        n = bottom;
    elseif n > top then
        n = top;
    end

    return n;
end

-- Normalises v1 and v2 to norm and returns both
function Math.normalise(v1, v2, norm)
    norm = norm or 1;
    v1 = v1 or 1;
    v2 = v2 or 1;

    alpha = math.atan(v2, v2);
    v1 = 1.4*norm*math.cos(alpha) -- 1.4 is the approximation of sqrt2
    v2 = v1*math.tan(alpha);
    return v1, v2;
end

function Math.round(n)
    assert(type(n) == "number", "Math.round() - n must be a number");
    if n-math.floor(n) <= 0.5 then
        return math.floor(n);
    else
        return math.ceil(n);
    end
end

--!VECTORS--
Math.vec2 = {};
Math.vec3 = {};

-- Creates 2d vector.
-- Multiplying 2 vectors means taking their dot product.
-- Dividing 2 vectors means taking their cross product.
---@param x number?
---@param y number?
---@return {x: number, y: number, a: number, r: number}
function Math.vec2.new(x,y)
    x = x or 0;
    y = y or 0;

    local vec = {};
    setmetatable(vec, {
        __add = function(v1, v2)
            return Math.vec2.new(v1.x+v2.x, v1.y+v2.y);
        end,
        __sub = function(v1, v2)
            return Math.vec2.new(v1.x-v2.x, v1.y-v2.y);
        end,
        __concat = function(v1, v2)
            return v1+v2;
        end,
        __len = function(v)
            return v.r;
        end,
        __tostring = function(v)
            return "Components: "..v.x.."(x), "..v.y.."(y)\nMagnitude: "..v.r.."\n";
        end
        --TODO: implement __pow, __mul, __div, __unm, __eq,
    })

    assert(type(x) == "number" and type(y) == "number", "Math.vec2.new() - x,y must be numbers");

    vec.x = x;
    vec.y = y;
    vec.a = math.acos(x/vec.r);
    vec.r = math.sqrt(x^2+y^2);

    return vec;
end

---@param x number?
---@param y number?
---@return {x: number, y: number}
-- Creates a vec2 without any other functionality (e.g. sum properties, product, etc.).<br>
-- Used especially for determining the position of a UI object.
function Math.vec2.simple(x, y)
    x = x or 0;
    y = y or 0;
    assert(type(x) == "number" and type(y) == "number", "Math.vec2.simple() - x, y must be numbers\n");
    
    local vec = {};
    vec.x = x;
    vec.y = y;

    setmetatable(vec, {
        __tostring = function(t)
            return "("..t.x..","..t.y..",".."t.z"..")";
        end
    })

    return vec;
end

---@param x number?
---@param y number?
---@param z number?
---@return {x: number, y: number, z: number, a: number, b: number, r: number}
function Math.vec3.new(x,y,z)
    local vec = {};
    setmetatable(vec, {
        __add = function(v1, v2)
            return Math.vec.new(v1.x+v2.x, v1.y+v2.y, v1.z+v2.z);
        end,
        __sub = function(v1, v2)
            return Math.vec.new(v1.x-v2.x, v1.y-v2.y, v1.z-v2.z);
        end,
        __mul = function(v1, v2)
            return Math.vec.new(v1.x*v2.x + v1.y*v2.y + v1.z*v2.z);
        end,
        __div = function(v1, v2)
            return Math.vec.new(v1.y*v2.z - v1.z*v2.y, v1.z*v2.x - v1.x*v2.z, v1.x*v2.y - v1.y*v2.x); 
        end,
        __tostring = function(v)
            return "Components: "..v.x.."(x), "..v.y.."(y), "..v.z.." (z)\nMagnitude: "..v.r;
        end,
    });

    -- Cartesian form
    vec.x = x;
    vec.y = y;
    vec.z = z;

    -- polar form
    r = x^2 + y^2 + z^2;
    b =  math.asin(z/r);

    vec.r = r;
    vec.a = math.asin(x/math.cos(b)/r);
    vec.b = b;

    -- Alias of vector:magnitude()
    function vec:len()
        return math.sqrt(self.x^2+self.y^2+self.z^2);
    end

    -- Returns the magnitude of the vector. Alias: vector:len()
    function vec:magnitude()
        return math.sqrt(self.x^2+self.y^2+self.z^2);
    end

    return vec;
end

---@param x number?
---@param y number?
---@param z number?
---@return {x: number, y: number, z: number}
-- Creates a vec3 without any other functionality (e.g. sum properties, product, etc.).<br>
-- Used especially for determining the position of a UI object.
function Math.vec3.simple(x,y,z)
    x = x or 0;
    y = y or 0;
    z = z or 0;
    assert(type(x) == "number" and type(y) == "number" and type(z) == "number", "Math.vec3.simple() - x, y, z must be numbers.\n");
    
    local vec = {};
    vec.x = x;
    vec.y = y;
    vec.z = z;

    setmetatable(vec, {
        __tostring = function(t)
            return "("..t.x..","..t.y..",".."t.z"..")";
        end
    })

    return vec;
end

return Math;