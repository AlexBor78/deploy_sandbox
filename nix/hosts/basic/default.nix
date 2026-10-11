# /nix/modules/common/default.nix
{ config, lib, pkgs, dotsroot, hostname, ... } : {

	# Don't change
  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# paltform
	# TODO: use var, no hardcoded shit
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # kernel version.
	# TODO: update
  boot.kernelPackages = pkgs.linuxPackages_6_6;

  # microcode updates
	# TODO: move to per-host
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;


	sops = {
		age.keyFile = "/var/lib/sops-nix/key.txt";
		age.generateKey = true;
		defaultSopsFile = "${dotsroot}/secrets/${hostname}/default.yaml";
		secrets = {
			default = {
				path = "/home/admin/.ssh/default";
				owner = "admin";
				mode = "0600";
			};
		};
	};

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Moscow";

	zramSwap.enable = true;
	imports = [
		./network.nix
		./pkgs.nix
		./shell.nix
	];

  boot.kernelParams = [
		# enable zswap (zram)
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=20"
    "zswap.zpool=z3fold" 
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
	services.udev.enable = true;
}
