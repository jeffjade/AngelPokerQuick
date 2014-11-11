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

--Debug 加载牌
    local cardui = require(GameRoomPath .. "roomMyCardUI").new()
    cardui:createCards(2, {{cardValue=1, cardType=2}, {cardValue=2, cardType=3}})
    cardui:placeCard()
    -- cardui:size(50,50)
    -- cardui:pos(0, 0)
    -- self:getCardPanel()
    -- self.m_cardPanel:addChild(cardui)

    self:addChild(self.rootMainScene)   

    display.addSpriteFrames("card_f.plist", "card_f.png")
    strNamePic = "#f1.png"
    local card = display.newSprite(strNamePic)  
    card:setPosition(400, 400)  
    card:setContentSize(50, 100)
    self:addChild(card)
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

--获取 牌 panel
function RoomScene:getCardPanel()
    if not self.m_cardPanel then
        self.m_cardPanel = cc.uiloader:seekNodeByName(self.rootMainScene, "widget_card")
    end
    return self.m_cardPanel
end

return RoomScene;