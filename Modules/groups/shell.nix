{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ripgrep
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
