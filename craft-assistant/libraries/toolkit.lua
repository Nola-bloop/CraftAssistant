--[[
    Author: Nola (nola.bloop on discord)

    This module adds a couple functions to manipulate many different things
]]
return  {
    --- Append functions of an addon to a lua object. 
    --- example of use: 'local monitor = CA.toolkit.addon(peripheral.find("monitor"), CA.addons.monitor)'
    --- returns nil if a NOT NULL value is null
    ---@param target any        @peripheral or object to apply the addon on. NOT NULL
    ---@param addon any         @addon to apply on the object. ALSO NOT NULL
    ---@param override boolean  @put to true to override the object's existing functions
    addon = function(target, addon, override)
        if not target then return nil end
        if not addon then return nil end
        override = override or false

        for k, v in pairs(addon) do
            if override or not target[k] then
            target[k] = v
            end
        end
        return target
    end,





    --- Searches a file for a table declaration and replaces the value to the specified one
    ---@param path string   @path to the file containing the table
    ---@param name string       @name of the variable whose value needs to be changed 
    ---@param value string      @new value of the variable
    replaceStringInTable = function(path, name, value)

        --open the file and memorize its content for processing
        local file = fs.open(path, "r")
            or CA.log.crash("Error while trying to read file "..path.." (toolkit.replaceStringInTable())")
        local oldContents = file.readAll()
        file.close()

        --find the parameter
        local strStart = nil
        local strEnd = nil
        for i = 1, #oldContents do
            if string.sub(oldContents, i, i+#name-1) == name then
                for j = i+#name, #oldContents do
                    if string.sub(oldContents, j, j) == "\\" then j = j+1 --skip next character if there is a backslash
                    elseif not strStart and string.sub(oldContents, j, j) == '"' then strStart = j 
                    elseif not strEnd and string.sub(oldContents, j, j) == '"'then strEnd = j break end
                end
                break
            end
        end
        CA.log.debug(strStart)
        CA.log.debug(strEnd)

        --replace the old value with the new one
        oldContents = string.sub(oldContents, 1, strStart)..value..string.sub(oldContents, strEnd, #oldContents)

        file = fs.open(path,"w") 
            or CA.log.crash("Error while trying to write in file "..path.." (toolkit.replaceStringInTable())")
        file.write(oldContents)
        file.flush()
        file.close()
    end,
}