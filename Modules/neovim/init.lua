local custom = {
    visual = {
        transparent = true
    },

    system = {
        local_dir = (function()
            local path = "/home/pika/.cache/nvim/local/"
            return path
        end)()
    },

    keybinds = {
        show_diagnostic = "<A-v>",
        show_compiler_suggestion = "<A-s>",
        show_function_definition = "<A-f>",
        show_hover_type = "<A-t>",

        format_code = "<A-o>",
        comment_code = "<A-r>",

        live_grep = "<A-b>",

        toggle_tree = "<A-w>",
        toggle_terminal = "<A-d>",
        toggle_md_preview = "<A-l>",

        prev_buffer = "<A-q>",
        next_buffer = "<A-e>",
        close_buffer = "<A-a>",

        close_nvim = "<A-c>",
        force_close_nvim = "<A-p>",
        create_vertical_split = "<A-g>",

        resize_left = "<S-A-Left>",
        resize_right = "<S-A-Right>",
        resize_up = "<S-A-Up>",
        resize_down = "<S-A-Down>",
        focus_left = "<A-Left>",
        focus_right = "<A-Right>",
        focus_up = "<A-Up>",
        focus_down = "<A-Down>",

        prev_completion = "<A-z>",
        next_completion = "<A-x>",
        abort_completion = "<A-b>",
        confirm_completion = "<Tab>",
        escape_in_terminal = "<A-Esc>"
    },
}
local kb = custom.keybinds

local lazypath = custom.system.local_dir .. "lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.api.nvim_echo({ { "Installing Lazy...", "Normal" } }, true, {})
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

--> Enable system clipboard support
vim.opt.clipboard:append("unnamedplus")

--> Enable 24-bit colour
vim.opt.termguicolors = true

--> Only show command line when entering a command
vim.o.cmdheight = 0

--> Disable relative line numbers
vim.wo.relativenumber = false

--> Enable absolute line number for the current line
vim.wo.number = true

--> Show sign column
vim.wo.signcolumn = "yes"

--> Fix tab sizes
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

--> Prevent comments from automatically continuing on enter
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove({ "r", "o" })
    end,
})

--> Setting Transparency
local transparent_segments = {}
if custom.visual.transparent then
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
            for _, v in ipairs(transparent_segments) do
                vim.api.nvim_set_hl(0, v, { bg = "NONE" })
            end
        end,
    })
end

local function set_transparent(groups)
    for _, v in ipairs(groups) do
        table.insert(transparent_segments, v)
        vim.api.nvim_set_hl(0, v, { bg = "NONE" })
    end
end

