{ config, lib, ... }:
{
  imports = [
    ../../Modules/firefox/firefox.nix
    ../../Modules/hypr/hyprland.nix
    ../../Modules/neovim/neovim.nix
    ../../Modules/kitty/kitty.nix
    ../../Modules/fastfetch/fastfetch.nix
    ../../Modules/sherlock/sherlock.nix
    ../../Modules/groups/screenshot.nix
    ../../Modules/quickshell/quickshell.nix
    ../../Modules/remote/remote.nix
  ];

  home.stateVersion = "25.05";

}
