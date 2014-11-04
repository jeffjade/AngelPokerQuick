-- File : gameAiPlayer.lua
-- Date : 2014.10.28   19:45
-- Auth : JeffYang

GameAiPlayer = class(roomPlayer)

function GameAiPlayer:ctor()

end

function GameAiPlayer:dtor()

end

function GameAiPlayer:setMoney()

end

function GameAiPlayer:getRoomInfo()
	self.mRoomInfo = require(GameRoomPath.."roomCache").new()
end

function GameAiPlayer:thinkHowGame()
	local lastMid = self.mRoomInfo:getLastPlayer();
	local outCards;
	local outType;

	if lastMid == 0 or lastMid == self.meMid then
		outCards, outType , betCards = self:outFirstCard();
	else
		outCards, outType , betCards = self:outLargeCard();
	end

	if outCards then
		if #outCards == 0 then
			local i = 0;
		end
		-- RoomCardTools.print_cards("out cards: " .. outType .. " ", outCards);
		self:setOutCards(#outCards, outType, outCards);

		self.mMyCardsChanged = true;
		self:outCard();  -- 出牌
	else
		self:turnCard(); -- 翻牌
	end
end

-- 此处为第一首出牌(经过AI得之)
function GameAiPlayer:outFirstCard()

end

-- 此处AI判断,得出最有优势的牌~出之;
function GameAiPlayer:outLargeCard()

end

function GameAiPlayer:sortCards(cards)

end

function GameAiPlayer:outCard(cards, count)
	self:dispathEvent({name = "SingleOutCardsEvent"})
end

function GameAiPlayer:turnCard()
	
end



