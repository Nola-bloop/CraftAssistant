--[[
    Author: Nola (nola.bloop on discord)

    This file is an attempt at controlling debugging without filling
    the terminal.
]]

--shared variable(s)
local logPath = "/craft-assistant/functionnal-files/logs"



--============= Private functions =============

--write in the log file
--- haha
---@param type string   @The type is a single character defining the type of the log message. Crashes use "c", warnings use "w", etc.
---@param time string   @Formatted version of the unix time given by os.time()
---@param msg string    @Message of the log
---@param locale string @can be utc, local or ingame.
local function write(type, time, msg, locale)
    --in case of error
    type = type or "N/A"
    time = time or "N/A"
    msg = msg or "N/A"
    locale = locale or "N/A"

    if time ~= "N/A" then
        if string.sub(time,2,2) == ":" then time = "0"..time end
    end
    time = string.sub(time,1,5)

    --read file and memorize it
    local file = fs.open(logPath,"r") 
        or error("[Logger Error] Could not read file at '"..logPath.."'. Make sure it is present and that the logger can read it.", 1)
    local oldContents = file.readAll()
    file.close()

    --append line at the top of the file
    file = fs.open(logPath,"w") 
        or error("[Logger Error] Could not read file at '"..logPath.."'. Make sure it is present and that it is not write protected.", 1)
    file.writeLine("("..type..")".."["..time.." ("..locale..")] : "..msg)
    file.write(oldContents)
    file.flush()
    file.close()
end
--- Reads parameters and assigns them defaults if they are empty
---@param msg string    @message to log, defaults to "No message specified"
---@param locale string @timezone to read the time in (utc|local|ingame), defaults to "utc"
---@param time string   @formatted version of the unix time, defaults to the current time in the locale's environment
local function verifyAndApplyDefaults(msg, time, locale)
    msg = msg or "No message specified"

    locale = locale or "utc"
    time = time or textutils.formatTime(os.time(locale))
    
    return msg, time, locale
end



--============= Public functions =============
--- Send a notice to the log file
---@param msg  string            @Message of the notice
---@param time nil | string     @Formatted time
---@param locale nil | string   @Locale local|ingame|utc
local function notice(msg, time, locale)
    msg, time, locale = verifyAndApplyDefaults(msg, time, locale)
    write("n", time, msg, locale)
end

--- Send a warning to the log file
---@param msg string      @Message of the warning
---@param time string     @Formatted time
---@param locale string   @Locale local|ingame|utc
local function warn(msg, time, locale)
    msg, time, locale = verifyAndApplyDefaults(msg, time, locale)
    write("w", time, msg, locale)
end

--- Send a 'funny' to the log file (I only made this to log when my funny stuff was getting triggered and make it a different color)
---@param msg string            @Message of the 'funny'
---@param time string     @Formatted time
---@param locale string   @Locale local|ingame|utc
local function funny(msg, time, locale)
    msg, time, locale = verifyAndApplyDefaults(msg, time, locale)
    write("w", time, msg, locale)
end

--- Send a debug line to the log file
---@param msg string            @Message of the debug line
---@param time string     @Formatted time
---@param locale string   @Locale local|ingame|utc
local function debug(msg, time, locale)
    msg, time, locale = verifyAndApplyDefaults(msg, time, locale)
    write("d", time, msg, locale)
end

--- Send a crash message to the log file
---@param msg string            @Message of the crash log
---@param time string     @Formatted time
---@param locale string   @Locale : local|ingame|utc
local function crash(msg, task, time, locale)
    task = task or "shutdown"
    msg, time, locale = verifyAndApplyDefaults(msg, time, locale)

    write("c", time, msg, locale)

    if task == "shutdown" then
        warn("Shutting down the pc...", time)
        os.shutdown()
    elseif task == "reboot" then
        warn("Rebooting the pc...", time)
        os.reboot()
    end
    
end

--return public functions
return {crash=crash, notice=notice, warn=warn, funny=funny, debug=debug}