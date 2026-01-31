{ config, pkgs, ... }:
{
  xdg.configFile."fastfetch/config.jsonc".source =
    config.lib.file.mkOutOfStoreSymlink ./config.jsonc;

  home.packages = with pkgs; [
    fastfetch
  ];
}
