# /nix/home/hyprland.nix

{ config, pkgs, dotsroot, rofi-theme, ... } : {
	
  # hypr
  home.file.".config/hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotsroot}/hypr"; 
    recursive = true;
    force = true;
  };

   home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  # cursor
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # rofi
	home.file.".config/rofi" = {
	  source = "${rofi-theme}";
	  recursive = true;
	  force = true;
	};
	# wallpaper
	home.file.".config/wallpaper.png".source = "${dotsroot}/assets/wallpaper.png";
#	home.file.".config/hypr/hyprpaper.conf".text = ''
#		wallpaper {
#    	monitor = eDP-1
#    	path = ~/.config/wallpaper.png
#			fit_mode = cover
#		}
#
#  '';

}
