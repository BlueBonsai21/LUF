UI = {}

--!SETUP--
local zModified = false; -- refers whether the active tablelib's been modified so it needs to be sorted again for z-index purpose (used to save memory)

_G.activeUI = {};

--!MAIN--

---@param settings {element: string?, mode: string?, pos: vector3?, size: vector2?, anchor: vector2?, image: string, rgba: colour?, parent: table?, text: {content: string, rgba: colour, font: string, size: number}?, clickCallback: {active: boolean, callback: function}?, visible: boolean?}
---@return table
--[[
No parameters are strictly required.<br>
Creates a UI instance, given a table containing the following:
*element* from Enum.UI (frame or canvas);<br>
*mode*, from Enum.UI (absolute, relative) determines the way dimensions are treated: "absolute" works in pixels from
the left corner of the window, or of the (eventual) parent, "relative" works in decimals (between 0 and 1) 
expressing the fraction of the size of the window or of the parent (e.g. 0.6 = 60%).<br>
*pos*, via Math.vec3.simple(x,y,z), where z is the z-index.<br>
*size*, via Math.vec2.simple(x,y), determining the size of the instance.<br>
*anchor*, via Math.vec2.simple(), that is the internal point of the instance where (0,0) wants to be set when calculating the position of the
same element (e.g. {1,1} means that the anchor point point will be in the bottom-right corner of the instance; 
if we set its position to {1,1,0} then it would get rendered inside the window, since we're moving the bottom-right corner
to (1,1) on screen).<br>
*rgba*, via Colour.new(), determines the red, green, blue and alpha channels of the UI instance.<br>
*parent*  requires a UI instance to be passed and it's the elements that in relative mode determines the position and size
of its children, based off its own properties.<br>
*text* is a table indexing: content (string), rgba (Colour), font (from UI.Fonts) and size (number); 
if content is provided, applies a text in the centre of the element.<br>
*visible*, determines wheter the element is being actively rendered or not. Unlike setting the alpha channel
to 0, *visible* affects its children, meaning they won't be rendered too.<br>
*clickCallback* is the table containing a boolean *active*, determing wheter the instance is a button (if it is, a border 
will be automatically generated around it) and *callback*, instead, is the function that fires when the user clicks on 
the button region.<br>
*image* is a string containg the address to the image to display.]]--
function UI.new(settings)
    Debugger.msg("-----------------------");
    Debugger.msg("UI.new() - UI created\n");

    ---@type table
    local newUI = {}
    local cache = {}; -- caching canvas and font, if existing

    local parent = settings.parent or nil;
    Debugger.conditional(settings.parent == nil, "UI.new() - defaulted parent to "..tostring(parent).."\n");
    assert(type(parent) == "nil" or type(parent) == "table");

    local mode = settings.mode or Enum.UI.absolute;
    Debugger.conditional(settings.mode == nil, "UI.new() - defaulted mode to "..tostring(mode).."\n");
    assert(type(mode) == "string", "UI.new() - mode must be a string");

    local anchor = settings.anchor or Math.vec2.simple(0,0);
    Debugger.conditional(settings.anchor == nil, "UI.new() - defaulted anchor to "..tostring(anchor).."\n");
    assert(type(anchor) == "table", "UI.new() - anchor must be a table. Use Math.vec2.simple()\n");

    local pos = settings.pos or Math.vec3.simple(0,0,1);
    Debugger.conditional(settings.pos == nil, "UI.new() - defaulted pos to "..tostring(pos).."\n");
    assert(type(pos) == "table", "UI.new() - pos must be a table\n");
    if parent then -- checking table content such that it contains the necessary keys
        pos.z = parent.z + settings.pos.z;
        table.insert(parent.children, newUI); -- stores only the memory reference
    end

    local size = settings.size or Math.vec2.simple(1,1);
    Debugger.conditional(settings.size == nil, "UI.new() - defaulted size to "..tostring(size).."\n");
    assert(type(size) == "table", "UI.new() - size must be a table with 2 elements (x,y)\n");

    if mode == Enum.UI.relative then
        size.x, size.y = Math.clamp(size.x, 0.0001, math.huge), Math.clamp(size.y, 0.0001, math.huge);

        if parent then
            size.x, size.y = size.x*parent.size.x, size.y*parent.size.y;
            pos.x, pos.y = parent.x + pos.x*parent.size.x - anchor.x*size.x, parent.y + pos.y*parent.size.y - anchor.y*size.y;
        else
            size.x, size.y = size.x*love.graphics.getWidth(), size.y*love.graphics.getHeight();
            pos.x, pos.y = pos.x*love.graphics.getWidth() - anchor.x*size.x, pos.y*love.graphics.getHeight() - anchor.y*size.y;
        end
    else
        mode = Enum.UI.absolute; -- just to ensure a correct mode is selected
        size.x, size.y = Math.clamp(size.x, 1, math.huge), Math.clamp(size.y, 1, math.huge);

        pos.x, pos.y = Math.round(pos.x) - anchor.x*size.x, Math.round(pos.y) - anchor.y*size.y;
        size.x, size.y = Math.round(size.x), Math.round(size.y);
    end

    local rgba = settings.rgba or Colour.new();
    Debugger.conditional(settings.rgba == nil, "UI.new() - defaulted rgba to "..tostring(rgba).."\n");
    assert(type(rgba) == "table", "UI.new() - rgba must be a table\n");

    local element = settings.element or Enum.UI.frame;
    Debugger.conditional(settings.element == nil, "UI.new() - defaulted element to "..tostring(element).."\n");
    assert(type(element) == "string", "UI.new() - element must be a string. Use Enum.UI.frame or Enum.UI.canvas\n");
    if element == Enum.UI.canvas then
        canvas = love.graphics.newCanvas(settings.size.x, settings.size.y);
        love.graphics.setCanvas(canvas);
        love.graphics.clear(0, 0, 0, 0);
        love.graphics.setBlendMode("alpha", "alphamultiply");
        love.graphics.setColor(rgba.r, rgba.g, rgba.b, rgba.a);
        love.graphics.rectangle("fill", 0, 0, size.x, size.y);
        love.graphics.setCanvas();
        
        cache.canvas = canvas -- caching the canvas
    end

    local text = settings.text or {content = "", rgba = Colour.new(), font = Enum.Fonts.first, size = 12};
    Debugger.conditional(settings.text == nil, "UI.new() - defaulted text.content to "..tostring(text.content).."\n");
    assert(type(text) == "table", "UI.new() - text must be a table\n");
    assert(type(text.content) == "string", "UI.new() - text.content must be a string\n");
    assert(type(text.rgba) == "table", "UI.new() - text.rgba must be a rgba table. Create using Colour.new(r,g,b,a)\n");
    assert(type(text.font) == type(Enum.Fonts.first), "UI.new() - text.font must be a value from Enum.Fonts\n");
    assert(type(text.size) == "number", "UI.new() - text.size must be a number\n");
    text.size = Math.round(text.size); -- removing eventual decimal point
    if text.content ~= "" then
        cache.font = love.graphics.newFont(text.font, text.size); -- caching the font
    end

    local clickCallback = settings.clickCallback or {active = false, callback = nil};
    Debugger.conditional(settings.clickCallback == nil, "UI.new() - defaulted clickCallback.active to "..tostring(clickCallback.active).."\n");
    assert(type(clickCallback) == "table", "UI.new() - clickable must be a boolean\n");

    local image = settings.image or "";
    Debugger.conditional(settings.image == nil, "UI.new() - defaulted image to "..tostring(image).."\n");
    assert(type(image) == "string", "UI.new() - image must be a string containing the image's address\n");
    if image ~= "" then
        cache.image = love.graphics.newImage(image);
    end

    local visible = settings.visible or true;
    Debugger.conditional(settings.visible == nil, "UI.new() - defaulted visible to "..tostring(visible).."\n");
    assert(type(visible) == "boolean", "UI.new() - visible must be a boolean\n");

    newUI.element = element;
    newUI.mode = mode;
    newUI.x, newUI.y, newUI.z = pos.x, pos.y, pos.z;
    newUI.anchor = anchor;
    newUI.visible = visible;
    newUI.rgba = rgba;
    newUI.size = size;
    newUI.text = text;
    newUI.image = image;
    newUI.clickCallback = clickCallback;
    newUI.cache = cache; -- cached canvas, text and images
    newUI.children = {};

    --!METHODS--
    ---@param pos vector2
    ---@param mode string?
    ---@return nil
    -- Move the UI element to a *pos*ition given by Math.vec2.simple(x,y), with a *mode* (default: absolute);
    function newUI:move(pos, mode) -- TODO: add lerps
        mode = mode or Enum.UI.absolute;
        assert(type(mode) == string, "UI.new():move() - mode must be a string. Use Enum.UI.absolute or Enum.UI.relative\n");

        if mode == "absolute" then
            self.x = pos.x;
            self.y = pos.x;
        else
            if self.parent then
                self.x = self.parent.x + self.x*self.parent.size.x;
                self.y = self.parent.y + self.y*self.parent.size.y;
            else
                self.x = settings.pos.x*love.graphics.getWidth();
                self.y = settings.pos.y*love.graphics.getHeight();
            end
        end
    end

    ---@param x number
    ---@param y number
    ---@param mode string?
    ---@return nil
    function newUI:resize(x, y, mode) --! TODO: add the possibility of a smooth transition + add relativity to the (eventual) parent
        mode = mode or Enum.UI.relative;
        if type(mode) ~= type(Enum.UI.relative) then
            print("newUI:resize() - (defaulted) mode = absolute");
            mode = Enum.UI.absolute;
        end

        if mode == Enum.UI.absolute then
            self.size.x = x;
            self.size.y = y;
        else
            x, y = Math.round(x), Math.round(y);
            self.x = x;
            self.y = y;
        end
    end

    function newUI:deactivate()
        for _, child in self.children do
            child:deactivate();
        end

        self.visible = false;
    end
    
    ---@param ratio number?
    ---@return nil
    function newUI:aspectRatio(ratio)
        ratio = ratio or 1;
        print(self.size.x, self.size.y, ratio);
        
        self.size.x = ratio*self.size.y;
        print(self.size.x, self.size.y, ratio);
        return;
    end

    ---@return nil
    function newUI:destroy()
        for i, element in activeUI do
            if element == self then
                table.remove(activeUI, i);
            end
        end

        for _, child in self.children do
            child:destroy();
        end

        self = nil;
        zModified = true;
    end

    table.insert(activeUI, newUI);
    zModified = true;
    return newUI;
