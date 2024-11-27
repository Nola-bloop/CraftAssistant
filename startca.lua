--Craft Assistant file
--[[
    Author: Nola (nola.bloop on discord)

    This is the startup script for Craft assistant
]]

--fetch global variables
require("craft-assistant.functionnal-files.globals")





--init        
CA.logger.notice("Starting Craft Assistant")      
--find monitor and apply monitor add-on
CA.monitor = CA.tools.addon(peripheral.wrap(CA.mainMonitor), CA.addons.monitor) 
    or CA.logger.warn("No monitor found. Running Craft assistant without UI.")
--add monitor addon to terminal
CA.tools.addon(term, CA.addons.monitor)
--load peripherals
local file = fs.open(CA.paths.peripherals, "r") or CA.log.crash("Unable to read the peripheral file at "..CA.paths.peripherals)
local peripheralsSerializedJson = file.readAll()
file.close()
if peripheralsSerializedJson == "" or not peripheralsSerializedJson then
    peripheralsSerializedJson = textutils.serialiseJSON({
        extensions      = {},
        computers       = {},
        commands        = {},
        drives          = {},
        modems          = {},
        monitors        = {},
        printers        = {},
        redstone_relays = {},
        speakers        = {}
    })
end
local peripheralsUnserializedJson = textutils.unserializeJSON(peripheralsSerializedJson) or CA.logger.crash("Unable to unserialize the connected peripherals file at "..CA.paths.peripherals)
CA.peripherals = peripheralsUnserializedJson
CA.logger.debug(textutils.serialiseJSON(CA.peripherals))
local file = fs.open(CA.paths.peripherals, "w") or CA.log.crash("Unable to write in the peripheral file at "..CA.paths.peripherals)
file.write(peripheralsSerializedJson)
file.flush()
file.close()

--start GUI/CLI
term.clear()
term.setCursorPos(1,1)
print("Craft Assistant V"..CA.ver) 
if not CA.monitor then
    if not CA.mainMonitor or CA.mainMonitor == "setup" or CA.mainMonitor == "nil" and CA.mainMonitor ~= "none" then
        print("No monitor was set up or could not be found. Do you wish to bind one?(Y/n)")
        local input = string.sub(read(),1,1)

        if (input ~= "n" and input ~= "N") then
            input = "n"
            local sideOut = "nil"
            repeat
                print("Please touch the monitor you wish to bind...")
                local event, side, x, y = os.pullEvent("monitor_touch")

                print("Do you wish to bind this monitor?(Y/n) : "..side)
                input = string.sub(read(),1,1)

                term:fullClear()
                if (input ~= "n" and input ~= "N") then
                    sideOut = side
                    print("Successfully bound the main monitor!")
                    CA.log.notice("Main monitor side changed to "..side)
                else
                    print("Please select a new monitor.")
                end
            until sideOut ~= "nil"
            
            CA.toolkit.replaceStringInTable(CA.paths.globals,"mainMonitor", sideOut)
        else
            CA.toolkit.replaceStringInTable(CA.paths.globals,"mainMonitor", "none")
        end
    end

    --handle command line mode
    local caShell = multishell.launch({require = require, CA = CA}, CA.paths.caShell)
    multishell.setTitle(caShell, "Craft Assistant")
    multishell.setFocus(caShell)
else
    --start commandline mode in terminal
    local caShell = multishell.launch({require = require, CA = CA}, CA.paths.caShell)
    multishell.setTitle(caShell, "Craft Assistant")
    multishell.setFocus(caShell)

    require("craft-assistant.windows.window-mgr")
end