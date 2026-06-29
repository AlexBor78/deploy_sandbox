# /nix/hosts/t480/default.nix

{ config, lib, pkgs, username, ...} : {
	imports = [
		./hardware-configuration.nix
    ./network.nix
    ./disks.nix
    ./ssh.nix
	];

  # docker dir
  systemd.tmpfiles.rules = [ "d /srv 0755 root root -" ];

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVmKG0A3mAahs3zXBW7BSt9Beb8yf6AAyeYvhNod8+L admin@lexa-projects.ru"
  ];


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

