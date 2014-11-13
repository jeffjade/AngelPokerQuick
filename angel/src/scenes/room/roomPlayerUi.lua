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
	self.mEventTable = {
		[kServerDealCardsEv]        = self.onGameDealCardsEvent;
		[kServerPlayOverEv] 		= self.onGamePlayOverEvent;
	}

	for k,v in pairs(self.mEventTable) do
		EventDispatcher.getInstance():register(k, self ,v);
	end
end

function RoomPlayerUi:unregisterEvent()
	for k,v in pairs(self.mEventTable) do
		EventDispatcher.getInstance():unregister(k, self ,v);
	end
end

-- ************************************LogicHelperFun*********************************************
function RoomPlayerUi:showMyCard()

end

-- ************************************LogicHelperFun*********************************************


-- ---------------------------------OnEventCallBack-----------------------------------------------
function RoomPlayerUi:onGameDealCardsEvent(mid)
	if mid == PhpInfo.getMid() then
		self:showMyCard()
	end
end

function RoomPlayerUi:onGamePlayOverEvent()
	print("RoomPlayerUi:onGamePlayOverEvent~~~")
end
-- ---------------------------------onEventCallBack-----------------------------------------------