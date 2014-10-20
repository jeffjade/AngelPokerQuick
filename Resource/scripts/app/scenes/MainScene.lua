
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	local button = display.newSprite("RemoveCoinButton.png", display.right - 100, display.bottom + 100)
    self:addChild(button)
    self.removeButtonBoundingBox = button:getBoundingBox()

    ui.newTTFLabel({text = "Hello, EveryOne!@Chen", size = 64, align = ui.TEXT_ALIGN_CENTER})
        :pos(display.cx, display.cy)
        :addTo(self)

    self:createButtons()
end

function MainScene:createButtons()
    local images = {
        normal = "GreenButton.png",
        pressed = "GreenScale9Block.png",
        disabled = "GreenButton.png",
    }
    cc.ui.UIPushButton.new(images, {scale9 = true})
        :setButtonSize(200, 60)
        :setButtonLabel("normal", ui.newTTFLabel({
            text = "New Game",
            size = 32
        }))
        :onButtonClicked(function(event)
            self:restartGame()
        end)
        :align(display.CENTER_TOP, display.left+display.width/2, display.top - 170)
        :addTo(self)
end


function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
