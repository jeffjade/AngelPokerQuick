local RoomScene  = class("RoomScene",function()
	return display.newScene("RoomScene");
end)

function RoomScene:ctor()
	display.newColorLayer(cc.c4b(255, 0, 0,128)):addTo(self);

    cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello,This is the second scene!", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self);

    local images = {
        normal = "GreenButton.png",
        pressed = "GreenScale9Block.png",
        disabled = "GreenButton.png",
    }

    cc.ui.UIPushButton.new(images,{scale9 = true})
    	:setButtonSize(200,80):setButtonLabel("normal",cc.ui.UILabel.new({
            UILabelType = 2,
            text = "返回",
            size = 48,
            color = cc.c3b(128,128,0)
        })):onButtonClicked(function(event)
           local mainScene = require("app.scenes.MainScene").new();
           display.replaceScene(mainScene, "slideInB", 0.6)

    end):align(display.CENTER,display.cx,display.cy+100):addTo(self);
    
end

function RoomScene:onEnter()
end

function RoomScene:onExit()
end

return RoomScene;