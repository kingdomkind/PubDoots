{ pkgs, userName, modulesDir, ... }:
{
  environment.systemPackages = with pkgs; [
    sherlock-launcher
  ];

  home-manager.users.${userName} = { config, ... }: {
    xdg.configFile."sherlock".source =
      config.lib.file.mkOutOfStoreSymlink (modulesDir + "/sherlock/source");
  };
}
