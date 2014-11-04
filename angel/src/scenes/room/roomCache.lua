-- File : roomCache.lua
-- Date : 2013.10.30
-- Auth : JeffYang

RoomCache = {}
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

function RoomCache:setLastOutCards(_count, _types, _cards)
	local tmp = {};
	for k, v in pairs(_cards) do
		tmp[k] = v;
	end
	self.mLastOutCards = { count = _count; types = _types; cards = tmp };
end

function RoomCache:getLastOutCards()
	return self.mLastOutCards;
end



function RoomCache:getAllPlayerInfo()
	return self.mPlayerMap or {};
end

function RoomCache:findPlayerByDirection(direction)
	return self.mPlayerSeatMap[direction];
end

function RoomCache:findNextPlayerByDirection(direction)
	return self.mPlayerSeatMap[direction % self.mPlayerMaxNum + 1];
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
	local mid = player:getMid();
	if self.mPlayerMap[mid] == nil then
		self.mPlayerNum = self.mPlayerNum + 1;
	end
	self.mPlayerMap[mid] = player;
	if mid == PhpInfo:getMid() then
		self.mMySelf = player;
	end
end

-- removePlayer
--		player : room_player
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

-- findPlayerByMid
-- mid : number
-- return : room_player
function RoomCache:findPlayerByMid(mid)
	return self.mPlayerMap and self.mPlayerMap[mid];
end

function RoomCache:getPlayerNum()
	return self.mPlayerNum;
end

-- removePlayer
--		player : room_player
--		return : number - direction(1~4)
function RoomCache:calcPlayerDirection(player)
	local me_mid = PhpInfo:getMid();
	if player:getMid() == me_mid then
		return 1;
	end
	local me = self.mMySelf;
	if me then
		local me_seat = me:getSeat();
		local player_seat = player:getSeat();
		local direction = (self.mPlayerMaxNum + player_seat - me_seat) % self.mPlayerMaxNum + 1;
		return direction;
	end
	return 0;
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
	self:changePlayerDirection(player, direction);
end

--	change_player_seat
--	player : room_player
--	seat   : number
--	return : boolean
function RoomCache:changePlayerDirection(player, direction)
	if player == nil then
		return;
	end

	local old_direction = player:getDirection();
	if self.mPlayerSeatMap[old_direction] ~= player then
		old_direction = 0;
	else
		self.mPlayerSeatMap[old_direction] = nil;
	end
	self.mPlayerSeatMap[direction] = player;
	player:setDirection(direction);
	return true;
end

-- findPlayerByDirection
-- direction : number - 1~4
-- eturn     : room_player
function RoomCache:findPlayerByDirection(direction)
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