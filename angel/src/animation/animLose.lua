-- File : animLose.lua
-- Date : 2014.11.27
-- Desc : animLose
-- Auth : JeffYang

AnimLose = class("AnimLose" , function()
		return display.newNode()
	end)

function AnimLose:ctor()
end

function AnimLose:start()
	display.addSpriteFrames("loseWind.plist", "loseWind.png")
	local frames = display.newFrames("wind%02d.png", 1, 11)
	local sprite = display.newSprite("#wind01.png", display.cx, display.cy)
	self:addChild(sprite)

	local animation = display.newAnimation(frames, 3 / 11)
	local function onComplete()  
		print("AnimLose Complete====================================== fuck !!!") 
	end
	sprite:playAnimationOnce(animation , true , onComplete)
end

return AnimLose