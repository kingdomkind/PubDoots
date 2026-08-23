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
                "typescript-language-server",

                --> Formatters
                "shfmt"
            },
            pkgbuilds = {
                "glsl_analyzer-bin"
            }
        }
    }
end
