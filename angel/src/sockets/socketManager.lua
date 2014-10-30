cc.net = require("framework.cc.net.init");

local SocketManager = class("socketManager");

SocketManager.instance = nil;

function SocketManager.getInstance()
	if not SocketManager.instance then 
		SocketManager.instance = SocketManager.new();
	end
	return SocketManager.instance;
end

function SocketManager.releaseInstance()
	
end

function SocketManager:ctor()
	self.mSocket = nil;
	self.m_isSocketOpening = false; -- socket正在打开标识
	self.m_isSocketOpened = false; 	-- socket已经打开标识
end

function SocketManager:openSocket(ip,port)
	self.mSocket = cc.net.SocketTCP.new(ip,port,false);
	self.mSocket:addEventListener(cc.net.SocketTCP.EVENT_CONNECTED,handler(self,self.onSocketConnected));
	self.mSocket:addEventListener(cc.net.SocketTCP.EVENT_CLOSE,handler(self,self.onClose));
	self.mSocket:addEventListener(cc.net.SocketTCP.EVENT_CLOSED, handler(self,self.onClosed));
	self.mSocket:addEventListener(cc.net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self,self.onConnectFail));
	self.mSocket:addEventListener(cc.net.SocketTCP.EVENT_DATA, handler(self,self.onData));
	self.mSocket:connect();
end

function SocketManager:onSocketConnected()
	print("SocketManager.onSocketConnected()-->");
end

function SocketManager:onClose()
	print("SocketManager.onClose()---->");
end

function SocketManager:onClosed()
	print("SocketManager.onClosed()--->");
end

function SocketManager:onConnectFail()
	print("SocketMaanager:onConnectFail()-->");
end

function SocketManager:onData()
	print("SocketManager.onData()--->");
end

function SocketManager:dtor()
end

return SocketManager;