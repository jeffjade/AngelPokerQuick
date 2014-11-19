-- File : codingConfig.lua
-- Date : 2014.11.04
-- Desc : Require Be Preloaded Coding

-- ------------------------------Common------------------------------------
require("common/constants")
require("common/toolUtil")
require("common/queueUtils")
require("common/queueMachine")
require("common/eventDispatcher")

-- ------------------------------Logic-------------------------------------
require("logic/bit")
require("logic/cardType")

-- ----------------------------Game Data-------------------------------------
require("gameData/phpInfo")
require("gameData/eventConstants")

-- ------------------------------sockets-------------------------------------
require("sockets/socketManager")
