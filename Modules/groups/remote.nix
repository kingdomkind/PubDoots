{ userName, ... }:
{
  home-manager.users.${userName} = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."github.com" = {
        user = "git";
        identityFile = "~/.ssh/github";
        identitiesOnly = true;
      };
    };

    programs.git = {
      enable = true;

      settings = {
        user = {
          name = "kingdomkind";
          email = "kingdomkind@protonmail.com";
        };
      };
    };
  };
}
