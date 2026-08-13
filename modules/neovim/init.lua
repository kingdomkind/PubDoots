local custom = {
    visual = {
        transparent = true
    },

    keybinds = {
        show_diagnostic = "<A-v>",
        show_compiler_suggestion = "<A-s>",
        show_function_definition = "<A-f>",
        show_hover_type = "<A-t>",
        format_code = "<A-Tab>",
        comment_code = "<A-c>",
        live_grep = "<A-b>",
        toggle_tree = "<A-w>",
        toggle_terminal = "<A-d>",
        prev_buffer = "<A-q>",
        next_buffer = "<A-e>",
        close_buffer = "<A-a>",
        close_nvim = "<A-Esc>",
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
        accept_completion = "<Tab>",
        abort_completion = "<A-b>",
        escape_in_terminal = "<A-k>",
        continue_comment = "<A-CR>",
        rotate_theme = "<A-r>",
    },
}
local kb = custom.keybinds

--> Setting Transparency
local transparent_segments = {}
local function set_transparent(groups)
    for _, v in ipairs(groups) do
        table.insert(transparent_segments, v)
    end
end

--> Generic Settings
do
    vim.opt.clipboard:append("unnamedplus")   --> Enable system clipboard support
    vim.opt.termguicolors = true              --> Enable 24-bit colour
    vim.opt.cmdheight = 0                     --> Only show command line when entering a command
    vim.opt.relativenumber = false            --> Disable relative line numbers
    vim.opt.number = true                     --> Enable absolute line number for the current line
    vim.opt.signcolumn = "yes"                --> Show sign column
    vim.opt.tabstop = 4                       --> Visual size of a tab, in spaces
    vim.opt.expandtab = true                  --> Convert tabs to equivalent spaces size
    vim.opt.shiftwidth = 4                    --> Number of spaces for indentation (eg. > or <).
    vim.opt.softtabstop = 4                   --> How many spaces to jump in insert mode, when you press <TAB> or backspace.
    vim.opt.smarttab = false;                 --> If true, uses shiftwidth for tabsize when there is preceding whitespace, else, uses tabstop
    vim.opt.swapfile = false                  --> Neovim will no longer generate swapfiles
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
end

--> Notification system (instead of logging to command line)
do
    vim.pack.add({
        "https://github.com/rcarriga/nvim-notify",
    })
    vim.notify = require("notify").setup({
        stages = "fade_in_slide_out",
        timeout = 5000,
        background_colour = "#000000",
    })
end

