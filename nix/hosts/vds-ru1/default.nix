{ lib, lexalib, ...} : {
	imports = [
		./hardware-configuration.nix
	];

	boot.loader.grub = {
		enable = true;
		device = "/dev/sda";
		efiSupport = false;
	};

	documentation.nixos.enable = false;
  documentation.man.enable = false;

	nix = {
	  settings.auto-optimise-store = true;
		optimise.automatic = true;
		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 7d";
		};
	};

	boot.kernelParams = [ "net.ifnames=0" "biosdevname=0" ];
	networking.networkmanager.enable = lib.mkForce false;
	networking.useDHCP = false;
  networking.interfaces.eth0 = {
    ipv4.addresses = [ { address = "188.68.220.25"; prefixLength = 24; } ];
  };

  networking.defaultGateway = "188.68.220.1";
  networking.nameservers = [ "188.93.16.19" "188.93.17.19" ];
}

