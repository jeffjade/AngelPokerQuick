SelectCardDialog = class("SelectCardDialog", function()
	return cc.ui.UIImage.new("mask.png")
end)

function SelectCardDialog:ctor()
	self.m_cards = {}

	self:setPosition(display.cx, display.cy + 80)
	self:setOpacity(125)
	self:setAnchorPoint(0.5, 0.5)
	self:setLayoutSize(800, 400)

	self:createCards()
--debug---------------
	self:addChild(self.m_cards[1])
--debug---------------
end

function SelectCardDialog:createCards()
	-- self:createACards()
	self:createNumCards()
	self:createLetterCards()
end

--创造 A
function SelectCardDialog:createACards()
	self.m_cards[#self.m_cards + 1] = cc.ui.UIPushButton.new("selectCardBg.jpg")
	-- local card = cc.ui.UIPushButton.new("selectCardBg.jpg")
		:addChild(cc.ui.UILabel.new(
			{
			UILabelType=1, 
			text="A",
			font="futura-48.fnt",
			}))
	-- self:addChild(card)
end

--创造数字牌 2~10
function SelectCardDialog:createNumCards()
end

--创造字母牌 J ~ K( 除了 A 之外 )
function SelectCardDialog:createLetterCards()
end

return SelectCardDialog