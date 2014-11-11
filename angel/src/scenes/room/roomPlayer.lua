-- File : roomPlayer.lua
-- Date : 2014.10.28 19:56
-- Auth : JeffYang

RoomPlayer = class("RoomPlayer")

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

function RoomPlayer:setSex(sex)
	self.mSex = sex or 1
end

function RoomPlayer:getSex()
	return self.mSex
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

function RoomPlayer:setWinCount(winCount)
	self.mWinCount = winCount
end

function RoomPlayer:getWinCount()
	return self.mWinCount
end

function RoomPlayer:setLoseCount(loseCount)
	self.mLoseCount = loseCount
end

function RoomPlayer:getLoseCount()
	return self.mLoseCount
end

function RoomPlayer:setIsReady(ready)
	self.mReady = ready and true or false
end

function RoomPlayer:getIsReady()
	return self.mReady
end

function RoomPlayer:setDirection(direction)
	self.mDirection = direction;
end

function RoomPlayer:getDirection()
	return self.mDirection or 0;
end

function RoomPlayer:setPlayerCards(_num , _cards)
	if self.mPlayerCards == nil then
		self.mPlayerCards = {  count = _num;
		                       cards = _cards };
	else
		self.mPlayerCards.cards = _cards;
		self.mPlayerCards.count = _num;
	end
end

function RoomPlayer:getPlayerCards()
	return self.mPlayerCards
end

function RoomPlayer:sortPlayerCards()
	-- 对玩家的手牌进行排序
end

-- 设置玩家所出的牌[ _count张数; _betCards叫牌信息; _outCards出牌信息]
function RoomPlayer:setOutCards(_count, _betCards, _outCards)
	self.mOutCards = {  count = _count; 
					    betCards = _betCards;
					    outCards = _outCards }
end

function RoomPlayer:getOutCards()
	return self.mOutCards or {}
end

return RoomPlayer