{ pkgs, ... }:
{
  imports = [
    ../../Modules/base/base.nix
    ../../Modules/nvidia/nvidia.nix
    ../../Modules/vfio/vfio.nix
    ../../Modules/zsh/zsh.nix
  ];

  networking.hostName = "pikalinux";

  environment.systemPackages = with pkgs; [
    git
    yazi
    rustup
    localsend
    signal-desktop
    xdg-desktop-portal-gtk
    unzip
    libgcc
    codex
    btop
  ];
}
