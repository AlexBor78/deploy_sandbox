# /nix/modules/common/services.nix

{ pkgs, config, ... } : {
	
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

	# display manager
#  services.greetd = {
#    enable = true;
#    settings.default_session = {
#      command = "${pkgs.hyprland}/bin/start-hyprland";
#      user = "alex";
#    };
#  };

	# upower
	services.upower.enable = true;
	services.udev.enable = true;

#	# fix btop showing power
#  services.udev.extraRules = ''
#    SUBSYSTEM=="powercap", MODE="0444"
#  '';
#
#	# bios updates
#	services.fwupd.enable = true;


#	# fingerprint
#	services.fprintd.enable = true;
#	security.pam.services.sudo.fprintAuth = true;
#  security.pam.services.login.fprintAuth = true;
#	security.pam.services.sshd.fprintAuth = true;
#	programs.ssh.startAgent = true;

	# docker
#	virtualisation.docker.enable = true;
#	virtualisation.docker.storageDriver = "btrfs";
#	virtualisation.docker.daemon.settings = {
#  	registry-mirrors = [
#    	"https://mirror.gcr.io"  # Официальное зеркало от Google [[57]]
#  	]; 
#	};

	# qemu
#	virtualisation.libvirtd.enable = true;
#  virtualisation.libvirtd.qemu = true;

}
