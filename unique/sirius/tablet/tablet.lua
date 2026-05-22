return function(lib)
    return {
        desym = {
            symlinks = {
                [lib.configd.. "OpenTabletDriver/settings.json"] = { source = lib.cwd().. "settings.json" }
            }
        }
    }
end
