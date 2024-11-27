--Craft Assistant file
--[[
    Author: Nola (nola.bloop on discord)

    This is the startup script for Craft assistant
]]

--fetch global variables
require("craft-assistant.functionnal-files.globals")

CA.logger.notice("Starting Craft Assistant")

--init              find monitor and apply monitor add-on
local monitor = CA.tools.addon(peripheral.wrap(CA.mainMonitor), CA.addons.monitor) 
    or CA.logger.warn("No monitor found. Running Craft assistant without UI.")
--add monitor addon to terminal
CA.tools.addon(term, CA.addons.monitor)


term.clear()
term.setCursorPos(1,1)
print("Craft Assistant V"..CA.ver) 
if not monitor then
    if not CA.mainMonitor or CA.mainMonitor == "setup" or CA.mainMonitor == "nil" or not monitor and CA.mainMonitor ~= "none" then
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
            
            CA.toolkit.replaceStringInTable("/craft-assistant/functionnal-files/globals.lua","mainMonitor", sideOut)
        else
            CA.toolkit.replaceStringInTable("/craft-assistant/functionnal-files/globals.lua","mainMonitor", "none")
        end
    end

    --handle command line mode
    local caShell = multishell.launch({require = require, CA = CA}, "/craft-assistant/ca-shell.lua")
    multishell.setTitle(caShell, "Craft Assistant")
    multishell.setFocus(caShell)
else
    --start commandline mode in terminal
    local caShell = multishell.launch({require = require, CA = CA}, "/craft-assistant/ca-shell.lua")
    multishell.setTitle(caShell, "Craft Assistant")
    multishell.setFocus(caShell)
end