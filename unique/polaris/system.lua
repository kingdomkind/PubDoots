return function(lib)
    local result = lib.imports({}, {
        lib.modulesd .. "fastfetch/fastfetch.lua",
        lib.modulesd .. "kitty/kitty.lua",
        lib.modulesd .. "neovim/neovim.lua",
        lib.modulesd .. "zsh/zsh.lua",
        lib.modulesd .. "noctalia/noctalia.lua",
        lib.modulesd .. "yazi/yazi.lua",
        { lib.modulesd .. "hypr/hypr.lua", { extension = lib.cwd() .. "hyprext.lua" } },
    })

    lib.merge(result, {
        depac = {
            packages = {
                --> Core
                "gcc",
                "git",
                "grub",
                "lua54",
                "make",
                "networkmanager",
                "rustup",
                "sudo",
                "intel-ucode",
                "arch-install-scripts",
                "artix-archlinux-support",
                "base",
                "base-devel",
                "cryptsetup",
                "dinit",
                "efibootmgr",
                "elogind-dinit",
                "linux",
                "linux-headers",
                "linux-firmware",

                --> Corey
                "bluez-dinit",
                "chrony-dinit",
                "networkmanager-dinit",
                "openssh",
                "pipewire-dinit",
                "pipewire-pulse-dinit",
                "wireplumber-dinit",
                "dnsmasq",
                "userspawn-dinit",
                "brightnessctl",

                --> Fonts
                "noto-fonts",
                "noto-fonts-emoji",
                "ttf-cascadia-code-nerd",

                "btop",
                "fastfetch",
                "less",
                "unzip",
                "cosmic-files",
                "kitty",
                "firefox",
                "mpv",
                "signal-desktop",
                "telegram-desktop",
                "yt-dlp",
            },

            ignore = {
                "brave-origin-nightly-bin",
                "discord-chat-exporter-cli-bin",
                "grimblast-git",
                "noctalia-git",
                "yay",
            }
        }
    })

    return result
end
