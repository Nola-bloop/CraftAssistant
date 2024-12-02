--[[
    Author: Nola (nola.bloop on discord)

    window manager...
]]
local function setup()
    CA.monitor:setColorPalette(CA.colorPalette)
    CA.monitor.setTextScale(CA.monitorScale)
end
setup()
--GUI variables
CA.GUI = {
    --"globals"
    showTabs = false,
    animations = true,
    tabs = {},
    currentTab = 2,
    clickables = {
        --obj = {x1, y1, x2, y2, click()}
    },
    appendDirectory = "";

    --tables for new tabs need a setup() function and a print() function
        --setup() creates the table and puts the default values
        --print() prints the tab and its components
        --refer to the existing tabs for reference
}



--draw tab container
local files = fs.list("/craft-assistant/windows/tabs/")
for k, v in pairs(files) do
    CA.GUI.tabs[k] = string.sub(v, 1, string.len(v)-4) --remove ".lua"
end
for k, v in pairs(CA.GUI.tabs) do
    require("craft-assistant.windows.tabs."..v).setup() --run setup method
end

--get custom library
local windows = require("craft-assistant.libraries.window-manager-lib")

local function refresh()

    --clear buttons
    CA.GUI.clickables = {}

    --clear monitor
    CA.monitor:fullClear(colors.gray)

    --clear whatever this is
    CA.GUI.appendDirectory = ""

    --<page>
        --print header
        require("craft-assistant.windows.partials.header")()

        --print tab content
        require("craft-assistant.windows.tabs."..CA.GUI.tabs[CA.GUI.currentTab]).print()

        --show tabs if open
        if CA.GUI.showTabs then windows.drawTabs(CA.GUI.currentTab) end

        --print footer
        require("craft-assistant.windows.partials.footer")()
    --</page>

    local parallels = {
        listener = function()
            repeat
                local happy = true
                local event, side, arg1, arg2 = os.pullEventRaw()
                if event == "monitor_touch" and side == CA.mainMonitor then
                    --event, side, x, y
                    windows.touch({x=arg1,y=arg2})
                elseif event == "monitor_resize" and side == CA.mainMonitor then
                    --event
                    CA.monitor.refresh = true
                elseif event == "peripheral" then
                    --event, side
                    if CA.peripherals[peripheral.getType(side)][side] ~= nil then
                        CA.peripherals[peripheral.getType(side)][side].connected = true
                    end
                    CA.monitor.refresh = true
                elseif event == "peripheral_detach" then
                    --event, side
                    CA.monitor.refresh = true
                elseif event == "terminate" then
                    CA.log.warn("Someone terminated the Craft Assistant program. Rebooting the PC instead.")
                    CA.reboot()
                else
                    happy = false
                end
            until happy
            CA.log.debug("Exitted listener")
        end,
        skip = function()
            repeat
                os.sleep(0.1)
            until CA.monitor.refresh
            CA.monitor.refresh = false
            setup()
            CA.monitor:setup()
        end
    }

    parallel.waitForAny(parallels.listener, parallels.skip)
end

while true do
    refresh()
end