# /nix/hosts/anton/default.nix
{ lexalib, ... } : {

	imports = [
		./hardware-configuration.nix
    ./disks.nix
		./pkgs.nix
		./services.nix
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

  # nvidia & CUDA
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = false;
  };
  
  # sops-nix
#  sops = {
#    defaultSopsFile = ./secrets/secrets.yaml;
#    age.keyFile = "/etc/sops/age/keys.txt";
#    secrets = {
#      "wg-private" = {
#        mode = "0400";
#        owner = "root";
#        group = "root";
#      };
#    };
#  };
}

