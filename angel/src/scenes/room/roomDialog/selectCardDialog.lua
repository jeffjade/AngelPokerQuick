SelectCardDialog = class("SelectCardDialog", function()
	return display.newNode()
end)

SelectDialogParams =
{
	BGMaskWidth = 800,
	BGMaskHeight = 400,

	BGOpacity = 125,
	BGAnchorX = 0.5,
	BGAnchorY = 0.5,

	CardUpperY = display.cy + 170,
	CardLowerY = display.cy,
}

SelectDialogCardParams = 
{
	Width = 30,
}

function SelectCardDialog:createMask()
	local imgMask = cc.ui.UIImage.new("mask.png")

	imgMask:setPosition(display.cx, display.cy + 80)
	imgMask:setOpacity(SelectDialogParams.BGOpacity)
	imgMask:setAnchorPoint(SelectDialogParams.BGAnchorX, SelectDialogParams.BGAnchorY)
	imgMask:setLayoutSize(SelectDialogParams.BGMaskWidth, SelectDialogParams.BGMaskHeight)

	self:addChild(imgMask)
end

function SelectCardDialog:ctor(roomMyCardUI)
	self.m_cards = {}
	self.m_roomMyCardUI = roomMyCardUI

	self:init()
	self:createMask()
	self:createCards()
	self:placeUpperCards()
	self:placeLowerCards()
end

--排列上层牌 A ~ 8
function SelectCardDialog:placeUpperCards()
	local gap = (SelectDialogParams.BGMaskWidth - SelectDialogCardParams.Width * 7) / 8
	local startPointX = display.cx - SelectDialogParams.BGMaskWidth/2 + gap

	for i = 1, 7 do
		self.m_cards[i]:pos(
			startPointX + (i - 1) * (SelectDialogCardParams.Width + gap)
			, SelectDialogParams.CardUpperY)
		self:addChild(self.m_cards[i])
	end
end

--排列下层牌 7 ~ 2
function SelectCardDialog:placeLowerCards()
	local gap = (SelectDialogParams.BGMaskWidth - SelectDialogCardParams.Width * 7) / 8
	local startPointX = display.cx - SelectDialogParams.BGMaskWidth/2 + gap

	for i = 8, 13 do
		self.m_cards[i]:pos(
			startPointX + (i - 8) * (SelectDialogCardParams.Width + gap)
			, SelectDialogParams.CardLowerY)
		self:addChild(self.m_cards[i])
	end
end

function SelectCardDialog:init()
	self:setPosition(0, 0)
end

--将选择框按照 A ~ K ~ 2 的顺序载入
function SelectCardDialog:createCards()
	self:createACards()
	self:createLetterCards()
	self:createNumCards()
end

function SelectCardDialog:checkHasSelectedCard()
	if 0 == #self.m_roomMyCardUI.m_statusCards then
		return false
	end
	return true
end

--创造 A
function SelectCardDialog:createACards()
	local btnCard = cc.ui.UIPushButton.new("selectCardBg.jpg"):onButtonClicked(
		function()
			if false == self:checkHasSelectedCard() then
				return
			end
			self.m_roomMyCardUI:updateStatus()
			self:setVisible(false)
			EventDispatchController:dispatchEvent( {name = "kPlayerSelectCardEv", cardValue = 14} )
		end)
	local labelCard = cc.ui.UILabel.new({UILabelType=1, text="A",font="futura-48.fnt"})
	btnCard:scale(0.5)
	labelCard:pos(-13, 0)
	btnCard:addChild(labelCard)

	self.m_cards[#self.m_cards + 1] = btnCard
end

--创造数字牌 2~10
function SelectCardDialog:createNumCards()
	for i = 10, 3, -1 do
  		local btnCard = cc.ui.UIPushButton.new("selectCardBg.jpg"):onButtonClicked(
		function()
			if false == self:checkHasSelectedCard() then
				return
			end
			self.m_roomMyCardUI:updateStatus()
			self:setVisible(false)
			EventDispatchController:dispatchEvent( {name = "kPlayerSelectCardEv", cardValue = i} )
		end)
		local labelCard = cc.ui.UILabel.new({UILabelType=1, text=tostring(i),font="futura-48.fnt", size=30})
		labelCard:pos(-13, 0)
		btnCard:scale(0.5)
		btnCard:addChild(labelCard)

		self.m_cards[#self.m_cards + 1] = btnCard
	end

--创造数字牌 2
	local btnCard = cc.ui.UIPushButton.new("selectCardBg.jpg"):onButtonClicked(
	function()
		if false == self:checkHasSelectedCard() then
			return
		end
		self.m_roomMyCardUI:updateStatus()
		self:setVisible(false)
		EventDispatchController:dispatchEvent( {name = "kPlayerSelectCardEv", cardValue = 15} )
	end)
	local labelCard = cc.ui.UILabel.new({UILabelType=1, text=tostring(2),font="futura-48.fnt", size=30})
	labelCard:pos(-13, 0)
	btnCard:scale(0.5)
	btnCard:addChild(labelCard)

	self.m_cards[#self.m_cards + 1] = btnCard
end

--创造字母牌 J ~ K( 除了 A 之外 )
function SelectCardDialog:createLetterCards()
	local tCards = {"K", "Q", "J"}
	local tValue = {13, 12, 11}

	for k, v in ipairs(tCards) do
		local btnCard = cc.ui.UIPushButton.new("selectCardBg.jpg"):onButtonClicked(
		function()
			if false == self:checkHasSelectedCard() then
				return
			end
			self.m_roomMyCardUI:updateStatus()
			self:setVisible(false)
			EventDispatchController:dispatchEvent( {name = "kPlayerSelectCardEv", cardValue = tValue[k]} )
		end)
		local labelCard = cc.ui.UILabel.new({UILabelType=1, text=v, font="futura-48.fnt"})
		labelCard:pos(-13, 0)
		btnCard:scale(0.5)
		btnCard:addChild(labelCard)

		self.m_cards[#self.m_cards + 1] = btnCard
	end
end

return SelectCardDialog