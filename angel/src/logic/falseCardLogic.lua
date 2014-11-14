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
	if realcards and type(realcards) == "table" then 
		self.m_realCards = clone(realcards);
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
function FalseCardMachine:stepo1FrEveryNumberCards(num)
	if not self.m_realCards or #self.m_realCards ~= 0 then 
		return ;
	end
	local coroutine = coroutine.create(function()
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
	end)

	coroutine.resume(coroutine)
end

--根据真牌，去除所有可能包含真牌的数组,生成符合条件的1张、2张、3张、4张假牌数组
function FalseCardMachine:step2RemoveRealCards()
	if self.m_realCardValue then 
		local m_tempFirstRealCardValue =  {self.m_realCardValue};
		local m_tempSecondRealCardValue = {self.m_realCardValue,self.m_realCardValue};
		local m_tempThirdRealCardValue =  {self.m_realCardValue,self.m_realCardValue,self.m_realCardValue};
		local m_tempFourthRealCardValue = {self.m_realCardValue,self.m_realCardValue,self.m_realCardValue,self.m_realCardValue};
		
		--去除1张数组、2张数组、3张数组、4张数组的对应牌
		self.m_oneFalseCards = clone(removePArray(self.m_oneFalseCards,m_tempFirstRealCardValue);
		self.m_twoFalseCards = clone(removePArray(self.m_twoFalseCards,m_tempSecondRealCardValue);
		self.m_threeFalseCards = clone(removePArray(self.m_threeFalseCards,m_tempThirdRealCardValue);
		self.m_fourFalseCards = clone(removePArray(self.m_fourFalseCards,m_tempFourthRealCardValue);

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
			for j=1,#self.m_twoFalseCards[i] then 
				if self.m_twoFalseCards[i] == lastValue then 
					iNum = iNum + 1;
				else
					iNum = 1;
				end 
				lastValue = self.m_twoFalseCards[i];
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
	    	for j=1,#self.m_threeFalseCards[i] then
	     		if self.m_threeFalseCards[j] == lastValue then
	     			iNum = iNum + 1;
	      		else
	       			lastNum = iNum;
	    			iNum = 1;
	     		end
	      		lastValue = self.m_threeFalseCards[j];
	     	end
	     	if iNum == 1 and lastNum == 1 then --表示ABC类型
	     		self.m_typeThrCardABC[#self.m_typeThrCardABC+1] = self.m_threeFalseCards[i];
	   		elseif iNum == 3 and lastNum == 0 then --表示AAA类型
	      		self.m_typeThrCardABC[#self.m_typeThrCardABC+1] = self.m_threeFalseCards[i];
	   		elseif iNum == 2 and lastNum == 1 or iNum == 1 and lastNum == 2 then --表示ABB类型
	      		self.m_typeThrCardABC[#self.m_typeThrCardABC+1] = self.m_threeFalseCards[i];
	   		end
	    end
	elseif num == 4 then 
		for i=1,#self.m_fourFalseCards do 
			local aNum = 0;
			local bNum = 0;
			local lastValue;
			for j=1,#self.m_fourFalseCards[i] do 
				if self.m_fourFalseCards[j] == lastValue then
					aNum = aNum + 1;
				else
					if aNum == 2 then
						bNum = 1;
					if aNum == 3 then
						bNum = 2;
					end
					aNum = 1;
				end
				lastValue = self.m_fourFalseCards[j];
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

function FalseCardMachine:getCardsForFalseCard()
	
end

return FalseCardMachine;