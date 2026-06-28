# /nix/hosts/t480/default.nix

{ config, lib, pkgs, modulesPath, ...} : {
	imports = [
		./hardware-configuration.nix
    ./network.nix
    ./disks.nix
    ./ssh.nix
	];

  # docker dir
  systemd.tmpfiles.rules = [ "d /srv 0755 root root -" ];
}

