return function(lib)
    return {
        desym = {
            symlinks = {
                [lib.configd .. "jj/conf.d/config.toml"] = { source = lib.cwd() .. "config.toml" }
            }
        },
        depac = {
            packages = {
                "git",
                "jujutsu",
            }
        }
    }
end
