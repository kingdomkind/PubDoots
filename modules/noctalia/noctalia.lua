return function(lib)
    return {
        desym = {
            symlinks = {
                [lib.configd.. "noctalia/settings.json"] = { source = lib.cwd().. "settings.json" }
            }
        }
    }
end
