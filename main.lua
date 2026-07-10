local pl_file = require("pl.file");
local lib = loadfile("lib.lua")()
local cjson = require("cjson")
-- local pretty = require("pl.pretty")

--> The gsub strips the trailing \n
local hostname = pl_file.read("/etc/hostname"):gsub("%s+$", "")
local patch = loadfile("patch.lua")()(hostname)
lib.merge(lib, patch)

local result = loadfile(lib.uniqued .. "system.lua")()(lib)
lib.merge(result, {
    depac = {
        packages = {
            "lua-lux",
            "lux-cli",
            "jq",
        }
    }
})

local json = cjson.encode(result)
print(json)
