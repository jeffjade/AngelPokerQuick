
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	cc.ui.UIImage.new("LoginBg.png")
		:align(display.CENTER,display.cx , display.cy)
		:addTo(self)

    cc.ui.UILabel.new({UILabelType = 2, text = "WELCOME OUR GAME",color = cc.c3b(128,99,222), size = 96})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)
end

function MainScene:onEnter()
    self:createScene()
end

function MainScene:onExit()
end

function MainScene:createScene()
	print("MainScene createScene-----------------------------");
	printInfo("MainScene createScene-----------------------------")
	printLog("WARN", "Network connection lost at %d", os.time())
	
	
	-- local scene = display.newScene(name)
	-- local node = singleScene.new(name)
	-- scene:addChild(node)
	-- return scene
	-- display.newColorLayer(cc.c4b(255, 0, 0,255)):addTo(self);

    display.newLine(
    {
        {display.left,display.top},{display.right,display.bottom}
    },
    { 
        borderColor = cc.c4f(0.5,1.0,1.0,0.5),
        borderWidth = 10
    })
    :addTo(self);


    display.newPolygon(
        {
           {display.left+25,display.bottom+15},
           {display.cx,display.bottom+15},
           {display.cx,display.top-15},
           -- {display.left+25,display.top-15}
        }, {borderColor = cc.c4f(1.0,0.0,0.5,1.0),borderWidth=20})
    :addTo(self);


  	local images = {
	    normal = "GreenButton.png",
	    pressed = "GreenScale9Block.png",
	    disabled = "GreenButton.png",
    }

	cc.ui.UIPushButton.new(images,{scale9 = true})
		:setButtonSize(200,80):setButtonLabel("normal",cc.ui.UILabel.new( {
            UILabelType = 2,
            text = "登录",
            size = 48,
            color = cc.c3b(255,0,0)} ))
        :onButtonClicked(function(event)
           local roomScene = require("app.scenes.RoomScene").new();
           display.replaceScene(roomScene, "splitCols", 0.6, cc.TRANSITION_ORIENTATION_UP_OVER)
        end)
        :align(display.CENTER,display.cx,display.cy+200):addTo(self);


    cc.ui.UIPushButton.new({
	    normal = "GreenButton.png",
	    pressed = "GreenScale9Block.png",
	    disabled = "GreenButton.png"} , {scale9 = true})
    :setButtonSize(200,80):setButtonLabel("normal",cc.ui.UILabel.new( {
            UILabelType = 2,
            text = "单机",
            size = 48,
            color = cc.c3b(255,0,0)} ))
	:align(display.CENTER, display.cx, display.cy-100)
	:onButtonClicked(function()
		local singleScene = require(GameRoomPath.."singleRoomScene/singleScene").new()
		display.replaceScene(singleScene,"slideInR",0.5, display.COLOR_WHITE)
	end)
	:addTo(self)
end


return MainScene
