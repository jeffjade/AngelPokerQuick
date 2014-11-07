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
	local betCards;

	if lastMid == 0 or lastMid == self.meMid then
		outCards , betCards = self:outFirstCard();
	else
		outCards , betCards = self:outLargeCard();
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
	local outCards , betCards
	-- first out card: random from true(1) and false(0)
	local betCardsFlag = ToolUtil.ToolUtil.randomInt(1 , 0)
	if betCardsFlag == 1 then 
		outCards , betCards = self:outBetTrueCard()
	elseif betCardsFlag == 0 then 
		outCards , betCards = self:outBetFalseCard()
	end
	return outCards , betCards
end

-- 此处AI判断,得出最有优势的牌~出之;
function GameAiPlayer:outLargeCard()

end

-- 出真牌(即out bet牌一致)
function GameAiPlayer:outBetTrueCard(Cards)
	-- random from(1~4) to get the number true cards
	local trueCardsList = findTrueCardList(Cards)

	-- 得到有效的真牌表(剔除空table)
	for k , v in pairs(trueCardsList) do 
		if v and type(v) and not next(v) then
			table.remove(trueCardsList, k )
		end
	end

	-- 从有效表中随机一组出来
	local cardsNum = ToolUtil.randomInt(#trueCardsList , 1)
	local tempCards = trueCardsList[cardsNum]

	-- random from(1~num);得到真牌组内出哪张真牌
	local num = ToolUtil.randomInt(#tempCards or 1, 1)
	local trueCards = tempCards[num]

	local betCards ={}
	betCards.num = 	cardsNum
	betCards.value = trueCards.cardValue;

	print_lua_table(trueCards)
	return trueCards , betCards
end

function GameAiPlayer:findTrueCardList(Cards)
	-- 将手剩牌根据 cardValue等于3~15放置于一个表cardsList内 
	local cardsValue = CardUtil.getCardsValue()
	local cardsList = {}
	local i = 0
	for _ , value in ipairs(cardsValue) do
		i = i + 1
		cardsList[i] = {}
		for k , v in ipairs(Cards) do 
			if value == v.cardValue then
				table.insert(cardsList[i] , v)
			end
		end
	end

	-- 将表cardsList内拥有的牌的张数[0-4](即子表的个数)将其存于trueCardsList中
	-- 即得到一张真牌表(里面有4个子表~分别存放n=1,2,3,4张真牌的表)
	local tempList = {0,1,2,3,4}
	local trueCardsList = {{} , {}, {}, {}}
	for k,v in ipairs(cardsList) do 
		if     v and #v == tempList[1] then
			-- do noting 
		elseif v and #v == tempList[2] then 
			table.insert( trueCardsList[1] , v)
		elseif v and #v == tempList[3] then 
			table.insert( trueCardsList[2] , v)
		elseif v and #v == tempList[4] then 
			table.insert( trueCardsList[3] , v)
		elseif v and #v == tempList[5] then 
			table.insert( trueCardsList[4] , v)
		end 
	end
	return trueCardsList
end

-- 出假牌(即out bet牌 不一致)
function GameAiPlayer:outBetFalseCard()
	
end


function GameAiPlayer:sortCards(cards)

end

function GameAiPlayer:outCard(cards, count)
	self:dispathEvent({name = "SingleOutCardsEvent"})
end

function GameAiPlayer:turnCard()
	
end