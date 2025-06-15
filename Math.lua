local Math = {};

function Math.clamp(n, a, b)
    assert(type(n) == "number" and type(a) == "number" and type(b) == "number", "Math.clamp() - n,a,b must be numbers\n");
    
    if n <= a then
        return a;
    elseif n >= b then
        return b;
    else
        return n;
    end
end

function Math.vec2(x,y)
    x = x or 0;
    y = y or 0;
    assert(type(x) == "number" and type(y) == "number", "Math.vec2() - x,y must be numbers\n");
    local vec = {};
    setmetatable(vec, {
        __tostring = function(t)
            return "(" .. t.x .. ", " .. t.y .. ")";
        end
    });

    vec.x, vec.y = x, y;

    return vec;
end

return Math;