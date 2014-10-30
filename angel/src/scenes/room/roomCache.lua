-- File : roomCache.lua
-- Date : 2013.10.30
-- Auth : JeffYang

RoomCache = {}
function RoomCache:ctor()

end

function RoomCache:dtor()

end

function RoomCache:reset()

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