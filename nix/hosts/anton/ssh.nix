# nix/hosts/anton/ssh.nix
{...} : {
#  services.openssh = {
#    enable = true;
#    openFirewall = false;
#    settings = {
#      # Auth
#      PasswordAuthentication = true; # just for now
#      PubkeyAuthentication = true;
#      PermitRootLogin = "no";
#      
#      # Security
#      X11Forwarding = false;
#      AllowTcpForwarding = "no";
#      PermitTunnel = "no";
#      AllowAgentForwarding = false;
#      
#      # Rate limiting (простая защита от брутфорса)
#      MaxAuthTries = 3;
#      LoginGraceTime = 30;
#
#      # Только нужные пользователи (опционально, но надёжно)
#      AllowUsers = [ "admin" ];
#    };
#  };
}
