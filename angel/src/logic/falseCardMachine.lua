--ClassName 	: FalseCardMachine
--create_author : ClarkWu
--create_date 	: 2014/11/13
--last_modified : 2014/11/14
--last_author	: ClarkWu
--description 	: 假牌生成器:
--				  1).根据当前牌生成所有的1张、2张、3张、4张牌的数组组合
--				  2).根据真牌，去除所有可能包含真牌的数组,生成符合条件的1张、2张、3张、4张假牌数组
--				  3).为1张、2张、3张、4张牌设置概率
--				  4).为1张、2张、3张、4张假牌数组分别生成匹配类型数组
--				  5).为每种匹配类型设置概率
--				  6).提供公用方法，根据每种概率随机生成假牌
--				  7).清空所有数组
local FalseCardMachine = class("FalseCardMachine");

FalseCardMachine.instance = nil;

function FalseCardMachine:ctor()
	self.m_realCards = {}; 	  	 -- 牌数组
	self.m_handCards = {};	--存放所有传入的手牌
	self.m_realCardValue = nil;  -- 真牌值
	self.m_oneFalseCards = {};   -- 1张假牌数组
	self.m_twoFalseCards = {};   -- 2张假牌数组
	self.m_threeFalseCards = {}; -- 3张假牌数组
	self.m_fourFalseCards = {};  -- 4张假牌数组

	self.m_rand_oneFalseProp = 0.25; -- 随机1张假牌的概率
	self.m_rand_twoFalseProp = 0.25; -- 随机2张假牌的概率
	self.m_rand_threeFalseProp = 0.25; -- 随机3张假牌的概率
	self.m_rand_fourFalseProp = 0.25; -- 随机4张假牌的概率

	self.m_totalType = {
		{"A"},{"AB","AA"},{"ABC","AAB","AAA"},{"ABCD","AABC","AAAB","AAAA"}
					}; -- 所有类型的数组集合
	self.m_typeOneCardA = {}; -- 牌型为1的单张牌类型数组
	self.m_typeTwoCardAB = {}; -- 牌型为12的双牌类型数组
	self.m_typeTwoCardAA = {}; -- 牌型为11的双牌类型数组
	self.m_typeThrCardAAA = {}; -- 牌型为111的三牌类型数组
	self.m_typeThrCardABC = {}; -- 牌型为123的三牌类型数组
	self.m_typeThrCardAAB = {}; -- 牌型为122的三牌类型数组
	self.m_typeFouCardABCD = {}; -- 牌型为1234的四牌类型数组
	self.m_typeFouCardAABC = {}; -- 牌型为1123的四牌类型数组
	self.m_typeFouCardAAAB = {}; -- 牌型为1112的四牌类型数组
	self.m_typeFouCardAAAA = {}; -- 牌型为1111的四牌类型数组

	self.m_typeProperties = {
		{1.0}, -- 出现A类型的概率
		{0.5,0.5}, --出现AB类型、AA类型的概率
		{0.33,0.33,0.33},--出现ABC类型、AAB类型、AAA类型的概率
		{0.25,0.25,0.25,0.25},--出现ABCD类型、AABC类型、AAAB类型、AAAA类型的概率
	}
end

function FalseCardMachine.getInstance()
	if not FalseCardMachine.instance then 
		FalseCardMachine.instance = FalseCardMachine.new();
	end
	return FalseCardMachine.instance;
end

