local pl_file = require("pl.file")

return function(lib)
    local result = lib.imports({}, {
        lib.modulesd .. "artix/artix.lua",
        lib.modulesd .. "fastfetch/fastfetch.lua",
        lib.modulesd .. "kitty/kitty.lua",
        lib.modulesd .. "neovim/neovim.lua",
        { lib.modulesd .. "zsh/zsh.lua",   { launch = "exec /home/pika/PubDoots/unique/sirius/launcher/first.sh" } },
        lib.modulesd .. "noctalia/noctalia.lua",
        lib.modulesd .. "yazi/yazi.lua",
        { lib.modulesd .. "hypr/hypr.lua", { extension = lib.cwd() .. "hyprext.lua" } },
        lib.modulesd .. "jj/jj.lua",
        { lib.modulesd .. "grub/grub.lua",             { source = lib.cwd() .. "grub" } },
        { lib.modulesd .. "fstab/fstab.lua",           { source = lib.cwd() .. "fstab" } },
        { lib.modulesd .. "mkinitcpio/mkinitcpio.lua", { source = lib.cwd() .. "mkinitcpio.conf", custom = { "multi-decrypt" } } },
        lib.modulesd .. "autologin/autologin.lua",
        lib.modulesd .. "glide/glide.lua",
        lib.uniqued .. "tablet/tablet.lua",
    })

    lib.merge(result, {
        depac = {
            packages = {
                "amd-ucode",
                "linux-cachyos",
                "linux-cachyos-headers",
                "linux-firmware-nvidia",
                "linux-firmware-realtek",
                "nvidia-open-dkms",
                "libva-nvidia-driver",
                "opentabletdriver",
                "syslog-ng-dinit",

                "libvirt-dinit",
                "qemu-base",
                "qemu-hw-usb-host",
                "swtpm",
                "virt-manager",

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
                "brave-origin-bin",
                "downgrade",
                "cuda",
                "mold",
                "occt",
                "llama-cpp",
                "ggml-cuda",
                "opencode",
                "qemu-hw-display-qxl",
                "scx-scheds",
                "rtkit",
                "openai-codex",
                "cmake",
            },

            pkgbuilds = {
                "protonup-qt-bin",
                "pureref",
                "yay",
                "havoc",
                "nsight-graphics",
                { ["base"] = "userspawn-git",             rpc = false },
                { ["base"] = "evsieve-git",               rpc = false },
                { ["base"] = "jellium-desktop-git",       rpc = false },
                { ["base"] = "discord-chat-exporter-bin", ["artifacts"] = { "discord-chat-exporter-cli-bin" } }
            }
        },
        desym = {
            files = {
                ["/etc/NetworkManager/conf.d/0-global-dns.conf"] = lib:root_file(
                    "[global-dns-domain-*]\nservers=1.1.1.1,1.0.0.1"
                ),
                ["/usr/local/sbin/evsieve"] = lib:root_binary(pl_file.read(lib.cwd() .. "evsieve.sh")),
                ["/etc/dinit.d/evsieve"] = lib:root_file(pl_file.read(lib.cwd() .. "evsieve.service")),
                ["/etc/dinit.d/scx_lavd"] = lib:root_file(pl_file.read(lib.cwd() .. "scx_lavd.service")),
                [lib.homed .. ".config/dinit.d/llama"] = lib:user_file(pl_file.read(lib.cwd() .. "llama.service")),
                ["/etc/libvirt/hooks/qemu.d/libvirt-hook.sh"] = lib:root_binary(pl_file.read(lib.cwd() .. "libvirt-hook.sh")),
            }
        }
    })
    return result
end
