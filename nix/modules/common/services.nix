# /nix/modules/common/services.nix

{ pkgs, config, ... } : {
	
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
	services.udev.enable = true;
}
