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


  # sops-nix
#  sops = {
#    defaultSopsFile = ./secrets/secrets.yaml;
#    age.keyFile = "/etc/sops/age/keys.txt";
#    secrets = {
#      "wg-private" = {
#        mode = "0400";
#        owner = "root";
#        group = "root";
#      };
#    };
#  };
}

