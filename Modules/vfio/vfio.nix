{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;

  services.spice-vdagentd.enable = true;

  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "kvmfr"
    ];

    kernelParams = [
      "amd_iommu=on"
      "vfio-pci.ids=10de:13c0,10de:0fbb"
      "pcie_acs_override=downstream,multifunction"
      "kvmfr.static_size_mb=64"
    ];
  };

  services.udev.packages = lib.singleton (
    pkgs.writeTextFile {
      name = "kvmfr";
      text = ''
        SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/70-kvmfr.rules";
    }
  );

  # TESTING
  services.udev.extraRules = ''
    KERNEL=="event*", SUBSYSTEM=="input", GROUP="kvm", MODE="0660", TAG+="uaccess"
  '';

  virtualisation.libvirtd.qemu = {
    verbatimConfig = ''
      namespaces = []
      cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
        "/dev/kvmfr0",

        "/dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd",
        "/dev/input/by-id/usb-CX_2.4G_Wireless_Receiver-if01-event-mouse"
      ]
    '';
  };

  users.users = {
    pika = {
      # replace with your username
      extraGroups = [ "kvm" "libvirtd" ];
    };
  };

  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];
}
