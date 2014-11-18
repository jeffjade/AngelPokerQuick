-- File : roomScene.lua
-- Date : 2014.10.21:22:23
-- Auth : JeffYang

local RoomScene = class("RoomScene", function()
    return display.newScene("RoomScene")
end)

function RoomScene:ctor()
    -- 根节点
    self.rootScene = cc.uiloader:load("wiget_main_scene.json")

    self:addPersonFirst()
    self:addPersonSecond()
    self:addPersonThird()
    self:addSelf()
    self:addChild(self.rootScene)
    self:createSelfLoadingBar()
    self:init()
    self:showCardPattern()
end

function RoomScene:init()
	local tCards = {}
    for i = 1, 49 do
        local card = {}
        card.cardValue = 15
        card.cardType = 3
        tCards[#tCards + 1] = card
    end
	self:showMyCards(tCards)
    self:createOutCardButton()
    self:showCardCall()
end

function RoomScene:onEnter()
end

function RoomScene:onExit() 
end

function RoomScene:showSelectDialog()
    self.m_dlgSelectCard = require(GameRoomPath .. "roomDialog/selectCardDialog").new()
    self:addChild(self.m_dlgSelectCard)
end

function RoomScene:createOutCardButton()
    self.m_btnOutCard = cc.ui.UIPushButton.new("btnOutCard.png"):pos(display.cx, display.cy - 80)
    self.m_btnOutCard:onButtonClicked(function()
        self:showSelectDialog()
    end)
    self:addChild(self.m_btnOutCard)

    local imgBtnInnerCircle = cc.ui.UIImage.new("btnOutCardInnerCircle.png")
    imgBtnInnerCircle:setPosition(-32, -32)
    self.m_btnOutCard:addChild(imgBtnInnerCircle)
end

function RoomScene:showMyCards(tCards)
	--Debug 加载牌
    local cardui = require(GameRoomPath .. "roomMyCardUI").new()
    cardui:createCards(tCards)
    cardui:placeCard()
    self:addChild(cardui)
end

-- 加载人物一
function RoomScene:addPersonFirst()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootScene, "widget_first_person")

    self.m_widgetFirstPerson = cc.uiloader:load("wiget_person.json") 
    self.m_widgetProgressBarFirstPerson = cc.uiloader:seekNodeByName(self.m_widgetFirstPerson, "progressbar_time")
    self.m_widgetProgressBarFirstPerson:setPercent(30)

    widgetPerson:addChild(self.m_widgetFirstPerson)
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

--加载人物二
function RoomScene:addPersonSecond()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootScene, "widget_second_person")

    self.m_widgetSecondPerson =  cc.uiloader:load("wiget_person.json") 
    self.m_widgetProgressBarSecondPerson = cc.uiloader:seekNodeByName(self.m_widgetSecondPerson, "progressbar_time")
    self.m_widgetProgressBarSecondPerson:setPercent(60)

    widgetPerson:addChild(self.m_widgetSecondPerson)
end

--加载人物三
function RoomScene:addPersonThird()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootScene, "widget_third_person")

    self.m_widgetThirdPerson =  cc.uiloader:load("wiget_person.json") 
    self.m_widgetProgressBarThirdPerson = cc.uiloader:seekNodeByName(self.m_widgetThirdPerson, "progressbar_time")
    self.m_widgetProgressBarThirdPerson:setPercent(80)

    widgetPerson:addChild(self.m_widgetThirdPerson)
end

--加载自己
function RoomScene:addSelf()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootScene, "widget_self_person")
    local widgetRootPersonScene =  cc.uiloader:load("widget_self.json") 
    widgetPerson:addChild(widgetRootPersonScene)
end

--创建自己的进度条
--cc.rect(options.capInsetsX, options.capInsetsY,options.capInsetsWidth, options.capInsetsHeight)
function RoomScene:createSelfLoadingBar() 
    self.m_selfLoadingBar = cc.ui.UILoadingBar.new({
        percent=100,scale9=true, image="btnBgLine.png", viewRect={width=900, height=20},
        capInsets = cc.rect(0, 0, 0, 0)
        })
    self.m_selfLoadingBar:setPosition(200, 240)
    self.m_selfLoadingBar:setPercent(90)
    self:addChild(self.m_selfLoadingBar)
end

function RoomScene:showCardPattern()
    self.m_cardPattern = require(GameRoomPath .. "roomDialog/cardPattern").new()
    self:addChild(self.m_cardPattern)
end

function RoomScene:showCardCall()
    self.m_cardCall = require(GameRoomPath .. "roomDialog/cardCall").new({{cardType=1, cardValue=3},{cardType=1, cardValue=3}})
    self:addChild(self.m_cardCall)
end

return RoomScene