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
    self:init()
end

function RoomScene:init()
	local tCards = {}
    for i = 1, 49 do
        local card = {}
        card.cardValue = 1
        card.cardType = 2
        tCards[#tCards + 1] = card
    end
	self:showMyCards(tCards)
end

function RoomScene:onEnter()
end

function RoomScene:onExit() 
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
    local widgetRootPersonScene =  cc.uiloader:load("wiget_person.json") 
    widgetPerson:addChild(widgetRootPersonScene)
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

--加载人物二
function RoomScene:addPersonSecond()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootScene, "widget_second_person")
    local widgetRootPersonScene =  cc.uiloader:load("wiget_person.json") 
    widgetPerson:addChild(widgetRootPersonScene)
end

--加载人物三
function RoomScene:addPersonThird()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootScene, "widget_third_person")
    local widgetRootPersonScene =  cc.uiloader:load("wiget_person.json") 
    widgetPerson:addChild(widgetRootPersonScene)
end

--加载自己
function RoomScene:addSelf()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootScene, "widget_self_person")
    local widgetRootPersonScene =  cc.uiloader:load("widget_self.json") 
    widgetPerson:addChild(widgetRootPersonScene)
end

return RoomScene