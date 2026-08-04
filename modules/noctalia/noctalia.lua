local pl_file = require("pl.file");

return function(lib, args)



    return {
        desym = {
            symlinks = {
                [lib.configd .. "noctalia/base.toml"] = { source = lib.cwd() .. "base.toml" }
            }
        },
        depac = {
            packages = {
                "noctalia",
            },
        }
    }
end
