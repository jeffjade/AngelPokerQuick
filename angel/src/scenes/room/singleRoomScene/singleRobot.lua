-- File: singleRobot.lua
-- Date: 2014.10.27 22:32
-- Auth: JeffYang

local handsomeManNick = {
	"车骑将军",
	"项少羽",
	"吕小布",
	"独孤求败",
}

local handsomeManNick2 = {
	"屠苏百里",
	"怡红公子",
	"纪晓岚",
	"甄宝玉",
}

local uglyManNick = {
	"岳老湿",
	"如花",
	"貌美如画",
	"鬼见我愁",
}

local prettyGrilNick = {
	"李师师",
	"千颂伊",
	"汉宫飞燕",
	"好双儿",
}

local smartGrilNick = {
	"琳琅",
	"若曦",
	"梅绛雪",
	"小妹玉环",
}

local cryGrilNick = {
	"小哭侠",
	"萌芷若",
	"邻家女孩",
	"我就这样",
}

local smileGrilNick = {
	"好彩妹",
	"小东邪",
	"我就是我",
	"云淡风轻",
}

local singleRobot = {
	{
		name = ToolUtil.randomItem(uglyManNick);
		sex = PhpInfo.MALE;
		icon = "room/computer_icon_1.png";
	},
	{
		name = ToolUtil.randomItem(handsomeManNick);
		sex = PhpInfo.MALE;
		icon = "room/computer_icon_2.png";
	},
	{
		name = ToolUtil.randomItem(prettyGrilNick);
		sex = PhpInfo.FAMLE;
		icon = "room/computer_icon_3.png";
	},
	{
		name = ToolUtil.randomItem(uglyManNick);
		sex = PhpInfo.FAMLE;
		icon = "room/computer_icon_4.png";
	},
	{
		name = ToolUtil.randomItem(cryGrilNick);
		sex = PhpInfo.FAMLE;
		icon = "update/updateDZCry.png";
	},
	{
		name = ToolUtil.randomItem(smileGrilNick);
		sex = PhpInfo.FAMLE;
		icon = "update/updateGuide.png";
	},
	{
		name = ToolUtil.randomItem(smartGrilNick);
		sex = PhpInfo.FAMLE;
		icon = "defaultPlayer_Girl.png";
	},
	{
		name = ToolUtil.randomItem(handsomeManNick2);
		sex = PhpInfo.MALE;
		icon = "defaultPlayer_Boy.png";
	},
}; 

return singleRobot