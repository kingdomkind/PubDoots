{ lib, ramGiB ? null, ... }:
{
  assertions = [
    {
      assertion = ramGiB != null && lib.isInt ramGiB && ramGiB > 0;
      message = "Modules/groups/swapfile.nix requires ramGiB to be a positive integer.";
    }
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = ramGiB * 1024; # MiB
    }
  ];
}
