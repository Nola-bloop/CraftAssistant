local function start()
    term:fullClear()
    while true do
        term.write("ca # ")
        local input = read()

        if input == "version" or input == "ver" then
            print("Craft Assistant V"..CA.ver)
        elseif input == "reboot" then
            CA.logger.warn("Command line triggered a controlled reboot.")
            os.reboot()
        elseif input == "shutdown" then
            CA.logger.warn("Command line triggered a controlled shutdown.")
            os.shutdown()
        elseif input == "factory reset" then
            print("Resetting Craft Assistant to factory settings...")
            require("craft-assistant.factory-reset")
        end
    end
end

start()