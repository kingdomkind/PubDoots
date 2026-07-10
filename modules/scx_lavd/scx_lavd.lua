local pl_file = require("pl.file");

return function(lib)
    local content = pl_file.read(lib.cwd() .. "sxc_lavd")

    return {
        desym = {
            ["/etc/dinit.d/scx_lavd"] = {
                source = content,
                uid = 0,
                gid = 0,
                mode = lib.mod
            }
        },
        depac = {
            "scx_lavd",
            "scx-scheds",
        }
    }
end
