local UI = require("UI");

function love.conf(game)
    game.identity = "data"; -- data files
    game.version = "11.5";
    game.console = false;
    game.externalstorage = false; -- Android only
    game.gammacorrect = true;
    game.window.title = "LUF";
    game.window.width = 800;
    game.window.height = 700;
    game.window.minwidth = game.window.width;
    game.window.minheight = game.window.height;
    game.window.resizable = false;
    game.window.vsync = 0;
    game.window.display = 1;
    game.window.fullscreen = false;
    game.window.x = 200;
    game.window.y = 50;
end