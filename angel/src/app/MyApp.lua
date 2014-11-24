require("config")
require("framework.init")
require("gameConfig/codingConfig")
require(GameRoomPath .. "eventDispatchController")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("MainScene")

     -- 清空输出的日志
    local outLogFile = io.open("DebugLogFile.txt", "w")
    local newLogTime = ToolUtil.getTimeYMD(os.time())
    outLogFile:write("##DebufLog"..newLogTime)
    outLogFile:close()
end

return MyApp