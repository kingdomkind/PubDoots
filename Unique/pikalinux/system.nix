{
  config,
  pkgs,
  uniqueDir,
  userName,
  ...
}:
{
  imports = [
    ../../Modules/base/base.nix
    ../../Modules/nvidia/nvidia.nix
    ../../Modules/vfio/vfio.nix
    ../../Modules/zsh/zsh.nix
    ../../Modules/groups/shell.nix
    ../../Modules/hypr/hyprland.nix
    ../../Modules/neovim/neovim.nix
    ../../Modules/kitty/kitty.nix
    ../../Modules/brave/brave.nix
    ../../Modules/fastfetch/fastfetch.nix
    ../../Modules/sherlock/sherlock.nix
    ../../Modules/groups/screenshot.nix
    ../../Modules/quickshell/quickshell.nix
    ../../Modules/remote/remote.nix
    ./tablet/tablet.nix
  ];

  networking.hostName = "pikalinux";

  environment.systemPackages = with pkgs; [
    yazi
    rustup
    localsend
    signal-desktop
    unzip
    codex
    btop
    vesktop
    adwsteamgtk
    steam
    tor-browser
    krita
    firefox
  ];

  # Decrypt secondary drive
  boot.initrd.luks.devices."data" = {
    device = "/dev/disk/by-uuid/c8dd5d21-4489-4551-a4ed-edea6456a739";
  };

  fileSystems."/home/pika/Documents" = {
    device = "/dev/mapper/data";
    fsType = "btrfs";
    options = [ "nofail" ];
  };

  home-manager.users.${userName} = {
    home.stateVersion = "25.05";
  };
}
