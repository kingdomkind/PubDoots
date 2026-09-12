return function(lib)
    local result = lib.imports({}, {
        lib.modulesd .. "artix/artix.lua",
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
                "vesktop",
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
            },

            pkgbuilds = {
                "protonup-qt-bin",
                "pureref",
                "yay",
                "havoc",
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
                ["/usr/local/sbin/evsieve"] = lib:root_binary([[
#!/bin/sh
exec /usr/bin/evsieve \
    --input /dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd domain=kb grab \
    --input /dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse domain=ms grab \
    --hook key:leftctrl key:leftalt toggle breaks-on=key::1 sequential \
    --toggle @kb @host-kb @guest-kb \
    --toggle @ms @host-ms @guest-ms \
    --output @host-kb create-link=/dev/input/by-id/host-keyboard repeat=enable \
    --output @host-ms create-link=/dev/input/by-id/host-mouse \
    --output @guest-kb create-link=/dev/input/by-id/guest-keyboard repeat=enable\
    --output @guest-ms create-link=/dev/input/by-id/guest-mouse]]),
                ["/etc/dinit.d/evsieve"] = lib:root_file([[
type = process
command = /usr/local/sbin/evsieve
depends-on = udev-settle
restart = true
log-type = buffer
restart-delay = 2]]),
                ["/etc/dinit.d/scx_lavd"] = lib:root_file([[
type = process
command = /usr/bin/scx_lavd
restart = true
restart-delay = 2]]),
                --> Prevent access to GPU0
                ["/etc/udev/rules.d/99-gpu0-access.rules"] = lib:root_file([[
#> Remove logind tags (so logind doesn't try to mess wit it) and deny pika access to programs don't try to open it
ACTION=="add|change", SUBSYSTEM=="drm", KERNELS=="0000:06:00.0", ENV{MAJOR}!="", TAG-="uaccess", TAG-="seat", TAG-="master-of-seat", RUN+="/usr/bin/setfacl -b $devnode", RUN+="/usr/bin/setfacl -m u:pika:--- $devnode"

#> Run this script, when the nvidia drivers binds to the GPU
ACTION=="add|bind", SUBSYSTEM=="pci", KERNEL=="0000:06:00.0", DRIVER=="nvidia", RUN+="/usr/local/sbin/gpu0-access"]]),
                ["/usr/local/sbin/gpu0-access"] = lib:root_binary([[
#!/bin/sh
set -eu
PATH=/usr/bin:/usr/sbin
#> Sets the permissions again, when the nvidia GPU binds

gpu_info=/proc/driver/nvidia/gpus/0000:06:00.0/information
[ -r "$gpu_info" ] || exit 0 #> Target GPU doesn't exist

#> Get rdev minor
gpu_minor=$(awk '/^Device Minor:/ {print $3}' "$gpu_info")
case "$gpu_minor" in ''|*[!0-9]*) exit 1 ;; esac
gpu_node=/dev/nvidia$gpu_minor
nvidia-modprobe -c "$gpu_minor"
[ -c "$gpu_node" ] || exit 1 #> Ensure the node exists (and is a character file, i.e. continuous)

#> https://forums.developer.nvidia.com/t/devices-permission-reset/110139/2
#> Abuse facl's to get around the regular permission bits being reset
setfacl -b "$gpu_node"
setfacl -m u:pika:--- "$gpu_node"
for gpu_drm in /sys/bus/pci/devices/0000:06:00.0/drm/*; do
    [ -r "$gpu_drm/dev" ] || continue
    gpu_drm_node=/dev/dri/${gpu_drm##*/}
    [ -c "$gpu_drm_node" ] || continue
    setfacl -b "$gpu_drm_node"
    setfacl -m u:pika:--- "$gpu_drm_node"
done]])
            }
        }
    })
    return result
end
