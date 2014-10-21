-- Date : 2014-10-261 20:37
-- Desc : ToolUtil 小工具

ToolUtil = {};

-- 将long转换成:xx年xx月xx日xx时xx分xx秒格式
function ToolUtil.getTimeYMD(time)
	local days = "";
	if time and tonumber(time) then
		local timeNum = tonumber(time);
		timeNum = math.abs(timeNum);
		local str = "%Y" .. string_get("yearStr") .. "%m" .. string_get("mouthStr") .. "%d" .. string_get("dayStr") .. "%H" .. string_get("hourStr") .. "%M" .. string_get("minStr") .. "%S" .. string_get("secStr");
		days = os.date(str, timeNum);
	end
	return days;
end

-- 将long转换成:xx-xx-xx
function ToolUtil.getTimeYMDEx(time)
	local days = "";
	if time and tonumber(time) then
		local timeNum = tonumber(time);
		timeNum = math.abs(timeNum);
		local str = "%Y-%m-%d";
		days = os.date(str, timeNum);
	end
	return days;
end

-- 将long转换成:xx月xx日xx:xx:xx格式
function ToolUtil.getTimeMDHMS(time)
	local days = "";
	if time and tonumber(time) then
		local timeNum = tonumber(time);
		timeNum = math.abs(timeNum);
		local str = "%m" .. string_get("mouthStr") .. "%d" .. string_get("dayStr") .. "%H" .. ":%M" .. ":%S";
		days = os.date(str, timeNum);
	end
	return days;
end
--将long转换成：XX-XX xx:xx格式
function ToolUtil.getTimeMDHM(time)
	local days = "";
	if time and tonumber(time) then
		local timeNum = tonumber(time);
		timeNum = math.abs(timeNum);
		local str = "%m-%d" .. "  " .. "%H" .. ":%M";
		days = os.date(str, timeNum);
	end
	return days;
end

-- 拆分时间：00时:00分:00秒
function ToolUtil.skipTime(time)
	local times = nil;
	if time then
		local timeNum = tonumber(time);
		if timeNum then
			timeNum = math.abs(timeNum);
			-- print_string("timeNum---------------->" .. timeNum);
			local hour = math.floor(timeNum / 3600);
			hour = (hour > 0) and hour or 0;
			local min = math.floor((timeNum % 3600) / 60);
			min = (min > 0) and min or 0;
			local sec = math.floor((timeNum % 3600) % 60);
			sec = (sec > 0) and sec or 0;

			hour = string.format("%02d", hour);
			min = string.format("%02d", min);
			sec = string.format("%02d", sec);
			times = hour .. ":" .. min .. ":" .. sec;
		end
	end
	return times or string_get("defaultTimeStr");
end


