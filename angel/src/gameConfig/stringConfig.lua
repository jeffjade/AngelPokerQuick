-- File : stringConfig.lua
-- Date : 2014.11.19 20:56
-- Auth : JeffYang

string_get = function(key)
	local str = stringLocalize[key];
	if str and type(str) == "string" then
		return str;
	else
		return str;
	end
end

stringLocalize = {
	---------------------------------------------------------------
	moneyQianStr = "K";
	moneyWanStr = "W";
	moneyWanStr2 = [[萬]];
	moneyZhaoStr = "M";
	moneyQWStr  = "KW";
	moneyYiStr = [[億]];
	---------------------------------------------------------------
	goldTxStr = "金幣";
	cancelStr = "取消";
	okStr = "確定";
	returnStr = "返回";
	dialogTitleStr = "溫馨提示";
	yearStr = "年";
	mouthStr = "月";
	dayStr = "日";
	hourStr = "時";
	minStr = "分";
	secStr = "秒";
	---------------------------------------------------------------
} 