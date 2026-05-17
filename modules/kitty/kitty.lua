return function(lib)
    return {
        desym = {
            symlinks = {
                [lib.configd.. "kitty"] = { source = lib.cwd().. "source" }
            }
        }
    }
end
