{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_scsi" "sd_mod" ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/cloudimg-rootfs";
    fsType = "ext4";
  };

  # real swap — 473MB RAM is even tighter than expected
  swapDevices = [ { device = "/swapfile"; size = 2048; } ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    efiSupport = false;
  };
}
