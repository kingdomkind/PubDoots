{ pkgs, userName, ... }:
{
  programs.dconf.enable = true;

  home-manager.users.${userName} = {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    home.packages = with pkgs; [
      adwaita-qt
      qt6Packages.qt6ct
      libsForQt5.qt5ct
    ];
  };
}
