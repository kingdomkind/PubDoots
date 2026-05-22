local lib = {}
local pl_path = require("pl.path")

---Gets the path of the caller
---@return string
function lib.cwd()
    return pl_path.abspath(debug.getinfo(2, "S").source:match("^@(.+/)")) .. "/"
end

---Automatically merges the target directories, into the base table
---Imports can be a raw string, for the path
---Alternatively, a table with [1] for the path, and [2] for a table of arguments to provide it, can be given
---@param base table
---@param paths (string | { [1]: string, [2]: table })[]
---@return table
function lib.imports(base, paths)
    for _, path in ipairs(paths) do
        local callback, err
        local additional_args
        if type(path) == "table" then
            callback, err = loadfile(path[1])
            additional_args = path[2]
        else
            callback, err = loadfile(path)
        end
        assert(callback, "Failed to load file: " .. path .. "\n" .. tostring(err))
        lib.merge(base, callback()(lib, additional_args))
    end

    return base
end

---Merges multiple tables into the base table
---@param base table
---@param additions table[]
---@return table
function lib.merges(base, additions)
    for _, addition in ipairs(additions) do
        lib.merge(base, addition)
    end

    return base
end

---Merges table2, into table1
---@param table1 table
---@param table2 table
---@return table
function lib.merge(table1, table2)
    for k, v in pairs(table2) do
        if type(v) == "table" and type(table1[k]) == "table" then
            lib.merge(table1[k], v)
        else
            table1[k] = v
        end
    end

    --> The merge family of functions merges in place,
    --> but we return too just for easier use
    return table1
end

--- Prevents nil accessing
---@param to_bar table The table you want barred
function lib.bar(to_bar)
    setmetatable(to_bar, {
        __index = function(_, k)
            error("[EXIT] Key '" .. tostring(k) .. "' does not exist in lib!", 2)
        end
    })
end

return lib.bar(lib)
