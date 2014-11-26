-- File : cardType
-- Date : 2014.10.21
-- Coder: JeffYang

require "bit"

CardUtil = {};

CardUtil.getCardsValue = function()
	local cardsValue = {3,4,5,6,7,8,9,10,11,12,13,14,15}
	return cardsValue
end

CardUtil.getAllCards = function()
	local cards = {}
	for i = 0, 3 do
		for j = 1, 13 do
			local x = bit.blshift(i, 4);
			local value = bit.bor(x, j);
			table.insert(cards, value);
		end
	end
	table.insert(cards, 0x4e); -- 大王
	table.insert(cards, 0x4f); -- 小王

	local cardInfos = {};

	for i, cardByte in ipairs(cards) do
		local temp = CardUtil.getCardInfo(cardByte);
		cardInfos[i] = temp;
	end

	return cardInfos;
end

CardUtil.getAllCardsWithNoKings = function()
	local cards = {}
	for i = 0, 3 do
		for j = 1, 13 do
			local x = bit.blshift(i, 4);
			local value = bit.bor(x, j);
			table.insert(cards, value);
		end
	end

	local cardInfos = {};
	for i, cardByte in ipairs(cards) do
		local temp = CardUtil.getCardInfo(cardByte);
		cardInfos[i] = temp;
	end

	return cardInfos;
end

--[[/**
 * 从 cards 中随机取出17张牌，取出的牌会从 cards 中删除
 * @param cards
 * @return
 */]]
CardUtil.get17cards = function(cards)
	local list = {};
	local index = 1;
	for i = 1, 17 do
		-- math.randomseed(os.time());
		math.randomseed(tostring(os.time()):reverse():sub(1, 6))
		index = math.random(#cards);
		list[i] = cards[index];
		table.remove(cards, index);
	end
	return list;
end

--[[
 	* 从 cards 中随机取出13张牌，取出的牌会从 cards中删除
 	* @param cards
 	* @return cards]]
CardUtil.get13cards = function(cards)
	local list = {};
	local index = 1;
	for i = 1, 13 do
		math.randomseed(tostring(os.time()):reverse():sub(1, 6))
		index = math.random(#cards);  -- 这个值得随机度不够(不够随机)
		list[i] = cards[index];
		table.remove(cards, index);
	end
	return list,cards;
end

CardUtil.show = function(cards)
	for i, v in ipairs(cards) do
		DebugLog("cardByte: " .. (v.cardByte or "nil"));
		DebugLog("cardType: " .. (v.cardType or "nil"));
		DebugLog("cardValue: " .. (v.cardValue or "nil"));
	end
end

--[[/**
 * 生成一个List&lt;Byte&gt;[4], 前3个包含17张牌，最后一个包含剩余的3张牌
 * @return
 */]]
CardUtil.generateCards = function()
	local rtn = {};
	local lists = CardUtil.getAllCards();
	for i = 1, 3 do
		rtn[i] = CardUtil.get17cards(lists);
	end
	rtn[4] = lists;
	CardUtil.show(rtn[4]);
	return rtn;
end

-- 洗牌[2014.11.06~~21:38]
CardUtil.shuffleCards = function(cards)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local cardsCount = #cards
	for i = 1, cardsCount do
		index = math.random(cardsCount);
		cards[index],cards[i] = cards[i],cards[index] 
	end
	return cards
end

CardUtil.getCardInfo = function(cardByte)
	local cardTypeValue = cardByte;
	local cardType = bit.brshift(cardTypeValue, 4);
	local cardNoTypeValue = bit.band(cardTypeValue, 0x0f);

	if cardNoTypeValue == 1 or cardNoTypeValue == 2 then
		cardNoTypeValue = cardNoTypeValue + 13;
	elseif cardNoTypeValue == 14 or cardNoTypeValue == 15 then -- 处理大小王
		cardNoTypeValue = cardNoTypeValue + 2;
	end

	local cardInfo = {};

	cardInfo.cardByte = cardTypeValue;
	cardInfo.cardType = cardType;
	cardInfo.cardValue = cardNoTypeValue;
	return cardInfo;
end

-- 按照牌面的大小对牌进行排序[14.11.08]
CardUtil.sortCardsByValue = function(cards)
	table.sort(cards, 
		function(a , b) 
			return a.cardValue > b.cardValue
		end)
	return cards
end

--[[@Param  : outCards[所出牌之表],betCards[所叫牌之表]
    @return : true(两个表相同)/false(两表不同)
    @Desc   : 验证Player所打之牌是否为真(出的牌和叫的牌一致)]]
CardUtil.judgePlayIsTrue = function(outCards , betCards)
	if not outCards  or not betCards or type(outCards) ~= "table" or type(betCards) ~= "table"  then
		error("CardUtil:need judge cards are not legal (1)!")
	end

	if #outCards ~= betCards.num then
		return false
	end

	for k , v in pairs(outCards) do
		if type(v) ~= "table" or not v.cardValue or type(betCards) ~= "table" or not betCards.cardValue then 
		   error("CardUtil: need judge cards are not legal (2)!")
		elseif v.cardValue ~= betCards.cardValue then 
			return false
		end
	end
	return true
end


--[[
local allCards = CardUtil.getAllCardsWithNoKings()
local shuffleCards = CardUtil.shuffleCards(allCards)
local playerCards , otherCards = CardUtil.get13cards(allCards)
playerCards = CardUtil.sortCardsByValue(playerCards)

-- print_lua_table(playerCards)
-- print("===================")
-- print_lua_table(otherCards)


function randomInt(max_num, min_num)
	local min_num = min_num or 0;
	local num = max_num - min_num;
	return (math.floor(math.random() * (num + 1) * (num + 1)) % (num + 1)) + min_num;
end

function outBetTrueCard(Cards)
	-- random from(1~4) to get the number true cards
	local trueCardsList = findTrueCardList(Cards)

	-- 得到3有效的真牌表(剔除空table)
	for k , v in pairs(trueCardsList) do 
		if v and type(v) == "table" and not next(v) then
			table.remove(trueCardsList, k )
			trueCardsList[k] = nil
		end
	end

	-- 从有效表中随机一组出来
	local cardsNum = randomInt(#trueCardsList , 1)
	local tempCards = trueCardsList[cardsNum]

	-- random from(1~num);得到真牌组内出哪张真牌
	local num = randomInt(#tempCards or 1, 1)
	print_lua_table(trueCardsList)
	local trueCards = tempCards[num]

	local betCards ={}
	betCards.num = 	cardsNum
	betCards.value = trueCards.cardValue;

	print_lua_table(trueCards)
	return trueCards , betCards
end


function findTrueCardList(Cards)
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

outBetTrueCard(playerCards)]]