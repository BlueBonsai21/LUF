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
            rgba = Colour.new(1,1,1,1),
            children = {},
            cache = {},
        },
    },
    active = {},
};

local mode = 0; -- 0 = absolute, 1 = relative
---Sets the mode to "absolute" (or 0), or "relative" (or 1) for all the following UI elements upon creation . <br>
---By passing no arguments it's defaulted to "absolute" (0).
---@param newMode string | number?
function UI.SetMode(newMode)
    newMode = newMode or 0;
    assert(newMode == 0 or newMode == 1 or newMode == "absolute" or newMode == "relative", "UI.ChangeMode() - mode has to be a valid number/string\n");
    if newMode == 0 or newMode == "absolute" then
        mode = 0;
    else
        mode = 1;
    end
end

local autocentre = false;
---If set to true, all UI elements will automatically have set their anchor point to {0.5,0.5}.<br>
---By passing no argument, it's defaulted to false.
---@param active boolean?
function UI.Autocentre(active)
    active = active or false;
    assert(type(active) == "boolean", "UI.Autocentre() - active must be a boolean\n");

    autocentre = active;
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

    if not autocentre then
        if settings.anchor then
            assert(type(settings.anchor) == "table" and settings.anchor.x and settings.anchor.y, "UI.lua - anchor must be a vec2 between 0 and 1\n");
            settings.anchor.x = Math.clamp(settings.anchor.x, 0, 1);
            settings.anchor.y = Math.clamp(settings.anchor.y, 0, 1);
            newUI.anchor = settings.anchor;
        end
    else
        newUI.anchor = Math.vec2(.5,.5);
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

    function newUI:activate()
        self.visible = true;
    end

    function newUI:deactivate()
        self.visible = false;
    end

    local function Initialise()
        local parentIndex = 0;
        for index, element in pairs(UI.active) do
            if newUI.parent and element == newUI.parent then
                parentIndex = index;
            end
        end
        for i=parentIndex+1, #UI.active-parentIndex, 1 do
            if UI.active[i].parent then
                if UI.active[i].z > newUI.z then
                    table.insert(UI.active, i, newUI);
                    return;
                end
            else
                break;
            end
        end
        table.insert(UI.active, newUI);
    end

    Initialise(); --! TODO check if it works well, logically

    print(newUI);

    return newUI;
end

---Creates a rectangle, given a settings table.
---@param settings any
---@return table
function UI.rect(settings)
    local rect = Create(settings);
    rect.type = Enum.type.frame;
    
    return rect;
end

---Creates a circle, given a settings table.<br>
---The radius of the circle can be assigned via *settings.radius* or it'll be defaulted to *settings.x*.
---@param settings table
---@return table
function UI.circle(settings)
    -- using circle.size.x as radius, although settings.radius can overwrite it
    local circle = Create(settings);
    circle.type = Enum.type.circle;

    if settings.radius then
        assert(type(settings.radius) == "number", "UI.circle() - radius must be a number\n");
        circle.radius = settings.radius;
    else
        circle.radius = circle.size.x;
    end
    
    return circle;
end

---Creates a text label, given a *settings.string* key.<br>
---Can assign a font via *settings.font*; if not provided it's defaulted to built-in LOVE2D default font.
---@param settings table
---@return table
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

---Creates an image label, given a *settings.source* key, representing the path to the image asset.<br>
---@param settings table
---@return table
function UI.image(settings)
    local img = Create(settings);
    img.type = Enum.type.image;

    if settings.source then
        assert(type(settings.source) == string, "UI.image() - source must be a string containing the path to the image\n");
        img.source = love.graphics.newImage(settings.source);
    else
        error("UI.image() - must provide a string path to the image asset\n");
        img = nil;
    end

    return img;
end

function UI.render()
    for _, element in pairs(UI.active) do
        if element.visible and element.type then
            love.graphics.setColor(element.rgba.r, element.rgba.g, element.rgba.b, element.rgba.a);

            if element.type == Enum.type.frame then
                love.graphics.rectangle("fill", element.x, element.y, element.size.x, element.size.y);
            end
            
            if element.type == Enum.type.text then
                if element.cache.font then
                    love.graphics.setFont(element.cache.font);
                end 
                love.graphics.print(element.string, element.x, element.y);
            end

            if element.type == Enum.type.circle then
                love.graphics.circle("fill", element.x, element.y, element.radius);
            end

            if element.type == Enum.type.image then
                love.graphics.draw(element.source, element.x, element.y);
            end

            love.graphics.setColor(1,1,1,1);
        end
    end
end

return UI;