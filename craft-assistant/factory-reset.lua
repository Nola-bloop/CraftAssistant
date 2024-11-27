--Craft Assistant File

--REQUIRE GLOBALS
--reset main monitor to "setup"
CA.toolkit.replaceStringInTable("/craft-assistant/functionnal-files/globals.lua","mainMonitor", "setup")


--clean the logs
local logFile = fs.open("/craft-assistant/functionnal-files/logs", "w")
logFile.writeLine(" ")
logFile.flush()
logFile.close()

CA.logger.notice("System was brought back to factory settings.")
CA.logger.notice("Rebooting system due to reset...")
print("Rebooting system due to reset in 3 seconds...")
os.sleep(3)
os.reboot()
