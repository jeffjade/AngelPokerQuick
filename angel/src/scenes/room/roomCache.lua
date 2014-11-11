-- File : roomCache.lua
-- Date : 2013.10.30
-- Auth : JeffYang

RoomCache = class("RoomCache")

function RoomCache:ctor()
	self.mPlayerSeatMap = {};
	self.mPlayerMap = {};
	self.mPlayerNum = 0;
	self.mPlayerMaxNum = 4;
end

function RoomCache:dtor()	
	for k, v in pairs(self.mPlayerMap) do
		delete(v);
	end

	self.mMySelf = nil;
	self.mPlayerMap = nil;
	self.mPlayerSeatMap = nil;
	self.mPlayerNum = 0;
	self.mPlayerMaxNum = 0;
end

function RoomCache:reset()
	self.mCurrentPlayerMid = nil

	self.mNextPlayerMid = nil
	self.mLastPlayerMid = nil

	self.mLastOutCards = nil
	self.mPlayerMaxNum = nil

	self.mClockTime = nil
	self.mCurrentClockTime = nil
end


function RoomCache:setCurrentPlayer(mid)
	self.mCurrentPlayerMid = mid;
end

function RoomCache:getCurrentPlayer(mid)
	return self.mCurrentPlayerMid or 0;
end

function RoomCache:setNextPlayer(mid)
	self.mNextPlayerMid = mid;
end

function RoomCache:getNextPlayer()
	return self.mNextPlayerMid or 0;
end

function RoomCache:setLastPlayer(mid)
	self.mLastPlayerMid = mid;
end

function RoomCache:getLastPlayer()
	return self.mLastPlayerMid or 0;
end

-- 保存玩家上家出牌信息[]
function RoomCache:setLastOutCards(_count, _betCards, _cards)
	local tmp = {};
	for k, v in pairs(_cards) do
		tmp[k] = v;
	end
	self.mLastOutCards = { count = _count; types = _betCards; cards = tmp };
end

function RoomCache:getLastOutCards()
	return self.mLastOutCards
end

function RoomCache:getAllPlayerInfo()
	return self.mPlayerMap or {};
end

--设置最大玩家数
function RoomCache:setPlayerMaxNum(num)
	self.mPlayerMaxNum = num;
end

function RoomCache:getPlayerMaxNum()
	return self.mPlayerMaxNum or 4;
end


function RoomCache:setOutCardTime(time)
	self.mOutCardTime = time;
end

function RoomCache:getOutCardTime(time)
	return self.mOutCardTime or 10;
end

function RoomCache:setClockTime(time)
	self.mClockTime = time;
end

function RoomCache:getClockTime(time)
	return self.mClockTime or 10;
end

function RoomCache:setCurrentClockTime(time)
	self.mCurrentClockTime = time;
end

function RoomCache:getCurrentClockTime(time)
	return self.mCurrentClockTime or 10;
end


function RoomCache:addPlayer(player)
	local mid = player:getMid()
	if self.mPlayerMap[mid] == nil then
		self.mPlayerNum = self.mPlayerNum + 1;
	end
	self.mPlayerMap[mid] = player;
	print("%%%%%%%%%%%%%%%%%%% mid = "..mid)
	if mid == PhpInfo:getMid() then
		self.mMySelf = player;
		self:setMe(player)
	end
end

-- removePlayer[player]
function RoomCache:removePlayer(player)
	local mid = player:getMid();
	if self.mPlayerMap[mid] then
		self.mPlayerNum = self.mPlayerNum - 1;
		self.mPlayerMap[mid] = nil;
	end
	for k, v in pairs(self.mPlayerSeatMap) do
		if v == player then
			self.mPlayerSeatMap[k] = nil;
			break;
		end
	end
end

--[[ findPlayerByMid
    @Param : mid(number)
	@return : roomPlayer]]
function RoomCache:findPlayerByMid(mid)
	return self.mPlayerMap and self.mPlayerMap[mid];
end

function RoomCache:getPlayerNum()
	return self.mPlayerNum;
end


function RoomCache:getMe()
	return self.mMySelf;
end

function RoomCache:setMe(value)
	self.mMySelf = value;
end

function RoomCache:resetAllPlayers()
	for k, v in pairs(self.mPlayerSeatMap) do
		v:reset();
	end
end

function RoomCache:updateDirection(player)
	local direction = self:calcPlayerDirection(player);
	print("============updateDirection===================direction==============="..direction)
	self:changePlayerDirection(player, direction);
end

--[[removePlayer
	@Param : player : roomPlayer
	@return : numbe -direction(1~4)]]
function RoomCache:calcPlayerDirection(player)
	local me_mid = PhpInfo:getMid();
	if player:getMid() == me_mid then
		return 1;
	end
	local me = self:getMe();
	print("FFFFFFFFFFF"..me:getMid() )
	if me then
		print("++++++++++++++++++++++++++++++++++++++++++++++++++++++me")
		local meSeat = me:getSeat();
		local playerSeat = player:getSeat();
		local direction = (self.mPlayerMaxNum + playerSeat - meSeat) % self.mPlayerMaxNum + 1;
		return direction;
	end
	return 0;
end

--[[Function : changePlayerSeat
	@param:player : roomPlayer
	@param:seat   : number
	@return : boolean]]
function RoomCache:changePlayerDirection(player, direction)
	if player == nil then
		return;
	end

	local oldDirection = player:getDirection();
	if self.mPlayerSeatMap[oldDirection] ~= player then
		oldDirection = 0;
	else
		self.mPlayerSeatMap[oldDirection] = nil;
	end
	self.mPlayerSeatMap[direction] = player;
	player:setDirection(direction);
	return true;
end

function RoomCache:findPlayerByDirection(direction)
	print("------------------------mPlayerSeatMap = "..(#self.mPlayerSeatMap or 0))
	return self.mPlayerSeatMap[direction];
end

function RoomCache:findNextPlayerByDirection(direction)
	return self.mPlayerSeatMap[direction % self.mPlayerMaxNum + 1];
end

-- findPlayerBySeat
-- seat :   number - 0~3
-- return : room_player
function RoomCache:findPlayerBySeat(seat)
	for k, v in pairs(self.mPlayerSeatMap) do
		if v:getSeat() == seat then
			return v;
		end
	end
	return nil;
end

return RoomCache