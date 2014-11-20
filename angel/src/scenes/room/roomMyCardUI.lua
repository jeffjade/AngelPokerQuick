--[[local roomMyCardUI = require(GameRoomPath .. "roomMyCardUI"):createCards(5, {{cardValue=1, cardType=2}})]]

local RoomMyCardUI = class("RoomMyCardUI",  function()
	return display.newNode()
end)

local g_cardWidth = 100

local RoomMyCardUIParams = 
{
	Gap = 43,                  		--间距
	Width = g_cardWidth,            --牌宽
	Height = g_cardWidth/0.693 ,    --牌高
	ScaleFactor = 0.25,             --缩放因子
}

function RoomMyCardUI:ctor()	
	self.m_cards = {}
	self.m_statusCards = {}
	self.m_numCards = 0
	self.m_numUpperCards = 0
	self.m_numLowerCards = 0
end

function RoomMyCardUI:updateStatus()
	table.sort(self.m_statusCards, function(a, b)
			return b.m_cardValue > a.m_cardValue
		end)

	for k,v in pairs(self.m_statusCards) do
		transition.moveTo(v, {x = display.cx + (k - 1) * 30, y = display.cy-50, time = 0.5})
		transition.scaleTo(v, {scaleX = 0.2, scaleY = 0.2, time = 0.2})
	end

	for k, v in pairs(self.m_statusCards) do
		for t, q in pairs(self.m_cards) do
			if q == v then
				self.m_cards[t] = nil
			end
		end
	end

	local cards = {}
	for k, v in pairs(self.m_cards) do
		cards[#cards + 1] = v
		print("*************** " .. v.m_cardType .. " " .. v.m_cardValue)
	end

	self.m_cards = cards

	self:replaceCards()
end

function RoomMyCardUI:replaceCards()
	self.m_numCards = #self.m_cards
	self:calUpperAndLowerCardsNum()

	--upper cards
	local centerPointx = (1280 - 110) / 2
	local cardLength = self.m_numUpperCards * RoomMyCardUIParams.Gap + (RoomMyCardUIParams.Width - RoomMyCardUIParams.Gap)
	local startPointX = centerPointx - cardLength/2

	for k = 1, self.m_numUpperCards do
		local v = self.m_cards[k]
		v:setPosition(startPointX + (k - 1) * RoomMyCardUIParams.Gap, 90)
		v:setScale(RoomMyCardUIParams.ScaleFactor)
		v:setAnchorPoint(0, 0)
	end

	--lower cards
	local centerPointx = (1280 - 110) / 2
	local cardLength = self.m_numLowerCards * RoomMyCardUIParams.Gap + (RoomMyCardUIParams.Width - RoomMyCardUIParams.Gap)
	local startPointX = centerPointx - cardLength/2

	local start = 1
	if 0 ~= self.m_numUpperCards then
		start = self.m_numUpperCards + 1
	end

	for k = start, self.m_numCards do
		local v = self.m_cards[k]
		v:setPosition(startPointX + (k - 1 - self.m_numUpperCards) 
				* RoomMyCardUIParams.Gap, 15)
		v:setScale(RoomMyCardUIParams.ScaleFactor)
		v:setAnchorPoint(0, 0)
	end
end

function RoomMyCardUI:calUpperAndLowerCardsNum()
	if self.m_numCards > 25 then
		self.m_numUpperCards = self.m_numCards - 25
		self.m_numLowerCards = 25
	else
		self.m_numLowerCards = self.m_numCards
	end
end

function RoomMyCardUI:createCards(tCards)
	for k, v in ipairs(tCards) do
		local card = require(GameRoomPath .. "card").new(v.cardValue, v.cardType, self)
		self.m_cards[#self.m_cards + 1] = card
		self.m_numCards = k
	end
	self:calUpperAndLowerCardsNum()
end

--排列上层
function RoomMyCardUI:placeUpperLevel()
	local centerPointx = (1280 - 110) / 2
	local cardLength = self.m_numUpperCards * RoomMyCardUIParams.Gap + (RoomMyCardUIParams.Width - RoomMyCardUIParams.Gap)
	local startPointX = centerPointx - cardLength/2

	for k = 1, self.m_numUpperCards do
		local v = self.m_cards[k]
		v:setPosition(startPointX + (k - 1) * RoomMyCardUIParams.Gap, 90)
		v:setScale(RoomMyCardUIParams.ScaleFactor)
		v:setAnchorPoint(0, 0)
		self:addChild(v)
	end
end

--排列下层
function RoomMyCardUI:placeLowerLevel()
	local centerPointx = (1280 - 110) / 2
	local cardLength = self.m_numLowerCards * RoomMyCardUIParams.Gap + (RoomMyCardUIParams.Width - RoomMyCardUIParams.Gap)
	local startPointX = centerPointx - cardLength/2

	local start = 1
	if 0 ~= self.m_numUpperCards then
		start = self.m_numUpperCards + 1
	end

	for k = start, self.m_numCards do
		local v = self.m_cards[k]
		v:setPosition(startPointX + (k - 1 - self.m_numUpperCards) 
				* RoomMyCardUIParams.Gap, 15)
		v:setScale(RoomMyCardUIParams.ScaleFactor)
		v:setAnchorPoint(0, 0)
		self:addChild(v)
	end
end

--开始编写排列 25 张下层牌
function RoomMyCardUI:placeCard()
	self:placeUpperLevel()
	self:placeLowerLevel()
end


return RoomMyCardUI