# /nix/modules/common/default.nix
{ config, lib, pkgs, username, dotsroot, ... } : {

	# Don't change
  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

	imports = [
		./boot.nix
		./network.nix
		./services.nix
		./user.nix
		./shell.nix
	];

	# paltform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_6;

  # microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "Europe/Moscow";
}
