local lib = {}
local pl_path = require("pl.path")

---@return string
function lib.cwd()
    return pl_path.abspath(debug.getinfo(2, "S").source:match("^@(.+/)")).."/"
end

---@param globals table
function lib.init(globals)
    lib.globals = globals
end

---@param base table
---@param paths string[]
---@return table
function lib.imports(base, paths)
    for _, path in ipairs(paths) do
        local callback, err = loadfile(path)
        assert(callback, "Failed to load file: " .. path .. "\n" .. tostring(err))
        lib.merge(base, callback()(lib.globals))
    end

    return base
end

---@param base table
---@param additions table[]
---@return table
function lib.merges(base, additions)
    for _, addition in ipairs(additions) do
        lib.merge(base, addition)
    end

    return base
end

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

return lib
