{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_scsi" "sd_mod" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/PASTE-UUID-HERE";
    fsType = "ext4";
  };

  swapDevices = [ ];

  boot.loader.grub.device = "/dev/vda";   # or /dev/sda — see below
}
