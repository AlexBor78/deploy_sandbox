# /nix/moduels/common/disks.nix

{ lib,  ... }: 
let    
  mkFat = device: {
    device = lib.mkForce device;
    fsType = "vfat";
    options = [ "defaults" "noatime" ];
  };
  
	mkBtrfs = {device, lvl}: {
    device = lib.mkForce device;
    fsType = "btrfs";
    options = [ "defaults" "noatime" "compress=zstd:${lvl}" ];
  };

  mkSwap = device: {
    device = lib.mkForce device;
    priority = -1;
  };

in {
  
  fileSystems = {
    "/" =    	mkBtrfs  "/dev/laptop/root";
    "/boot" = mkFat   "/dev/disk/by-label/boot";
  };

  swapDevices = [ (mkSwap "/dev/disk/by-label/swap") ] ;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = 100;
    memoryPercent = 50;
  };
}
