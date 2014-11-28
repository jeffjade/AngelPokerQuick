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

function RoomMyCardUI:ctor(scene)	
	self.m_scene = scene
	self.m_cards = {}
	self.m_cardsOtherPlayer = {}
	self.m_statusCards = {}
	self.m_numCards = 0
	self.m_numUpperCards = 0
	self.m_numLowerCards = 0

	self:registerRoomMyCardUIEvents()
end

function RoomMyCardUI:registerRoomMyCardUIEvents()
    EventDispatchController:addEventListener( "kPlayerSelectCardEv" ,  handler(self, self.onPlayerSelectCardEvent))
end

function RoomMyCardUI:onPlayerSelectCardEvent(event)
	local player = self.m_scene:getPlayerByMid(PhpInfo:getMid())
	local cards = {}

	for k, v in pairs(self.m_statusCards) do
		local card = {}
		card.cardValue = v.m_cardValue
		card.cardType = v.m_cardType
		card.cardByte = CardUtil.getCardByteByValueType(card.cardValue , card.cardType)
		cards[#cards + 1] = card
	end
	player:setOutCards(#cards, {num = #cards, cardValue = event.cardValue}, cards)

	-- print_lua_table( cards )
	player:removeCard(#cards , cards)

	EventDispatchController:dispatchEvent( {name = "SINGLE_SERVER_OUT_CARDS", mid = PhpInfo:getMid() } )
	EventDispatchController:dispatchEvent({name = "kServerPlayerOutCardsEv" , mid = PhpInfo:getMid() ,outCards = cards})
end

function RoomMyCardUI:updateStatus()
	local statusCards = {}
	for k, v in pairs(self.m_statusCards) do
		statusCards[#statusCards + 1] = v
	end

	self.m_statusCards = statusCards

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

--0、1、2、3 号位出牌飞出
function RoomMyCardUI:flyOutPlayerCards(seatSequence, tCards)
	for k, v in ipairs(tCards) do
		local card = require(GameRoomPath .. "card").new(v.cardValue, v.cardType, self)
		self.m_cardsOtherPlayer[#self.m_cardsOtherPlayer + 1] = card
		if seatSequence and 3 == seatSequence then
			card:setPosition(100, 300)
		elseif seatSequence and 2 == seatSequence then
			card:setPosition(400, 600)
		elseif seatSequence and 1 == seatSequence then
			card:setPosition(800, 600)
		end

		card:setScale(0.2)
		card:setAnchorPoint(0, 0)
		card:getCard():setButtonEnabled(false)
		transition.moveTo(card, {x = display.cx +  k * 30, y = display.cy-50, time = 1})

		self:addChild(card)
	end
end

--0、1、2、3 号剩余数量牌展示
function RoomMyCardUI:showCardsAmountBySeat(seat, num)
	if 0 == seat then
		if not self.m_labelCardsMe then
			self.m_labelCardsMe = cc.ui.UILabel.new({UILabelType=1, text="0",font="boundsTestFont.fnt"})
			self.m_labelCardsMe:setPosition(1185, 20)
			self:addChild(self.m_labelCardsMe)
		end
		self.m_labelCardsMe:setString(num)
	elseif 1 == seat then
		if not self.m_labelCardsSeatOne then
			self.m_labelCardsSeatOne = cc.ui.UILabel.new({UILabelType=1, text="0",font="boundsTestFont.fnt"})
			self.m_labelCardsSeatOne:setPosition(820, 510)
			self:addChild(self.m_labelCardsSeatOne)
		end
		self.m_labelCardsSeatOne:setString(num)
	elseif 2 == seat then
		if not self.m_labelCardsSeatTwo then
			self.m_labelCardsSeatTwo = cc.ui.UILabel.new({UILabelType=1, text="0",font="boundsTestFont.fnt"})
			self.m_labelCardsSeatTwo:setPosition(370, 510)
			self:addChild(self.m_labelCardsSeatTwo)
		end
		self.m_labelCardsSeatTwo:setString(num)
	elseif 3 == seat then
		if not self.m_labelCardsSeatThree then
			self.m_labelCardsSeatThree = cc.ui.UILabel.new({UILabelType=1, text="0",font="boundsTestFont.fnt"})
			self.m_labelCardsSeatThree:setPosition(50, 270)
			self:addChild(self.m_labelCardsSeatThree)
		end
		self.m_labelCardsSeatThree:setString(num)
	end
end

return RoomMyCardUI