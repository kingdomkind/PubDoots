{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    wayfreeze
    satty
    grim
    slurp
    wl-clipboard
  ];
}
