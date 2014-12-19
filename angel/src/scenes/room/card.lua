--[[
	local card = require(GameRoomPath .. "card").new(1, 2):createCard()
]]
--方块：f1.png ~ f13.png           
--梅花：m1.png ~ m13.png
--黑桃：h1.png ~ h13.png
--红桃：r1.png ~ r13.png

local CardType = 
{
	Hei  = 0,
	Hong = 1,
	Mei  = 2,
	Fang = 3,
}

local Card = class("Card", function()
		return cc.ui.UIImage.new()
	end)

function Card:ctor(cardValue, cardType, roomMycardUI)
	self.m_roomCardUI = roomMycardUI
	self.m_cardValue = cardValue or 1
	self.m_cardType = cardType or 1
	self.m_bSelected = false

	self:setAnchorPoint(0, 0)
	self:createCard()
end

function Card:getCardValue()
	return self.m_cardValue
end

function Card:getCardType()
	return self.m_cardType
end

--根据牌型、牌值 返回牌精灵控件
function Card:createCard()
	if CardType.Fang == self.m_cardType then
		self:createCardF()
	elseif CardType.Mei == self.m_cardType then
		self:createCardM()
	elseif CardType.Hei == self.m_cardType then
		self:createCardH()
	elseif CardType.Hong == self.m_cardType then
		self:createCardR()
	end
end

function Card:updateCardStatus()
	local bFlag = true
	local indexCard = 0

	if true == self.m_bSelected then
		for k, v in pairs(self.m_roomCardUI.m_statusCards) do
			if v == self then
				bFlag = false
				break
			end
		end
		if bFlag then
			self.m_roomCardUI.m_statusCards[#self.m_roomCardUI.m_statusCards + 1] = self
		end
	elseif false == self.m_bSelected then
		for k, v in pairs(self.m_roomCardUI.m_statusCards) do
			if v == self then
				bFlag = false
				indexCard = k
				break
			end
		end
		if not bFlag then
			self.m_roomCardUI.m_statusCards[indexCard] = nil
		end
	end
end


function Card:createCardF()
	display.addSpriteFrames("card_f.plist", "card_f.png")
	strNamePic = "f" .. self.m_cardValue .. ".jpg"
	self:set(strNamePic)
end

function Card:createCardM()
	display.addSpriteFrames("card_m.plist", "card_m.png")
	strNamePic = "m" .. self.m_cardValue .. ".jpg"  
	self:set(strNamePic)
end

function Card:createCardH()
	display.addSpriteFrames("card_h.plist", "card_h.png")
	strNamePic = "h" .. self.m_cardValue .. ".jpg"
	self:set(strNamePic)
end

function Card:createCardR()
	display.addSpriteFrames("card_r.plist", "card_r.png")
	strNamePic = "r" .. self.m_cardValue .. ".jpg"
	self:set(strNamePic)
end

function Card:set(strNamePic)
	local frame = display.newSpriteFrame(strNamePic)

	self:setSpriteFrame(frame) 
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
    		local x, y = self:getPosition()
			if self.m_bSelected then
				self:setPosition(x, y - 30)
			else
				self:setPosition(x, y + 30)
			end
			self.m_bSelected = not self.m_bSelected

			self:updateCardStatus()
        end
        return true
    end)
end

function Card:setSelectStatus(status)
	self.m_bSelected = status
end

return Card