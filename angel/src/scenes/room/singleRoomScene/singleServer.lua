-- File : singleServer.lua
-- Date : 2014.10.27~22:19
-- Auth : JeffYang

require("logic/cardType")

local singleRobot = require("scenes/room/singleRoomScene/singleRobot")
SingleServer = class("SingleServer" , function()
    return display.newScene("SingleScene") end)

local SingleMaxPlayerNum = 4

function SingleServer:ctor() 
	self:init()
end

function SingleServer:dtor()

end

function SingleServer:init()
	print("SingleServer:~~~~~init\n")

	self.mRoomInfo =  require(GameRoomPath.."roomCache").new()

	cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self:addEventListener(kSingleGameReadyEv , handler(self, self.onGameReadyEvent))
	self:addEventListener(kSingleGamePlayStartEv , handler(self, self.onPlayStartEvent))
end

function SingleServer:onGameReadyEvent()
	print("SingleServer:~~~~~onGameReadyEvent")
	self:addPlayereSelf()
	self:addMachine();
end

function SingleServer:addPlayereSelf()
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
		local mid = self.mAiCount or 10000000
		mid = mid + 1
		self.mAiCount = mid

		local cAiPlayer = import(GameRoomPath.."singleRoomScene/gameAiPlayer").new()
		cAiPlayer:setMid(self.mAiCount)
		cAiPlayer:setMoney(999999)

		local cAiRobot, index = ToolUtil.randomItem(singleRobotData);
		table.remove(singleRobotData, index);
		local sex = cAiRobot.sex;
		local nick = cAiRobot.name;
		local icon = cAiRobot.icon
		cAiPlayer:setIcon(icon);
		cAiPlayer:setSex(sex);
		cAiPlayer:setNick(nick);
		cAiPlayer:setSeat(mid - 10000000);

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
			self:playerReady()
		end
	end
end

function SingleServer:playerReady()

end

-- 玩家准备~发牌喽
function SingleServer:playReady()
	local isAllPlayerReadyFlag = self:isAllPlayerReadyFlag()
	if isAllPlayerReadyFlag then
		print("SingleServer:playerReady()==============================")
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
	allCards = CardUtil.shuffleCards(allCards)  --洗牌
	local otherCards = allCards

	-- Set Player Cards
	local maxPlayerNum = SingleMaxPlayerNum
	for i = 1, maxPlayerNum do
		local playerCards = {}
		playerCards ,otherCards = CardUtil.get13cards(allCards)
		local player = self:findPlayerByDirection(i)
		player:setPlayerCards(playerCards)
		player:sortPlayerCards()   -- 将玩家的牌排序

		print_lua_table(playerCards)
	end

	self:playStart()
end

function SingleServer:playStart()
	local firstPlayPlayerMid = self:findStandsOutMid()
	local firstPlayer = self:findPlayerByMid(firstPlayPlayerMid)

	for k,v in pairs(self.mRoomInfo.mPlayerSeatMap) do 
		if v:getMid() ~= firstPlayPlayerMid then
			-- v:setTeam(2)  -- 未曾完全想好
		else
			-- v:setTeam(1)
		end
		-- v:setReady(false);
	end
	self.mRoomInfo:setCurrentPlayer(firstPlayPlayerMid)
	self.mRoomInfo:setNextPlayer(0);
	
	-- StateMachine:getInstance():pushCommand(firstPlayer.thinkHowGame, firstPlayer);
	QueueUtils:getInstance():sychronizedDelayCommand(nil,function()
		firstPlayer:thinkHowGame()
		end ,1)
	-- firstPlayer:thinkHowGame()
	-- self:dispatchEvent({name = "SERVER_EVENT.PLAY_START"})
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
	for i = 1, maxPlayerNum do
		local player = self:findPlayerByDirection(i)
		local playerCards = player:getPlayerCards()
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
		print("iiiiiiiiii==  "..i)
		print( player:getIsReady() and "is ready:YES!!!" or "is ready:NO???")
		if not player or not player:getIsReady() then
			return false
		end
	end
	return true
end

function SingleServer:getCurrentPlayer()
	
end

function SingleServer:setCurrentPlayer(mid)
	
end

return SingleServer