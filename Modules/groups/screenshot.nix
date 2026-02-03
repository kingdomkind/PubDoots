{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wayfreeze
    satty
    grim
    slurp
    wl-clipboard
  ];
}
