{ userName, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    ripdrag
  ];

  home-manager.users.${userName} = {
    programs.yazi = {
      enable = true;

      keymap = {
        manager.prepend_keymap = [
          {
            on = "<C-n>";
            run = "shell '${lib.getExe pkgs.ripdrag} \"$@\" -x 2>/dev/null &'";
            desc = "Drag file";
          }
        ];
      };
    };
  };
}
