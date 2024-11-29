return function()
    local count = 1
    for k,v in pairs(CA.colorPalette) do
        CA.monitor:drawBox({x=count,y=CA.monitor.size.y},{x=count+1, y=CA.monitor.size.y},colors[k])
        count = count +2;
    end
end
