--header
return function()
    if (string.len("Craft Assistant V"..CA.ver)+string.len(CA.date()) > CA.monitor.size.x) then
        CA.monitor:drawBox({x=1,y=1},{x=CA.monitor.size.x,y=2}, colors.black)
        CA.monitor.workspace = {x = 1, y=3}
    else
        CA.monitor:drawBox({x=1,y=1},{x=CA.monitor.size.x,y=1}, colors.black)
        CA.monitor.workspace = {x = 1, y=2}
    end
    
    --write CA version
    CA.monitor:writeAt(
        "Craft Assistant V"..CA.ver, 
        {x=1,  y=1},  
        colors.white, 
        nil, 
        CA.monitor.mid.x
    )
    
    --write date
    CA.monitor:writeAt(
        CA.date(), 
        {x=CA.monitor.size.x+1, y=1},  
        colors.white, 
        nil, 
        CA.monitor.size.x-CA.monitor.mid.x, 
        true
    )
    
    --write the '>' for the tabs
    CA.monitor:writeAt(
        ">",
        {x=1, y=CA.monitor.workspace.y},
        colors.black,
        colors.lightGray
    )
    CA.GUI.clickables.tabsButton = {
        x1=1, 
        y1=CA.monitor.workspace.y, 
        x2 = 1, 
        y2 = CA.monitor.workspace.y,
        click = function()
            if CA.GUI.showTabs then CA.GUI.showTabs = false
            else CA.GUI.showTabs = true end
        end
    }
end