--> Show errors inline and optionally floating
vim.diagnostic.config({
    float = {
        border = "rounded",
        focusable = false,
        source = "always",
        header = "",
        prefix = "",
        max_width = 80,
    },

    virtual_text = {
        prefix = "●",
        spacing = 2,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

--> Opt is equivalent to require.setup, config is a callback when the plugin loads
--> Setup plugins
require("lazy").setup({
    --> Install and enable LSPs
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            local lsps = {
                "rust_analyzer",
                "nixd",
                "nixfmt",
                "clangd",
            }

            local sole_lsps = {}
            for _, lsp in pairs(lsps) do
                if type(lsp) == "string" then
                    table.insert(sole_lsps, lsp)
                else
                    table.insert(sole_lsps, lsp[1])
                end
            end

            for _, lsp in ipairs(lsps) do
                local name, config = nil, nil
                if type(lsp) == "string" then
                    name = lsp
                else
                    name = lsp[1]; config = lsp[2]
                end

                vim.lsp.enable(name)
                if config ~= nil then
                    vim.lsp.config(name, config)
                end
            end
        end,
    },

    --> Fuzzy Finding
    {
        "nvim-telescope/telescope.nvim",
        tag = "v0.2.0",
        dependencies = { "nvim-lua/plenary.nvim" },

        config = function()
            require("telescope").setup({})
            local builtin = require("telescope.builtin")

            vim.keymap.set("n", kb.live_grep, builtin.live_grep)
        end,
    },

    --> Better Syntax Highlighting, works in conjunction with LSPs
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "lua",
                "rust",
                "nix",
                "css",
                "markdown",
                "java",
            },
            sync_install = false,
            auto_install = true,
        }
    },

    --> Toggleable terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                shade_terminals = false,
                start_in_insert = false,
                highlights = {
                    Normal = {
                        guibg = "NONE",
                    },
                    NormalFloat = {
                        guibg = "NONE",
                    },
                },
            })

            vim.keymap.set("n", kb.toggle_terminal, ":ToggleTerm<CR>")
        end,
    },

    --> Top Bar
    {
        "romgrk/barbar.nvim",
        version = "*",
        dependencies = {
            "lewis6991/gitsigns.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("barbar").setup({
                -- your options here
                auto_hide = false,
            })

            vim.keymap.set("n", kb.prev_buffer, "<Cmd>BufferPrevious<CR>")
            vim.keymap.set("n", kb.next_buffer, "<Cmd>BufferNext<CR>")
            vim.keymap.set("n", kb.close_buffer, "<Cmd>BufferClose<CR>")

            set_transparent({
                "Current",
                "Inactive",
                "Alternate",
                "Visible",
                "BufferAlternate",
            })
        end,
    },

    --> Bottom Bar
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { "lsp_status", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            },
        }
    },

    --> Autocompletions
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    [kb.prev_completion] = cmp.mapping.select_prev_item(),
                    [kb.next_completion] = cmp.mapping.select_next_item(),
                    [kb.abort_completion] = cmp.mapping.abort(),
                    [kb.confirm_completion] = cmp.mapping.confirm({ select = true }),
                    ["<Up>"] = cmp.config.disable,
                    ["<Down>"] = cmp.config.disable,
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                }, {
                    { name = "buffer" },
                })
            })
        end

    },

    {
        "folke/snacks.nvim",
        opts = {
            indent = {
                enabled = true
            }
        },
    },

    --> File browser tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("neo-tree").setup({
                -- your config here
                filesystem = {
                    use_libuv_file_watcher = true, --> Automatic refresh upon change
                    follow_current_file = {
                        enabled = true,            --> When neotree opens, select current file
                    },
                    filtered_items = {
                        visible = true,
                        --hide_dotfiles = false,
                        --hide_gitignored = false,
                    },
                },
            })

            set_transparent({
                "NeoTreeNormal",
                "NeoTreeNormalNC",
                "NeoTreeEndOfBuffer",
                "NeoTreeTitleBar",
                "NeoTreeVertSplit",
                "NeoTreeWinSeparator",
                "NeoTreeTitleBar",
            })

            vim.keymap.set("n", kb.toggle_tree, ":Neotree toggle filesystem<CR>")
        end,
    },


    --> Commenting and Uncommenting Code
    {
        "nvim-mini/mini.comment",
        version = "*",
        opts = {
            options = {
                ignore_blank_line = true,
            },

            mappings = {
                comment = kb.comment_code,
                comment_line = kb.comment_code,
                comment_visual = kb.comment_code,
            }
        }
    },

    --> Code Formatting
    {
        "stevearc/conform.nvim",
        config = function()
            local conform = require("conform")
            conform.setup({})

            vim.keymap.set("n", kb.format_code, function()
                conform.format({ async = true, lsp_fallback = true })
            end)
        end,
    },

    --> Start Screen
    {
        "nvim-mini/mini.starter",
        version = "*",
        opts = {
            autoopen = true,
            header = [[
╔══════════════════════════════════════════════════════════════════════════════╗
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣔⣾⠟⠻⢶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⢤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠋⡼⠃⠀⠀⠀⢻⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠟⠐⠶⣌⠙⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠡⢸⠁⠀⠀⠀⠀⠀⢹⡇⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡿⢁⠀⠀⠀⠈⢻⡄⠙⢷⣄⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⡆⠀⠀⠀⠀⢀⣀⣀⣀⣰⠀⢀⣿⣡⠃⣺⠀⠀⠀⠀⠀⠀⠀⢷⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠁⠀⠀⠀⠀⠀⠀⢹⡄⠂⠹⢲⣄⠀⠀⠀⠀⠀⣼⡄⢠⣿⠋⢿⡍⢉⠛⠟⢉⠙⣿⠛⡟⣱⠁⠀⡇⠀⠀⠀⠀⠀⠀⠀⢸⡌⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⢻⡀⠀⠀⠘⢷⣄⢀⣤⡶⠋⢻⣾⠻⣄⠰⠀⠀⠀⠀⠠⢠⡿⢧⣼⠟⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⣧⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠰⣷⣄⡀⠀⠀⠹⠟⠉⠀⠀⢸⠙⣿⠟⠲⡀⠀⠀⠠⣴⠿⢧⣜⠋⡄⠀⠀⠹⣄⡀⢀⡄⠀⢀⣀⠐⣟⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢺⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⠈⠙⢤⡀⠀⠀⠀⠀⡧⣰⡟⢀⠁⢹⡀⠀⢸⡇⢀⠀⠘⣧⡃⠀⠀⠁⠀⠹⣟⣠⡶⠋⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡄⠀⠀⠀⠀⠀⢢⠀⠀⠀⢹⢆⠀⠈⠘⠷⣄⠀⠘⠱⡟⢡⣾⣩⡇⢣⡐⠘⠧⣯⣧⠀⠈⣷⠀⠀⣠⣥⣴⢿⣧⡐⠐⠀⠀⡿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⠀⠀⠀⠀⠀⠀⠀⢀⣤⠋⠀⠀⠀⠀⠂⠈⠙⢦⣀⣇⣸⣿⠿⢿⢤⣇⣀⣤⠿⠿⠧⣄⣸⣶⢦⣿⠏⠁⠀⠈⣙⠖⣤⣰⡇⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡎⠀⠀⠀⠀⠀⠀⢨⡇⠀⠀⠀⠀⠀⠀⠀⠈⣦⠿⠋⠁⠀⠀⣀⣤⣾⣿⣶⣶⣶⣦⣄⡈⠻⢿⡀⠀⠀⠀⠀⠀⠀⠈⢻⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⠀⠀⠀⠀⠀⢠⡞⠉⠀⠀⠀⠀⠀⠀⠀⣀⡏⠀⠀⢀⣴⢿⣿⠛⠉⢀⣀⣽⣿⣿⡿⠁⠀⠀⢻⡦⠶⠶⠶⠶⠶⠦⠀⢿⡶⠦⠴⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⠀⠀⠀⢠⣟⠀⠀⠀⠀⠀⠀⠐⠒⢉⣿⠋⡀⠠⠹⢦⣛⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀⢸⠃⠀⠀⠀⠀⠀⠀⠀⣸⡁⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣶⠤⠀⡟⠊⠀⠀⠀⠀⠀⠀⠀⣴⡾⠣⢇⠹⠃⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⡠⢻⠀⠀⠀⠀⠀⠀⠀⢀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⡛⣧⠀⡇⢀⠀⠀⠀⠀⠀⠀⠀⠈⢧⠀⢸⡇⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠃⡾⠀⠀⠀⠀⠀⠀⠀⣼⠟⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⣿⡀⠃⠀⠀⠀⠀⠀⠀⠀⢸⡄⠀⠙⣶⣄⡀⠀⠀⣠⠤⠞⠓⠢⠤⢤⢶⣿⠁⢸⠃⠀⠀⠀⠀⠀⠀⣼⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣧⡘⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠘⡇⠉⠉⠉⠁⠀⠀⠀⠀⠀⠈⣽⠃⠀⡼⠁⠀⠀⠀⢀⣠⣾⠏⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⡀⠀⠀⠀⠀⠀⣠⡶⠋⢀⣽⠗⠂⢲⡄⠀⠀⠀⠀⠐⠉⢻⣤⡐⣄⠀⠀⠀⠀⠀⢸⡄⠀⠀⢳⠈⠀⠀⠀⠀⠀⠀⠀⠀⣀⠏⠀⠀⡇⠀⠀⠀⠀⣵⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⣴⠞⠛⣛⠳⢦⣄⣾⠏⠔⠀⠉⠁⠀⠠⠾⠹⢆⡀⠀⠀⠀⠀⠀⣙⢿⣮⠣⡀⠀⠀⠀⠸⣇⠠⡀⠘⡜⠀⠀⠀⠀⠀⠀⠀⢣⡻⠀⠀⣸⠃⠀⠠⢀⣼⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⣼⣷⠀⠀⠀⠈⠄⠻⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣄⠀⠀⠀⠀⠈⠊⠻⣷⣈⠢⡀⠀⠀⠹⡄⠁⠀⢻⠀⠀⠀⠀⣄⠔⠀⢸⠇⠀⢀⡏⠀⢀⣴⠿⠣⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠹⣤⣰⣵⡶⢶⣄⠰⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⣼⠘⠀⠀⠀⠀⠀⠀⠀⢪⡻⢷⣄⣀⠀⠀⢻⡀⢠⠀⣇⠀⠀⠀⠁⠐⠀⡏⠀⢀⣞⢀⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⢿⡇⡅⠀⠀⠀⠀⠀⠀⠀⠀⢨⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠉⠻⢷⣦⣀⠓⠆⣇⠘⣄⠀⠀⠠⠀⣴⠀⣴⡟⣰⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠘⣷⢠⠀⠀⠀⠀⠀⠀⢀⣤⡟⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠿⡷⣿⡄⠈⠳⣤⣴⠾⠁⢰⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⢻⣇⢇⠀⠀⠀⠀⠀⠀⠉⠳⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⠦⠒⠒⢺⡇⠈⠛⢄⠀⠀⠠⢀⣴⢏⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠈⢿⡎⢆⠀⠀⠀⠀⠀⠀⠀⠀⠙⢧⡀⠀⠀⠀⣀⣀⣠⠴⠞⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠤⠴⠚⠁⣼⣧⣠⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣌⢢⠀⠀⠀⠀⠀⠀⠀⠀⣌⠻⠟⠛⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠃⠀⠀⠨⡙⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠙⣧⡁⢄⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠀⠀⠀⠀⠈⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠈⠀⠀⡠⢄⠀⠀⠀⠀⠹⣦⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⡀⠉⠢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣡⡾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠂⠈⠉⠒⠀⠀⢠⣤⣤⣤⠤⠴⠖⠺⠟⠛⢻⡿⢁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢠⡞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
║⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⣀⣀⣠⣀⠀⠀⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀║
╚══════════════════════════════════════════════════════════════════════════════╝]],
            footer = os.date("%Y-%m-%d"),
            items = nil,
        }
    },

    --> Md Preview
    {
        "brianhuster/live-preview.nvim",
        config = function()
            require("live-preview").setup({})
            vim.keymap.set("n", kb.toggle_md_preview, ":LivePreview start<CR>")
        end
    },

    --> Write as Sudo, pure vim
    {
        "lambdalisue/vim-suda",
        init = function()
            --> Auto ask sudo when required
            vim.g.suda_smart_edit = 1
            vim.cmd("cabbrev sudow SudaWrite")
        end,

    },

    --> Fix Delete
    {
        "gbprod/cutlass.nvim",
        opts = {
            cut_key = "x",
            override_del = true,
        }
    },

    --> Colour Scheme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha",
            transparent_background = custom.visual.transparent,

            integrations = {
                cmp = true,
                nvimtree = true,
                treesitter = true,
            },
        },
        config = function()
            vim.cmd.colorscheme("catppuccin")

            set_transparent({
                "StatusLine",
                "TabLine",
                "TabLineFill",
                "Normal",
                "NormalNC",
                "VertSplit",

            })
        end
    }

}, {
    --> Lazy plugin config
    root = custom.system.local_dir .. "plugins",
    lockfile = custom.system.local_dir .. "lazy.lock",
    git = {
        timeout = 600, --> Timeout in seconds until clones exit
    }
})

