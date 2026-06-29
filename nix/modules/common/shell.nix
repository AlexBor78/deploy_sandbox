# /nix/modules/common/shell.nix

{ config, pkgs, lib, theme, hostname, dotsroot, username, ... } : {
  # terminal settings
  environment.sessionVariables = {
    TERM = "xterm-256color";
    EDITOR = "vim";
  };

  programs.ssh = {
  startAgent = true;
  
  # Глобальный конфиг для всех SSH подключений
  extraConfig = ''
      AddKeysToAgent yes
      IdentityFile ~/.ssh/github_key
    '';
  };

  programs.bash = {
    enableCompletion = true;
    interactiveShellInit = ''
      alias ll='ls -l'
      alias lla='ls -la'
      alias rebuild='sudo nixos-rebuild switch --flake /home/${username}/deploy_sandbox#${hostname}'
    '';
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # vim config
  environment.etc."vimrc".text = ''
    syntax on
    filetype plugin indent on
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
    set expandtab
    set number
    set relativenumber
  '';

  # for vim config
  environment.variables.VIMINIT = "source /etc/vimrc";
}

