--File : MyScene.lua
--Date : 2014.10.17:11

local MyScene = class("MyScene", function ()  
    return display.newScene("myscene")  
end)  
   
function MyScene:ctor()
    display.newSprite("hello.png"):addTo(self);
    -- ui("room/ffff.png"):addTo(self);
   	
   	-- local menuItem = ui.newImageMenuItem({image = "GreenScale9Block.png"})
   	-- ui.newMenu(menuItem):addTo(self)

    ui.newTTFLabel({text = "Hello, World!@Fuck @you", align = ui.TEXT_ALIGN_CENTER, x = display.cx, y = display.height*0.9}):addTo(self)  
    -- self:createButtons()
end  
   
function MyScene:createButtons()
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

return MyScene 