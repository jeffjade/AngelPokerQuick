--[[
	local card = require(GameRoomPath .. "card").new(1, 2):createCard()
]]
--方块：f1.png ~ f13.png           
--梅花：m1.png ~ m13.png
--黑桃：h1.png ~ h13.png
--红桃：r1.png ~ r13.png

local CardType = 
{
	Hei  = 1,
	Hong = 2,
	Mei  = 3,
	Fang = 4,
}

local Card = class("Card")

function Card:ctor(cardValue, cardType)
	self.m_cardValue = cardValue or 1
	self.m_cardType = cardType or 1
end

--根据牌型、牌值 返回牌精灵控件
function Card:createCard()
	if CardType.Fang == self.m_cardType then
		return self:createCardF()
	elseif CardType.Mei == self.m_cardType then
		return self:createCardM()
	elseif CardType.Hei == self.m_cardType then
		return self:createCardH()
	elseif CardType.Hong == self.m_cardType then
		return self:createCardR()
	end
end

function Card:createCardF()
	display.addSpriteFrames("card_f.plist", "card_f.png")
	strNamePic = "#f" .. self.m_cardValue .. ".png"
	return display.newSprite(strNamePic)  
end

function Card:createCardM()
	display.addSpriteFrames("card_m.plist", "card_m.png")
	strNamePic = "#m" .. self.m_cardValue .. ".png"
	return display.newSprite(strNamePic)  
end

function Card:createCardH()
	display.addSpriteFrames("card_h.plist", "card_h.png")
	strNamePic = "#h" .. self.m_cardValue .. ".png"
	return display.newSprite(strNamePic)  
end

function Card:createCardR()
	display.addSpriteFrames("card_r.plist", "card_r.png")
	strNamePic = "#r" .. self.m_cardValue .. ".png"
	return display.newSprite(strNamePic)  
end

return Card