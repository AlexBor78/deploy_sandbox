# nix/hosts/anton/network.nix
{...} : {

	# maria is a NAT for infra
  # let infra hosts reach maria (ping/ssh) without firewall fuss
  networking.firewall.trustedInterfaces = [ "enp2s0-2" ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
	networking.vlans."enp2s0-2" = { id = 2; interface = "enp2s0"; };
  networking.interfaces."enp2s0-2".ipv4.addresses = [ { address = "10.20.0.1"; prefixLength = 24; } ];
  networking.nat = {
    enable = true;
    internalInterfaces = [ "enp2s0-2" ];
    externalInterface = "enp2s0";
  };

	# wg 
	networking.wireguard.enable = true;
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.0.0.7/24" ];
    privateKeyFile = "/var/lib/wireguard/privatekey";
    
    peers = [
      {
        # vds key
        publicKey = "wJ0ynClXDC8OVsGpy/cgCpMmJAH8QDHrUK0PNoMJSn0=";
        endpoint = "188.68.223.213:51820";
        
        allowedIPs = [ "10.0.0.0/24" "10.0.1.0/24" ];
        persistentKeepalive = 25;
      }
    ];
  };
}
