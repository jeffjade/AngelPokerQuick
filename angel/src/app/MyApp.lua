
require("config")
require("framework.init")

require("gameConfig/codingConfig")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

GameRoomPath = "scenes/room/"

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    --self:enterScene("MainScene")
    self:enterScene("RoomScene")

    print_lua_table({"adsf","asdf"})
    -- require("scenes.room").new():run()
    -- local singleScene = require(GameRoomPath.."singleRoomScene/singleScene")
    -- display.replaceScene(singleScene)
end

return MyApp