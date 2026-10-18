{ pkgs, lexalib, ...} : {
	imports = [
		./hardware-configuration.nix
    ./network.nix
    ./disks.nix
    ./ssh.nix
	];

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

  nix.settings.trusted-users = [ "builder" ];
	users.groups.builder = {};
  users.users.builder = {
		isSystemUser = true;
		hashedPassword = "*";

		home = "/var/lib/builder";
		createHome = true;

		group = "builder";
		extraGroups = [ "nix" ];

		shell = pkgs.bash;
		openssh.authorizedKeys.keys = [
			lexalib.infra.alex-laptop.public-ssh-keys."to-builder"
			lexalib.infra.vds-ru1.public-ssh-keys."to-builder"
		];
	};

  # docker dir
  systemd.tmpfiles.rules = [ "d /srv 0755 root root -" ];
}

