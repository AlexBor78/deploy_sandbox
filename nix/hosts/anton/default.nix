# /nix/hosts/t480/default.nix

{ config, lib, pkgs, username, ...} : {
	imports = [
		./hardware-configuration.nix
    ./network.nix
    ./disks.nix
    ./ssh.nix
    ./agent.nix
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


	# Builder (for vds)
  nix.settings.trusted-users = [ "root" "builder" ];
	users.users.builder = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAA... vds-ru1-root"   # from the VDS TODO
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVmKG0A3mAahs3zXBW7BSt9Beb8yf6AAyeYvhNod8+L admin@lexa-projects.ru"
    ];
  };




  # docker dir
  systemd.tmpfiles.rules = [ "d /srv 0755 root root -" ];
	virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_29;

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVmKG0A3mAahs3zXBW7BSt9Beb8yf6AAyeYvhNod8+L admin@lexa-projects.ru"
  ];
nixpkgs.config.allowUnfree = true;
  # nvidia & CUDA
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;  # для сервера
    open = false;  # проприетарный драйвер (лучше для headless)
    nvidiaSettings = false;  # не нужно без GUI
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # nvidia-smi и базовые утилиты
  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
  ];

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

