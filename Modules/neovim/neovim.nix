{
  pkgs,
  userName,
  modulesDir,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    rust-analyzer
    nixd
    nixfmt
    llvmPackages_20.clang-tools
    neovim
  ];

  home-manager.users.${userName} =
    { config, ... }:
    {
      xdg.configFile."nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink (
        modulesDir + "/neovim/init.lua"
      );
    };
}
