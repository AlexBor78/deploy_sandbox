# /nix/home/shell.nix

{ config, pkgs, lib, theme, hostname, dotsroot, ... } : {

	programs.lsd.enable = true;
	programs.bat = {
		enable = true;
		tokyonight.enable = true;
	};

	programs.btop.settings.color_theme = "tokyo-night";

	# kitty
	programs.kitty = {
	  enable = true;
	  extraConfig = builtins.readFile ( pkgs.fetchFromGitHub {
	      owner = "folke";
	      repo = "tokyonight.nvim";
	      rev = "main";
	      sha256 = "sha256-4zfkv3egdWJ/GCWUehV0MAIXxsrGT82Wd1Qqj1SCGOk=";
	    } + "/extras/kitty/tokyonight_night.conf"
	  );
	};

	# zsh - shell
	programs.zsh = {
		enable = true;
		enableCompletion = true;
 	  autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

		initContent = '' 
			if [ -z "$SSH_AUTH_SOCK" ]; then
			  eval "$(ssh-agent -s)"
			fi
			eval "$(starship init zsh)"
			fastfetch
		'';

		oh-my-zsh = {
			enable = true;
			theme = "";
			plugins = [
				"git"
#				"zsh-autosuggestions"
#				"zsh-syntax-highlighting"
			];
		};

		shellAliases = {
			ls = lib.mkForce "lsd";
			cat = "bat";
			rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#${hostname}";

		};
	};

	# starship - prompt
	programs.starship = {
		enable = true;
		settings = {
			format = "$username@$hostname $directory $git_branch $battery\n$character";
			add_newline = false;

		  username = {
				show_always = true;
				format = "[$user]($style)";
				style_user = "purple";
			};

		  hostname = {
				disabled = false;
				ssh_only = false;
				format = "[$hostname]($style)";
				style = "dimmed purple";
			};

		  directory = {
				disabled = false;
				format = "[$path]($style)";
				style = "bold blue";
				truncation_length = 0;
				truncate_to_repo = false;
			};

			git_branch = {
				symbol = "";
				format = "[\\($branch\\)]($style)";
				style = "bold purple";
			};
			time.disabled = true;

		  battery = {
				disabled = false;
				display = [ 
					{
						threshold = 5;
						style = "bold red";
					}
					{
						threshold = 30;
						style = "bold yellow";
					}
					{
						threshold = 100;
						style = "bold green";
					}
				];
				format = "[$percentage]($style)";
				full_symbol = "";
				charging_symbol = "";
				discharging_symbol = "";
			};
			character = {
				success_symbol = "[>\\$](bold purple)";
		    error_symbol = "[>\\$](bold red)";
			};
		};
	};

	# fastfetch 
	programs.fastfetch = {
		enable = true;
		settings = {
			logo = {
				type = "kitty";
				source = "${dotsroot}/assets/nixos-logo.png";
				width = 40;
				height = 20;
				padding = {
					top = 0;
					right = 0;
					left = 2;
				};
			};

			modules = [
				"title"
				"separator"
				{
					type = "host";
					key = "host";
					keyColor = "blue";
				}
				{
					type = "cpu";
					key = "cpu";
					format = "{name} ({cores-physical}/{cores-logical}) @ {freq-max}";
				}
				{
					type = "gpu";
					key = "gpu";
				}
				{
					type = "memory";
					key = "memory";
				}
				{
					type = "swap";
					key = "swap";
				}
				{
					type = "disk";
					key = "disk";
				}
				{
					type = "battery";
					key = "battery";
				}
				{
					type = "uptime";
					key = "uptime";
				}

				"separator"
				{
					type = "Kernel";
					key = "kernel";

				}
				{
					type = "os";
					key = "os";
				}
				{
					type = "wm";
					key = "wm";
				}
				{
					type = "terminal";
					key = "terminal";
				}
				{
					type = "shell";
					key = "shell";
				}
				{
					type = "packages";
					key = "packages";
				}

				"separator"
				{
					type = "colors";
				}
			];
		};
	};
}
