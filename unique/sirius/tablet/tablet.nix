{
  config,
  lib,
  pkgs,
  uniqueDir,
  userName,
  ...
}:
{
  hardware.opentabletdriver.enable = true;
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];

  home-manager.users.${userName} = { config, ... }: {
    xdg.configFile."OpenTabletDriver/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink (uniqueDir + "/tablet/settings.json");
  };
}