--> Show errors inline and optionally floating
vim.diagnostic.config({
    float = {
        border = "rounded",
        focusable = false,
        source = true,
        header = "",
        prefix = "",
        max_width = 80,
        wrap = true,
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

--> Enable and configure LSPs
do
    --> Get the default lsp configurations
    vim.pack.add({
        "https://github.com/neovim/nvim-lspconfig"
    })
    --> These are the names nvim-lspconfig calls their configs
    local lsps = {
        "rust_analyzer",
        "nixd",
        "clangd",
        "zls",
        "lua_ls",
        "svelte",
        "glsl_analyzer",
        "pyright",
        "bashls",
    }

    for _, lsp in ipairs(lsps) do
        --> Automatically looks in the lsp/ runtime path
        --> which is where nvim-lspconfig dumps its configs
        vim.lsp.enable(lsp)
    end

    --> Clear clangd setting comment token types to things that aren't comments
    --> Comments have additional highlight groups, that will still be used, even if the LSP doesn't provide its own
    set_transparent({ "@lsp.type.comment.cpp" })
end

--> Code Formatting
do
    vim.pack.add({
        "https://github.com/stevearc/conform.nvim"
    })
    --> LSPs can also do formatting, but conform allows us to use
    --> regular formatters too
    local conform = require("conform")
    conform.setup({
        formatters_by_ft = {
            sh = { "shfmt" }
        }
    })
    vim.keymap.set("n", kb.format_code, function()
        conform.format({ async = true, lsp_fallback = true })
    end)
end

--> Better Syntax Highlighting, works in conjunction with LSPs
do
    vim.pack.add({
        "https://github.com/nvim-treesitter/nvim-treesitter"
    })
    vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
            --> Pcall, because FileType (event.match) may be an arbitrary buffer
            pcall(vim.treesitter.start, event.buf, event.match)
        end,
    })
end

--> Fuzzy Finding
do
    vim.pack.add({
        "https://github.com/nvim-lua/plenary.nvim",
        "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
        "https://github.com/nvim-telescope/telescope.nvim"
    })
    require("telescope").setup({})
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", kb.live_grep, builtin.live_grep)
    set_transparent({
        "TelescopeSelectionCaret",
        "TelescopeResultsNormal",
        "TelescopePreviewNormal",
        "TelescopePromptPrefix",
        "TelescopePromptNormal",
        "TelescopeSelection",
        "TelescopeMatching",
        "TelescopeNormal",
        "TelescopeBorder",
        "TelescopeTitle",
    })
end

--> Toggleable terminal
do
    vim.pack.add({
        "https://github.com/akinsho/toggleterm.nvim"
    })
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
end

--> Top Bar
do
    vim.pack.add({
        "https://github.com/nvim-tree/nvim-web-devicons",
        "https://github.com/romgrk/barbar.nvim"
    })
    require("barbar").setup({
        auto_hide = false,

    })
    vim.keymap.set("n", kb.prev_buffer, "<Cmd>BufferPrevious<CR>")
    vim.keymap.set("n", kb.next_buffer, "<Cmd>BufferNext<CR>")
    vim.keymap.set("n", kb.close_buffer, "<Cmd>BufferClose<CR>")
    set_transparent({
        "BufferDefaultInactive"
    })
end

--> Bottom Bar
do
    vim.pack.add({
        "https://github.com/nvim-tree/nvim-web-devicons",
        "https://github.com/nvim-lualine/lualine.nvim"
    })
    require("lualine").setup({
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { "filename" },
            lualine_x = { "lsp_status", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" }
        },
    })
end

--> Autocompletions
do
    vim.opt.autocomplete = true
    vim.opt.complete = "o"                         --> Use completions from any source
    vim.opt.completeopt = "menuone,fuzzy,noselect" --> Noselect nullifies noinsert
    vim.opt.pumheight = 10
    --> Limit the completions shown to the height available
    --> To prevent it from showing to the right of the cursor
    vim.api.nvim_create_autocmd({ "WinResized", "CursorMoved", "CursorMovedI" }, {
        callback = function(_)
            local window_height = vim.api.nvim_win_get_height(0)
            local space_below = window_height - vim.fn.winline()
            vim.o.pumheight = math.min(10, space_below - 1)
        end,
        desc = "shrink pumheight to fit visible space below cursor",
    })
    local function pum()
        return vim.fn.pumvisible() == 1
    end
    --> Clear hard-coded keybinds
    --> <C-e> closes the autocomplete menu
    vim.keymap.set("i", "<Up>", function()
        return pum() and "<C-e><Up>" or "<Up>"
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<Down>", function()
        return pum() and "<C-e><Down>" or "<Down>"
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<CR>", function()
        return pum() and "<C-e><CR>" or "<CR>"
    end, { expr = true, silent = true })
    --> Set new keybinds
    vim.keymap.set("i", kb.next_completion, function()
        return pum() and "<C-n>" or nil
    end, { expr = true, silent = true })
    vim.keymap.set("i", kb.prev_completion, function()
        return pum() and "<C-p>" or nil
    end, { expr = true, silent = true })
    vim.keymap.set("i", kb.accept_completion, function()
        return pum() and "<C-y>" or kb.accept_completion
    end, { expr = true, silent = true })
    vim.keymap.set("i", kb.abort_completion, function()
        return pum() and "<C-e>" or nil
    end, { expr = true, silent = true })
end

--> Command line replacement
do
    vim.pack.add({
        "https://github.com/MunifTanjim/nui.nvim",
        "https://github.com/folke/noice.nvim",
    })

    require("noice").setup({
        popupmenu = {
            --> Their popupmenu has positioning issues
            enabled = false
        },
        lsp = {
            progress = {
                --> LSPs otherwise send progress notifications
                --> of their processing
                enabled = false,
            }
        },
        cmdline = {
            view = "cmdline", --> Use the default command line aesthetics
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
        },

    })
end

do
    vim.pack.add({
        "https://github.com/nvim-tree/nvim-web-devicons",
        "https://github.com/nvim-tree/nvim-tree.lua",
    })

    require("nvim-tree").setup({
        view = {
            side = "left",
        },

        update_focused_file = {
            enable = true,       --> Follow active buffer
            update_root = false, --> If outside of root dir, don't follow
        },

        filters = {
            dotfiles = false,
            git_ignored = false,
        },

        renderer = {
            --> Set highlight groups for gitignore files, and dotfiles
            highlight_git = true,
            highlight_hidden = "all",
            icons = {
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                },
            },
        },
    })

    local api = require("nvim-tree.api")
    vim.keymap.set("n", kb.toggle_tree, function()
        api.tree.toggle({
            find_file = true,
        })
    end)

    --> Make the gitignore files, and dotfiles, dark grey
    vim.api.nvim_set_hl(0, "NvimTreeHiddenFileHL", { fg = "#5c6370" })
    vim.api.nvim_set_hl(0, "NvimTreeHiddenFolderHL", { fg = "#5c6370" })
    vim.api.nvim_set_hl(0, "NvimTreeHiddenIcon", { fg = "#5c6370" })
    vim.api.nvim_set_hl(0, "NvimTreeGitIgnored", { fg = "#5c6370" })
