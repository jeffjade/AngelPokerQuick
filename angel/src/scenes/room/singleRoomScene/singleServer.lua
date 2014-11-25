-- File : singleServer.lua
-- Date : 2014.10.27~22:19
-- Auth : JeffYang

local singleRobot = require("scenes/room/singleRoomScene/singleRobot")
SingleServer = class("SingleServer" , function()
    return display.newNode()
end)

local GameAiPlayer = import(GameRoomPath..".singleRoomScene.GameAiPlayer")

require(GameRoomPath.."/singleRoomScene/gameAiPlayer")

local SingleMaxPlayerNum = 4


function SingleServer:ctor(scene)
	self.mRoomScene = scene
	self.mRoomInfo = self.mRoomScene:getRoomInfo()
	self:registerEvent()
end

function SingleServer:dtor()
	self:unregisterEvent()
end

function SingleServer:registerEvent()
	EventDispatchController:addEventListener( "kSingleGameReadyEv" ,      handler(self, self.onGameReadyEvent))
	EventDispatchController:addEventListener( "SINGLE_SERVER_OUT_CARDS" , handler(self, self.onOutCardEvent) )
	EventDispatchController:addEventListener( "kServerTurnPlayCardsEv" ,  handler(self, self.onTurnCardEvent) )
	EventDispatchController:addEventListener( "kServerPlayNextEv" ,       handler(self, self.onPlayNextEvent) )
end

function SingleServer:unregisterEvent()

end

-- ************************************LogicHelperFun*********************************************
function SingleServer:addPlayerSelf()
	self.mMySelfPlayer = require(GameRoomPath.."singleRoomScene/singlePlayer").new()
	local meMid = 100
    self.mMySelfPlayer:setMid(meMid)
    PhpInfo:setMid(meMid)

    self.mMySelfPlayer:setSex(1)
    self.mMySelfPlayer:setMoney(888)
    self.mMySelfPlayer:setIsReady(true)
    self.mMySelfPlayer:setSeat(0)
    -- self:playEnterRoom(meMid)
    
    self.mRoomInfo:addPlayer(self.mMySelfPlayer)
    self.mRoomInfo:updateDirection(self.mMySelfPlayer);
end

function SingleServer:addMachine()
	local maxPlayerNum = SingleMaxPlayerNum

	local singleRobotData = {}
	for k, v in pairs(singleRobot) do
		singleRobotData[k] = v;
	end

	for i = 1, maxPlayerNum - 1  do 
		local mid = self.mAiCount or 100
		mid = mid + 1
		self.mAiCount = mid

		local cAiPlayer = GameAiPlayer.new(self.mRoomInfo)
		cAiPlayer:setMid(self.mAiCount)
		cAiPlayer:setMoney(999999)

		local cAiRobot , index = ToolUtil.randomItem(singleRobotData);
		table.remove(singleRobotData, index);
		local sex = cAiRobot.sex;
		local nick = cAiRobot.name;
		local icon = cAiRobot.icon
		cAiPlayer:setIcon(icon);
		cAiPlayer:setSex(sex);
		cAiPlayer:setNick(nick);
		cAiPlayer:setSeat(mid - 100);

		-- 设置随机出来的战绩情形
		local level = ToolUtil.randomInt(99 , 11)
		local cWinRate = ToolUtil.randomInt(80, 20)
		local count = ToolUtil.randomInt(level * level * 25, level * level * 5)
		local cWinCount = math.floor(count * cWinRate * 0.01)
		cAiPlayer:setWinCount(cWinCount)
		cAiPlayer:setLoseCount(count - cWinCount)

		self.mRoomInfo:addPlayer(cAiPlayer)

		self:playEnterRoom(mid)
		self.mRoomInfo:updateDirection(cAiPlayer)
	end

	self:playReady()
end

-- Enter Room
function SingleServer:playEnterRoom(mid)
	local meMid = 100 -- self:getMeMid()
	if mid and meMid then
		if mid ~= meMid then 
			local player = self:findPlayerByMid(mid)
			player:setIsReady(true)
			self:playerReady(mid)
		end
	end
end

function SingleServer:playerReady(mid)

end

-- 玩家准备~发牌喽
function SingleServer:playReady()
	local isAllPlayerReadyFlag = self:isAllPlayerReadyFlag()
	if isAllPlayerReadyFlag then
		self.mRoomInfo.fuck = 999
		print("???fuck=======self.mRoomInfo.fuck = "..self.mRoomInfo.fuck)
		self:dealCards()
	end
