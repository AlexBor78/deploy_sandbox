{ hostname, ... } : {
	
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # mirrors
  nix.settings = {
    # Отключаем скачивание мусорного registry (убирает половину таймаутов)
    flake-registry = ""; 
    
    # Добавляем зеркала (Yandex и другие)
    substituters = [
      "https://mirror.yandex.ru/nixos"
      "https://cache.nixos.org"
    ];
  };
}
