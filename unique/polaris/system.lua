return function(lib)
    local result = lib.imports({}, {
        { lib.modulesd .. "artix/artix.lua", { generators = true } },
        lib.modulesd .. "fastfetch/fastfetch.lua",
        lib.modulesd .. "kitty/kitty.lua",
        lib.modulesd .. "neovim/neovim.lua",
        lib.modulesd .. "zsh/zsh.lua",
        lib.modulesd .. "noctalia/noctalia.lua",
        lib.modulesd .. "yazi/yazi.lua",
        lib.modulesd .. "jj/jj.lua",
        { lib.modulesd .. "hypr/hypr.lua",   { extension = lib.cwd() .. "hyprext.lua" } },
        lib.modulesd .. "autologin/autologin.lua",
        { lib.modulesd .. "grub/grub.lua",             { source = lib.cwd() .. "grub" } },
        { lib.modulesd .. "fstab/fstab.lua",           { source = lib.cwd() .. "fstab" } },
        { lib.modulesd .. "mkinitcpio/mkinitcpio.lua", { source = lib.cwd() .. "mkinitcpio.conf" } },

    })

    lib.merge(result, {
        depac = {
            packages = {
                "make",
                "rustup",
                "intel-ucode",
                "linux",
                "linux-headers",
                "linux-firmware-intel",
                "linux-firmware-other",
                "fprintd",
                "userspawn-dinit",
                "brightnessctl",
                "btop",
                "fastfetch",
                "less",
                "unzip",
                "cosmic-files",
                "kitty",
                "firefox",
                "mpv",
                "signal-desktop",
                "yt-dlp",
                "upower",
                "teams-for-linux",
            },
            pkgbuilds = {
                "yay",
            },
        }
    })

    return result
end