--> LSP specific binds, must be created on attachment
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        --> Show hovered type
        vim.keymap.set("n", kb.show_hover_type, vim.lsp.buf.hover, {
            buffer = args.buf,
            desc = "Show variable type"
        })
    end,
})

--> Generic Binds
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("t", kb.escape_in_terminal, "<Esc>")

vim.keymap.set("n", kb.show_diagnostic, function() vim.diagnostic.open_float(nil, { focus = false }) end)
vim.keymap.set("n", kb.show_compiler_suggestion, vim.lsp.buf.code_action)
vim.keymap.set("n", kb.show_function_definition, vim.lsp.buf.definition)

vim.keymap.set("n", kb.close_nvim, ":qa<CR>")
vim.keymap.set("n", kb.force_close_nvim, ":qa!<CR>")
vim.keymap.set("n", kb.create_vertical_split, ":vertical split<CR>")

vim.keymap.set("n", kb.resize_left, ":vertical resize -5<CR>")
vim.keymap.set("n", kb.resize_right, ":vertical resize +5<CR>")
vim.keymap.set("n", kb.resize_up, ":resize +5<CR>")
vim.keymap.set("n", kb.resize_down, ":resize -5<CR>")

vim.keymap.set("n", kb.focus_left, ":wincmd h<CR>")
vim.keymap.set("n", kb.focus_right, ":wincmd l<CR>")
vim.keymap.set("n", kb.focus_up, ":wincmd k<CR>")
vim.keymap.set("n", kb.focus_down, ":wincmd j<CR>")
