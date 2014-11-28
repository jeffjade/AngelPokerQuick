-- File : singlePlayer.lua
-- Date : 2014.10.30
-- Auth : JeffYang

local roomPlayer = require(GameRoomPath.."roomPlayer")
SinglePlayer = class("SinglePlayer", roomPlayer)

function SinglePlayer:ctor()

end

function SinglePlayer:dtor()

end

function SinglePlayer:thinkHowGame()
	print("=== !!! SinglePlayer:thinkHowGame()~~~~~~~")
end

function SinglePlayer:sortCards(cards)

end

function SinglePlayer:removeCard(count ,info)
	count = count or 0
	local curCount = self.mPlayerCards.count;
	local cards = self.mPlayerCards.cards;
	local tmp = {};
	for j = 1, count do
		tmp[j] = info[j];
	end
	
	local new_cards = {};
	local new_count = 0;
	for j = 1, curCount do
		local card = cards[j];
		local found = false;
		for i = 1, count do
			if card.cardByte == tmp[i].cardByte then
				table.remove(tmp, i);
				count = count - 1;
				found = true;
				break;
			end
		end
		if not found then
			new_count = new_count + 1;
			new_cards[new_count] = card;
		end
	end
	-- print_lua_table( new_cards )

	self.mPlayerCards.cards = new_cards
	self.mPlayerCards.count = new_count
end

function SinglePlayer:outPlayCard()
	
end

function SinglePlayer:turnPlayCard()
	
end

return SinglePlayer