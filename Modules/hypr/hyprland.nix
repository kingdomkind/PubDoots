{ config, hostName, pkgs, inputs, ... }:
{
  xdg.configFile."hypr/hyprland.conf".source =
    config.lib.file.mkOutOfStoreSymlink ./hyprland.conf;

  xdg.configFile."hypr/hyprext.conf".source =
    config.lib.file.mkOutOfStoreSymlink ../../Unique/${hostName}/hyprext.conf;

  home.packages = with pkgs; [
    hyprland
    inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
