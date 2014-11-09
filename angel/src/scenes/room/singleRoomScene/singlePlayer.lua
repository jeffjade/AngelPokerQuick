-- File : singlePlayer.lua
-- Date : 2014.10.30
-- Auth : JeffYang

local roomPlayer = require(GameRoomPath.."roomPlayer")
SinglePlayer = class("SinglePlayer", roomPlayer)

function SinglePlayer:ctor()

end

function SinglePlayer:dtor()

end

function SinglePlayer:thinkHowGame()
end

function SinglePlayer:sortCards(cards)

end

function SinglePlayer:outCard(cards, count)

end

return SinglePlayer