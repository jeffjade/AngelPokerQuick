-- File : singleServer.lua
-- Date : 2014.10.27~22:19
-- Auth : JeffYang

require("logic/cardType")

local singleRobot = require("scenes/room/singleRoomScene/singleRobot")
SingleServer = class("SingleServer")

local SingleMaxPlayerNum = 4

function SingleServer:ctor()
	self:init()
end

function SingleServer:dtor()

end

function SingleServer:init()
	self.mRoomInfo =  require(GameRoomPath.."roomCache").new()

	self:addEventListener("SERVER_EVENT_GAME_READY", self.onGameReadyEvent)
	self:addEventListener("SERVER_EVENT_PLAY_START", self.onPlayStartEvent)
end


function SingleServer:onGameReadyEvent()
	self:addMachine();
end


function SingleServer:addMachine()
	local maxPlayerNum = SingleMaxPlayerNum

	local singleRobotData = {}
	for k, v in pairs(singleRobot) do
		singleRobotData[k] = v;
	end

	for i = 1, maxPlayerNum-1  do 
		local mid = self.mAiCount or 100
		mid = mid + 1
		self.mAiCount = mid

		local cAiPlayer = new(GameAiPlayer);
		cAiPlayer:setMid(mid)
		cAiPlayer:setMoney(999999)

		local cAiRobot, index = ToolUtil.randomItem(singleRobotData);
		table.remove(singleRobotData, index);
		local sex = cAiRobot.sex;
		local nick = cAiRobot.name;
		local icon = cAiRobot.icon
		cAiPlayer:setIcon(icon);
		cAiPlayer:setSex(sex);
		cAiPlayer:setNick(nick);
		cAiPlayer:setSeat(mid - 100);

		-- 设置随机出来的战绩情形
		local cWinRate = ToolUtil.randomInt(80, 20);
		local count = ToolUtil.randomInt(level * level * 25, level * level * 5);
		local cWinCount = math.floor(count * cWinRate * 0.01);
		cAiPlayer:setWinCount(cWinCount);
		cAiPlayer:setLoseCount(count - cWinCount);

		self:playEnterRoom(mid)
	end
end

-- Enter Room
function SingleServer:playEnterRoom(mid)
	local meMid = self.getMeMid()
	if mid and meMid then
		if mid ~= meMid then 
			local player = self:findPlayerByMid(mid)
			player:setIsReady(true)
			player:playerReady()
		end
	end
end

-- 玩家准备~发牌喽
function SingleServer:playerReady()
	local isAllPlayerReadyFlag = self:isAllPlayerReadyFlag()
	if isAllPlayerReadyFlag then
		self:dealCards()
	end
end

function SingleServer:dealCards()
	-- 率先清掉玩家的手牌
	-- local direction = nil;
	-- direction = self:getCurrentPlayer():getDirection();
	-- local maxPlayerNum = SingleMaxPlayerNum
	-- for i = 1, maxPlayerNum do
	-- end
	local allCards = CardUtil.getAllCardsWithNoKings()
	local otherCards = allCards

	-- Set Player Cards
	local maxPlayerNum = SingleMaxPlayerNum
	for i = 1, maxPlayerNum do
		local playerCards = {}
		playerCards ,otherCards = CardUtil.get13cards(allCards)
		local player = self:findPlayerByDirection(i)
		player:setPlayerCards(playerCards)
		player:sortPlayerCards()   -- 将玩家的牌排序
		print_lua_table(playerCards)-------------------------*********
	end

	self:playStart()
end

function SingleServer:playStart()
	local firstPlayPlayerMid = self:findStandsOutMid()
	local firstPlayer = self:findPlayerByMid(firstPlayPlayerMid)

	for k,v in pairs(self.mRoomInfo.mPlayerSeatMap) do 
		if v:getMid() ~= firstPlayPlayerMid then
			v:setTeam(2)
		else
			v:setTeam(1)
		end
		v:setReady(false);
	end
	self.mRoomInfo:setCurrentPlayer(firstPlayPlayerMid)
	self.mRoomInfo:setNextPlayer(0);
	
	-- StateMachine:getInstance():pushCommand(firstPlayer.thinkHowGame, firstPlayer);
	-- firstPlayer:thinkHowGame()
	self:dispatchEvent({name = "SERVER_EVENT.PLAY_START"})
end

function SingleServer:onPlayStartEvent()
	-- EventDispatcher.getInstance():dispatch(SERVER_EVENT.PLAY_NEW_TURN);
	-- 发消息告诉现在进入新的一轮;
	self:dispatchEvent({name = "SERVER_EVENT.PLAY_NEW_TURN"})

	self.mHadPlay = true
	-- local g_info = self.m_state:getInfo()
	-- local mid = g_info:getLandlord();
	-- local player = g_info:findPlayerByMid(mid);
	-- g_info:setCurrentPlayer(mid);
	-- self:getNextPlayer();
	-- StateMachine:getInstance():pushCommand(player.think, player);

	local firstPlayPlayerMid = self:findStandsOutMid()
	self:setCurrentPlayer(firstPlayPlayerMid)
	local firstPlayer = self:findPlayerByMid(firstPlayPlayerMid)
	firstPlayer:thinkHowGame()
end

--=========================================Helper Fun===================================================
-- 遍历每个玩家的牌,找到红桃3所属玩家的mid
function SingleServer:findStandsOutMid()
	local maxPlayerNum = SingleMaxPlayerNum
	for i=i, maxPlayerNum do
		local player = self:findPlayerByDirection(i)
		local playerCards = player:getPlayerCards()
		local isRed3CardsFlag = self:isHaveRed3Card(playerCards)
		if isRed3CardsFlag then
			local playerMid = player:getMid()
			return playerMid
		end
	end
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
	for i=1 , maxPlayerNum do
		local player = self:findPlayerByDirection(i)
		if not player or player:getIsReady() then 
			return false
		end
	end
	return true
end

function SingleServer:getCurrentPlayer()
	
end

function SingleServer:setCurrentPlayer(mid)
	
end