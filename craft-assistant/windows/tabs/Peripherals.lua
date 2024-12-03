--[[
    peripheral structure:
    CA.peripherals = {
        "modem" = {
            modem_01 = {
                connected = true,
                ...
            }
            modem_02 = {...}
        }
        "monitor" = {
            monitor_01 = {...}
        }
    }
]]

local newLine

local function scan()
    --get all sides
    local usedSides = {}
    for type, peripheral in pairs(CA.peripherals) do
        if #peripheral ~= 0 then
            for side, _ in pairs(peripheral) do
                table.insert(usedSides, side)
            end 
        end
    end

    --scan sides
    local scanned = peripheral.getNames()

    
    for k, v in pairs(usedSides) do
        --set connected peripherals to connected and vice-versa
        if not CA.tools.contains(scanned, v) and #v ~= 0 then
             usedSides[k].connected = false
        elseif #v ~= 0 then usedSides[k].connected = true end
    end

    local newPeripherals = {}
    for k, v in pairs(scanned) do
        if CA.peripherals[peripheral.getType(v)][v] == nil and v ~= CA.mainMonitor and #{peripheral.getType(v)} == 1 then --don't count already paired deviced, main monitor and peripheral network connector
            table.insert(newPeripherals, v)
        end
    end

    if #newPeripherals == 0 then table.insert(newPeripherals, "None found.") end
    CA.monitor:drawBox(
            {x=1, y=newLine},
            {x=18, y=CA.monitor.size.y-1},
            colors.purple,
            false,
            colors.lightBlue
        )
    CA.monitor:writeAt(
        "unknown devices",
        {x=1, y=newLine},
        colors.lime,
        colors.purple
    )

    --up&down
    CA.monitor:writeAt(
        "^",
        {x=1, y=newLine+1},
        colors.lime,
        colors.purple
    )
    CA.monitor:writeAt(
        "v",
        {x=1, y=newLine+2},
        colors.lime,
        colors.purple
    )
    CA.GUI.clickables["scan_cursor_decrement"] = {
        x1 = 1,
        x2 = 1,
        y1 = newLine+1,
        y2 = newLine+1,
        click = function()
            CA.GUI.peripherals.scan_cursor = 
            CA.tools.clamp(
                CA.GUI.peripherals.scan_cursor - 1, 
                1, 
                CA.tools.clamp(
                    #newPeripherals- (CA.monitor.size.y- 3 - newLine), 
                    1,
                    #newPeripherals
                    )
            )
        end
    }
    CA.GUI.clickables["scan_cursor_increment"] = {
        x1 = 1,
        x2 = 1,
        y1 = newLine+2,
        y2 = newLine+2,
        click = function()
            CA.GUI.peripherals.scan_cursor = 
            CA.tools.clamp(
                CA.GUI.peripherals.scan_cursor + 1, 
                1, 
                CA.tools.clamp(
                    #newPeripherals- (CA.monitor.size.y- 3 - newLine), 
                    1,
                    #newPeripherals
                    )
            )
        end
    }
    if CA.monitor.refresh then
        CA.GUI.peripherals.scan_cursor = 
            CA.tools.clamp(
                CA.GUI.peripherals.scan_cursor + 1, 
                1, 
                CA.tools.clamp(
                    #newPeripherals- (CA.monitor.size.y- 3 - newLine), 
                    1,
                    #newPeripherals
                    )
            )
    end


    for k, v in pairs(newPeripherals) do
        if k >= CA.GUI.peripherals.scan_cursor and k+1-CA.GUI.peripherals.scan_cursor < CA.monitor.size.y - 1 - newLine then
            local y = newLine+k-CA.GUI.peripherals.scan_cursor+1
            CA.monitor:writeAt(
                v,
                {x=2, y=y},
                colors.gray,
                colors.lightBlue
            )
            if v ~= "None found." then
                CA.monitor:writeAt(
                    "+",
                    {x=17, y=y},
                    colors.lightBlue,
                    colors.gray
                )
            end

            CA.GUI.clickables["peripheral_pair_"..v] = {
                x1 = 17,
                x2 = 17,
                y1 = y,
                y2 = y,
                click = function()
                    --add peripheral to CA.peripherals
                    local new = nil
                    if not CA.peripherals[peripheral.getType(v)][v] then
                        CA.peripherals[peripheral.getType(v)][v] = {}
                        new = CA.peripherals[peripheral.getType(v)][v]
                    else 
                        new = CA.peripherals[peripheral.getType(v)][v]
                    end
                    new.connected = true

                    --update json
                    CA.saveJson()
                end
            }
        end
    end
end

return {
    --- Create the function table and assign the default values
    setup = function()
        CA.GUI.peripherals = {
            option = 1,
            options = {
                [1] = "Scan",
                [2] = "Manage"
            },
            scan_cursor = 1
        }
    end,
    print = function()
        local menus = CA.GUI.peripherals.options
        newLine = CA.monitor.workspace.y+1
    
        --box1
        CA.monitor:drawBox(
            {x=1, y=newLine},
            {x=18, y=newLine+1+#menus},
            colors.lightGray,
            true
        )
    
        --title
        CA.monitor:writeAt(
                "Options",
                {x=1, y=3},
                colors.black,
                colors.lightGray
        )
    
        for k, v in pairs(menus) do
            if k == CA.GUI.peripherals.option then
                CA.monitor:writeAt(
                    "> "..v,
                    {x=2, y=3+k},
                    colors.blue,
                    colors.lightBlue
                )
            else
                CA.monitor:writeAt(
                    "> "..v,
                    {x=2, y=3+k},
                    colors.blue,
                    colors.gray
                )
                CA.GUI.clickables[v] = {
                    type = "peripheralOption",
                    x1 = 2,
                    x2 = 19,
                    y1 = 3+k,
                    y2 = 3+k,
                    click = function()
                        CA.GUI.peripherals.option = k
                    end
                }
            end
        end 
        newLine = newLine+1+#menus+1

        CA.GUI.appendDirectory = CA.GUI.peripherals.options[CA.GUI.peripherals.option]

        if CA.GUI.peripherals.options[CA.GUI.peripherals.option] == "Scan" then scan() end
    end
}
