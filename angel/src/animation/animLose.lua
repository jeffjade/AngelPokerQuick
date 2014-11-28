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
	-- display.addSpriteFrames("loseWind.plist", "loseWind.png") --添加帧缓存
	-- local sp = display.newSprite("#wind01.png", display.cx, display.cy)
	-- self:addChild(sp)
	-- local frames = display.newFrames("wind_d.png", 1, 11)
	-- local animation = display.newAnimation(frames, 2.8/14.0)
	-- sp:playAnimationOnce(animation)


	display.addSpriteFrames("loseWind.plist", "loseWind.png")

	--[[
	local frames = display.newFrames("wind%02d.png", 1, 11)
	local animation = display.newAnimation(frames, 2 / 11) -- 0.5 秒播放 8 桢
	display.setAnimationCache("loseWind", animation)

	-- 在需要使用 Walk 动画的地方
	local sprite = display.newSprite("wind01.png")
	sprite:setPosition(100, 300)
	self:addChild(sprite)

	local function onComplete()  
		print("====================================== fuck !!!") 
	end
	print("====================================== fuck !!!===================") 
	-- display.getAnimationCache("loseWind")
	-- transition.playAnimationOnce(sprite , animation, true , onComplete , 1) -- 播放一次动画

	transition.playAnimationForever(sprite , animation, 1)]]

	
	local frames = display.newFrames("wind%02d.png", 1, 11)
	local sp = display.newSprite("#wind01.png", display.cx, display.cy)
	self:addChild(sp)

	local animation = display.newAnimation(frames, 3 / 11) -- 0.5 秒播放 8 桢
	local function onComplete()  
		print("====================================== fuck !!!") 
	end
	sp:playAnimationOnce(animation , true , onComplete)
end

return AnimLose