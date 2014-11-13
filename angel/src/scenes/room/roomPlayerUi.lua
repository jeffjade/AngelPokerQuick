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



-- ************************************LogicHelperFun*********************************************


-- ---------------------------------OnEventCallBack-----------------------------------------------
function RoomPlayerUi:onGamePlayOverEvent()
	print("RoomPlayerUi:onGamePlayOverEvent~~~")
end
-- ---------------------------------onEventCallBack-----------------------------------------------