end

function SingleServer:dealCards()
	local allCards = CardUtil.getAllCardsWithNoKings()
	allCards = CardUtil.shuffleCards(allCards)  --洗牌
	local otherCards = allCards

	-- Set Player Cards
	local maxPlayerNum = SingleMaxPlayerNum
	for i = 1, maxPlayerNum do
		local playerCards = {}
		playerCards ,otherCards = CardUtil.get13cards(allCards)
		local player = self:findPlayerByDirection(i)

		playerCards = CardUtil.sortCardsByValue( playerCards ) -- 对牌排序
		player:setPlayerCards( #playerCards , playerCards )

		EventDispatcher.getInstance():dispatch( kServerDealCardsEv, player:getMid() , playerCards);
		-- print_lua_table(playerCards)
	end

	self:playStart()
end

function SingleServer:playStart()
	print("SingleServer:playStart()~~~~~~~~~~~~~")
	local firstPlayPlayerMid = self:findStandsOutMid()
	local firstPlayer = self:findPlayerByMid(firstPlayPlayerMid)

	self.mRoomInfo:setCurrentPlayer(firstPlayPlayerMid)
	self.mRoomInfo:setNextPlayer(0);
	
	-- QueueMachine:getInstance():delayCommand( function()
	-- 	firstPlayer:thinkHowGame()
	-- 	end , 3 )

	-- QueueUtils:getInstance():sychronizedDelayCommand(firstPlayer ,
	-- 	firstPlayer.thinkHowGame ,1)
	firstPlayer:thinkHowGame()
end

function SingleServer:nextPlayerPlay()
	local player = self:getNextPlayer()
	print("SingleServer:nextPlayerPlay()==============!!!!")
	if player then
		local mid = player:getMid()
		print("SingleServer:nextPlayerPlay() mid ="..mid)
		-- self:onPlayNextEvent(mid)
		EventDispatchController:dispatchEvent( {name = "kServerPlayNextEv", mid = mid} )

		self.mRoomInfo:setCurrentPlayer(mid)
		local direction = player:getDirection()
		player = self.mRoomInfo:findNextPlayerByDirection(direction);
		local next_mid = player:getMid()
		self.mRoomInfo:setNextPlayer(next_mid)
	else
		error("Error,SingleServer:~nextPlayerPlay() 之 Cannot Find Next Player !!!")
	end
end

function SingleServer:gamePlayOver()
	print("SingleServer:gamePlayOver()~~~~~~")
	local gameOverList = {}
	local gameOverPlayerList = {}
	gameOverList.winnerMid =self.mRoomInfo:getWinner()
 
	local maxPlayerNum = SingleMaxPlayerNum
	for i = 1 , maxPlayerNum do 
		local player = self.mRoomInfo:findPlayerByDirection( i )
		if player and next(player) then
			local playerInfo = {}
			playerInfo.mid   = player:getMid()
			playerInfo.nick  = player:getNick()
			playerInfo.money = player:getMoney()
			playerInfo.sex   = player:getSex()
			playerInfo.seat  = player:getSeat()
			gameOverPlayerList[i] = playerInfo
		end
	end
	self.mRoomInfo:setGameOverInfo(gameOverList , gameOverPlayerList)

	EventDispatcher.getInstance():dispatch( kServerPlayOverEv , mid)
end
-- ************************************LogicHelperFun*********************************************


-- ---------------------------------onEventCallBack-----------------------------------------------
function SingleServer:onGameReadyEvent(data)
	print("SingleServer:~~~~~onGameReadyEvent")
	self:addPlayerSelf()
	self:addMachine();
end

function SingleServer:onPlayStartEvent()
	-- 发消息告诉现在进入新的一轮;
	EventDispatcher.getInstance():dispatch(kServerPlayNewTurnEv);

	self.mHadPlay = true

	local firstPlayPlayerMid = self:findStandsOutMid()
	self.mRoomInfo:setCurrentPlayer(firstPlayPlayerMid)
	self.mRoomInfo:setNextPlayer(0);

	local firstPlayer = self:findPlayerByMid(firstPlayPlayerMid)
	firstPlayer:thinkHowGame()
end

function SingleServer:onOutCardEvent(event)
	local mid = event.mid

	print("@@@@fuck=======self.mRoomInfo.fuck = "..self.mRoomInfo.fuck.." mid = "..mid)
	local player = self.mRoomInfo:findPlayerByMid(mid)
	local cards = player:getOutCards()

	local lastCards = {};
	if cards.outCards then
		for k, v in ipairs(cards.outCards) do
			lastCards[k] = v.cardValue;
		end
	end
	self.mRoomInfo:setLastOutCards(cards.count , cards.betCards , lastCards) --??
	self.mRoomInfo:setLastPlayer(mid)
	
	-- print("SingleServer Last Out Cards Is:")
	-- print_lua_table(cards)

	player:removeCard(cards.count , cards.outCards)

	local gameIsOver = (player and player:getPlayerCards().count == 0) or false;
	if gameIsOver then
		self.mRoomInfo:setWinner(mid)
		self.mRoomInfo:setNextPlayer(0)
		EventDispatcher.getInstance():dispatch(kServerPlayerOutCardsEv , mid);
		self:gamePlayOver();
	elseif mid ~= 0 then
		EventDispatcher.getInstance():dispatch(kServerPlayerOutCardsEv , mid);
		self:nextPlayerPlay();
	end
end

function SingleServer:onTurnCardEvent(event)
	local mid = event.mid

	-- 控制将上一家所打的牌给翻出来-以验明真假;
	print("@@@@ onTurnCardEvent fuck=======self.mRoomInfo.fuck = "..self.mRoomInfo.fuck.." mid = "..mid)
end

function SingleServer:onPlayNextEvent(event)
	local mid = event.mid
	if mid == self.mRoomInfo:getLastPlayer() then
		-- 发送消息出去(告知这是新的一轮)
		EventDispatcher.getInstance():dispatch(kServerPlayNewTurnEv);
	else
		-- do nothing
	end

	if mid ~= PhpInfo:getMid() then
		print("!!!!!fuck=======self.mRoomInfo.fuck = "..self.mRoomInfo.fuck)
		local player = self.mRoomInfo:findPlayerByMid(mid);
		-- QueueUtils:getInstance():sychronizedDelayCommand(nil,function()
		-- 		player:thinkHowGame()
		-- 	end ,1)
		player:thinkHowGame()
	end
end
-- ---------------------------------onEventCallBack-----------------------------------------------


 --=========================================Helper Fun=============================================
-- 遍历每个玩家的牌,找到红桃3所属玩家的mid
function SingleServer:findStandsOutMid()
	local maxPlayerNum = SingleMaxPlayerNum
	for i = 1, maxPlayerNum do
		local player = self:findPlayerByDirection(i)
		local playerCards = player:getPlayerCards().cards  --表中嵌表了;
		local isRed3CardsFlag = self:isHaveRed3Card(playerCards)
		if isRed3CardsFlag then
			local playerMid = player:getMid()
			return playerMid
		end
	end
end

function SingleServer:findPlayerByMid(mid)
	local player = self.mRoomInfo:findPlayerByMid(mid)
	return player
end

function SingleServer:getNextPlayer()
	local mid = self.mRoomInfo:getNextPlayer();
	if mid == nil or mid == 0 then
		local playerMid = self.mRoomInfo:getCurrentPlayer();
		local player = self:findPlayerByMid(playerMid)
		local direction = player and player:getDirection()
		local nextPlayer = self.mRoomInfo:findNextPlayerByDirection(direction);
		local nextMid = nextPlayer:getMid();
		self.mRoomInfo:setNextPlayer(nextMid);
		return nextPlayer;
	else
		return self.mRoomInfo:findPlayerByMid(mid);
	end
end

function SingleServer:findPlayerByDirection(direction)
	print("SingleServer:findPlayerByDirection======")
	local player = self.mRoomInfo:findPlayerByDirection(direction)
	return player
end

-- 遍历手牌找“红桃3”所属的玩家mid
function SingleServer:isHaveRed3Card(Cards)
	Cards = Cards or {}
	for k,v in pairs(Cards) do
		if v["cardValue"] == 3 and v["cardType"] == 1 then
			return true
		end  
	end
end

function SingleServer:isAllPlayerReadyFlag()
	local maxPlayerNum = SingleMaxPlayerNum
	for i = 1 , maxPlayerNum do
		local player = self:findPlayerByDirection(i)
		print( player:getIsReady() and "is ready:YES!!!" or "is ready:NO???")
		if not player or not player:getIsReady() then
			return false
		end
	end
	return true
end
 --=========================================Helper Fun=============================================

return SingleServer