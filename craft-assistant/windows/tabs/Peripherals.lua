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
        for side, _ in pairs(peripheral) do
            table.insert(side)
        end
    end

    --scan sides
    local scanned = peripheral.getNames()

    
    for k, v in pairs(usedSides) do
        --set connected peripherals to connected and vice-versa
        if not CA.tools.contains(scanned) then
             usedSides[k].connected = false
        else usedSides[k].connected = true end
    end

    local newPeripherals = {}
    for k, v in pairs(scanned) do
        if not CA.tools.contains(usedSides) and v ~= CA.mainMonitor and #{peripheral.getType(v)} == 1 then --don't count already paired deviced, main monitor and peripheral network connector
            table.insert(newPeripherals, v)
        end
    end
    CA.monitor:drawBox(
            {x=1, y=newLine},
            {x=18, y=newLine+1+#newPeripherals},
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
    for k, v in pairs(newPeripherals) do
        CA.monitor:writeAt(
            v,
            {x=2, y=newLine+k},
            colors.gray,
            colors.lightBlue
        )

        CA.monitor:writeAt(
            "+",
            {x=17, y=newLine+k},
            colors.lightBlue,
            colors.gray
        )

        CA.GUI.clickables["peripheral_pair_"..v] = {
            x1 = 17,
            x2 = 17,
            y1 = newLine+k,
            y2 = newLine+k,
            click = function()
                --add peripheral to CA.peripherals
                CA.peripherals[peripheral.getType(v)][v] = {
                    connected = true
                }
            end
        }
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
            }
        }
    end,
    print = function()
        local menus = CA.GUI.peripherals.options
        newLine = CA.monitor.workspace.y+1
    
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
