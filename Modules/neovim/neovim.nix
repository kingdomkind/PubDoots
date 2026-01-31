{ config, pkgs, ... }:
{
  xdg.configFile."nvim/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink ./init.lua;

  home.packages = with pkgs; [
    rust-analyzer
    nixd
    nixfmt
    neovim
  ];
}
