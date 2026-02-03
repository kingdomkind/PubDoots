{ pkgs, userName, modulesDir, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
  ];

  home-manager.users.${userName} = { config, ... }: {
    xdg.configFile."kitty".source =
      config.lib.file.mkOutOfStoreSymlink (modulesDir + "/kitty/source");
  };
}
