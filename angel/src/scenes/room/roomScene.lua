-- File : roomScene.lua
-- Date : 2014.10.21:22:23
-- Auth : JeffYang

local RoomScene = class("RoomScene", function()
    return display.newScene("RoomScene")
end)

function RoomScene:ctor()
    self.rootScene = cc.uiloader:load("wiget_main_scene.json")

    self:addPersonFirst()
    self:addPersonSecond()
    self:addPersonThird()
    self:addSelf()
    self:addChild(self.rootScene)
    self:createSelfLoadingBar()
    self:init()
    -- self:showCardPattern()
    self:schedulerProcess()
    self:registerEvent()

    EventDispatchController:addEventListener( "kPlayerFlipCardsEv", handler(self, self.onPlayerFlipCards))
end

function RoomScene:onPlayerFlipCards(event)
    self:flipCardsBySeat(event.seat)
end

function RoomScene:getPlayerByMid(mid)
end

function RoomScene:init()

    self:showMyCards({{cardValue=3, cardType=3}, 
        {cardValue=4, cardType=3},
        {cardValue=5, cardType=3},
        {cardValue=6, cardType=3},
        {cardValue=7, cardType=3},
        {cardValue=8, cardType=3},
        {cardValue=9, cardType=3},
        {cardValue=10, cardType=3},
        {cardValue=11, cardType=3}}
        )

    self:createOutCardButton()

    self:flyOutCardsBySeat(1,
    {{cardValue=3, cardType=3},
    {cardValue=3, cardType=3},
    {cardValue=3, cardType=3}})

    self.m_cardUi:showCardsAmountBySeat(3, 12)
    self.m_cardUi:showCardsAmountBySeat(2, 10)
    self.m_cardUi:showCardsAmountBySeat(1, 13)
    self.m_cardUi:showCardsAmountBySeat(0, 15)
end

function RoomScene:registerEvent()
end

function RoomScene:showPlayerLeftCardCount(seat , count)
    self.m_cardUi:showCardsAmountBySeat(seat, count)
end

function RoomScene:flyOutCardsBySeat(seat, tCards)
    self.m_cardUi:flyOutPlayerCards(seat, tCards)
end

function RoomScene:onEnter()
end


function RoomScene:showSelectDialog()
    self.m_dlgSelectCard = require(GameRoomPath .. "roomDialog/selectCardDialog").new(self.m_cardUi)
    self:addChild(self.m_dlgSelectCard)
end

function RoomScene:createOutCardButton()
    if not self.m_btnOutCard then
        self.m_btnOutCard = cc.ui.UIPushButton.new("btnOutCard.png"):pos(display.cx - 100, display.cy - 80)
        self.m_btnOutCard:onButtonClicked(function()
            self.m_btnOutCard:setVisible(false)
            if self.m_btnFollowCard then
                self.m_btnFollowCard:setVisible(false)
            end
            self:showSelectDialog()
        end)
        self:addChild(self.m_btnOutCard)

        local label = cc.ui.UILabel.new({UILabelType=1, text="出牌",font="font_hei.fnt"})
        label:setPosition(-25, 0)
        self.m_btnOutCard:addChild(label)
    end
    self.m_btnOutCard:setVisible(true)
end

function RoomScene:flipCardsBySeat(seat)
    self.m_cardUi:flipLastCards(seat)
end

function RoomScene:showFlipButton()
    if not self.m_btnFollowCard then
        self.m_btnFollowCard = cc.ui.UIPushButton.new("btnOutCard.png"):pos(display.cx + 100, display.cy - 80)
        self.m_btnFollowCard:onButtonClicked(function()
            if self.m_cardUi then
                self.m_btnFollowCard:setVisible(false)
                self.m_btnOutCard:setVisible(false)
                EventDispatchController:dispatchEvent( { name = "kServerTurnPlayCardsEv", 
                                                         mid = PhpInfo:getMid() } )
            end
        end)
        self.m_btnFollowCard:setLocalZOrder(1000)
        self:addChild(self.m_btnFollowCard)

        local label = cc.ui.UILabel.new({UILabelType=1, text="翻牌",font="font_hei.fnt"})
        label:setPosition(-25, 0)
        self.m_btnFollowCard:addChild(label)
    end
    self.m_btnFollowCard:setVisible(true)
end

function RoomScene:showMyCards(tCards)
	--Debug
    self.m_cardUi = require(GameRoomPath .. "roomMyCardUI").new(self)
    self.m_cardUi:createCards(tCards)
    self.m_cardUi:placeCard()
    self:addChild(self.m_cardUi)
end

function RoomScene:addPersonFirst()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootScene, "widget_first_person")

    self.m_widgetFirstPerson = cc.uiloader:load("wiget_person.json") 
    self.m_widgetProgressBarFirstPerson = cc.uiloader:seekNodeByName(self.m_widgetFirstPerson, "progressbar_time")
    self.m_widgetProgressBarFirstPerson:setPercent(30)

    widgetPerson:addChild(self.m_widgetFirstPerson)
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

function RoomScene:addPersonSecond()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootScene, "widget_second_person")

    self.m_widgetSecondPerson =  cc.uiloader:load("wiget_person.json") 
    self.m_widgetProgressBarSecondPerson = cc.uiloader:seekNodeByName(self.m_widgetSecondPerson, "progressbar_time")
    self.m_widgetProgressBarSecondPerson:setPercent(60)

    widgetPerson:addChild(self.m_widgetSecondPerson)
end

function RoomScene:addPersonThird()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootScene, "widget_third_person")

    self.m_widgetThirdPerson =  cc.uiloader:load("wiget_person.json") 
    self.m_widgetProgressBarThirdPerson = cc.uiloader:seekNodeByName(self.m_widgetThirdPerson, "progressbar_time")
    self.m_widgetProgressBarThirdPerson:setPercent(80)

    widgetPerson:addChild(self.m_widgetThirdPerson)
end

function RoomScene:addSelf()
    local widgetPerson = cc.uiloader:seekNodeByName(self.rootScene, "widget_self_person")
    local widgetRootPersonScene =  cc.uiloader:load("widget_self.json") 
    widgetPerson:addChild(widgetRootPersonScene)
end

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

function RoomScene:schedulerProcess()
    local scheduler = require("framework.scheduler")

    local percent = 100
    local function onInterval(dt)
        percent = (percent + 99) % 100

        percent1 = (percent + 20) % 100 + 1
        self.m_widgetProgressBarFirstPerson:setPercent(percent1)

        percent2 = (percent + 40) % 100 + 1
        self.m_widgetProgressBarSecondPerson:setPercent(percent2)

        percent3 = (percent + 60) % 100 + 1
        self.m_widgetProgressBarThirdPerson:setPercent(percent3)

        percentSelf = (percent + 90) % 100 + 1

        self.m_selfLoadingBar:setPercent(percentSelf)
    end

    self.m_scheduler = scheduler.scheduleGlobal(onInterval, 0.05)    
end

function RoomScene:stopScheduler()
    local scheduler = require("framework.scheduler")
    scheduler.unscheduleGlobal(self.m_scheduler)
end

function RoomScene:onExit()
    self:stopScheduler()
end

return RoomScene