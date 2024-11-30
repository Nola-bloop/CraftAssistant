--[[
    Author: Nola (nola.bloop on discord)

    window manager...
]]
CA.monitor:setColorPalette(CA.colorPalette)
CA.monitor.setTextScale(CA.monitorScale)

--GUI variables
CA.GUI = {
    showTabs = false,
    animations = true,
    tabs = {},
    currentTab = 2,
    clickables = {
        --obj = {x1, y1, x2, y2, click()}
    }
}

--get custom library
local windows = require("craft-assistant.windows.window-manager-lib")

local function refresh()
    --clear monitor
    CA.monitor:fullClear(colors.gray)

    --print header
    require("craft-assistant.windows.partials.header")()

    --show tabs if open
    if CA.GUI.showTabs then windows.drawTabs(CA.GUI.currentTab) end

    --print footer
    require("craft-assistant.windows.partials.footer")()

    local event, side, x, y = os.pullEvent("monitor_touch")
    print("Touched "..x..";"..y)
    windows.touch({x=x,y=y})
end

while true do
    refresh()
end