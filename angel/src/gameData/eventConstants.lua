-- File : constants.lua
-- Date : 2014.11.09 19:01
-- Auth : JeffYang

-- ===================================SingleSceneConstants==================================
kSingleGameReadyEv      = EventDispatcher.getInstance():getUserEvent() -- "singleGameReadyEvent"
kSingleGamePlayStartEv  = EventDispatcher.getInstance():getUserEvent() -- "singleGamePlayStartEvent"
kSingleOutCardEv        = EventDispatcher.getInstance():getUserEvent()
kSingleTurnCardEv       = EventDispatcher.getInstance():getUserEvent()

kServerPlayerOutCardsEv = EventDispatcher.getInstance():getUserEvent()
kServerPlayNextEv       = EventDispatcher.getInstance():getUserEvent()
kServerPlayNewTurnEv    = EventDispatcher.getInstance():getUserEvent()