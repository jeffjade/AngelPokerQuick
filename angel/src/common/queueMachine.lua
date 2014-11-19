-- File : queueMachine.lua
-- Date : 2014.11.18
-- Desc : provide Fun For Msg Dispatching

QueueMachine = class("QueueMachine");

function QueueMachine:ctor()
	self.mTimersList = {} 
end

function QueueMachine:dtor()
	self.mTimersList = nil
end

function QueueMachine:getInstance()
 	if not QueueMachine.instance then 
		QueueMachine.instance = QueueMachine.new();
	end
	return QueueMachine.instance;
end

function QueueMachine:delayCommand(func , delay , ...)
	local pak = { func, { ... } };

	 --{}mTimersList是一个消息队列，最大容纳100000条消息;
	local timers = self.mTimersList;
	local id = self.mTimerCount or 0;

	-- 	遍历到队列的最后一条消息，拿到其下标
	while self.mTimersList[id] do
		id = (id + 1) % 100000;  --100000为队列的长度
	end

	self.mTimersList[id] = pak;

	local scheduler = require("framework.scheduler");
	pak[3] = scheduler;

	scheduler.performWithDelayGlobal( function()
		local pak = self.mTimersList[id];
		self.mTimersList[id] = nil;
		if pak then
			pak[1](unpack(pak[2]));
			scheduler = nil
			-- delete(pak[3]);
		end
	end , delay);

	return scheduler;
end

--[[function QueueMachine:onTimerEvent(id)
	local pak = self.mTimersList[id];
	self.mTimersList[id] = nil;
	if pak then
		pak[1](unpack(pak[2]));
		delete(pak[3]);
	end
end]]

function QueueMachine:clearCommands()
	for k, v in pairs(self.mTimersList) do
		delete(v[3]);
	end
	self.mTimersList = {};
end