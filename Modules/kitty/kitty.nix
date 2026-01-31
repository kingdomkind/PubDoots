{ config, pkgs, ... }:
{
  xdg.configFile."kitty".source =
    config.lib.file.mkOutOfStoreSymlink ./source;

  home.packages = with pkgs; [
    kitty
  ];
}
