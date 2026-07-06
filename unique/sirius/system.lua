return function(lib)
    local result = lib.imports({}, {
        lib.modulesd .. "fastfetch/fastfetch.lua",
        lib.modulesd .. "kitty/kitty.lua",
        lib.modulesd .. "neovim/neovim.lua",
        lib.modulesd .. "zsh/zsh.lua",
        lib.modulesd .. "noctalia/noctalia.lua",
        lib.modulesd .. "yazi/yazi.lua",
        { lib.modulesd .. "hypr/hypr.lua",             { extension = lib.cwd() .. "hyprext.lua" } },
        lib.modulesd .. "jj/jj.lua",
        { lib.modulesd .. "grub/grub.lua",             { source = lib.cwd() .. "grub" } },
        { lib.modulesd .. "mkinitcpio/mkinitcpio.lua", { source = lib.cwd() .. "mkinitcpio.conf" } },
        lib.uniqued .. "tablet/tablet.lua",
    })

    lib.merge(result, {
        depac = {
            packages = {
                --> Core
                "amd-ucode",
                "arch-install-scripts",
                "artix-archlinux-support",
                "base",
                "base-devel",
                "cryptsetup",
                "dinit",
                "efibootmgr",
                "elogind-dinit",
                "grub",
                "linux",
                "linux-firmware",
                "linux-headers",
                "linux-zen",
                "linux-zen-headers",

                --> Corey
                "bluez-dinit",
                "chrony",
                "chrony-dinit",
                "networkmanager",
                "networkmanager-dinit",
                "nvidia-open-dkms",
                "openssh",
                "opentabletdriver",
                "rtkit",
                "scx-scheds",
                "pipewire-dinit",
                "pipewire-pulse-dinit",
                "wireplumber-dinit",
                "dnsmasq",

                --> Fonts
                "noto-fonts",
                "noto-fonts-emoji",
                "rose-pine-hyprcursor",
                "ttf-cascadia-code-nerd",

                --> Virtualisation
                "distrobox",
                "libvirt-dinit",
                "podman",
                "qemu-base",
                "qemu-hw-usb-host",
                "swtpm",
                "virt-manager",

                "btop",
                "fastfetch",
                "flatpak",
                "fzf",
                "less",
                "nvtop",
                "rsync",
                "unzip",

                "clang",
                "libc++",
                "rustup",
                "tokei",
                "vulkan-headers",

                "cosmic-files",
                "gamescope",
                "kitty",

                "blender",
                "firefox",
                "flatseal",
                "krita",
                "mpv",
                "obs-studio",
                "pureref",
                "signal-desktop",
                "telegram-desktop",
                "vesktop-bin",
                "yt-dlp",

                "protonup-qt-bin",
                "steam",
                "umu-launcher",
                "wine-staging",
                "winetricks",
            },

            ignore = {
                "brave-origin-nightly-bin",
                "discord-chat-exporter-cli-bin",
                "grimblast-git",
                "noctalia-git",
                "userspawn-git",
                "paru",
            }
        }
    })
    return result
end
