return function(lib)
    return {
        desym = {
            symlinks = {
                [lib.configd .. "nvim/init.lua"] = { source = lib.cwd() .. "init.lua" }
            }
        },
        depac = {
            packages = {
                --> Lsps
                "neovim",
                "clang",
                "lua-language-server",
                "rust-analyzer",
                "bash-language-server",

                --> Formatters
                "shfmt"
            },
            ignore = {
                "glsl_analyzer-bin"
            }
        }
    }
end
