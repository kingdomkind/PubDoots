{
  config,
  lib,
  pkgs,
  userName,
  ...
}:
{
  imports = [ ];

  nixpkgs.config.allowUnfree = true;
  boot.initrd.systemd.enable = true;

  home-manager.users.${userName} = {
    home.stateVersion = "26.05";
  };

  # Allow home manager to specify the xdg portals
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];

  fonts.packages = with pkgs; [
    cascadia-code
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.getty.autologinUser = userName;

  users.users.${userName} = {
    isNormalUser = true;
    description = userName;
    group = "users";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  users.groups.${userName} = { };

  services.openssh.enable = true;
  system.stateVersion = "25.11";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  systemd.settings.Manager.DefaultTimeoutStopSec = "5s";
  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

  nix.gc = {
    automatic = true;
    dates = "3d";
    options = "--delete-older-than 3d";
  };
}
