# /nix/modules/common/default.nix
{ config, lib, pkgs, ... } : {

	# Don't change
  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# paltform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # kernel version.
  boot.kernelPackages = pkgs.linuxPackages_6_6;

  # microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Moscow";

	zramSwap.enable = true;

	imports = [
		./boot.nix
		./network.nix
		./services.nix
		./user.nix
		./shell.nix
	];
}
