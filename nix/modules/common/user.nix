# /nix/modules/common/user.nix

{ config, lib, pkgs, username, zen-browser, ... } : {

	programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "render" ]; # Enable ‘sudo’ for the user.
  	shell = pkgs.zsh;
    packages = with pkgs; [
      tree lsd
    	fastfetch 
			starship
			clang
			powertop
			dmidecode
		  acpica-tools
		  msr-tools
		  uefitool
		  binwalk
		  p7zip
		  git
		  wget
		  curl
		  grub2
		  dosfstools
		  flashrom
			ntfs3g
			cmake
			doxygen
			docker


			rsync

			sing-box
			jq
			wireguard-tools
#			ghidra ida-free
    ];
  };

	hardware.cpu.x86.msr.settings.allow-writes = "on";

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    wget git curl htop btop hyprland kitty
    brightnessctl
		upower
		qemu
    libvirt
    bridge-utils
  ];
}
