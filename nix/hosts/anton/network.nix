# nix/hosts/anton/network.nix
{...} : {

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
#
#  # firewall
#  networking.firewall = {
#    enable = true;
#    allowPing = true;
#    logReversePathDrops = true;
#    allowedTCPPorts = [ ];
#  
#    # zero trust model: port 22 only for 10.0.0.3 ip
#     extraCommands = ''
#       iptables -A nixos-fw -i wg0 -p tcp --dport 22 -s 10.0.0.3/32 -j ACCEPT
#     '';
#  };
}
