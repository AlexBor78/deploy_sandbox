# /nix/hosts/anton/default.nix
{ lexalib, ... } : {

	imports = [
		./hardware-configuration.nix
    ./disks.nix
		./pkgs.nix
		./services.nix
	];
  
	# ssh key
  nix.settings.trusted-users = [ "root" "admin" ];
  users.users.admin.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVmKG0A3mAahs3zXBW7BSt9Beb8yf6AAyeYvhNod8+L admin@lexa-projects.ru"
		lexalib.infra.alex-laptop.public-ssh-keys.to-anton
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

