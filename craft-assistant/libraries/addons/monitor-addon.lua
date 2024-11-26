--[[
    Author: Nola (nola.bloop on discord)

    Monitor module add-on that adds some functions to ease manipulation

    usage:
        local monitor = CA.tools.addon(peripheral.find("monitor"), CA.addons.monitor)
        monitor:fullClear(colors.white)
        
]]

local module = {}


function module.fullClear(self, color, cursorX, cursorY)
    --sanity checks
    color   = color     or colors.black
    cursorX = cursorX   or 1
    cursorY = cursorY   or 1


    self.setBackgroundColor(color)
    self.clear()
    self.setCursorPos(1,1)
end

return module