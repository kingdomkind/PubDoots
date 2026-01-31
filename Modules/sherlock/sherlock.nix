{ config, pkgs, ... }:
{
  xdg.configFile."sherlock".source =
    config.lib.file.mkOutOfStoreSymlink ./source;

  home.packages = with pkgs; [
    sherlock-launcher
  ];
}
