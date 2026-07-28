return function(lib)
    return {
        desym = {
            symlinks = {
                [lib.configd .. "nvim/init.lua"] = { source = lib.cwd() .. "init.lua" }
            }
        },
        depac = {
            packages = {
                "neovim",
                "clang",
                "lua-language-server",
                "rust-analyzer",
            },
            ignore = {
                "glsl_analyzer-bin"
            }
        }
    }
end
