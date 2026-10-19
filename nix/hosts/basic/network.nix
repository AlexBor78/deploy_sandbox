{ hostname, ... } : {
	
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # mirrors
  nix.settings = {
    flake-registry = ""; 
    substituters = [
      #"https://mirror.yandex.ru/nixos" # dead now
			"https://mirrors.tuna.tsinghua.edu.cn/nix-store"
      "https://cache.nixos.org"
    ];
  };
}
