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
end

return MyApp