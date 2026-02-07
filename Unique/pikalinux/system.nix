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
    ../../Modules/base/base.nix
    ../../Modules/nvidia/nvidia.nix
    ../../Modules/vfio/vfio.nix
    ../../Modules/zsh/zsh.nix
    ../../Modules/groups/shell.nix
    (import ../../Modules/groups/swapfile.nix {
      lib = pkgs.lib;
      ramGiB = 48;
    })
    ../../Modules/hypr/hyprland.nix
    ../../Modules/neovim/neovim.nix
    ../../Modules/kitty/kitty.nix
    ../../Modules/brave/brave.nix
    ../../Modules/fastfetch/fastfetch.nix
    ../../Modules/sherlock/sherlock.nix
    ../../Modules/groups/screenshot.nix
    ../../Modules/quickshell/quickshell.nix
    ../../Modules/remote/remote.nix
    ../../Modules/bluetooth/bluetooth.nix
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

  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      "org.vinegarhq.Sober"
    ];
  };
}
