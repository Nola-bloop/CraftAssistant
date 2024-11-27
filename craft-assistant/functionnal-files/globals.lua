--Craft Assistant file

--global variables (constants)
CA = {
    --info
    version = "1.0",

    --depencies
    logger = require("craft-assistant.libraries.logger"),
    toolkit = require("craft-assistant.libraries.toolkit"),

    --Constant variables (only refresh on reboot (maybe))
    mainMonitor = "setup", --side
    monitorScale = 0.5,

    --addons
    addons = {
        monitor = require("craft-assistant.libraries.addons.monitor-addon")
    },

    paths = {
        caShell     = "/craft-assistant/ca-shell.lua",
        globals     = "/craft-assistant/functionnal-files/globals.lua",
        peripherals = "/craft-assistant/functionnal-files/peripherals.json"
    },
}

--shorthands 
CA.ver = CA.version
CA.log = CA.logger
CA.tools = CA.toolkit