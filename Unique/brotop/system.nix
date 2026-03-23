{
  config,
  pkgs,
  uniqueDir,
  userName,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../Modules/groups/base.nix
    ../../Modules/groups/zsh.nix
    ../../Modules/groups/shell.nix
    ../../Modules/groups/dark.nix
    (import ../../Modules/groups/swapfile.nix {
      size = 16;
    })
    ../../Modules/hypr/hyprland.nix
    ../../Modules/neovim/neovim.nix
    ../../Modules/kitty/kitty.nix
    ../../Modules/groups/brave.nix
    ../../Modules/fastfetch/fastfetch.nix
    ../../Modules/sherlock/sherlock.nix
    ../../Modules/groups/screenshot.nix
    ../../Modules/groups/yazi.nix
    ../../Modules/quickshell/quickshell.nix
    ../../Modules/groups/remote.nix
    ../../Modules/groups/bluetooth.nix
    ../../Modules/groups/fingerprint.nix
  ];

  networking.hostName = "brotop";

  environment.systemPackages = with pkgs; [
    brightnessctl
    rustup
    signal-desktop
    unzip
    codex
    btop
    vesktop
    firefox
    cosmic-files
    teams-for-linux
    cloc
  ];

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.logind.lidSwitch = "ignore";
}
