local pl_file = require("pl.file");

return function(lib)
    return {
        desym = {
            files = {
                ["/etc/pacman.conf"] = lib:root_file(pl_file.read(lib.cwd() .. "pacman.conf"))
            }
        },
        depac = {
            packages = {
                "gcc",
                "git",
                "sudo",
                "networkmanager",
                "efibootmgr",
                "dinit",
                "elogind-dinit",
                "cryptsetup",
                "base",
                "base-devel",
                "bluez-dinit",
                "chrony-dinit",
                "networkmanager-dinit",
                "openssh",
                "pipewire-dinit",
                "pipewire-pulse-dinit",
                "wireplumber-dinit",
                "dnsmasq",
                "noto-fonts",
                "noto-fonts-emoji",
                "ttf-cascadia-code-nerd",
                "arch-install-scripts",
                "artix-archlinux-support",

            },
            ignore = {
                "cachyos-keyring",
                "cachyos-mirrorlist",
                "cachyos-v3-mirrorlist",
            }
        }
    }
end
