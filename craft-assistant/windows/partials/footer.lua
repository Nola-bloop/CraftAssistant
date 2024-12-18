return function()

    --print tab name
    local color = nil
    if #CA.monitor.workspace.x%2 == 1 then color = colors.gray
    else color = colors.green end
    CA.monitor:writeAt(
        CA.GUI.tabs[CA.GUI.currentTab].." > "..CA.GUI.appendDirectory, 
        {x=CA.monitor.size.x, y=CA.monitor.size.y},  
        colors.lightGray, 
        color,
        nil, 
        true
    )

    -- print color palette
    local count = 1
    for k,v in pairs(CA.colorPalette) do
        CA.monitor:drawBox({x=count,y=CA.monitor.size.y},{x=count+1, y=CA.monitor.size.y},colors[k])
        count = count +2;
    end

end