end

-- temporarily make all the active UIs invisible
function UI.hide()
    for _, element in ipairs(activeUI) do
        element.visible = false;
    end
end

-- re-enable all the invisible UIs
function UI.show()
    for _, element in ipairs(activeUI) do
        element.visible = true;
    end

    zModified = true;
end

function UI.update()    -- TODO: create tweens in here and track them
    if zModified then
        if #activeUI > 1 then
            table.sort(activeUI, function(a, b) -- sorting the z-indices
                return a.z < b.z;
            end);
            zModified = false;
        end
    end
end

function UI.render()
    for _, element in pairs(activeUI) do
        if element.visible then
            if element.element == Enum.UI.frame then
                love.graphics.setColor(element.rgba.r, element.rgba.g, element.rgba.b, element.rgba.a);
                love.graphics.rectangle("fill", element.x, element.y, element.size.x, element.size.y);
            end

            if element.element == Enum.UI.canvas then
                love.graphics.draw(element.cache.canvas, element.x, element.y); 
            end

            if element.text.content ~= "" then
                love.graphics.setFont(element.cache.font);
                love.graphics.setColor(element.text.rgba.r, element.text.rgba.g, element.text.rgba.b, element.text.rgba.a);
                love.graphics.printf(element.text.content, element.x, element.y, element.size.x, "center");
            end

            if element.image ~= "" then
                local image = element.cache.image;
                love.graphics.draw(image, element.x+element.size.x/2-image:getWidth()/2, element.y+element.size.y/2-image:getHeight()/2);
            end

            if element.clickCallback.active then
                local vertices = {
                    element.x, element.y,
                    element.x + element.size.x, element.y,
                    element.x + element.size.x, element.y + element.size.y,
                    element.x, element.y + element.size.y
                }
                love.graphics.polygon("line", vertices);
            end
            
            love.graphics.setColor(1,1,1,1);
        end
    end
end

return UI;