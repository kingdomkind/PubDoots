return function(lib)
    return {
        desym = {
            symlinks = {
                [lib.configd.. "nvim/init.lua"] = { source = lib.cwd().. "init.lua" }
            }
        }
    }
end
