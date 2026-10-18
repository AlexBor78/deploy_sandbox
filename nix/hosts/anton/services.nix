# /nix/hosts/anton/services.nix
{ pkgs, ... } : {
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
