--[[local roomMyCardUI = require(GameRoomPath .. "roomMyCardUI"):createCards(5, {{cardValue=1, cardType=2}})]]

local RoomMyCardUI = class("RoomMyCardUI",  function()
	return display.newNode()
end)

local g_cardWidth = 20

local RoomMyCardUIParams = 
{
	Gap = 43,                  		
	Width = 100,            
	Height = 100/0.693 ,    
	ScaleFactor = 0.25,             
	TimeFlyOut = 1,
}

CardPatternParam = 
{
	Width = 50,
	Height = 75,
	Gap = 30,
	EndX = display.cx,
	EndY = display.cy,
	MinimumX = 300,
	MaxX = 1280 - 300,
}

CardFlipParam =
{
	Width = 100,
	Height = 100/0.693,
	Gap = 50,
	startY = display.cy,
	Time = 1,
}

function RoomMyCardUI:ctor(scene)	
	self.m_ZOrder = 1000
	self.m_scene = scene
	self.m_lastCards = {}
	self.m_lastCircleCards = {}
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
	self.m_statusCards = {}
	player:setOutCards(#cards, {num = #cards, cardValue = event.cardValue}, cards)
	player:removeCard(#cards , cards)
	-- print_lua_table( cards )
	EventDispatchController:dispatchEvent({name = "SINGLE_SERVER_OUT_CARDS", mid = PhpInfo:getMid()})
	EventDispatchController:dispatchEvent({name = "kServerPlayerOutCardsEv" , mid = PhpInfo:getMid() ,outCards = cards})
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
		v:setLayoutSize(RoomMyCardUIParams.Width, RoomMyCardUIParams.Height)
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
		v:setLayoutSize(RoomMyCardUIParams.Width, RoomMyCardUIParams.Height)
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

function RoomMyCardUI:placeUpperLevel()
	local centerPointx = (1280 - 110) / 2
	local cardLength = self.m_numUpperCards * RoomMyCardUIParams.Gap + (RoomMyCardUIParams.Width - RoomMyCardUIParams.Gap)
	local startPointX = centerPointx - cardLength/2

	for k = 1, self.m_numUpperCards do
		local v = self.m_cards[k]
		v:setPosition(startPointX + (k - 1) * RoomMyCardUIParams.Gap, 90)
		v:setLayoutSize(RoomMyCardUIParams.Width, RoomMyCardUIParams.Height)
		v:setAnchorPoint(0, 0)
		self:addChild(v)
	end
end


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
		v:setLayoutSize(RoomMyCardUIParams.Width, RoomMyCardUIParams.Height)
		v:setAnchorPoint(0, 0)
		self:addChild(v)
	end
end

function RoomMyCardUI:placeCard()
	self:placeUpperLevel()
	self:placeLowerLevel()
end

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

function RoomMyCardUI:updateStatus()
	self.m_lastCards = {}
	local statusCards = {}
	for k, v in pairs(self.m_statusCards) do
		statusCards[#statusCards + 1] = v
	end

	self.m_statusCards = statusCards

	table.sort(self.m_statusCards, function(a, b)
			return b.m_cardValue > a.m_cardValue
		end)

	for k, v in pairs(self.m_statusCards) do
		local card = cc.ui.UIImage.new("cardPattern.png")
		self.m_lastCircleCards[#self.m_lastCircleCards + 1] = card
		self.m_lastCards[#self.m_lastCards + 1] = card
		card:setLayoutSize(RoomMyCardUIParams.Width, RoomMyCardUIParams.Height)
		card:setAnchorPoint(0, 0)
		card:setLocalZOrder(self:newZOrder())

		local boundingSize = card:getBoundingBox()
        local sx = CardPatternParam.Width / (boundingSize.width / card:getScaleX()) 
        local sy = CardPatternParam.Height / (boundingSize.height / card:getScaleY())

		transition.scaleTo(card, {
			scaleX = sx, 
			scaleY = sy,
			time = 1})
		transition.fadeIn(card, {time = 1})
		card:setOpacity(0)
		transition.fadeTo(card, {opacity = 255, time = 1.5})

		boundingSize = v:getBoundingBox()
        sx = CardPatternParam.Width / (boundingSize.width / v:getScaleX()) 
        sy = CardPatternParam.Height / (boundingSize.height / v:getScaleY())

		transition.scaleTo(v, {
			scaleX = sx, 
			scaleY = sy,
			time = 1})
		transition.fadeOut(v, {time = 0.1})

		card:setPosition(v:getPosition())
		card.innerCard = v
		self:addChild(card)
	end

	self:placePattern(self:calculateGap())

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

function RoomMyCardUI:newZOrder()
	self.m_ZOrder = self.m_ZOrder + 1
 	return self.m_ZOrder
end

function RoomMyCardUI:flyOutPlayerCards(seat, tCards)
	local srcPosition = {}
	self.m_lastCards = {}

	if seat and 3 == seat then
		srcPosition.x = 100
		srcPosition.y = 300
	elseif seat and 2 == seat then
		srcPosition.x = 400
		srcPosition.y = 600
	elseif seat and 1 == seat then
		srcPosition.x = 800
		srcPosition.y = 600
	end

	for k, v in ipairs(tCards) do
		local card = cc.ui.UIImage.new("cardPattern.png")
		self.m_lastCircleCards[#self.m_lastCircleCards + 1] = card
		self.m_lastCards[#self.m_lastCards + 1] = card
		card:setLayoutSize(CardPatternParam.Width, CardPatternParam.Height)
		card:setPosition(srcPosition.x, srcPosition.y)
		card:setAnchorPoint(0, 0)
		card:setLocalZOrder(self:newZOrder())
		self:addChild(card)
	end

	self:placePattern(self:calculateGap())
end

function RoomMyCardUI:calculateGap()
	local gap = CardPatternParam.Gap
	local length = #self.m_lastCircleCards * CardPatternParam.Gap 
				+ (CardPatternParam.Width - CardPatternParam.Gap)
	local startX = (display.cx - length/2)
	if startX < CardPatternParam.MinimumX and #self.m_lastCircleCards > 1 then
		gap = (CardPatternParam.MaxX - CardPatternParam.MinimumX - CardPatternParam.Width)
			/ (#self.m_lastCircleCards - 1)
	end
	return gap
end

function RoomMyCardUI:placePattern(gap)
	local length = #self.m_lastCircleCards * gap 
				+ (CardPatternParam.Width - gap)
	local startX = (display.cx - length/2)
	local startY = CardPatternParam.EndY - CardPatternParam.Height

	for k, v in ipairs(self.m_lastCircleCards) do
		transition.moveTo(v, {x = startX + (k - 1) * gap, y = startY, time = 1})
		if v.innerCard then
			transition.moveTo(v.innerCard, {x = startX + (k - 1) * gap, y = startY, time = 1})
		end
	end
end

function RoomMyCardUI:calculateStartX()
	return (1280 - (#self.m_lastCards * CardFlipParam.Width + (#self.m_lastCards - 1) * CardFlipParam.Gap)) / 2
end

function RoomMyCardUI:FlipLastCards()
	local startX = self:calculateStartX()

	for k, v in ipairs(self.m_lastCards) do
		transition.fadeOut(v, {time = CardFlipParam.Time})
		transition.moveTo(v, {x = startX + (k - 1) * (CardFlipParam.Gap + CardFlipParam.Width), y = CardFlipParam.startY, time = CardFlipParam.Time})
		local boundingSize = v:getBoundingBox()
        local sx = CardFlipParam.Width / (boundingSize.width / v:getScaleX()) 
        local sy = CardFlipParam.Height / (boundingSize.height / v:getScaleY())

		transition.scaleTo(v, {
			scaleX = sx, 
			scaleY = sy,
			time = 1})

		if v.innerCard then
			transition.fadeIn(v.innerCard, {time = 2})
			transition.moveTo(v.innerCard, {x = startX + (k - 1) * (CardFlipParam.Gap + CardFlipParam.Width), y = CardFlipParam.startY, time = CardFlipParam.Time})
			boundingSize = v.innerCard:getBoundingBox()
        	sx = CardFlipParam.Width / (boundingSize.width / v.innerCard:getScaleX()) 
        	sy = CardFlipParam.Height / (boundingSize.height / v.innerCard:getScaleY())

			transition.scaleTo(v.innerCard, {
				scaleX = sx, 
				scaleY = sy,
				time = 1})
		end
	end
end

return RoomMyCardUI