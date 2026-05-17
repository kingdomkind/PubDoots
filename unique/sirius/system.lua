return function(lib)
    local result = lib.imports({}, {
        lib.modulesd.. "fastfetch/fastfetch.lua"
    })

    return result
end
