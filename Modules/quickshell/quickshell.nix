{ pkgs, userName, modulesDir, ... }:
{
  environment.systemPackages = with pkgs; [
    quickshell
  ];

  home-manager.users.${userName} = { config, ... }: {
    xdg.configFile."quickshell".source =
      config.lib.file.mkOutOfStoreSymlink (modulesDir + "/quickshell/source");
  };
}
