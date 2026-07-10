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
        { lib.modulesd .. "scheds/scheds.lua",         { sched = "scx_lavd" } },
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
                "linux-zen",
                "linux-zen-headers",
                "linux-firmware-nvidia",
                "linux-firmware-realtek",

                --> Corey
                "bluez-dinit",
                "chrony-dinit",
                "networkmanager-dinit",
                "nvidia-open-dkms",
                "openssh",
                "opentabletdriver",
                "pipewire-dinit",
                "pipewire-pulse-dinit",
                "wireplumber-dinit",
                "dnsmasq",

                --> Fonts
                "noto-fonts",
                "noto-fonts-emoji",

                --> Virtualisation
                "distrobox",
                "libvirt-dinit",
                "podman",
                "qemu-base",
                "qemu-hw-usb-host",
                "swtpm",
                "virt-manager",

                --> Apps
                "blueman",
                "btop",
                "fastfetch",
                "flatpak",
                "less",
                "nvtop",
                "rsync",
                "unzip",
                "libc++",
                "rustup",
                "tokei",
                "vulkan-headers",
                "cosmic-files",
                "gamescope",
                "blender",
                "firefox",
                "flatseal",
                "krita",
                "mpv",
                "obs-studio",
                "signal-desktop",
                "telegram-desktop",
                "yt-dlp",
                "steam",
                "umu-launcher",
                "winetricks",
            },

            ignore = {
                "brave-origin-nightly-bin",
                "discord-chat-exporter-cli-bin",
                "userspawn-git",
                "protonup-qt-bin",
                "pureref",
                "vesktop-bin",
                "paru",
            }
        }
    })
    return result
end