--设置牌数组
function FalseCardMachine:setRealCards(realcards)
	self.m_handCards = clone(realcards);
	if realcards then 
		for k,v in pairs(realcards) do
			for k2,v2 in pairs(v) do
				if k2 == "cardValue" then
					if v2 > 13 then
						v2 = v2 -13;
					end
					self.m_realCards[#self.m_realCards+1] = v2;
				end
			end
		end
		table.sort(self.m_realCards);
	end
end

--设置当前的真牌值
function FalseCardMachine:setRealCardsValue(cardValue)
	self.m_realCardValue = cardValue;
end

--设置生成1张、2张、3张、4张假牌的概率
function FalseCardMachine:setRandOneFalseProp(oneFalseProp,twoFalseProp,threeFalseProp,fourFalseProp)
	self.m_rand_oneFalseProp = oneFalseProp or 0.25;
	self.m_rand_twoFalseProp = twoFalseProp or 0.25;
	self.m_rand_threeFalseProp = threeFalseProp or 0.25;
	self.m_rand_fourFalseProp = fourFalseProp or 0.25;
end

-- 生成所有的1张、2张、3张、4张牌的数组组合
-- @param num -- 随机的是几张牌
function FalseCardMachine:step1FrEveryNumberCards(num)
	if not self.m_realCards or #self.m_realCards == 0 then 
		-- print("no realCards")
		return ;
	end
	local tempcoroutine = coroutine.create(function()
		local m_oneFalseCards = {};
		local m_twoFalseCards = {};
		local m_threeFalseCards = {};
		local m_fourFalseCards = {};
		if num == 1 then 
			m_oneFalseCards = ToolUtil.combination(self.m_realCards,1) or {};
		elseif num == 2 then 
			m_twoFalseCards = ToolUtil.combination(self.m_realCards,2) or {};
		elseif num == 3 then 
			m_threeFalseCards = ToolUtil.combination(self.m_realCards,3) or {};
		elseif num == 4 then 
			m_fourFalseCards = ToolUtil.combination(self.m_realCards,4) or {};
		end
		self.m_oneFalseCards = clone(removeRetable(m_oneFalseCards));
		self.m_twoFalseCards = clone(removeRetable(m_twoFalseCards));
		self.m_threeFalseCards = clone(removeRetable(m_threeFalseCards));
		self.m_fourFalseCards = clone(removeRetable(m_fourFalseCards));
	end);
	coroutine.resume(tempcoroutine);
end

-- --根据真牌，去除所有可能包含真牌的数组,生成符合条件的1张、2张、3张、4张假牌数组
function FalseCardMachine:step2RemoveRealCards()
	local function removePArray(a,b)
		local newArray = {};

		for i=1,#a do
			local flag = false;
			for j=1,#b do
				if a[i][j] == b[j] then
					flag = true;
				end
			end
			if not flag then
				newArray[#newArray+1] =a[i];
			end
		end
		return newArray;
	end
	if self.m_realCardValue then 
		local m_tempFirstRealCardValue =  {self.m_realCardValue};
		local m_tempSecondRealCardValue = {self.m_realCardValue,self.m_realCardValue};
		local m_tempThirdRealCardValue =  {self.m_realCardValue,self.m_realCardValue,self.m_realCardValue};
		local m_tempFourthRealCardValue = {self.m_realCardValue,self.m_realCardValue,self.m_realCardValue,self.m_realCardValue};
		
		--去除1张数组、2张数组、3张数组、4张数组的对应牌
		self.m_oneFalseCards = clone(removePArray(self.m_oneFalseCards,m_tempFirstRealCardValue));
		self.m_twoFalseCards = clone(removePArray(self.m_twoFalseCards,m_tempSecondRealCardValue));
		self.m_threeFalseCards = clone(removePArray(self.m_threeFalseCards,m_tempThirdRealCardValue));
		self.m_fourFalseCards = clone(removePArray(self.m_fourFalseCards,m_tempFourthRealCardValue));
	end
end

--为1张、2张、3张、4张假牌数组分别生成匹配类型数组(必须保证每项都是经过排序的)
function FalseCardMachine:step4GenerateSuitableArray(num)
	if num == 1 then  -- 随机生成的是1张牌数组
		self.m_typeOneCardA = clone(self.m_oneFalseCards);

	elseif num == 2 then 
		for i=1,#self.m_twoFalseCards do
			local iNum = 0;
			local lastValue;
			for j=1,#self.m_twoFalseCards[i] do 
				if self.m_twoFalseCards[i][j] == lastValue then 
					iNum = iNum + 1;
				else
					iNum = 1;
				end 
				lastValue = self.m_twoFalseCards[i][j];
			end
			if iNum == 1 then --表示AB类型
				self.m_typeTwoCardAB[#self.m_typeTwoCardAB+1] = self.m_twoFalseCards[i];
			elseif iNum == 2 then --表示AA类型
				self.m_typeTwoCardAA[#self.m_typeTwoCardAA+1] = self.m_twoFalseCards[i];
			end
		end
	elseif num == 3 then 
		for i=1,#self.m_threeFalseCards do
		 	local iNum = 0;
			local lastNum = 0;
	    		local lastValue;
	    		for j=1,#self.m_threeFalseCards[i] do
	     			if self.m_threeFalseCards[i][j] == lastValue then
	     				iNum = iNum + 1;
	      			else
	       				lastNum = iNum;
	    				iNum = 1;
	     			end
	      			lastValue = self.m_threeFalseCards[i][j];
	     		end
	     		if iNum == 1 and lastNum == 1 then --表示ABC类型
	     			self.m_typeThrCardABC[#self.m_typeThrCardABC+1] = self.m_threeFalseCards[i];
	   		elseif iNum == 3 and lastNum == 0 then --表示AAA类型
	      			self.m_typeThrCardAAA[#self.m_typeThrCardAAA+1] = self.m_threeFalseCards[i];
	   		elseif iNum == 2 and lastNum == 1 or iNum == 1 and lastNum == 2 then --表示ABB类型
	      			self.m_typeThrCardAAB[#self.m_typeThrCardAAB+1] = self.m_threeFalseCards[i];
	   		end
	   	end
	elseif num == 4 then 
		for i=1,#self.m_fourFalseCards do 
			local aNum = 0;
			local bNum = 0;
			local lastValue;
			for j=1,#self.m_fourFalseCards[i] do 
				if self.m_fourFalseCards[i][j] == lastValue then
					aNum = aNum + 1;
				else
					if aNum == 2 then
						bNum = 1;
					elseif aNum == 3 then
						bNum = 2;
					end
					aNum = 1;
				end
				lastValue = self.m_fourFalseCards[i][j];
			end

			if aNum == 1 and bNum == 0 then --表示是ABCD型
				self.m_typeFouCardABCD[#self.m_typeFouCardABCD+1] = self.m_fourFalseCards[i];
			elseif aNum == 1 and bNum == 1 then --表示的是AABC型
				self.m_typeFouCardAABC[#self.m_typeFouCardAABC+1] = self.m_fourFalseCards[i];
			elseif aNum == 1 and bNum == 2 then --表示的是AAAB型		
				self.m_typeFouCardAAAB[#self.m_typeFouCardAAAB+1] = self.m_fourFalseCards[i];
			elseif aNum == 4 and bNum == 0 then --表示的是AAAA型
				self.m_typeFouCardAAAA[#self.m_typeFouCardAAAA+1] = self.m_fourFalseCards[i];
			end
		end
	end
end

--向外层提供设置单张牌概率
--@param typeAProp 0.0-1.0 之间
function FalseCardMachine:setPropForTypeOneCard(typeAProp)
	if type(typeAProp) == "number" and tonumber(typeAProp) <=1.0 and tonumber(typeAProp) >= 0 then 
		self.m_typeProperties[1] = typeAProp;
	end
end

--向外层提供设置两张牌概率
--@param typeABProp 0.0-1.0 之间
--@param typeAAProp 0.0-1.0 之间
function FalseCardMachine:setPropForTypeTwoCard(typeABProp,typeAAProp)
	if type(typeABProp) == "number" and type(typeAAProp) == "number" and 
		tonumber(typeABProp) <=1.0 and tonumber(typeABProp) >= 0 and 
		tonumber(typeAAProp) <=1.0 and tonumber(typeAAProp) >= 0 then 
		self.m_typeProperties[2][1] = typeABProp;
		self.m_typeProperties[2][2] = typeAAProp;
	end
end

--向外层提供设置三张牌概率
--@param typeABCProp 0.0-1.0 之间
--@param typeAABProp 0.0-1.0 之间
--@param typeAAAProp 0.0-1.0 之间
function FalseCardMachine:setPropForTypeThreeCard(typeABCProp,typeAABProp,typeAAAProp)
	if type(typeABCProp) == "number" and type(typeAABProp) == "number" and type(typeAAAProp) == "number" 
		and tonumber(typeABCProp) <=1.0 and tonumber(typeABCProp) >= 0 and 
			tonumber(typeAABProp) <=1.0 and tonumber(typeAABProp) >= 0 and
			tonumber(typeAAAProp) <=1.0 and tonumber(typeAAAProp) >= 0 then 
		self.m_typeProperties[3][1] = typeABCProp;
		self.m_typeProperties[3][2] = typeAABProp;
		self.m_typeProperties[3][3] = typeAAAProp;
	end
end

--向外层提供设置四张牌概率
--@param typeABCDProp 0.0-1.0 之间
--@param typeAABCProp 0.0-1.0 之间
--@param typeAAABProp 0.0-1.0 之间
--@param typeAAAAProp 0.0-1.0 之间
function FalseCardMachine:setPropForTypeFourCard(typeABCDProp,typeAABCProp,typeAAABProp,typeAAAAProp)
	if type(typeABCDProp) == "number" and type(typeAABCProp) == "number"
		and type(typeAAABProp) == "number" and type(typeAAAAProp) == "number" and
			tonumber(typeABCDProp) <=1.0 and tonumber(typeAABCProp) >= 0 and 
			tonumber(typeAABCProp) <=1.0 and tonumber(typeAABCProp) >= 0 and
			tonumber(typeAAABProp) <=1.0 and tonumber(typeAAABProp) >= 0 and 
			tonumber(typeAAAAProp) <=1.0 and tonumber(typeAAAAProp) >= 0 then 
		self.m_typeProperties[4][1] = typeABCDProp;
		self.m_typeProperties[4][2] = typeAABCProp;
		self.m_typeProperties[4][3] = typeAAABProp;
		self.m_typeProperties[4][4] = typeAAAAProp;
	end
end

--清空所有的数组列表
function FalseCardMachine:clearAllData()
	self.m_realCards = {}; 	  	 -- 牌数组
	self.m_handCards = {}; --存如所有的手牌
	self.m_realCardValue = nil;  -- 真牌值
	self.m_oneFalseCards = {};   -- 1张假牌数组
	self.m_twoFalseCards = {};   -- 2张假牌数组
	self.m_threeFalseCards = {}; -- 3张假牌数组
	self.m_fourFalseCards = {};  -- 4张假牌数组

	self.m_totalType = {
		{"A"},{"AB","AA"},{"ABC","AAB","AAA"},{"ABCD","AABC","AAAB","AAAA"}
					}; -- 所有类型的数组集合
	self.m_typeOneCardA = {}; -- 牌型为1的单张牌类型数组
	self.m_typeTwoCardAB = {}; -- 牌型为12的双牌类型数组
	self.m_typeTwoCardAA = {}; -- 牌型为11的双牌类型数组
	self.m_typeThrCardAAA = {}; -- 牌型为111的三牌类型数组
	self.m_typeThrCardABC = {}; -- 牌型为123的三牌类型数组
	self.m_typeThrCardAAB = {}; -- 牌型为122的三牌类型数组
	self.m_typeFouCardABCD = {}; -- 牌型为1234的四牌类型数组
	self.m_typeFouCardAABC = {}; -- 牌型为1123的四牌类型数组
	self.m_typeFouCardAAAB = {}; -- 牌型为1112的四牌类型数组
	self.m_typeFouCardAAAA = {}; -- 牌型为1111的四牌类型数组
end

--得到假牌方法
--@param isJiao 是否是第一个出牌者
--@return Table 选的假牌数组
--@return Table 下叫的那张牌
function FalseCardMachine:getCardsForFalseCard(isJiao)
	--根据概率取到响应的值
	--@param props 		概率
	--@param propValues 几种概率值
	local function randomByProp(props,propValues)
		math.randomseed(tostring(os.time()):reverse():sub(1, 6));
		if type(props) ~= "table" or type(propValues) ~= "table" or #props ~= #propValues then
			return;
		end
		if #props == 1 then
			return propValues[1];
		elseif #props >= 2 then
			local randomProp = math.random();
			local param = 0;
			local index = 1;
			for i=1,#props do
				param = param + props[i];
				if param > randomProp then
					index = i;
					break;
				end
			end
			return propValues[index];
		end
	end

	--这个一般A都是1-13
	local function removePArray(a,b)
		local newArray = {};

		for i=1,#a do
			local flag = false;
			for j=1,#b do
				if a[i] == b[j] then
					flag = true;
				end
			end
			if not flag then
				newArray[#newArray+1] =a[i];
			end
		end
		return newArray;
	end

	local randomProps = {self.m_rand_oneFalseProp,self.m_rand_twoFalseProp,self.m_rand_threeFalseProp,
						self.m_rand_fourFalseProp};
	local randomNums = {1,2,3,4};
	local randomNumCount = randomByProp(randomProps,randomNums);

	-- print("随机数字:" .. randomNumCount);
	self:step1FrEveryNumberCards(randomNumCount);
	self:step2RemoveRealCards();

	self:step4GenerateSuitableArray(randomNumCount);

	-- print("AA:" .. #self.m_typeTwoCardAA);
	for i=1,#self.m_typeTwoCardAA do 
		-- print(unpack(self.m_typeTwoCardAA[i]));
	end
	-- print("AB:" .. #self.m_typeTwoCardAB);
	for i=1,#self.m_typeTwoCardAB do 
		-- print(unpack(self.m_typeTwoCardAB[i]));
	end
	-- print("ABC" .. #self.m_typeThrCardABC);
	for i=1,#self.m_typeThrCardABC do 
		-- print(unpack(self.m_typeThrCardABC[i]));
	end
	-- print("AAB" .. #self.m_typeThrCardAAB);
	for i=1,#self.m_typeThrCardAAB do 
		-- print(unpack(self.m_typeThrCardAAB[i]));
	end
	-- print("AAA" .. #self.m_typeThrCardAAA);
	for i=1,#self.m_typeThrCardAAA do 
		-- print(unpack(self.m_typeThrCardAAA[i]));
	end
	-- print("ABCD" .. #self.m_typeFouCardABCD);
	for i=1,#self.m_typeFouCardABCD do 
		-- print(unpack(self.m_typeFouCardABCD[i]));
	end
	-- print("AABC" .. #self.m_typeFouCardAABC);
	for i=1,#self.m_typeFouCardAABC do 
		-- print(unpack(self.m_typeFouCardAABC[i]));
	end
	-- print("AAAB" .. #self.m_typeFouCardAAAB);
	for i=1,#self.m_typeFouCardAAAB do 
		-- print(unpack(self.m_typeFouCardAAAB[i]));
	end
	-- print("AAAA" .. #self.m_typeFouCardAAAA);
	for i=1,#self.m_typeFouCardAAAA do 
		-- print(unpack(self.m_typeFouCardAAAA[i]));
	end

	if randomNumCount == 1 then 
		local typeRandomProps = {self.m_typeProperties[1]};
		local typeRandomValues = {"A"};
		local typeCard = randomByProp(typeRandomProps,typeRandomValues);
		if typeCard == "A" then 
			local randomParam = {};
			local randomParamValue = {};
			for i=1,#self.m_typeOneCardA do 
				randomParam[#randomParam+1] = 1/#self.m_typeOneCardA;
				randomParamValue[#randomParamValue+1] = i;
			end
			local randomValue = randomByProp(randomParam,randomParamValue);
			local paramCard = self.m_typeOneCardA[randomValue];
			if isJiao then 
				--这边叫牌是从A-K随机概率的(单张牌去除一张概率)
				local param = {0.08,0.08,0.08,0.08,0.08, 0.08,0.08,0.08,0.08,0.08, 0.08,0.08};
				local paramValueAll = {1,2,3,4,5,6,7,8,9,10,11,12,13};
				local paramValue = removePArray(paramValueAll,paramCard);
				local xiaojiaoCard = randomByProp(param,paramValue);
				return self:returnRealCardsForType(paramCard),xiaojiaoCard;
			end
			return self:returnRealCardsForType(paramCard);
		end
	elseif randomNumCount == 2 then 
		local typeRandomProps = self.m_typeProperties[2];
		local typeRandomValues = {"AB","AA"};
		local typeCard = randomByProp(typeRandomProps,typeRandomValues);
		-- print("随机类型:" .. typeCard);
		if typeCard == "AB" then 
			if #self.m_typeTwoCardAB == 0 then 
				return self:getCardsForFalseCard(isJiao);
			end
			local randomParam = {};
			local randomParamValue = {};
			for i=1,#self.m_typeTwoCardAB do 
				randomParam[#randomParam+1] = 1/#self.m_typeTwoCardAB;
				randomParamValue[#randomParamValue+1] = i;
			end
			local randomValue = randomByProp(randomParam,randomParamValue);
			local paramCards = self.m_typeTwoCardAB[randomValue];
			if isJiao then 
				--这边叫牌是从A-K随机概率的(单张牌去除一张概率)
				local param = {0.07,0.07,0.07,0.07,0.07, 0.07,0.07,0.07,0.07,0.07, 0.07,0.07,0.07};
				local paramValueAll = {1,2,3,4,5,6,7,8,9,10,11,12,13};
				local xiaojiaoCard = randomByProp(param,paramValueAll);
				return self:returnRealCardsForType(paramCards),xiaojiaoCard;
			end
			return self:returnRealCardsForType(paramCards);
		elseif typeCard == "AA" then 
			if #self.m_typeTwoCardAA == 0 then 
				return self:getCardsForFalseCard(isJiao);
			end
			local randomParam = {};
			local randomParamValue = {};
			for i=1,#self.m_typeTwoCardAA do 
				randomParam[#randomParam+1] = 1/#self.m_typeTwoCardAA;
				randomParamValue[#randomParamValue+1] = i;
			end
			local randomValue = randomByProp(randomParam,randomParamValue);
			local paramCards = self.m_typeTwoCardAA[randomValue];
			if isJiao then 
				--这边叫牌是从A-K随机概率的(单张牌去除一张概率)
				local param = {0.08,0.08,0.08,0.08,0.08, 0.08,0.08,0.08,0.08,0.08, 0.08,0.08};
				local paramValueAll = {1,2,3,4,5,6,7,8,9,10,11,12,13};
				local paramValue = removePArray(paramValueAll,{paramCards[1]});
				local xiaojiaoCard = randomByProp(param,paramValue);
				return self:returnRealCardsForType(paramCards),xiaojiaoCard;
			end
			return self:returnRealCardsForType(paramCards);
		end
	elseif randomNumCount == 3 then 
		local typeRandomProps = self.m_typeProperties[3];
		local typeRandomValues = {"ABC","AAB","AAA"};
		local typeCard = randomByProp(typeRandomProps,typeRandomValues);
		-- print("随机类型:" .. typeCard);
		if typeCard == "ABC" then 
			if #self.m_typeThrCardABC == 0 then 
				return self:getCardsForFalseCard(isJiao);
			end
			local randomParam = {};
			local randomParamValue = {};
			for i=1,#self.m_typeThrCardABC do 
				randomParam[#randomParam+1] = 1/#self.m_typeThrCardABC;
				randomParamValue[#randomParamValue+1] = i;
			end
			local randomValue = randomByProp(randomParam,randomParamValue);
			local paramCards = self.m_typeThrCardABC[randomValue];
			if isJiao then 
				--这边叫牌是从A-K随机概率的
				local param = {0.07,0.07,0.07,0.07,0.07, 0.07,0.07,0.07,0.07,0.07, 0.07,0.07,0.07};
				local paramValueAll = {1,2,3,4,5,6,7,8,9,10,11,12,13};
				local xiaojiaoCard = randomByProp(param,paramValueAll);
				return self:returnRealCardsForType(paramCards),xiaojiaoCard;
			end
			return self:returnRealCardsForType(paramCards);
		elseif typeCard == "AAB" then 
			if #self.m_typeThrCardAAB == 0 then 
				return self:getCardsForFalseCard(isJiao);
			end 
			local randomParam = {};
			local randomParamValue = {};
			for i=1,#self.m_typeThrCardAAB do 
				randomParam[#randomParam+1] = 1/#self.m_typeThrCardAAB;
				randomParamValue[#randomParamValue+1] = i;
			end
			local randomValue = randomByProp(randomParam,randomParamValue);
			local paramCards = self.m_typeThrCardAAB[randomValue];
			if isJiao then 
				--这边叫牌是从A-K随机概率的
				local param = {0.07,0.07,0.07,0.07,0.07, 0.07,0.07,0.07,0.07,0.07, 0.07,0.07,0.07};
				local paramValueAll = {1,2,3,4,5,6,7,8,9,10,11,12,13};
				local xiaojiaoCard = randomByProp(param,paramValueAll);
				return self:returnRealCardsForType(paramCards),xiaojiaoCard;
			end
			return self:returnRealCardsForType(paramCards);
		elseif typeCard == "AAA" then 
			if #self.m_typeThrCardAAA == 0 then 
				return self:getCardsForFalseCard(isJiao);
			end 
			local randomParam = {};
			local randomParamValue = {};
			for i=1,#self.m_typeThrCardAAA do 
				randomParam[#randomParam+1] = 1/#self.m_typeThrCardAAA;
				randomParamValue[#randomParamValue+1] = i;
			end
			local randomValue = randomByProp(randomParam,randomParamValue);
			local paramCards = self.m_typeThrCardAAA[randomValue];
			-- print(paramCards);
			if isJiao then 
				--这边叫牌是从A-K随机概率的
				local param = {0.08,0.08,0.08,0.08,0.08, 0.08,0.08,0.08,0.08,0.08, 0.08,0.08};
				local paramValueAll = {1,2,3,4,5,6,7,8,9,10,11,12,13};
				local paramValue = removePArray(paramValueAll,{paramCards[1]});
				local xiaojiaoCard = randomByProp(param,paramValue);
				return self:returnRealCardsForType(paramCards),xiaojiaoCard;
			end
			return self:returnRealCardsForType(paramCards);
		end
	elseif randomNumCount == 4 then 
		local typeRandomProps = self.m_typeProperties[4];
		local typeRandomValues = {"ABCD","AABC","AAAB","AAAA"};
		local typeCard = randomByProp(typeRandomProps,typeRandomValues);
		-- print("随机类型:" .. typeCard);
		if typeCard == "ABCD" then
			if #self.m_typeFouCardABCD == 0 then 
				return self:getCardsForFalseCard(isJiao);
			end 
			local randomParam = {};
			local randomParamValue = {};
			for i=1,#self.m_typeFouCardABCD do 
				randomParam[#randomParam+1] = 1/#self.m_typeFouCardABCD;
				randomParamValue[#randomParamValue+1] = i;
			end
			local randomValue = randomByProp(randomParam,randomParamValue);
			local paramCards = self.m_typeFouCardABCD[randomValue];
			if isJiao then 
				--这边叫牌是从A-K随机概率的
				local param = {0.07,0.07,0.07,0.07,0.07, 0.07,0.07,0.07,0.07,0.07, 0.07,0.07,0.07};
				local paramValueAll = {1,2,3,4,5,6,7,8,9,10,11,12,13};
				local xiaojiaoCard = randomByProp(param,paramValueAll);
				return self:returnRealCardsForType(paramCards),xiaojiaoCard;
			end
			return self:returnRealCardsForType(paramCards);
		elseif typeCard == "AABC" then 
			if #self.m_typeFouCardAABC == 0 then 
				return self:getCardsForFalseCard(isJiao);
			end
			local randomParam = {};
			local randomParamValue = {};
			for i=1,#self.m_typeFouCardAABC do 
				randomParam[#randomParam+1] = 1/#self.m_typeFouCardAABC;
				randomParamValue[#randomParamValue+1] = i;
			end
			local randomValue = randomByProp(randomParam,randomParamValue);
			local paramCards = self.m_typeFouCardAABC[randomValue];
			if isJiao then 
				--这边叫牌是从A-K随机概率的
				local param = {0.07,0.07,0.07,0.07,0.07, 0.07,0.07,0.07,0.07,0.07, 0.07,0.07,0.07};
				local paramValueAll = {1,2,3,4,5,6,7,8,9,10,11,12,13};
				local xiaojiaoCard = randomByProp(param,paramValueAll);
				return self:returnRealCardsForType(paramCards),xiaojiaoCard;
			end
			return self:returnRealCardsForType(paramCards);
		elseif typeCard == "AAAB" then 
			if #self.m_typeFouCardAAAB == 0 then 
				return self:getCardsForFalseCard(isJiao);
			end
			local randomParam = {};
			local randomParamValue = {};
			for i=1,#self.m_typeFouCardAAAB do 
				randomParam[#randomParam+1] = 1/#self.m_typeFouCardAAAB;
				randomParamValue[#randomParamValue+1] = i;
			end
			local randomValue = randomByProp(randomParam,randomParamValue);
			local paramCards = self.m_typeFouCardAAAB[randomValue];
			if isJiao then 
				--这边叫牌是从A-K随机概率的
				local param = {0.07,0.07,0.07,0.07,0.07, 0.07,0.07,0.07,0.07,0.07, 0.07,0.07,0.07};
				local paramValueAll = {1,2,3,4,5,6,7,8,9,10,11,12,13};
				local xiaojiaoCard = randomByProp(param,paramValueAll);
				return self:returnRealCardsForType(paramCards),xiaojiaoCard;
			end
			return self:returnRealCardsForType(paramCards);
		elseif typeCard == "AAAA" then 
			if #self.m_typeFouCardAAAA == 0 then 
				return self:getCardsForFalseCard(isJiao);
			end
			local randomParam = {};
			local randomParamValue = {};
			for i=1,#self.m_typeFouCardAAAA do 
				randomParam[#randomParam+1] = 1/#self.m_typeFouCardAAAA;
				randomParamValue[#randomParamValue+1] = i;
			end
			local randomValue = randomByProp(randomParam,randomParamValue);
			local paramCards = self.m_typeFouCardAAAA[randomValue];
			if isJiao then 
				--这边叫牌是从A-K随机概率的
				local param = {0.08,0.08,0.08,0.08,0.08, 0.08,0.08,0.08,0.08,0.08, 0.08,0.08};
				local paramValueAll = {1,2,3,4,5,6,7,8,9,10,11,12,13};
				local paramValue = removePArray(paramValueAll,{paramCards[1]});
				local xiaojiaoCard = randomByProp(param,paramValue);
				return self:returnRealCardsForType(paramCards),xiaojiaoCard;
			end
			return self:returnRealCardsForType(paramCards);
		end
	end

	self:clearAllData();
end

s

return FalseCardMachine;