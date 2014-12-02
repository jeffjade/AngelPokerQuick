-- File : toast.lua
-- Date : 2014.12.01
-- Auth : JeffYang
-- LastModify : 2014.12.01

Toast = class("Toast", function()
		return display.newNode()
	end)

Toast.s_defaultDisplayTime = 2; 
Toast.s_defaultBgImage = "toastBg.png";
Toast.s_defaultSpaceW = 20;
Toast.s_defaultSpaceH = 10;

Toast.getInstance = function(scene)
	Toast.s_instance = Toast.new( scene );
	return Toast.s_instance;
end

function Toast.setDefaultDisplayTime(second)
	Toast.s_displayTime = second or Toast.s_defaultDisplayTime;
end

function Toast.setDefaultImage(bgImg)
	Toast.s_defaultBgImage = bgImg or Toast.s_defaultBgImage;
end 

function Toast:ctor( scene )
	scene:addChild(self)

	self.mToastBg = cc.ui.UIImage.new(Toast.s_defaultBgImage, {scale9 = true})
	    -- :setLayoutSize(220, 80)
	    -- :pos(display.cx , display.cy)
	    :addTo(self)

	self.mContent = cc.ui.UILabel.new({ UILabelType = 2, text = "This is toast anim", 
										size = 30 ,color = cc.c3b(22,222,22)})
        :align(display.CENTER, display.cx, display.cy )
        :addTo(self)
end

function Toast:showText(msg)
	self.mContent:setString(msg)
	local strWidth = 666   --self.mContent:getMaxLineWidth()

	self.mToastBg:setLayoutSize(strWidth , 50)
	self.mToastBg:pos(display.cx - strWidth/2 , display.cy - 25)

	self.mToastBg:setVisible(true)
	self.mContent:setVisible(true)

	print("===================Toast:showText(msg)========================width =" .. strWidth)
	print("===================Toast:showText(msg)==========================msg =" .. msg)
	
	local scheduler = require("framework.scheduler");
	scheduler.performWithDelayGlobal(function()
		-- self.mToastBg:setVisible(false)
		-- self.mContent:setVisible(false)
		transition.fadeOut(self.mToastBg , {time = 2})
		transition.fadeOut(self.mContent , {time = 2})
	end,  Toast.s_defaultDisplayTime )
end

return Toast