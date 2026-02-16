{
  size,
  ...
}:
{
  swapDevices = [
    {
      device = "/swapfile";
      size = size * 1024; # MiB
    }
  ];

  boot.initrd.systemd.enable = true;
}
