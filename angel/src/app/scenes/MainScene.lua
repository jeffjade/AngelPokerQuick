
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	cc.ui.UIImage.new("login/LoginBg.png")
		:align(display.CENTER,display.cx , display.cy)
		:addTo(self)

    cc.ui.UILabel.new({UILabelType = 2, text = "Welcome To Our Game",color = cc.c3b(128,99,222), size = 96})
        :align(display.CENTER, display.cx, display.cy + 300)
        :addTo(self)
end

function MainScene:onEnter()
    self:createScene()
end

function MainScene:onExit()
end

function MainScene:createScene()
	print("MainScene createScene-----------------------------");
	printLog("WARN", "Network connection lost at %d", os.time())
	
    --[[
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
    :addTo(self);]]


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
           local roomScene = require(GameRoomPath.."roomScene").new();
           display.replaceScene(roomScene, "splitCols", 0.6, cc.TRANSITION_ORIENTATION_UP_OVER)
        end)
        :align(display.CENTER,display.cx,display.cy + 100):addTo(self);


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


    local loseAnim = require("animation/animLose").new()
    self:addChild(loseAnim)
    loseAnim:start()

    -- self:createNumberAnim()
    Toast.getInstance(self):showText("TEST TOAST HERE 创建一个帧动画")
end

-- 创建一个帧动画
function MainScene:createNumberAnim()
    display.addSpriteFrames("loseWind.plist", "loseWind.png") --添加帧缓存
    local sp = display.newSprite("#wind01.png", display.cx, display.cy)
    -- local frames = display.newFrames("wind%02d.png", 1, 11)
    self:addChild(sp)

    local frames = display.newFrames("wind%02d.png", 1, 11)
    local animation = display.newAnimation(frames, 2.8/14.0)
    sp:playAnimationOnce(animation )
end

return MainScene
