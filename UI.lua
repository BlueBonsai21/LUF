--!LIBRARIES--
local Math = require("Math");
local Colour = require("Colour");

--!MAIN--
local UI = {
    template = {
        __index = {
            visible = true,
            parent = nil,
            x = 0,
            y = 0,
            z = 0,
            anchor = Math.vec2(),
            size = Math.vec2(1, 1),
            rgba = Colour.new(),
            children = {},
            cache = {},
        },
        __tostring = function()
            return unpack(t);
        end
    },
    active = {},
    inactive = {},
};

local mode = 0; -- 0 = absolute, 1 = relative
function UI.SetMode(newMode)
    newMode = newMode or 0;
    assert(newMode == 0 or newMode == 1 or newMode == "absolute" or newMode == "relative", "UI.ChangeMode() - mode has to be a valid number/string\n");
    if newMode == 0 or newMode == "absolute" then
        mode = 0;
    else
        mode = 1;
    end
end

local function OrderActive()
    local parents = {};
    for _, element in ipairs(UI.active) do
        if not element.Parent then
            table.insert(parents, element);
        end
    end
    table.sort(parents, function(a,b)
     return a.z < b.z;
    end);
    for parentIndex, parent in pairs(parents) do
        if #parent.children > 0 then
            table.sort(parent.children, function(a, b)
                return a.z < b.z;
            end);

            for childIndex, child in pairs (parent.children) do
                table.insert(parents, parentIndex + childIndex,child);
            end
        end
    end

    children = nil;
    parents = nil;
end

local function Create(settings)
    local newUI = {};
    setmetatable(newUI, UI.template);

    if settings.visible then
        assert(type(settings.visible) == "boolean", "UI.lua - visible must be a boolean");
        newUI.visible = settings.visible;
    end

    
    if settings.parent then
        assert(type(settings.parent) == "table" and settings.parent.x and settings.parent.y and settings.parent.size, "UI.lua - provided parent is not a valid parent; make sure to pass a UI reference, or nil\n");
        newUI.parent = settings.parent;
        table.insert(settings.parent.children, newUI);
    end
    
    if settings.size then
        if settings.size.x and settings.size.y then
            if mode == 0 then
                newUI.size = settings.size;
            elseif mode == 1 then
                if newUI.parent then
                    newUI.size = Math.vec2(settings.size.x * newUI.parent.size.x,  settings.size.y * newUI.parent.size.y);
                else
                    newUI.size = Math.vec2(settings.size.x * love.graphics.getWidth(),  settings.size.y * love.graphics.getHeight());
                end
            end
        else
            error("UI.lua - size must have an x and y value\n");
        end
    end

    if settings.anchor then
        assert(type(settings.anchor) == "table" and settings.anchor.x and settings.anchor.y, "UI.lua - anchor must be a vec2 between 0 and 1\n");
        settings.anchor.x = Math.clamp(settings.anchor.x, 0, 1);
        settings.anchor.y = Math.clamp(settings.anchor.y, 0, 1);
        newUI.anchor = settings.anchor;
    end
    
    if settings.x then
        assert(type(settings.x) == "number", "UI.lua - x must be a number\n");
        
        if mode == 0 then
            newUI.x = settings.x;
        elseif mode == 1 then
            print()
            if newUI.parent then
                newUI.x = newUI.parent.x + settings.x*newUI.parent.size.x - newUI.anchor.x * newUI.size.x;
            else
                newUI.x = settings.x*love.graphics.getWidth() - newUI.anchor.x * newUI.size.x;
            end
        end
    end

    
    if settings.y then
        assert(type(settings.y) == "number", "UI.lua - y must be a number\n");
        
        if mode == 0 then
            newUI.y = settings.y;
        elseif mode == 1 then
            if newUI.parent then
                newUI.y = newUI.parent.y + settings.y*newUI.parent.size.y - newUI.anchor.y * newUI.size.y;
            else
                newUI.y = settings.y*love.graphics.getHeight() - newUI.anchor.y * newUI.size.y;
            end
        end
    end

    if settings.z then
        assert(type(settings.z) == "number", "UI.lua - z must be a number\n");

        if newUI.parent then
            newUI.z = newUI.parent + settings.z;
        else
            newUI.z = settings.z;
        end
    else
        if newUI.parent then
            newUI.z = newUI.parent.z;
        end
    end

    if settings.rgba then
        if settings.rgba.r and settings.rgba.g and settings.rgba.b and settings.rgba.a then
            newUI.rgba = settings.rgba;
        else
            error("UI.lua - rgba must be a rgba table. Use Colour.new()\n");
        end
    end

    if newUI.visible then
        table.insert(UI.active, newUI);
    else
        table.insert(UI.inactive, newUI);
    end

    function newUI:activate()
        self.visible = true;
        if UI.inactive[newUI] then
            UI.inactive[newUI] = nil;
            table.insert(UI.active, newUI);
        end
    end

    function newUI:deactivate()
        self.visible = false;
        if UI.active[newUI] then
            UI.active[newUI] = nil;
            table.insert(UI.inactive, newUI);
        end
    end

    --OrderActive();

    return newUI;
end

function UI.rect(settings)
    local rect = Create(settings);
    rect.type = Enum.type.frame;
    
    return rect;
end

function UI.circle(settings)
    local circle = Create(settings);
    circle.type = Enum.type.frame;

    return circle;
end

function UI.text(settings)
    local text = Create(settings);
    text.type = Enum.type.text;
    
    if settings.string then
        assert(type(settings.string) == "string", "UI.text() - string must be a string (who would've guessed?)\n");
        text.string = settings.string;
    end

    
    if settings.string:gsub(" ", "") == "" then
        return text;
    end

    if settings.font then
        assert(settings.font == Enum.fonts.lollygag, "UI.text() - choose font via Enum.fonts\n");
        local font = love.graphics.newFont(settings.font);
        text.cache.font =  font;
    end
    
    return text;
end

function UI.render()
    for _, element in pairs(UI.active) do
        if element.visible and element.type then
            if element.type == Enum.type.frame then
                love.graphics.setColor(element.rgba.r, element.rgba.g, element.rgba.b, element.rgba.a);
                love.graphics.rectangle("fill", element.x, element.y, element.size.x, element.size.y);
                love.graphics.setColor(0,0,0,1);
            end
            
            if element.type == Enum.type.text then
                if element.cache.font then
                    love.graphics.setFont(element.cache.font);
                end 
                love.graphics.setColor(element.rgba.r, element.rgba.g, element.rgba.b, element.rgba.a);
                love.graphics.print(element.string, element.x, element.y);
                love.graphics.setColor(0,0,0,1);
            end
        end
    end
end

return UI;