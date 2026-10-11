# /nix/hosts/t480/default.nix

{ config, lib, pkgs, username, ...} : {
	imports = [
		./hardware-configuration.nix
#    ./network.nix
#    ./disks.nix
#    ./ssh.nix
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


  # docker dir
  systemd.tmpfiles.rules = [ "d /srv 0755 root root -" ];
	#virtualisation.docker.enable = true;

	# using my key
  users.users.admin.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVmKG0A3mAahs3zXBW7BSt9Beb8yf6AAyeYvhNod8+L admin@lexa-projects.ru"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8JTAx0ILgIYmj7Vql75ocUjLnircF4H+aTso5kSwrD alex laptop -> vds-ru1"
  ];

}

