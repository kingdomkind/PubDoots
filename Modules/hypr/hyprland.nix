{
  config,
  modulesDir,
  uniqueDir,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  xdg.configFile."hypr/hyprland.conf".source =
    config.lib.file.mkOutOfStoreSymlink (modulesDir + "/hypr/hyprland.conf");

  xdg.configFile."hypr/hyprext.conf".source =
    config.lib.file.mkOutOfStoreSymlink (uniqueDir + "/hyprext.conf");

  xdg.portal = {
    enable = true;
    config.common.default = "cosmic";
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-cosmic
    ];
  };

  home.packages = with pkgs; [
    # hyprland
    inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
