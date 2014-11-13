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

    local tCards = {}
    for i = 1, 49 do
        local card = {}
        card.cardValue = 1
        card.cardType = 2
        tCards[#tCards + 1] = card
    end

--Debug 加载牌
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