# /nix/modules/common/user.nix
{ config, lib, pkgs, username, ... } : {

  # Define a user account.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.bash;
    packages = with pkgs; [
    # usless placeholders
    	powertop
    	dmidecode
    	p7zip
    ];
  };

#  hardware.cpu.x86.msr.settings.allow-writes = "on";

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [

    # basic utils
    wget curl 
    htop tree jq
    git vim tmux

    #infra stuff
    wireguard-tools # vpn
    sops age # secretes manager
    cryptsetup btrfs-progs # disks

    # deploy utils
    docker
  ];
}
