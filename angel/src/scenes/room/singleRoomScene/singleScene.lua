-- File : singleScene.lua
-- Date : 2014.10.28
-- Auth : JeffYang

local RoomScene = require(GameRoomPath.."roomScene")
local SingleScene = class("SingleScene", RoomScene)

SingleScene.GAME_READY = "singleGameReadyEvent"
SingleScene.PLAY_START = "singlePlayStartEvent"

function SingleScene:ctor()
	self.super.ctor(self)
end

function SingleScene:init()
    self.mRoomInfo =  require(GameRoomPath.."roomCache").new(self)
    self.mGameServer = require(GameRoomPath.."singleRoomScene/singleServer").new(self)
end

function SingleScene:registerEvent()
    EventDispatchController:addEventListener( "kServerPlayStartEv" ,      handler(self, self.onPlayStartEvent))
    EventDispatchController:addEventListener("kServerDealCardsEv" ,       handler(self, self.onGameDealCardsEvent))
    EventDispatchController:addEventListener("kServerPlayNextEv" ,        handler(self, self.onPlayNextEvent))
    EventDispatchController:addEventListener("kServerPlayerOutCardsEv" ,  handler(self, self.onPlayOutCardsEvent))
    EventDispatchController:addEventListener( "kServerPlayNewTurnEv" ,    handler(self, self.onPlayNewTurnEvent))
end

function SingleScene:getRoomInfo()
    return self.mRoomInfo
end

function SingleScene:getPlayerByMid(mid)
    return self.mRoomInfo:findPlayerByMid(mid)
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
  
    EventDispatchController:dispatchEvent({name = "kSingleGameReadyEv"})
end

function SingleScene:onExit()
    RoomScene.onExit(self)
end

function SingleScene:onCleanup()
end

function SingleScene:updatePlayerLastCountByMid(mid)
    local player = self.mRoomInfo:findPlayerByMid(mid)
    local seat = player:getSeat()
    local playerCards = player:getPlayerCards()
    local leftCount = playerCards.count
    self:showPlayerLeftCardCount(seat , leftCount )
end

-- ---------------------------------onEventCallBack-----------------------------------------------
function SingleScene:onPlayStartEvent(event)
    if event.mid == PhpInfo:getMid() then
        self:showOutCardButton()
    end
end

function SingleScene:onGameDealCardsEvent(event)
    local  mid = event.mid
	if mid == PhpInfo:getMid() then
		self:showMyCards(event.playerCards)
	end
    self:updatePlayerLastCountByMid(mid)
end

function SingleScene:onPlayNextEvent(event)
    if event.mid == PhpInfo:getMid() then
        if self.isNewTurn then
            self:showOutCardButton()
        else
            self:showFlipButton()
            self:showFollowButton()
        end
    end
end

function SingleScene:onPlayOutCardsEvent(event)
    local mid = event.mid
    local outCards = event.outCards
    local player = self.mRoomInfo:findPlayerByMid(mid)
    local seat = player:getSeat()
    local playerCards = player:getPlayerCards()
    local leftCount = playerCards.count
    print("ooooooooooooooo----onPlayOutCardsEvent----oooooooooooo " .. seat .. " leftCount= " .. leftCount)
    if mid ~= PhpInfo:getMid() then
        self:flyOutCardsBySeat(seat , outCards)
        self:showPlayerLeftCardCount(seat , leftCount )
    else
        -- 播放玩家自己出牌 之 (动画)
        self:showPlayerLeftCardCount(seat , leftCount)
    end
    self.isNewTurn = false
end

function SingleScene:onPlayNewTurnEvent(event)
    self.isNewTurn = true
end
-- ---------------------------------onEventCallBack-----------------------------------------------


return SingleScene