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
    
        CA.monitor:drawBox(
            {x=1, y=3},
            {x=20,y=4+#menus},
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
        CA.GUI.appendDirectory = CA.GUI.peripherals.options[CA.GUI.peripherals.option]
    end
}
