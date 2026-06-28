# /nix/modules/common/services.nix

{ pkgs, config, ... } : {
	
#  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

	# upower
	services.upower.enable = true;
	services.udev.enable = true;

	# docker
	virtualisation.docker.enable = true;
#	virtualisation.docker.storageDriver = "btrfs";
#	virtualisation.docker.daemon.settings = {
#  	registry-mirrors = [
#    	"https://mirror.gcr.io"  # Официальное зеркало от Google [[57]]
#  	]; 
#	};
}
