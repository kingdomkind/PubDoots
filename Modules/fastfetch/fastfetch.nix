{ pkgs, userName, modulesDir, ... }:
{
  environment.systemPackages = with pkgs; [
    fastfetch
  ];

  home-manager.users.${userName} = { config, ... }: {
    xdg.configFile."fastfetch/config.jsonc".source =
      config.lib.file.mkOutOfStoreSymlink (modulesDir + "/fastfetch/config.jsonc");
  };
}
