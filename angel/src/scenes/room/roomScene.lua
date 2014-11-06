-- File : roomScene.lua
-- Date : 2014.10.21:22:23
-- Auth : JeffYang

local RoomScene = class("RoomScene", function()
    return display.newScene("RoomScene")
end)

function RoomScene:ctor()
   print("RoomScene Be Called")
end

function RoomScene:onEnter()
end

function RoomScene:onExit() 
end

return RoomScene