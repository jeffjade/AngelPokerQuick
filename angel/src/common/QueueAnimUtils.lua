-- 队列动画工具
local QueueAnimUtils = class("QueueAnimUtils");

QueueAnimUtils.instance = nil;

function QueueAnimUtils:ctor()
	self.queueAnim = {};
	self.isPlaying = false;
end

function QueueAnimUtils:getInstance()
 	if not QueueAnimUtils.instance then 
		QueueAnimUtils.instance = QueueAnimUtils.new();
	end
	return QueueAnimUtils.instance;
end

--同步执行方法,加进来的方法会直接执行，不用手动调用asyncDelayCommand
function QueueAnimUtils:sychronizedDelayCommand(obj,funcName,second,...)
	self:addAnimForQueue(obj,funcName,second,...);
	self:asyncDelayCommand();
end

--添加需要执行的队列动画方法(对象，函数名，时间，函数参数)
function QueueAnimUtils:addAnimForQueue(obj,funcName,second,...)
	local queueFunc = {};
	queueFunc.object = obj;
	
	queueFunc.funcName = funcName;

	queueFunc.funcParam = {...};
	queueFunc.second = second;

	table.insert(self.queueAnim,queueFunc);
end

--异步执行这个方法，但之前必须要addAnimForQueue
function QueueAnimUtils:asyncDelayCommand()
	if self.queueAnim then 
		local scheduler = require("framework.scheduler");
		for i=1,#self.queueAnim do 
			local obj = self.queueAnim[i].object;

			local funcName = self.queueAnim[i].funcName;
			local funcParam = self.queueAnim[i].funcParam;
			local second = self.queueAnim[i].second;
			scheduler.performWithDelayGlobal(function()
				if #funcParam ~= 0 then 
					funcName(obj,unpack(funcParam));
				else
					funcName();
				end
				table.remove(self.queueAnim[i]);
			end,second);
		end
	end
end

return QueueAnimUtils;