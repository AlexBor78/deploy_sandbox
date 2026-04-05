{ config, lib, pkgs, username, zen-browser, ... }: {
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;




  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
