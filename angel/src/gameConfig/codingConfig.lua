-- File : codingConfig.lua
-- Date : 2014.11.04
-- Desc : Require Be Preloaded Coding

require("gameConfig/stringConfig")
-- ------------------------------Common------------------------------------
require("common/constants")
require("common/toolUtil")
require("common/queueUtils")
require("common/queueMachine")
require("common/eventDispatcher")

-- ------------------------------Logic-------------------------------------
require("logic/bit")
require("logic/cardUtil")

-- ----------------------------Game Data-------------------------------------
require("gameData/phpInfo")
require("gameData/eventConstants")

-- ------------------------------sockets-------------------------------------
require("sockets/socketManager")

-- ------------------------------Animation-----------------------------------
require("animation/toast")
