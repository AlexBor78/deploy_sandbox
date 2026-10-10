# /nix/hosts/t480/default.nix

{ config, lib, pkgs, username, ...} : {
	imports = [
		./hardware-configuration.nix
#    ./network.nix
#    ./disks.nix
#    ./ssh.nix
	];

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

  # docker dir
  systemd.tmpfiles.rules = [ "d /srv 0755 root root -" ];
	#virtualisation.docker.enable = true;

	# using my key
  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVmKG0A3mAahs3zXBW7BSt9Beb8yf6AAyeYvhNod8+L admin@lexa-projects.ru"
  ];

}

