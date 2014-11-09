-- File : singleScene.lua
-- Date : 2014.10.28
-- Auth : JeffYang

local SingleScene = class("SingleScene", function()
    return display.newScene("SingleScene") 
end)

function SingleScene:ctor()
    cc.ui.UILabel.new({UILabelType = 2, text = "HERE IS OUER SINGLE GAME", size = 64})
        :align(display.CENTER, display.cx, display.top-64)
        :addTo(self)

    printLog("==========================")
    self:init()
end

function SingleScene:init()
    self.mGameServer = require(GameRoomPath.."singleRoomScene/singleServer").new()
    self.mRoomInfo =  require(GameRoomPath.."roomCache").new()

    self.mMySelfPlayer = require(GameRoomPath.."roomPlayer").new()
    self.mMySelfPlayer:setMid(100)
    self.mMySelfPlayer:setSex(1)
    self.mMySelfPlayer:setMoney(888)
    self.mMySelfPlayer:setIsReady(true)
    self.mMySelfPlayer:setSeat(1)

    self.mGameServer:playEnterRoom(100)
    self.mRoomInfo:addPlayer(self.mMySelfPlayer)
end

function SingleScene:onEnter()
	local images = {
        normal = "GreenButton.png",
        pressed = "GreenScale9Block.png",
        disabled = "GreenButton.png",
    }

    cc.ui.UIPushButton.new(images,{scale9 = true})
    	:setButtonSize(200,80):setButtonLabel("normal",cc.ui.UILabel.new({
            UILabelType = 2,
            text = "返回",
            size = 48,
            color = cc.c3b(128,128,0)
        })):onButtonClicked(function(event)
           local mainScene = require("app.scenes.MainScene").new();
           display.replaceScene(mainScene, "slideInB", 0.6)

    end):align(display.CENTER,display.cx,display.cy+100):addTo(self);

    -- 分发不过去???(待解决)
    -- self:dispatchEvent( {name = "SERVER_EVENT_GAME_READY"} )
    self.mGameServer:onGameReadyEvent()
end

function SingleScene:dispatchEvent(eventTable)
    local myApp = require("app.MyApp").new()
    myApp:dispatchEvent(eventTable)
end

function SingleScene:onExit() 
end

function SingleScene:onCleanup()
end

return SingleScene