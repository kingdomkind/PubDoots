{ pkgs, ... }:
{
  imports = [
    ../../hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

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
  };

  services.getty.autologinUser = "pika";

  users.users.pika = {
    isNormalUser = true;
    description = "pika";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    packages = with pkgs; [
    ];
    shell = pkgs.zsh;
  };

  services.openssh.enable = true;
  system.stateVersion = "25.11";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "3d";
    options = "--delete-older-than 3d";
  };
}
