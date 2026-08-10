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
        { lib.modulesd .. "fstab/fstab.lua",           { source = lib.cwd() .. "fstab" } },
        { lib.modulesd .. "mkinitcpio/mkinitcpio.lua", { source = lib.cwd() .. "mkinitcpio.conf", custom = { "multi-decrypt" } } },
        { lib.modulesd .. "scheds/scheds.lua",         { sched = "scx_lavd" } },
        lib.modulesd .. "autologin/autologin.lua",
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
                "linux-cachyos",
                "linux-cachyos-headers",
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
                "libvirt-dinit",
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
                "firefox",
                "krita",
                "mpv",
                "obs-studio",
                "signal-desktop",
                "telegram-desktop",
                "yt-dlp",
                "steam",
                "umu-launcher",
                "winetricks",
                "kicad",
                "wayland-utils",
                "vesktop",
                "brave-origin-bin",
                "downgrade",
                "cuda",
                "mold",
                "openai-codex",
            },

            ignore = {
                "discord-chat-exporter-cli-bin",
                "userspawn-git",
                "protonup-qt-bin",
                "pureref",
                "yay",
                "havoc",
                "cachyos-keyring",
                "cachyos-mirrorlist",
                "cachyos-v3-mirrorlist",
            }
        },
        desym = {
            files = {
                ["/etc/NetworkManager/conf.d/0-global-dns.conf"] = lib:root_file("[global-dns-domain-*]\nservers=1.1.1.1,1.0.0.1")
            }
        }
    })
    return result
end
