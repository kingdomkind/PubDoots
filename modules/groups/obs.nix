{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obs-studio
  ];

  boot.kernelModules = [ "v4l2loopback" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
}
