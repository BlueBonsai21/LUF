local World = {}

--!MODULES--
local Entities = require("Entities");
local MainMenu = require("MainMenu");

--!SETUP--
_G.GRID_X = 5;
_G.GRID_y = 5;

--!MAIN--
function World.new()
    MainMenu.load();
    plr = Entities.new();
end

function World.update()
    plr:walk();
end

function World.render()
    Entities.render();
end

return World;