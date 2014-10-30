-- File : roomPlayer.lua
-- Date : 2014.10.28 19:56
-- Auth : JeffYang

RoomPlayer = {}

function RoomPlayer:ctor()
end

function RoomPlayer:dtor()
end

function RoomPlayer:setMid(mid)
	self.mMid = mid
end

function RoomPlayer:getMid()
	return self.mMid or 0
end

function RoomPlayer:setMoney(money)
	self.mMoney = money
end

function RoomPlayer:getMoney()
	return self.mMoney or 0
end

function RoomPlayer:setIcon(icon)
	self.mIcon = icon
end

function RoomPlayer:getIcon()
	return self.mIcon
end

function RoomPlayer:setNick(nick)
	self.mNick = nick
end

function RoomPlayer:getIcon()
	return self.mNick
end

function RoomPlayer:setSeat(seat)
	self.mSeat = seat 
end

function RoomPlayer:getSeat()
	return self.mSeat or 1
end

function RoomPlayer:setIsReady(ready)
	self.mReady = ready and true or false
end

function RoomPlayer:getIsReady()
	return slef.mReady
end

