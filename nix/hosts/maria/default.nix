# /nix/hosts/t480/default.nix

{ lexalib, ...} : {
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


  nix.settings.trusted-users = [ "root" "admin" ];
  users.users.admin.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVmKG0A3mAahs3zXBW7BSt9Beb8yf6AAyeYvhNod8+L admin@lexa-projects.ru"
		lexalib.ssh_keys.public.anton
  ];

  # docker dir
  systemd.tmpfiles.rules = [ "d /srv 0755 root root -" ];
}

