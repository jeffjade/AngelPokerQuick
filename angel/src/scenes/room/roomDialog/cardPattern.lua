CardPattern = class("CardPattern", function()
	return display.newNode()
end)

function CardPattern:ctor()
	self:setPosition(display.cx-170, display.cy-50)

	self.m_imgFirst = cc.ui.UIImage.new("cardPattern.png")
	self.m_imgSecond = cc.ui.UIImage.new("cardPattern.png")
	self.m_imgThird = cc.ui.UIImage.new("cardPattern.png")

	self:addChild(self.m_imgFirst)
	self:addChild(self.m_imgSecond)
	self:addChild(self.m_imgThird)

	self:placeCardPattern()	
end

function CardPattern:placeCardPattern()
	self.m_imgFirst:setPosition(0, 0)
	self.m_imgSecond:setPosition(30, 0)
	self.m_imgThird:setPosition(60, 0)
end

function CardPattern:dtor()
end

return CardPattern