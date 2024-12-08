--[[
    Author: Nola (nola.bloop on discord)

    Monitor module add-on that adds some functions to ease manipulation

    example:
        local monitor = CA.tools.addon(peripheral.find("monitor"), CA.addons.monitor)
        monitor:fullClear(colors.white)
    --it's important to use ":" to call the functions to send the "self" parameter
        
]]

local module = {}

--- give the module constants
---@param object object @should be self (target)
function module.setup(object, parent)
    parent = parent or peripheral.wrap(CA.mainMonitor)

    object.parent = parent
    object.size = {}
    object.mid = {}
    object.size.x, object.size.y = object.getSize()
    object.mid.x = object.size.x/2
    object.mid.y = object.size.y/2
    object.workspace = {}
    object.workspace.x = {}
    for i = 1, object.size.x+6/21 do
        if i == 1 then
            table.insert(object.workspace.x, i*21-20)
        else
            table.insert(object.workspace.x, i*21-20-3)
        end
    end
end

--- Complete a full clear of the monitor
---@param self any
---@param color color       @color to fill the monitor in
function module.fullClear(self, color)
    --sanity checks
    color   = color     or colors.black


    self.setBackgroundColor(color)
    self.clear()
    self.setCursorPos(1,1)
end

--- More complete monitor.write() function
---@param self any
---@param text string       @text to write
---@param pos table         @{x, y} position to write at
---@param size integer      @Size to write in
---@param textColor color   @color of the text (e.g. colors.white)
---@param bgColor color     @color of the background
---@param wrap integer      @max characters on one line
---@param pointToEnd boolean @put to true if the coordinates are pointing at the end of the text instead of the beginning
function module.writeAt(self, text, pos, textColor, bgColor, wrap, pointToEnd)
    --sanity checks
    pos.x = pos.x or 1
    pos.y = pos.y or 1
    if pointToEnd == nil then pointToEnd = false end

    if pointToEnd then
        if wrap and wrap > string.len(text) then
            pos.x = pos.x-string.len(text)
        else
            pos.x = pos.x-string.len(text)
        end
    end

    if bgColor then self.setBackgroundColor(bgColor) end
    if textColor then self.setTextColor(textColor) 
    
    end
    self.setCursorPos(pos.x, pos.y)
    if wrap ~= nil and wrap < string.len(text) then
        local fractions = {}
        repeat
            local space = string.len(text)
            for i = 1, wrap do
                if string.sub(text, i,i) == " " then
                    space = i
                end
            end
            table.insert(fractions, string.sub(text, 1, space-1))
            if space == string.len(text) then break end
            text = string.sub(text, space+1, string.len(text))
        until string.len(text) < wrap

        table.insert(fractions, text)

        for i = 1, #fractions do
            if pointToEnd then
                self.setCursorPos(pos.x-string.len(fractions[i]),pos.y-1+i)
            else
                self.setCursorPos(pos.x,pos.y-1+i)
            end
            if not textColor then
                for i = 1, string.len(text) do
                    local x, y = self.getCursorPos()
                    local col = self.getBackgroundColor()
                    self.write(string.sub(text, i,i))
                end
            else
                self.write(fractions[i])
            end
        end
    else
        self.write(text)
    end
end

--- Draw a square at the specified coordinates in the given color
---@param pos1 table    @{x, y} where to start drawing
---@param pos2 table    @{x, y} where to end drawing
---@param color color   @color to fill the square in
---@param isHollow boolean @set to true if box must be hollow
---@param fill color @color to fill the box. will override isHollow if not null
function module.drawBox(self, pos1, pos2, color, isHollow, fill)
    --nil checks
    pos1.x = pos1.x or CA.log.crash("pos1.x cannot be nil: monitor-addon.drawSquare()")
    pos2.x = pos2.x or CA.log.crash("pos2.x cannot be nil: monitor-addon.drawSquare()")
    pos1.y = pos1.y or CA.log.crash("pos1.y cannot be nil: monitor-addon.drawSquare()")
    pos2.y = pos2.y or CA.log.crash("pos2.y cannot be nil: monitor-addon.drawSquare()")
    isHollow = isHollow or false

    if pos1.x > pos2.x then CA.log.crash("pos1.x cannot be greater than pos2.x : monitor-addon.drawSquare()") end
    if pos1.y > pos2.y then CA.log.crash("pos1.y cannot be greater than pos2.y : monitor-addon.drawSquare()") end

    color = color or CA.log.crash("color cannot be nil: monitor-addon.drawSquare()")

    local colorIsColor = false
    for k, v in pairs(colors) do
        if v == color then colorIsColor = true end
    end
    if not colorIsColor then CA.log.crash("color is not a color: monitor-addon.drawSquare()") end


    self.setCursorPos(pos1.x,pos1.y)
    self.setBackgroundColor(color)

    for i = pos1.y, pos2.y do
        self.setCursorPos(pos1.x,i)
        for j = pos1.x, pos2.x do
            if isHollow then
                if i == pos1.y or i == pos2.y or j == pos1.x or j == pos2.x then
                    self.setCursorPos(j,i)
                    self.write(" ")
                else

                end
            else
                self.setCursorPos(j,i)
                self.write(" ")
            end
        end
    end

    if fill then
        self.setBackgroundColor(fill)
        for i = pos1.y+1, pos2.y-1 do
            for j = pos1.x+1, pos2.x-1 do
                self.setCursorPos(j,i)
                self.write(" ")
            end
        end
    end
end

--- set the color palette of the monitor
---@param self any
---@param colorPalette table @table of colors to apply.
function module.setColorPalette(self, colorPalette)
    for k, v in pairs(colorPalette) do
        self.setPaletteColor(colors[k], tonumber("0x"..colorPalette[k]))
        term.setTextColor(colors[k])
    end
end

return module