end

--> Commenting and Uncommenting Code
do
    vim.pack.add({
        "https://github.com/nvim-mini/mini.comment"
    })
    require("mini.comment").setup({
        options = {
            ignore_blank_line = true,
        },
        mappings = {
            comment = kb.comment_code,
            comment_line = kb.comment_code,
            comment_visual = kb.comment_code,
        }
    })
end

--> Write as Sudo
do
    vim.pack.add({
        "https://github.com/lambdalisue/vim-suda"
    })
    --> Auto ask sudo when required
    vim.g.suda_smart_edit = 1
    vim.cmd("cabbrev sudow SudaWrite")
end

--> Fix Delete
do
    --> Only apply the keymappings on buffers which are modifiable
    --> Otherwise they'll still try to run on neo-tree, ministarter,
    --> or generally buffers which try to parse the commands themself
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(args)
            if vim.bo[args.buf].modifiable then
                vim.keymap.set({ "n", "v" }, "d", "\"_d", { buf = args.buf })
                vim.keymap.set({ "n", "v", "o" }, "x", "d", { buf = args.buf })
            end
        end,
    })
end

--> LSP specific binds, must be created on attachment
do
    vim.api.nvim_create_user_command("Reload", function()
        for _, client in
        ipairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
            client:stop()
        end
        vim.cmd.edit();
    end, {})

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
            local client = assert(vim.lsp.get_client_by_id(event.data.client_id),
                "Couldn't get LSP client by id from event")
            --> Show hovered type
            vim.keymap.set("n", kb.show_hover_type, vim.lsp.buf.hover, {
                buffer = event.buf,
                desc = "Show variable type"
            })
            --> Enable native LSP completion integration
            vim.lsp.completion.enable(true, client.id, event.buf)
        end,
    })
end

--> Prevent comments from automatically continuing when you press enter
do
    vim.api.nvim_create_autocmd("FileType", {
        callback = function()
            vim.opt_local.formatoptions:remove({ "r", "o" })
        end,
    })
    vim.keymap.set("i", kb.continue_comment, function()
        local current_format = vim.opt_local.formatoptions:get()
        vim.opt_local.formatoptions:append("r")
        vim.schedule(function()
            vim.opt_local.formatoptions = current_format
        end)
        return "<CR>"
    end, { expr = true, silent = true })
end

--> Indent line
do
    vim.pack.add({
        "https://github.com/folke/snacks.nvim"
    })
    require("snacks").setup({
        indent = {
            enabled = true

        },
    })
end

--> Start Screen
do
    vim.pack.add({
        "https://github.com/nvim-mini/mini.starter"
    })
    require("mini.starter").setup({
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
    })
end

--> Colour Scheme
do
    local function set_theme(name)
        vim.cmd.colorscheme(name)
        for _, v in ipairs(transparent_segments) do
            vim.api.nvim_set_hl(0, v, { bg = "NONE" })
        end
    end
    local themes = {}
    do
        vim.pack.add({
            "https://github.com/catppuccin/nvim"
        })
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = custom.visual.transparent,
        })
        table.insert(themes, "catppuccin")
    end
    do
        vim.pack.add({
            "https://github.com/sainnhe/gruvbox-material",
        })
        vim.g.gruvbox_material_transparent_background = custom.visual.transparent
        table.insert(themes, "gruvbox-material")
    end

    local current = 1
    set_theme(themes[current])
    vim.keymap.set("n", kb.rotate_theme, function()
        current = (current % #themes) + 1
        set_theme(themes[current])
    end)
end
