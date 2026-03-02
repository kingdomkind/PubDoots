{
  config,
  modulesDir,
  uniqueDir,
  pkgs,
  lib,
  inputs,
  userName,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    # config.common.default = "cosmic";
    config.common = {
      default = "hyprland";
      "org.freedesktop.impl.portal.FileChooser" = "cosmic";
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-cosmic
    ];
  };

  environment.systemPackages = [
    inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.users.${userName} =
    { config, ... }:
    {
      xdg.configFile."hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink (
        modulesDir + "/hypr/hyprland.conf"
      );

      xdg.configFile."hypr/hyprext.conf".source = config.lib.file.mkOutOfStoreSymlink (
        uniqueDir + "/hyprext.conf"
      );
    };
}
