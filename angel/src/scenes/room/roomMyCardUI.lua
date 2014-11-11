--[[local roomMyCardUI = require(GameRoomPath .. "roomMyCardUI"):createCards(5, {{cardValue=1, cardType=2}})]]

local RoomMyCardUI = class("RoomMyCardUI",  function()
	return display.newNode()
end)

local RoomMyCardUIParams = 
{
	Gap = 30,                 --间距
	Width = 50,              --牌宽
	Height = 100,            --牌高
}

function RoomMyCardUI:ctor()	
	self.m_cards = {}
	self.m_numCards = 0
end

function RoomMyCardUI:createCards(numCard, tCards)
	if numCard >= 0 and numCard <= 25 then
		for k, v in ipairs(tCards) do
			local card = require(GameRoomPath .. "card").new(v.cardValue, v.cardType):createCard()
			self.m_cards[#self.m_cards + 1] = card
		end
	end
end

--开始编写排列 25 张下层牌
function RoomMyCardUI:placeCard()
	local centerPointX = display.cx / 2
	local centerPointY = 400
	local cardLength = self.m_numCards * RoomMyCardUIParams.Gap + (RoomMyCardUIParams.Width - RoomMyCardUIParams.Gap)
	local startPointX = centerPointX - cardLength

	for k,v in ipairs(self.m_cards) do
		-- v:setPosition(startPointX + (k - 1) * RoomMyCardUIParams.Gap, centerPointY)
		-- v:setContentSize(1, 1)
		self:addChild(v)
	end
end


return RoomMyCardUI