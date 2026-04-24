{
  pkgs,
  modulesDir,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../Modules/groups/base.nix
    ../../Modules/groups/nvidia.nix
    ../../Modules/groups/vfio.nix
    ../../Modules/groups/zsh.nix
    ../../Modules/groups/shell.nix
    ../../Modules/groups/dark.nix
    (import ../../Modules/groups/swapfile.nix {
      size = 48;
    })
    ../../Modules/hypr/hyprland.nix
    ../../Modules/neovim/neovim.nix
    ../../Modules/kitty/kitty.nix
    ../../Modules/groups/brave.nix
    ../../Modules/fastfetch/fastfetch.nix
    ../../Modules/sherlock/sherlock.nix
    ../../Modules/groups/screenshot.nix
    ../../Modules/groups/remote.nix
    ../../Modules/groups/bluetooth.nix
    ../../Modules/groups/obs.nix
    ../../Modules/groups/hardenednetwork.nix
    ../../Modules/groups/noctalia.nix

    ./tablet/tablet.nix
  ];

  networking.hostName = "pikalinux";

  environment.systemPackages = with pkgs; [
    yazi
    rustup
    signal-desktop
    codex
    btop
    vesktop
    steam
    krita
    firefox
    mpv
    cosmic-files
    exfatprogs
    zip
    unzip
    libreoffice
    yt-dlp
    cloc
    discordchatexporter-desktop
    telegram-desktop
  ];

  programs.localsend.enable = true;

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

  networking = {
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;
}
