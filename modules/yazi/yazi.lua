return function(lib)
    return {
        desym = {
            symlinks = {
                [lib.configd .. "yazi"] = { source = lib.cwd() .. "source" }
            }
        },
        depac = {
            packages = {
                "ripdrag",
                "yazi",
            }
        }
    }
end
