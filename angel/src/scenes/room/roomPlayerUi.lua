-- File : roomPlayerUi.lua
-- Date : 2014.11.12  21:20
-- Auth : JeffYang
-- Desc : Control Playing Player Action
-- LastMoify : 2014.11.12 By jeff

RoomPlayerUi = class("RoomPlayerUi")

function RoomPlayerUi:ctor()
	self:registerEvent()
end

function RoomPlayerUi:dtor()
	self:unregisterEvent()
end

function RoomPlayerUi:registerEvent()
	-- EventDispatchController:addEventListener( "kServerDealCardsEv" ,    handler(self, self.onGameDealCardsEvent))
end

function RoomPlayerUi:unregisterEvent()
	
end

-- ************************************LogicHelperFun*********************************************
function RoomPlayerUi:showMyCard()

end

-- ************************************LogicHelperFun*********************************************


-- ---------------------------------OnEventCallBack-----------------------------------------------
function RoomPlayerUi:onGameDealCardsEvent(event)
	if mid == PhpInfo.getMid() then
		self:showMyCard()
	end
end

function RoomPlayerUi:onGamePlayOverEvent()
	print("RoomPlayerUi:onGamePlayOverEvent~~~")
end
-- ---------------------------------onEventCallBack-----------------------------------------------