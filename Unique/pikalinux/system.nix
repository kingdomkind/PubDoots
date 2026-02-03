{ pkgs, ... }:
{
  imports = [
    ../../Modules/base/base.nix
    ../../Modules/nvidia/nvidia.nix
    ../../Modules/vfio/vfio.nix
    ../../Modules/zsh/zsh.nix
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

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

}
