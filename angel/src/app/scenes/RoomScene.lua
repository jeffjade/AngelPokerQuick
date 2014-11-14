local RoomScene = class("RoomScene", function()
    return display.newScene("RoomScene");
end)

function RoomScene:ctor()
    -- 根节点
    self.rootMainScene = cc.uiloader:load("wiget_main_scene.json")

    self:addPersonFirst()
    self:addPersonSecond()
    self:addPersonThird()
    self:addSelf()
--debug -------------
    local tCards = {}
    for i = 1, 49 do
        local card = {}
        card.cardValue = 1
        card.cardType = 1
        tCards[#tCards + 1] = card
    end
--debug -------------
    self:loadCard(tCards)
    self:createOutCardButton()
end

--创建选牌对话框
function RoomScene:showSelectDialog()
    self.m_dlgSelectCard = require(GameRoomPath .. "selectCardDialog").new()
    self:addChild(self.m_dlgSelectCard)
end

--创造确定出牌按钮
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

--加载牌面
function RoomScene:loadCard(tCards)
    local cardui = require(GameRoomPath .. "roomMyCardUI").new()
    cardui:createCards(tCards)
    cardui:placeCard()
    self:addChild(self.rootMainScene)  
    self:addChild(cardui)
end

-- 加载人物一
function RoomScene:addPersonFirst()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootMainScene, "widget_first_person")
    local widgetRootPersonScene =  cc.uiloader:load("wiget_person.json") 
    widgetPerson:addChild(widgetRootPersonScene)
end

--加载人物二
function RoomScene:addPersonSecond()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootMainScene, "widget_second_person")
    local widgetRootPersonScene =  cc.uiloader:load("wiget_person.json") 
    widgetPerson:addChild(widgetRootPersonScene)
end

--加载人物三
function RoomScene:addPersonThird()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootMainScene, "widget_third_person")
    local widgetRootPersonScene =  cc.uiloader:load("wiget_person.json") 
    widgetPerson:addChild(widgetRootPersonScene)
end

--加载自己
function RoomScene:addSelf()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootMainScene, "widget_self_person")
    local widgetRootPersonScene =  cc.uiloader:load("widget_self.json") 
    widgetPerson:addChild(widgetRootPersonScene)
end

return RoomScene;