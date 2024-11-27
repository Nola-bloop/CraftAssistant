--Craft Assistant file

--global variables (constants)
CA = {
    --info
    version = "1.0",

    --depencies
    logger = require("craft-assistant.libraries.logger"),
    toolkit = require("craft-assistant.libraries.toolkit"),

    --Constant variables (only refresh on reboot (maybe))
    mainMonitor = "none", --side

    --addons
    addons = {
        monitor = require("craft-assistant.libraries.addons.monitor-addon")
    }
}

--shorthands 
CA.ver = CA.version
CA.log = CA.logger
CA.tools = CA.toolkit