# /nix/modules/common/default.nix
{ config, lib, pkgs, username, ... } : {

	# Don't change
  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

	imports = [
		./boot.nix
		./disks.nix
		./network.nix
		./services.nix
		./user.nix
	];

	# paltform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

	services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;  # 🔥 КРИТИЧНО!
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      SATA_LINKPWR_ON_BAT = "min_power";
      PCIE_ASPM_ON_BAT = "powersupersave";
      WIFI_PWR_ON_BAT = "on";
    };
  };

  services.power-profiles-daemon.enable = false;
}
