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
        green       = "202942",
        red         = "FFAEAE",
        black       = "1A1429",
    },




    --functions
    reboot = function()
        CA.logger.warn("Command line triggered a controlled reboot.")
        CA.monitor:fullClear(colors.black)
        local msg = "Computer is rebooting..."
        CA.monitor:writeAt(
            msg,
            {x=CA.monitor.mid.x-string.len(msg)/2, y=CA.monitor.mid.y},
            colors.lightGray,
            colors.black
        )
        CA.monitor:writeAt(
            "Craft Assistant V"..CA.ver,
            {x=CA.monitor.size.x, y=CA.monitor.size.y},
            colors.lightGray,
            colors.black,
            nil,
            true
        )
        os.reboot()
    end,

    shutdown = function()
        CA.logger.warn("Command line triggered a controlled shutdown.")
        CA.monitor:fullClear(colors.black)
        local msg = "Computer is off"
        CA.monitor:writeAt(
            msg,
            {x=CA.monitor.mid.x-string.len(msg)/2, y=CA.monitor.mid.y},
            colors.lightGray,
            colors.black
        )
        CA.monitor:writeAt(
            "Craft Assistant V"..CA.ver,
            {x=CA.monitor.size.x, y=CA.monitor.size.y},
            colors.lightGray,
            colors.black,
            nil,
            true
        )
        os.sleep(1)
        os.shutdown()
    end,

    saveJson = function()
        local json = textutils.serialiseJSON(CA.peripherals)
        local file = fs.open(CA.paths.peripherals, "w")
        file.write(json)
        file.flush()
        file.close()
    end,



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