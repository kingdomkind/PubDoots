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
    ../../Modules/quickshell/quickshell.nix
    ../../Modules/groups/remote.nix
    ../../Modules/groups/bluetooth.nix
    ../../Modules/groups/obs.nix

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
    mpv
    cosmic-files
    exfatprogs
    zip
    unzip
    libreoffice
    yt-dlp
    cloc
    dino
    discordchatexporter-desktop
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

  services.udisks2.enable = true;
  services.gvfs.enable = true;
}
