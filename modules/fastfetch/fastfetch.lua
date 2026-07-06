return function(lib)
    return {
        desym = {
            symlinks = {
                [lib.configd .. "fastfetch/config.jsonc"] = { source = lib.cwd() .. "config.jsonc" }
            }
        },
        depac = {
            packages = {
                "fastfetch",
            }
        }
    }
end
