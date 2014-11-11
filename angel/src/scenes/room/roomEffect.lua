-- File : roomEffect
-- Date : 2014.11.11 14:29
-- Auth : JeffYang
-- LastModify : 2014.11.11
-- Desc : Play Music And Effect For Game

RoomEffect = class("RoomEffect")

function RoomEffect:ctor()
	self:registerEvent()
end 

function RoomEffect:dtor()
	self:unregisterEvent();
end 

function RoomEffect:registerEvent()

end

function RoomEffect:unregisterEvent()

end



return RoomEffect