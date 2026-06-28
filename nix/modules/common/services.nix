# /nix/modules/common/services.nix

{ pkgs, config, ... } : {
	
#  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

	# upower
	services.upower.enable = true;
	services.udev.enable = true;
}
