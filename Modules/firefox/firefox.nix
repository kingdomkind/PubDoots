{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;

  user_chrome = ''
    /* Make the sidebar smaller */
    #sidebar-main {
      background-image: linear-gradient(transparent, transparent),
        var(--lwt-additional-images,none),
        var(--lwt-header-image, none) !important;
      background-position: left top !important;
      background-size: auto !important;
    }

    .actions-list {
      & > moz-button {
        --button-outer-padding-block: 0px !important;
        --button-outer-padding-block-start: 0px !important;
        --button-outer-padding-block-end: 0px !important;
        --button-outer-padding-inline: 0px !important;
        --button-outer-padding-inline-start: 4px !important;
        --button-outer-padding-inline-end: 4px !important;
      }
    }

    /* Fix bright line on the sidebar when not hovered */
    .sidebar-splitter {
      min-width: 0 !important;
      width: 0 !important;
    }

    /* Make the sidebar smaller */
    :root {
      --tab-inner-inline-margin: 4px !important;
    }
  '';

  user_settings = {
    # Disable first-run stuff
    "browser.disableResetPrompt" = true;
    "browser.download.panel.shown" = true;
    "browser.feeds.showFirstRunUI" = false;
    "browser.messaging-system.whatsNewPanel.enabled" = false;
    "browser.rights.3.shown" = true;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.shell.defaultBrowserCheckCount" = 1;
    "browser.startup.homepage_override.mstone" = "ignore";
    "browser.uitour.enabled" = false;
    "startup.homepage_override_url" = "";
    "trailhead.firstrun.didSeeAboutWelcome" = true;
    "browser.bookmarks.restore_default_bookmarks" = false;
    "browser.bookmarks.addedImportButton" = true;

    # Allow extensions to be auto-enabled
    "extensions.autoDisableScopes" = 0;

    "browser.tabs.inTitlebar" = 0;
    "sidebar.backupState" =
      ''{"command":"","panelOpen":false,"launcherWidth":40,"launcherExpanded":false,"launcherVisible":true}'';

    "browser.download.autohideButton" = false;

    # Scroll on middle mouse
    "general.autoScroll" = true;

    # Do not round viewport
    "sidebar.revamp.round-content-area" = false;

    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

    # Disable alt to show menu bar
    "ui.key.menuAccessKeyFocuses" = false;

    "browser.tabs.closeWindowWithLastTab" = false;

    "sidebar.verticalTabs" = true;
    "sidebar.revamp" = true;
    "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
    "sidebar.main.tools" = [ ];

    "browser.aboutConfig.showWarning" = false;

    "browser.uiCustomization.state" = builtins.toJSON {
      placements = {
        widget-overflow-fixed-list = [ ];
        unified-extensions-area = [ ];
        nav-bar = [
          "back-button"
          "forward-button"
          "stop-reload-button"
          "vertical-spacer"
          "urlbar-container"
          "downloads-button"
          "sidebar-button"
          "unified-extensions-button"
        ];
        toolbar-menubar = [ "menubar-items" ];
        TabsToolbar = [ ];
        vertical-tabs = [ "tabbrowser-tabs" ];
        PersonalToolbar = [
          "import-button"
          "personal-bookmarks"
        ];
      };

      seen = [
        "developer-button"
        "screenshot-button"
      ];

      currentVersion = 23;
    };
  };

  mkThemeXpi =
    {
      pname,
      version,
      addonId,
      url,
      sha256,
      description,
      license,
    }:
    inputs.firefox-addons.lib.${system}.buildFirefoxXpiAddon {
      inherit
        pname
        version
        addonId
        url
        sha256
        ;
      meta = with pkgs.lib; {
        inherit description license;
        mozPermissions = [ ];
        platforms = platforms.all;
      };
    };

in
{
  imports = [
    inputs.arkenfox.hmModules.arkenfox
  ];

  programs.firefox = {
    enable = true;

    arkenfox.enable = true;
    arkenfox.version = "master";
    package = pkgs.firefox;

    profiles.default = {
      id = 0;

      arkenfox = {
        enable = true;
        enableAllSections = true;
      };

      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
      };

      extensions.packages =
        let
          addons = inputs.firefox-addons.packages.${system};
        in
        [
          addons.bitwarden
          addons.ublock-origin
          addons.tabliss

          (mkThemeXpi {
            pname = "purple-starfield-animated";
            version = "1.0";
            addonId = "{5adf2485-4acd-42a8-b04c-1b0a6b03ddd0}";
            url = "https://addons.mozilla.org/firefox/downloads/file/4061627/purple-starfield-animated-1.0.xpi";
            sha256 = "0wvcgd6xqp7zdq57gk3sr5gws4fdxhi566l07crzqcrbgiilgzbm";
            description = "Animated purple starfield Firefox theme";
            license = pkgs.lib.licenses.mit; # It is actually cc-by-nc-sa-30
          })
        ];

      userChrome = user_chrome;

      settings = user_settings // {
        "extensions.activeThemeID" = "{5adf2485-4acd-42a8-b04c-1b0a6b03ddd0}";

        "uBlock0@raymondhill.net".settings = {
          # Find Lists: https://raw.githubusercontent.com/gorhill/uBlock/master/assets/assets.json
          selectedFilterLists = [
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "ublock-quick-fixes"
            "adguard-cookies"
            "ublock-cookies-adguard"
          ];
        };
      };
    };

    profiles.work = {
      id = 1;
      arkenfox.enable = false;

      extensions.packages =
        let
          addons = inputs.firefox-addons.packages.${system};
        in
        [
          addons.bitwarden
          addons.ublock-origin
          addons.tabliss

          (mkThemeXpi {
            pname = "falling-snow-animated-theme";
            version = "1.0";
            addonId = "{282f6081-e216-40d4-b31a-9e6f51b473e7}";
            url = "https://addons.mozilla.org/firefox/downloads/file/4146711/falling_snow_animated_theme-1.0.xpi";
            sha256 = "16xapqi8irnbzx98x64jgqrzc5zm8v60qw5avh28ni9fc91vrccq";
            description = "Enjoy this wintery dark blue animated falling snow theme!";
            license = pkgs.lib.licenses.mit; # i forgot what this one actually was
          })
        ];

      userChrome = user_chrome;

      settings = user_settings // {
        "extensions.activeThemeID" = "{282f6081-e216-40d4-b31a-9e6f51b473e7}";
      };
    };
  };
}
