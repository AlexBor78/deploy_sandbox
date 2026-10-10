# /nix/modules/common/boot.nix
{ config, lib, pkgs, ...} : {
	
  boot.kernelParams = [
		# enable zswap (zram)
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=20"
    "zswap.zpool=z3fold" 
  ];
}
