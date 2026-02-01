{ pkgs, ... }:
{
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
      # "nvidia"
      # "nvidia_modeset"
      # "nvidia_uvm"
      # "nvidia_drm"
    ];

    kernelParams = [
      "amd_iommu=on"
      "vfio-pci.ids=10de:13c0,10de:0fbb"
      "pcie_acs_override=downstream,multifunction"
    ];
  };
}
