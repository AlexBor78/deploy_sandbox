# /nix/modules/common/boot.nix
{ config, lib, pkgs, ...} : {
	
  # Bootloader (grub)
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      useOSProber = false;
    };
  };

  boot.kernelParams = [
		# enable zswap (zram)
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=20"
    "zswap.zpool=z3fold" 
  ];
}
