--[[
    Author: Nola (nola.bloop on discord)

    Monitor module add-on that adds some functions to ease manipulation

    usage:
        local monitor = CA.tools.addon(peripheral.find("monitor"), CA.addons.monitor)
        monitor:fullClear(colors.white)
        
]]

local module = {}

function module.setup(object)
    object.size = {}
    object.mid = {}
    object.size.x, object.size.y = object.getSize()
    object.mid.x = object.size.x/2
    object.mid.y = object.size.y/2
end

function module.fullClear(self, color, cursorX, cursorY)
    --sanity checks
    color   = color     or colors.black
    cursorX = cursorX   or 1
    cursorY = cursorY   or 1


    self.setBackgroundColor(color)
    self.clear()
    self.setCursorPos(1,1)
end

--- More complete monitor.write() function
---@param self any
---@param text string   @text to write
---@param x integer     @X position where to write
---@param y integer     @Y position where to write
---@param size integer  @Size to write in
---@param textColor color   @color of the text (e.g. colors.white)
---@param bgColor color     @color of the background
---@param endx integer
---@param endy integer
function module.writeAt(self, text, x, y, size, textColor, bgColor, endx, endy)
    --sanity checks
    x = x or 1
    y = y or 1

    if bgColor then self.setBackgroundColor(bgColor) end
    if textColor then self.setTextColor(textColor) end
    if size then self.setTextScale(size) end
    self.setCursorPos(x,y)
    self.write(text)

    x, y = self.getCursorPos()
    if endx then self.setCursorPos(endx, y) end
    x, y = self.getCursorPos()
    if endy then self.setCursorPos(x, endy) end

    self.setTextScale(CA.monitorScale)
end

return module