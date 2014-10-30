-- File : singleScene.lua
-- Date : 2014.10.28
-- Auth : JeffYang

local SingleScene = class("SingleScene", function()
    return display.newScene("SingleScene") 
    -- local node = display.newNode()
    -- node.sceneName = sceneName
    -- return node
    
    -- require(GameRoomPath.."roomScene")
end)
-- local SingleScene = display.newScene("SingleScene")

function SingleScene:ctor()
   print("SingleScene Be Called========================================")

    cc.ui.UILabel.new({UILabelType = 2, text = "Hello, Fuck Every@Chen And @Wu!", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)
end

function SingleScene:onEnter()
	print("SingleScene onEnter========================================")
end

function SingleScene:onExit() 
end

function SingleScene:onCleanup()
end

return SingleScene