local pl_file = require("pl.file");

return function(lib)
    return {
        desym = {
            files = {
                ["/etc/pacman.conf"] = lib:root_file(pl_file.read(lib.cwd() .. "pacman.conf")),
                --> Make pk-exec cache the password / authorisation
                ["/etc/polkit-1/rules.d/49-pkexec.rules"] = lib:root_file(pl_file.read(lib.cwd() .. "49-pkexec.rules")),
                --> Add fingerprint support to polkit, if fprintd exists
                ["/etc/pam.d/polkit-1"] = lib:root_file(pl_file.read(lib.cwd() .. "polkit-1"))
            }
        },
        depac = {
            packages = {
                "luajit",
                "lua-lux",
                "lux-cli",
                "jq",
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
                "polkit",
                "arch-install-scripts",
                "artix-archlinux-support",

            },
            ignore = {
                "cachyos-keyring",
                "cachyos-mirrorlist",
                "cachyos-v3-mirrorlist",
            },
            settings = {
                ["elevation"] = "pkexec"
            }
        }
    }
end
