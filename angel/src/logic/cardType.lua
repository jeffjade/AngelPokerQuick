-- File : cardType
-- Date : 2014.10.21
-- Coder: JeffYang

require "bit"
CardType = {};

CardType.CT_ERROR  = 0;      --  0.错误
CardType.CT_SINGLE = 1;      --  1.单牌
CardType.CT_DOUBLE = 2;      --  2.对牌
CardType.CT_THREE  = 3;      --  3.三张
CardType.CT_FOUR   = 4;      --  4.四张

function print_lua_table (lua_table, indent)
    if not lua_table or type(lua_table) ~= "table" then
        return;
    end

	if not next(lua_table) then
		print("here table is {}!")
	end

    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if type(v) == "table" then
            print(formatting)
            print_lua_table(v, indent + 1)
            print(szPrefix.."},")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            print(formatting..szValue..",")
        end
    end
end


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
		index = math.random(#cards);
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

-- local allCards = CardUtil.getAllCardsWithNoKings()
-- local playerCards , otherCards = CardUtil.get13cards(allCards)
-- print_lua_table(playerCards)
-- print("===================")
-- print_lua_table(otherCards)

local tab = {{}, {}, {}, {}}
table.insert(tab[1], 22)

print_lua_table(tab)