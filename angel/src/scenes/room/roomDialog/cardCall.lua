CardCall = class("CardCall", function() 
	return display.newNode()
end)

local CardType = 
{
	Hei  = 0,
	Hong = 1,
	Mei  = 2,
	Fang = 3,
}

--此版本可以显示的牌最多4张
function CardCall:ctor(tCards)
	self.m_cards = tCards

	self:setPosition(display.cx + 30, display.cy-50)
	self:showCards()
end

function CardCall:showCards()
	for k, v in ipairs(self.m_cards) do
		local card = self:createCard(v):pos(k * 30, 0)
		self:addChild(card)
	end
end

function CardCall:createCard(tCard)
	if CardType.Fang == tCard.cardType then
		return self:createCardF(tCard.cardValue)
	elseif CardType.Mei == tCard.cardType then
		return self:createCardM(tCard.cardValue)
	elseif CardType.Hei == tCard.cardType then
		return self:createCardH(tCard.cardValue)
	elseif CardType.Hong == tCard.cardType then
		return self:createCardR(tCard.cardValue)
	end
end

function CardCall:createCardF(cardValue)
	display.addSpriteFrames("card_f.plist", "card_f.png")
	strNamePic = "#f" .. cardValue .. ".png"
	return cc.ui.UIImage.new(strNamePic):scale(0.1)
end

function CardCall:createCardM(cardValue)
	display.addSpriteFrames("card_m.plist", "card_m.png")
	strNamePic = "#m" .. cardValue .. ".png"  
	return cc.ui.UIImage.new(strNamePic):scale(0.1)
end

function CardCall:createCardH(cardValue)
	display.addSpriteFrames("card_h.plist", "card_h.png")
	strNamePic = "#h" .. cardValue .. ".png"
	return cc.ui.UIImage.new(strNamePic):scale(0.1)
end

function CardCall:createCardR(cardValue)
	display.addSpriteFrames("card_r.plist", "card_r.png")
	strNamePic = "#r" .. cardValue .. ".png"
	return cc.ui.UIImage.new(strNamePic):scale(0.2)
end

return CardCall