--拆分金币每3位用逗号隔开
function ToolUtil.skipMoney(curMoney)
	local moneyStr = nil;
	if curMoney and tonumber(curMoney) then
		curMoney = ToolUtil.setInt(curMoney);
		local money = curMoney .. "";
		if curMoney < 0 then
			money = string.sub(money .. "", 2, #money)
		end
		local length = #money;
		local spead = 1;
		for i = length, 0, -3 do
			local x = length - spead * 3 + 1;
			if x < 1 then
				x = 1;
			end
			if moneyStr then
				moneyStr = string.sub(money, x, length - (spead - 1) * 3) .. "," .. moneyStr;
			else
				moneyStr = string.sub(money, x, length - (spead - 1) * 3);
			end
			spead = spead + 1;
		end
		if string.sub(moneyStr, 1, 1) == "," then
			moneyStr = string.sub(moneyStr, 2, #moneyStr);
		end
	end
	if not moneyStr then
		moneyStr = curMoney;
	end
	if curMoney < 0 then
		return "-" .. moneyStr
	end
	return moneyStr;
end

----金币数分级为：w,kw,格式 0~999999 三位一逗号表示 
-- 100W~9999W 用W表示
-- 大于10kw 用kw表示
function ToolUtil.skipMoneyEx(curMoney)
	if curMoney and tonumber(curMoney) then
		if curMoney >= 100000000 then
			local money = math.floor(curMoney / 10000000);
			return ToolUtil.skipMoney(money) .. string_get("moneyQWStr");
		elseif curMoney >= 1000000 then
			local money = math.floor(curMoney / 10000);
			return ToolUtil.skipMoney(money) .. string_get("moneyWanStr");
		else
			return ToolUtil.skipMoney(curMoney);
		end
	end
end

function ToolUtil.skipMoneyByTenthousand(curMoney)
	if curMoney and tonumber(curMoney) then
		if curMoney >= 10000 then
			local money = math.floor(curMoney / 10000);
			return ToolUtil.skipMoney(money) .. string_get("moneyWanStr2");
		else
			return ToolUtil.skipMoney(curMoney);
		end  
	else
	 	return " ";
	end
end

--设置element区域
function ToolUtil.setElemRect(obj, element, diffRect)
	if diffRect.w and diffRect.h then
		element:setRect(obj.m_x + diffRect.x, obj.m_y + diffRect.y, diffRect.w, diffRect.h);
	else
		element:setRect(obj.m_x + diffRect.x, obj.m_y + diffRect.y);
	end
end

--获取utf8字符串的子字符串
function ToolUtil.utf8_substring(str, first, num)
	local ret = "";

	local n = string.len(str);
	local offset = 1;
	local cp;
	local b, e;
	local i = 1;
	while i <= n do
		if not b and offset >= first then
			b = i;
		end
		if not e and offset >= first + num then
			e = i;
			break;
		end
		cp = string.byte(str, i);
		if cp >= 0xF0 then
			i = i + 4;
			offset = offset + 2;
		elseif cp >= 0xE0 then
			i = i + 3;
			offset = offset + 2;
		elseif cp >= 0xC0 then
			i = i + 2;
			offset = offset + 2;
		else
			i = i + 1;
			offset = offset + 1;
		end
	end

	if not b then
		return "";
	end

	if not e then
		e = n + 1;
	end

	ret = string.sub(str, b, e - b);

	return ret;
end

function ToolUtil.subString(str, strMaxLen)
	if nil == str then
		return "";
	end
	return ToolUtil.utf8_substring(str, 1, strMaxLen);
end

function ToolUtil.formatNick(nick, width)
	if not nick then
		return ""
	end
	local subStr = ToolUtil.subString(nick, (width or 9));
	if subStr == "" then
	elseif subStr ~= nick then
		subStr = subStr .. "..."
	end
	return subStr;
end

function ToolUtil.formatText(text, width)
	return ToolUtil.formatNick(text, width)
end

ToolUtil.weakValues = {};
setmetatable(ToolUtil.weakValues, { __mode = "v" });

function ToolUtil.xmlString(str)
	str = string.gsub(str, "(\n)", " ");
	return str;
end

-- 如去除字符串首尾的空格
function ToolUtil.trim(s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function ToolUtil.randomInt(max_num, min_num)
	local min_num = min_num or 0;
	local num = max_num - min_num;
	return (math.floor(math.random() * (num + 1) * (num + 1)) % (num + 1)) + min_num;
end

function ToolUtil.randomItem(tt)
	local count = #tt;
	if count == 0 then
		return;
	end
	local id = ToolUtil.randomInt(count, 1);
	return tt[id], id;
end


--- string 过滤空值
function ToolUtil.setString(param)
	if param then
		return tostring(param);
	else
		return "";
	end
end

--- int 过滤空值
function ToolUtil.setInt(param)
	local result = 0;
	if param then
		if tonumber(param) then
			result = tonumber(param);
		end
	end
	return result or 0;
end


function ToolUtil.compareVersion(ver1, ver2)
	DebugLog("ToolUtil.compareVersion : ver1: %s, ver2: %s",ver1 or "100.0",ver2 or "100.0");
	local vers1 = ver1:split("%.");
	local vers2 = ver2:split("%.");
	local max = #vers1 > #vers2 and #vers1 or #vers2
	for i = 1, max do
		if tonumber(vers1[i]) > tonumber(vers2[i]) then
			return 1;
		elseif tonumber(vers1[i]) < tonumber(vers2[i]) then
			return -1;
		end
	end
	return 0;
end


--- deal昵称屏幕显示长度(主针对W/i/特别字符/昵称过长等问题)
function ToolUtil.dealMnickLen(obj, strData, lenLimit)
	if obj then
		if "win32" == gPlatform then
			obj:setText(ToolUtil.formatNick((strData or " "), 15));
		else
			local strScreenLen, mnickShow = NativeEvent.getStringScreenLen(strData, " ", 22, (lenLimit or 100));
			obj:setText(mnickShow);
		end
	end
end

function ToolUtil.checkPhoneNum(phoneNum)
	local start, length = string.find(phoneNum, "^1[3|4|5|8][0-9]%d+$"); -- 判断手机号码是否正确
	if start ~= nil and length == 11 then
		return true;
	else
		return false;
	end
end

function ToolUtil.emptySpace(txt, len)
	if not txt then return end 
	local str = "";
	local sp = " ";
	local txt = txt
	local n = math.ceil(len/9);
	for i=1,n do
		str = str .. sp;
	end
	local txt = str .. "    " .. txt;
	return txt
end

function print_lua_table (lua_table, indent)
	if gDebug or not lua_table or type(lua_table) ~= "table" then 
		return;
	end

	indent = indent or 0
	for k, v in pairs(lua_table) do
		if type(k) == "string" then
			k = string.format("%q", k)
		end
		local szSuffix = ""
		if type(v) == "table" then
			szSuffix = "{"
		end
		local szPrefix = string.rep("    ", indent)
		formatting = szPrefix.."["..k.."]".." = "..szSuffix
		if type(v) == "table" then
			print(formatting)
			print_lua_table(v, indent + 1)
			print(szPrefix.."},")
		else
			local szValue = ""
			if type(v) == "string" then
				szValue = string.format("%q", v)
			else
				szValue = tostring(v)
			end
			print(formatting..szValue..",")
		end
	end
end

function ToolUtil.concatString(...)
	local data={...}
	local str=""
	for i,v in ipairs(data) do
		local v= tostring(v)
		if v and type(v)=="string" then
			str = str .. v
		end
	end
	return str
end