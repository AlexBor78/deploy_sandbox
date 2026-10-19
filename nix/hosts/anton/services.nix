# /nix/hosts/anton/services.nix
{ pkgs, ... } : {
  services.xserver.videoDrivers = [ "nvidia" ];
  # docker dir
  systemd.tmpfiles.rules = [ "d /srv 0755 root root -" ];
	virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_29;

	# network settings
	networking.networkmanager.unmanaged = [ "eno1" ];
	networking.vlans."eno1-2" = { id = 2; interface = "eno1"; };
  networking.interfaces."eno1-2".ipv4 = {
    addresses = [ { address = "10.20.0.2"; prefixLength = 24; } ];
    routes = [ { address = "0.0.0.0"; prefixLength = 0; via = "10.20.0.1"; } ];
  };
  # eno1 stays a member of VLAN 1 but gets NO IP — invisible to home LAN:
  networking.interfaces.eno1.useDHCP = false;
  networking.interfaces.eno1.ipv4.addresses = [ ];
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

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
