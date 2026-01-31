return function(Info)
    return {
        Symlinks = {
            [Info.Home .. "/.zshrc"] = Info.Modules .. "/zsh/desktopdefault",
            [Info.Home .. "/.ssh/config"] = Info.Modules .. "/ssh.config",
            [Info.DotConfig .. "/nvim"] = Info.Modules .. "/neovim",
            [Info.DotConfig .. "/hypr"] = Info.Modules .. "/hypr",
            [Info.DotConfig .. "/sherlock"] = Info.Modules .. "/sherlock",
            [Info.DotConfig .. "/fastfetch"] = Info.Modules .. "/fastfetch",
            [Info.DotConfig .. "/kitty"] = Info.Modules .. "/kitty",
            [Info.DotConfig .. "/quickshell"] = Info.Modules .. "/quickshell",
            ["/etc/nix/nix.conf"] = Info.Modules .. "/nix/nix.conf",
            ["/etc/default/grub"] = Info.HostPath .. "/boot/grub",
        },

        Settings = {
            AddSymlinkConfirmation = false,
            AddPathConfirmation = true,
            RemovePathConfirmation = true,
            CachePath = Info.DotConfig .. "/",
            SuperuserCommand = "sudo",
        }
    }
end
