local pl_file = require("pl.file");
local lib = loadfile("lib.lua")()
local cjson = require("cjson")

--> The gsub strips the trailing \n
local hostname = pl_file.read("/etc/hostname"):gsub("%s+$", "")

lib.init(
    lib.merge(lib, {
        ["configd"] = "/home/pika/.config/",
        ["uniqued"] = "unique/" .. hostname .. "/",
        ["modulesd"] = "modules/"
    })
)

local result = loadfile("unique/" .. hostname .. "/system.lua")()(lib)

--> Debug dump
if false then
    local pretty = require("pl.pretty")
    pretty.dump(result)
end

local json = cjson.encode(result)
print(json)
