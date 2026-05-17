{
  inputs,
  pkgs,
  userName,
  ...
}:
{
  services.upower.enable = true;

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
          automationEnabled = true;
          randomIntervalSec = 10800;
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
          widgetSpacing = 0;
          widgets = {
            left = [
              { id = "Workspace"; }
              { id = "SystemMonitor"; }
              { id = "NotificationHistory"; }
              {
                id = "AudioVisualizer";
                width = 200;
              }
              {
                id = "MediaMini";
                maxWidth = 400;
              }
            ];
            center = [
              { id = "Clock"; }
            ];
            right = [
              { id = "Tray"; }
              { id = "Brightness"; }
              { id = "Network"; }
              { id = "Bluetooth"; }
              { id = "Volume"; }
              {
                id = "Battery";
                alwaysShowPercentage = true;
              }
              { id = "ControlCenter"; }
            ];
          };
        };
      };
    };
  };
}
