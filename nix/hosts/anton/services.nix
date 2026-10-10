# /nix/hosts/anton/services.nix
{ pkgs, ... } : {
	# Builder (for vds)
  nix.settings.trusted-users = [ "root" "builder" ];
	users.users.builder = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGCRr8fr5siteRrwnRfMiXJP1M7kR8jDXXXMYdkmenzK vds-ru1-root"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVmKG0A3mAahs3zXBW7BSt9Beb8yf6AAyeYvhNod8+L admin@lexa-projects.ru"
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  # docker dir
  systemd.tmpfiles.rules = [ "d /srv 0755 root root -" ];
	virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_29;

	# vpn for server
	networking.wireguard.enable = true;
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.0.0.2/24" ];
    privateKeyFile = "/var/lib/wireguard/privatekey";
    
    peers = [
      {
        publicKey = "wJ0ynClXDC8OVsGpy/cgCpMmJAH8QDHrUK0PNoMJSn0=";
        endpoint = "188.68.223.213:51820";
        
        allowedIPs = [ "10.0.0.0/24" ];
        persistentKeepalive = 25;
      }
    ];
  };
}
