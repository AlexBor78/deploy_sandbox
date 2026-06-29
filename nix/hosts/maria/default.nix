# /nix/hosts/t480/default.nix

{ config, lib, pkgs, username, ...} : {
	imports = [
		./hardware-configuration.nix
    ./network.nix
    ./disks.nix
    ./ssh.nix
	];

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVmKG0A3mAahs3zXBW7BSt9Beb8yf6AAyeYvhNod8+L admin@lexa-projects.ru"
  ];

  # docker dir
  systemd.tmpfiles.rules = [ "d /srv 0755 root root -" ];
}

