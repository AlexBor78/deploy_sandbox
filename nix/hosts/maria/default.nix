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

  # docker dir
  systemd.tmpfiles.rules = [ "d /srv 0755 root root -" ];
}

