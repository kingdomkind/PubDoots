{
  inputs,
  pkgs,
  userName,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    jq
    brightnessctl
  ];
  home-manager.users.${userName} = {
    imports = [
      inputs.noctalia.homeModules.default
    ];
    programs.noctalia-shell = {
      enable = true;
      settings = {
        colorSchemes.predefinedScheme = "Rose Pine";
        dock.enabled = false;
        notifications = {
          density = "compact";
          location = "top";
        };
        wallpaper = {
          enabled = true;
          directory = "/home/${userName}/Pictures/Wallpapers";
        };

        general.animationSpeed = 2;

        appLauncher = {
          showCategories = false;
        };

        bar = {
          backgroundOpacity = 1;
          barType = "framed";
          density = "comfortable";
          displayMode = "always_visible";
          frameRadius = 15;
          frameThickness = 24;
          position = "top";
          showCapsule = false;
          useSeparateOpacity = true;
          widgets = {
            left = [
              { id = "Workspace"; }
              { id = "WallpaperSelector"; }
              {
                id = "AudioVisualizer";
                width = 200;
              }
              { id = "MediaMini"; }
            ];
            center = [
              { id = "Clock"; }
            ];
            right = [
              { id = "SystemMonitor"; }
              { id = "Tray"; }
              { id = "NotificationHistory"; }
              { id = "Battery"; }
              { id = "Volume"; }
              { id = "Brightness"; }
              { id = "ControlCenter"; }
            ];
          };
        };
      };
    };
  };
}
