-- File : gameAiPlayer.lua
-- Date : 2014.10.28   19:45
-- Auth : JeffYang

local SinglePlayer = require(GameRoomPath.."singleRoomScene/singlePlayer")
GameAiPlayer = class("GameAiPlayer" , SinglePlayer)

function GameAiPlayer:ctor()
	self.mRoomInfo = require(GameRoomPath.."roomCache").new()
	self:registerEvent()
end

function GameAiPlayer:dtor()
	self:unregisterEvent()
end

function GameAiPlayer:registerEvent()
	self.mEventTable = {
		[kServerPlayerOutCardsEv] 		= self.onPlayerOutCardEvent;
	}

	for k,v in pairs(self.mEventTable) do
		EventDispatcher.getInstance():register(k, self ,v);
	end
end

function GameAiPlayer:setMoney()

end

function GameAiPlayer:getRoomInfo()
	return self.mRoomInfo
end

function GameAiPlayer:thinkHowGame()
	local lastMid = self.mRoomInfo:getLastPlayer();
	local outCards;
	local betCards;

	local myCards = self:getPlayerCards().cards;
	if lastMid == 0 or lastMid == self.mMid then
		outCards , betCards = self:outFirstCard(myCards);
	else
		outCards , betCards = self:outLargeCard(myCards);
	end

	if #outCards == 0 then 
		print("GameAiPlayer:thinkHowGame()~~~~~~~ what???")
	end
	print("~~~~~~~~player mid is:"..self.mMid)
	print("~~~~~~~~GameAiPlayer:ai out cards: ")
	print_lua_table(outCards)

	if outCards and next(outCards) then
		self:setOutCards(#outCards, outType, outCards);

		self.mMyCardsChanged = true;
		self:outPlayCard();  -- 出牌
	else
		self:turnPlayCard(); -- 翻牌
	end
end

-- 此处为第一首出牌(经过AI得之)
function GameAiPlayer:outFirstCard(myCards)
	local outCards , betCards
	-- first out card: random from true(1) and false(0)
	local betCardsFlag = ToolUtil.randomInt(1 , 1)
	if betCardsFlag == 1 then
		outCards , betCards = self:outBetTrueCard(myCards)
	elseif betCardsFlag == 0 then 
		outCards , betCards = self:outBetFalseCard(myCards)
	end
	return outCards , betCards 
end

-- 此处AI判断,得出最有优势的牌~出之;
function GameAiPlayer:outLargeCard(myCards)
 	-- Find Last BetCardsValue In MyCards( If Have Put True,Or Turn PlayCard)
	local lastCards = self.mRoomInfo:getLastOutCards()
	local lastBetCards = lastCards.betCards
	local lastCardsValue = lastBetCards.cardValue

	local tempCards = {}
	for k , v in pairs(myCards) do
		if v and lastCardsValue == v.cardValue then
			table.insert(tempCards , v)
		end
	end

	if next(tempCards) then
		return tempCards , tempCards
	else
		return nil , nil
	end
end

-- 出真牌(即out bet牌一致)
function GameAiPlayer:outBetTrueCard(Cards)
	-- random from(1~4) to get the number true cards
	local trueCardsTempist = self:findTrueCardList(Cards)
	local trueCardsList = {}

	-- 得到有效的真牌表(剔除空table)
	for k , v in pairs(trueCardsTempist) do
		if v and type(v) and next(v) then
			table.insert(trueCardsList , v) 
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

	print_lua_table(trueCards)---------@@@
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
	print("GameAiPlayer:outBetFalseCard()~~~~~~")
end


function GameAiPlayer:sortCards(cards)

end

function GameAiPlayer:outPlayCard()
	EventDispatcher.getInstance():dispatch(kSingleOutCardEv , self.mMid);
end

function GameAiPlayer:turnPlayCard()
	EventDispatcher.getInstance():dispatch(kSingleTurnCardEv , self.mMid);
end

-- -----------------------------onEventCallBack-----------------------------
function GameAiPlayer:onPlayerOutCardEvent(mid)
	-- 播放robot的聊天动画;
	if mid ~= self.mMid then

	end
end
-- -----------------------------onEventCallBack-----------------------------

return GameAiPlayer