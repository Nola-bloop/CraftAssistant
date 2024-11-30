return {
    drawTabs = function(index)
        --draw tab container
        local tabs = {}
        local files = fs.list("/craft-assistant/windows/tabs/")
        for k, v in pairs(files) do
            tabs[k] = "> "..string.sub(v, 1, string.len(v)-4) --remove ".lua"
        end
        
        CA.monitor:writeAt(
            "v   Tabs  ",
            {x=1, y=CA.monitor.workspace.y},
            colors.black,
            colors.lightGray
        )
        for i = 1, #tabs do
            if CA.animations and CA.GUI.animations then os.sleep(0.1) end
            if index == i then
                CA.monitor:writeAt(
                tabs[i],
                {x=1,y=CA.monitor.workspace.y+i},
                colors.lime,
                colors.magenta
                )
            else
                CA.monitor:writeAt(
                tabs[i],
                {x=1,y=CA.monitor.workspace.y+i},
                colors.purple,
                colors.gray
                )
                CA.GUI.clickables[tabs[i]] = {
                    x1=1, 
                    y1=CA.monitor.workspace.y+i,
                    x2 =string.len(tabs[i]),
                    y2=CA.monitor.workspace.y+i,
                    click = function()
                        CA.GUI.currentTab = i
                    end
                }
            end 
        end
    end,
    touch = function(pos)
        for k, v in pairs(CA.GUI.clickables) do
            if (
                v.x1 <= pos.x and
                v.y1 <= pos.y and
                v.x2 >= pos.x and
                v.y2 >= pos.y
            ) then
                v.click()
                CA.GUI.animations = true
            else
                CA.GUI.animations = false
            end
        end
    end
}