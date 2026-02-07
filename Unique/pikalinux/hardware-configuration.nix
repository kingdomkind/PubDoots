{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mapper/luks-60e20d4b-e4a1-41ee-aed9-8796955334eb";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-60e20d4b-e4a1-41ee-aed9-8796955334eb".device =
    "/dev/disk/by-uuid/60e20d4b-e4a1-41ee-aed9-8796955334eb";

  fileSystems."/home/pika/Documents" = {
    device = "/dev/mapper/data";
    fsType = "btrfs";
    options = [ "nofail" ];
  };

  boot.initrd.luks.devices."data".device = "/dev/disk/by-uuid/c8dd5d21-4489-4551-a4ed-edea6456a739";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F2C0-F5B7";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
