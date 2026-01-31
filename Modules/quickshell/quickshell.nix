{ config, pkgs, ... }:
{
  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink ./source;

  home.packages = with pkgs; [
    quickshell
  ];
}
