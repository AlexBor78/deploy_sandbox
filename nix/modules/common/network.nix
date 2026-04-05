{ hostname, ... } : {
	
  networking.hostName = hostname; # Define your hostname.
  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
	networking.networkmanager.dns = "none";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

	# vpn for server
#	networking.wireguard.enable = true;
#  networking.wireguard.interfaces.wg0 = {
#    ips = [ "10.0.0.3/24" ];
#    privateKeyFile = "/var/lib/wireguard/privatekey";
#    
#    peers = [
#      {
#        publicKey = "wJ0ynClXDC8OVsGpy/cgCpMmJAH8QDHrUK0PNoMJSn0=";
#        endpoint = "188.68.223.213:51820";
#        
#        allowedIPs = [ "10.0.0.0/24" ];
#        persistentKeepalive = 25;
#      }
#    ];
#  };
#  

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
