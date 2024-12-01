--Craft Assistant file

--global variables (constants)
CA = {
    --info
    version = "1.0",
    date = function(locale)
        locale = locale or "local"
        local time = os.epoch(locale) / 1000
        return os.date("%A %d %B %Y",time)
    end,
    --depencies
    logger = require("craft-assistant.libraries.logger"),
    toolkit = require("craft-assistant.libraries.toolkit"),

    --Constant variables (only refresh on reboot (maybe))
    mainMonitor = "top", --side
    monitorScale = 0.5,
    animations = true,
    colorPalette = {
        white       = "F5FEFF",
        orange      = "FFBE84",
        magenta     = "8A73E5",
        lightBlue   = "8099F2",
        yellow      = "F6FCAA",
        lime        = "B8DE5D",
        pink        = "FFDCEB",
        gray        = "283454",
        lightGray   = "4A608F",
        cyan        = "99C2DE",
        purple      = "5D4870",
        blue        = "AFECFF",
        brown       = "7F6A5B",
        green       = "636E64",
        red         = "FFAEAE",
        black       = "1A1429",
    },
    --peripherals = {}  (declared in startca.lua)

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

--peripherals