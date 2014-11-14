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
	ScaleFactor = 0.25,
}

function RoomMyCardUI:ctor()	
	self.m_cards = {}
	self.m_numCards = 0
	self.m_numUpperCards = 0
	self.m_numLowerCards = 0
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
print("********************************************************" .. v.cardValue)
		local card = require(GameRoomPath .. "card").new(v.cardValue, v.cardType):createCard()
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