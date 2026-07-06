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
        if type(path) == "table" then
            local callback, err = loadfile(path[1])
            assert(callback, "Failed to load file: " .. path[1] .. "\n" .. tostring(err))
            lib.merge(base, callback()(lib, path[2]))
        else
            local callback, err = loadfile(path)
            assert(callback, "Failed to load file: " .. path .. "\n" .. tostring(err))
            lib.merge(base, callback()(lib))
        end
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

--> Helper, to avoid clobbering if the keys don't actually matter
local function is_array(t)
    if type(t) ~= "table" then return false end
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then return false end
    end
    return true
end

---Merges table2, into table1
---@param table1 table
---@param table2 table
---@return table
function lib.merge(table1, table2, path)
    path = path or ""
    for k, v in pairs(table2) do
        local full_key = path == "" and tostring(k) or (path .. "." .. tostring(k))

        if type(v) == "table" and type(table1[k]) == "table" then
            if is_array(v) and is_array(table1[k]) then
                --> If they are both arrays, just append, rather than clobber keys together
                for _, va in ipairs(v) do
                    table.insert(table1[k], va)
                end
            else
                lib.merge(table1[k], v, full_key)
            end
        else
            --> Avoid hitting nil indexing metamethod
            if rawget(table1, k) == nil then
                table1[k] = v
            else
                error(string.format(
                    "[EXIT] Attempted to clobber key '%s': existing=%s, incoming=%s",
                    full_key,
                    tostring(rawget(table1, k)),
                    tostring(v)
                ))
            end
        end
    end
    --> The merge family of functions merges in place,
    --> but we return too just for easier use
    return table1
end

--- Prevents nil accessing
---@param to_bar table The table you want barred
---@return table
function lib.bar(to_bar)
    setmetatable(to_bar, {
        __index = function(_, k)
            error("[EXIT] Key '" .. tostring(k) .. "' does not exist in lib!", 2)
        end
    })

    return to_bar
end

---Ensures the field exists in base, else, errors
---@param base table
---@param field string it must be a dotted path eg. a.b.c
function lib.require_field(base, field)
    local current = base
    for key in field:gmatch("[^.]+") do
        current = current and current[key]
        if current == nil then
            error(string.format(
                "[EXIT] Key '%s' was nil, required '%s'",
                key,
                field
            ))
        end
    end

    return current
end

return lib.bar(lib)
