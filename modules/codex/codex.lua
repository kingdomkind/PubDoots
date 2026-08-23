return function(lib)
    return {
        desym = {
            symlinks = {
                [lib.configd .. "codex/config.toml"] = { source = lib.cwd() .. "config.toml" }
            }
        },
        depac = {
            packages = {
                "openai-codex",
            },
        }
    }
end
