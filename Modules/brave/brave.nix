{ pkgs, userName, ... }:
{
  home-manager.users.${userName} = {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "jdbnofccmhefkmjbkkdkfiicjkgofkdh"; } # Bookmark Sidebar
        { id = "jinjaccalgkegednnccohejagnlnfdag"; } # Violentmonkey
        { id = "ponfpcnoihfmfllpaingbgckeeldkhle"; } # Enhancer for YouTube
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock for YouTube
        { id = "khncfooichmfjbepaaaebmommgaepoid"; } # Unhook
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      ];
    };
  };
}
