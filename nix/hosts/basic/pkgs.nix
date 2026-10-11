# /nix/modules/common/pkgs.nix
{ pkgs, ... } : {
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  environment.systemPackages = with pkgs; [
    # basic utils
    curl 
    btop htop fastfetch
		tree 
    git vim tmux
		zip unzip

    #infra stuff
    wireguard-tools
    #sops age # secretes manager
    #cryptsetup btrfs-progs # disks
  ];
}
