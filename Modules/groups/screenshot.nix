{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # wayfreeze
    satty
    # grim
    # slurp
    killall
    grimblast
    wl-clipboard
  ];
}
