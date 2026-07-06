local pl_file = require("pl.file");
local lib = loadfile("lib.lua")()
local cjson = require("cjson")

--> The gsub strips the trailing \n
local hostname = pl_file.read("/etc/hostname"):gsub("%s+$", "")

local globals = {}
globals.configd = "/home/pika/.config/"
globals.homed = "/home/pika/"
globals.dootsd = "./"
globals.uniqued = "unique/" .. hostname .. "/"
globals.modulesd = "modules/"
globals.uid = 1000
globals.gid = 1000
globals.mode = tonumber("644", 8)

lib.merge(lib, globals)

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

---@diagnostic disable-next-line
if false then
    print("Printing debug");
    local pretty = require("pl.pretty")
    pretty.dump(result)
else
    local json = cjson.encode(result)
    print(json)
end
