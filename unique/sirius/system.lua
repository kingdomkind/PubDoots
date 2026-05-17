return function(lib)
    local result = lib.imports({}, {
        lib.modulesd.. "fastfetch/fastfetch.lua",
        lib.modulesd.. "kitty/kitty.lua",
        lib.modulesd.. "neovim/neovim.lua",
        lib.modulesd.. "zsh/zsh.lua",
        lib.modulesd.. "noctalia/noctalia.lua",
    })

    return result
end
