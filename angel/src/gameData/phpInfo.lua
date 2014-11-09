-- File : phpInfo.lua
-- Date : 2014.11.08 1:40
-- Desc : Record phpInfo and Gameinfo

PhpInfo = {}

PhpInfo.MALE  = 1
PhpInfo.FMALE = 2

function PhpInfo:setMoney(money)
	PhpInfo.mMoney = money
end

function PhpInfo:getMoney()
	return PhpInfo.mMoney
end 


function PhpInfo:setMid(mid)
	PhpInfo.mMid = mid or 0
end

function PhpInfo:getMid()
	return PhpInfo.mMid
end


function PhpInfo:setSex(sex)
	PhpInfo.mSex = sex or PhpInfo.MALE
end

function PhpInfo:getSex()
	return PhpInfo.mSex
end
