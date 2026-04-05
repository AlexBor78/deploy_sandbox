# /nix/hosts/t480/default.nix

{ config, lib, pkgs, modulesPath, ...} : {
	imports = [
		./hardware-configuration.nix
	];
}
