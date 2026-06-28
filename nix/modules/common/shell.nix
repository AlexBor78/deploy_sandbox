# /nix/modules/common/shell.nix

{ config, pkgs, lib, theme, hostname, dotsroot, ... } : {

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

  # terminal settings
  environment.sessionVariables = {
    TERM = "xterm-256color";
  };
}

