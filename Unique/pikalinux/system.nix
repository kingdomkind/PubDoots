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
  ];
}
