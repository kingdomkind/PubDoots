{ ... }:
{
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
    ];
  };
}
