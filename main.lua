local pl_file = require("pl.file");
local lib = loadfile("lib.lua")()
local cjson = require("cjson")

--> The gsub strips the trailing \n
local hostname = pl_file.read("/etc/hostname"):gsub("%s+$", "")
local patch = loadfile("patch.lua")()(hostname)
lib.merge(lib, patch)

local result = loadfile(lib.uniqued .. "system.lua")()(lib)
local json = cjson.encode(result)
print(json)
