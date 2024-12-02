local function start()
    term:fullClear()

    local commands = {}
    commands = {
        help = function()
            for k, v in pairs(commands) do
                print(k)
            end
        end,
        version = function(self)
            print("Craft Assistant V"..CA.ver)
        end,
        reboot = function(self)
            CA.reboot()
        end,
        shutdown = function(self)
            CA.shutdown()
        end,
        ["factory reset"] = function(self)
            print("Resetting Craft Assistant to factory settings...")
            require("craft-assistant.factory-reset")
        end,
        refresh = function()
            CA.monitor.refresh = true
        end
    }

    --shorthands
    commands.ver = commands.version

    while true do
        term.write("ca # ")
        local input = read()
        if not commands[input] then print("unknown command '"..input.."'")
        else commands[input]()
        end
    end
end

start()