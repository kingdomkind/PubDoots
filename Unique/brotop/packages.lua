return {
    Pacman = {
        Primary = {
            --> Base
            "base",
            "base-devel",
            "linux", "linux-headers",
            "linux-firmware",
            "efibootmgr",
            "intel-ucode",
            "dkms",
            "cryptsetup",
            "networkmanager-iwd", --> From chaotic
            "grub",
            "sudo",
            "lua", "luarocks", --> For declarages
            "brightnessctl",
            "tlp", "tlp-rdw",
            "wireless-regdb", --> Set wireless to UK
            "fprintd",        --> Fingerprint
            "booster",

            --> Audio
            "libpulse",
            "pipewire",
            "pipewire-jack",
            "pipewire-pulse",
            "pipewire-alsa",
            "wireplumber",

            --> Graphics
            "mesa",
            "mesa-utils",

            --> Bluetooth
            "bluez",
            "bluez-utils", --> Eg. includes bluetoothctl
            "blueman",

            --> Package Managers
            "flatpak",
            "nix",

            --> Keyrings
            "chaotic-keyring",
            "chaotic-mirrorlist",

            --> Core
            "cloc",
            "git", "less",
            "zsh", -- The shell is ZSH for root
            "zsh-syntax-highlighting",
            "zsh-autosuggestions",
            "openssh",
            "dnsmasq",
            "ttf-cascadia-code", "noto-fonts", "noto-fonts-emoji",
            "wl-clipboard",
            "system-config-printer",
            "pacman-contrib", --> Required for pactree
            "fd",             --> Alternative to find
            "7zip",
            "ripgrep",        --> Recursive grep
            "zoxide",         --> CD replacement
            "eza",            --> LS replacement

            --> Filesystems
            "exfatprogs",

            --> Development
            "rustup",
            "meson",
            "jdk-openjdk", "maven",

            --> Apps
            "fastfetch",
            "btop",
            "neovim", "npm", "unzip", --> npm is required for BashLS, Unzip is required for Clangd
            "yazi",
            "kitty",
            "xdg-desktop-portal-hyprland", "hyprland", "hyprpaper", "uwsm",
            "grim", "slurp", "satty",
            "signal-desktop",
            "mpv",
            "firefox",
            "nautilus",
            "udisks2", --> For mounting & umounting drivers as user
            "man-db",
            "obs-studio",
            "go",        --> For yay
            "tealdeer",  --> Shorter manpages via tldr
            "playerctl", --> Issue playback commands to media playing
            "wev",       --> Check keysyms of keys
            "krita",
            "network-manager-applet",
            "libreoffice-fresh", "hunspell-en_gb", "mythes-en",
            "quickshell",

            --> Chaotic AUR
            "yay",
            "epson-inkjet-printer-escpr",
            "brave-bin",
            "downgrade",
            "zsh-vi-mode",
            "localsend",
            "teams-for-linux"
        },

        Custom = {

            {
                Base = "maypaper",
                Sub = { "maypaper" },
                RPC = false,
            },
            {
                Base = "wayfreeze-git",
                Sub = { "wayfreeze-git" },
                RPC = false,
            },
            {
                Base = "sherlock-launcher",
                Sub = { "sherlock-launcher-bin" },
                CloneCmd = "git clone https://aur.archlinux.org/sherlock-launcher.git"
            },
            {
                Base = "Rust-VPN-Handler",
                Sub = { "vpn-handler-git" },
                CloneCmd = "git clone https://github.com/initMayday/Rust-VPN-Handler"
            },
        },

        Ignore = {},

        Settings = {
            CustomLocation = os.getenv("ST_HOME") .. "/.aur/",
        },
    },

    Flatpak = {
        Primary = {
            "com.rtosta.zapzap",
        },

        Ignore = {},
    },

    Nix = {
        Primary = {
            "home-manager",
        },

        Ignore = { "home-manager-path" },
    },

    Settings = { Cores = { "Pacman", "Flatpak" } }
}
