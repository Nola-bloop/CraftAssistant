--- cp /craft-assistant/examples/eg-tab.lua /craft-assistant/windows/tabs/NewTab.lua
-- The window manager (window-mgr.lua) generates the tab automatically when it sees a new lua file in the tabs/ folder

return {
    --- Create the function table and assign the default values
    setup = function()
        --[[
            CA.GUI.example = {}
            CA.GUI.example.index = 1
            CA.GUI.example.tabs = {...}
            ...
        ]]
    end,
    --- Print the tab's GUI
    print = function()
        --[[
            CA.monitor.writeAt:(
                "example",
                ...
            )
        ]]
    end
}