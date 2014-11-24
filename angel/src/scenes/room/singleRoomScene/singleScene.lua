-- File : singleScene.lua
-- Date : 2014.10.28
-- Auth : JeffYang

local RoomScene = require(GameRoomPath.."roomScene")
local SingleScene = class("SingleScene", RoomScene)

SingleScene.GAME_READY = "singleGameReadyEvent"
SingleScene.PLAY_START = "singlePlayStartEvent"


function SingleScene:ctor()
    cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	self.super.ctor(self)

    cc.ui.UILabel.new({UILabelType = 2, text = "SINGLE GAME", size = 64 ,color = cc.c3b(22,222,22)})
        :align(display.CENTER, display.cx, display.top-50)
        :addTo(self)

    self:registerEvent()
    self:init()
end

function SingleScene:registerEvent()
	self.mEventTable = {
		[kServerDealCardsEv] 		= self.onGameDealCardsEvent;
	}
	for k,v in pairs(self.mEventTable) do
		EventDispatcher.getInstance():register(k, self ,v);
	end
end

function SingleScene:unregisterEvent()
	for k,v in pairs(self.mEventTable) do
		EventDispatcher.getInstance():unregister(k, self ,v);
	end
end

function SingleScene:init()
    self.mRoomInfo =  require(GameRoomPath.."roomCache").new(self)
    self.mGameServer = require(GameRoomPath.."singleRoomScene/singleServer").new(self)
end

function SingleScene:getRoomInfo()
    return self.mRoomInfo
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

    end):align(display.CENTER,display.right-100 ,display.top-50):addTo(self);
  

    -- self:dispatchEvent( {name = "kSingleGameReadyEv"} )
    -- EventDispatcher.getInstance():dispatch( kSingleGameReadyEv )
    -- self.mGameServer:onGameReadyEvent()

    -- g_SingleServer:onGameReadyEvent()
    EventDispatchController:dispatchEvent({name = "kSingleGameReadyEv"})
end

-- function SingleScene:dispatchEvents(eventTable)
--     self.mGameServer:dispatchEvent(eventTable)
-- end

function SingleScene:onExit() 
end

function SingleScene:onCleanup()
end

function SingleScene:onGameDealCardsEvent(mid , myCards)
	if mid == PhpInfo:getMid() then
		print_lua_table(myCards)
		self:showMyCards(myCards)
	end
end

return SingleScene