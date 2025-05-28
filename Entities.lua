local Entities = {}

--!SETUP--
local active = {};

--!MAIN--
-- Creates a new entity
---@param sprite string?
---@param x number?
---@param y number?
---@param can_move boolean?
---@param can_rotate boolean?
---@param direction number?
---@return table
function Entities.new(sprite, x, y, can_move, can_rotate, direction) --TODO: create default cases; switch to args table
    sprite = sprite or Enum.Sprites.trainer;
    assert(type(sprite) == type(Enum.Sprites.trainer), "Entities.new() - wrong entity type. Use Enum.Sprites\n");

    x, y = x or 0, y or 0;
    assert(type(x) == "number" and type(y) == "number", "Entities.new() - x,y must be numbers\n");

    direction = direction or 1;
    assert(type(direction) == "number", "Entities.new() - direction must be a number\n");

    can_move, can_rotate = can_move or true, can_rotate or true;
    assert(type(can_move) == "boolean" and type(can_rotate) == "boolean", "Entities.new() - can_move, can_rotate must be booleans\n");

    local entity = {};
    entity.sprite = sprite;
    entity.x = x;
    entity.y = y;
    entity.can_move = can_move;
    entity.can_rotate = can_rotate;
    entity.direction = direction; -- 1 = up, 2 = left, 3 = down, 4 = right
    entity.step = 1; -- animation step (from 1 to 4)
    entity.movementTimer = 1;
    entity.animationStepTime = .2;
    entity.speed = {
        x = 0,
        y = 0,
    };
    entity.moving = false;
    entity.maxSpeed = 100;
    entity.quads = {{}, {}, {}, {}};

    local SPRITE_WIDTH, SPRITE_HEIGHT = 150, 150;
    QUAD_WIDTH, QUAD_HEIGHT = SPRITE_WIDTH/4, SPRITE_HEIGHT/4;
    for i=1, 4 do
        for j=1, 4 do 
            entity.quads[i][j] = love.graphics.newQuad(QUAD_WIDTH*(i-1), QUAD_HEIGHT*(j-1), QUAD_WIDTH, QUAD_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT);
        end
    end

    function entity:walk()
        if self.can_move then
            if love.keyboard.isDown("w") then
                self.speed.y = -self.maxSpeed;
                self.speed.x = 0;
            elseif love.keyboard.isDown("s") then
                self.speed.y = self.maxSpeed;
                self.speed.x = 0;
            elseif love.keyboard.isDown("a") then
                self.speed.x = -self.maxSpeed;
                self.speed.y = 0;
            elseif love.keyboard.isDown("d") then
                self.speed.x = self.maxSpeed;
                self.speed.y = 0;
            else
                self.speed.x, self.speed.y = 0,0;
            end
        end
        if self.can_rotate then
            if love.keyboard.isDown("w") then
                self.direction = 4;
            elseif love.keyboard.isDown("s") then
                self.direction = 1;
            elseif love.keyboard.isDown("a") then
               self.direction = 2; 
            elseif love.keyboard.isDown("d") then
                self.direction = 3;
            end
        end

        if love.timer.getTime() - self.movementTimer >= self.animationStepTime then
            if love.keyboard.isDown("w") or love.keyboard.isDown("a") or love.keyboard.isDown("s") or love.keyboard.isDown("d") then
                self.movementTimer = love.timer.getTime();
                if self.step >= 4 then
                    self.step = 1;
                end
                self.step = self.step + 1;
                self.x, self.y = self.x + self.speed.x*self.animationStepTime, self.y + self.speed.y*self.animationStepTime;
                return;
            else
                if self.step == 2 then
                    self.step = 3;
                else
                    self.step = 1;
                end
            end
        end


    end

    table.insert(active, entity);
    return entity;
end

function Entities.render()
    for _, entity in ipairs(active) do
        if DEBUGGING then
            local vertices = {
                entity.x, entity.y,
                entity.x + QUAD_WIDTH, entity.y,
                entity.x + QUAD_WIDTH, entity.y + QUAD_HEIGHT,
                entity.x, entity.y + QUAD_HEIGHT,
                entity.x, entity.y,
                entity.x + QUAD_WIDTH, entity.y + QUAD_HEIGHT,
                entity.x + QUAD_WIDTH, entity.y,
                entity.x, entity.y + QUAD_HEIGHT
            };
            love.graphics.setColor(1,0,0,1);
            love.graphics.polygon("line", vertices);
            love.graphics.setColor(1,1,1,1);
        end
        love.graphics.draw(entity.sprite, entity.quads[entity.step][entity.direction], entity.x, entity.y);
    end
    -- TODO: finish; use Entities.active to get entities to render
    -- ?Note: eventually make it so elements outside the scene aren't being rendered, so memory is saved.
end

return Entities;