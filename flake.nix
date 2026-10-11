# /flake.nix
{
  description = "deploy dotfiles";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
		desktop_dotfiles.url = "github:AlexBor78/dotfiles";
	};

  outputs = { self, nixpkgs, sops-nix, desktop_dotfiles, ... }: 
  let
		# todo: remove username
    username = "admin";
    dotsroot = toString self;
		lexalib = desktop_dotfiles.lexalib;
		mkSystem = hostname: nixpkgs.lib.nixosSystem {
			# todo: make system as optional arg, and by default x86_64
			system = "x86_64-linux";
			specialArgs = { 
				inherit self lexalib hostname username dotsroot sops-nix;
			};
			modules = [
				{ nixpkgs.config.allowUnfree = true; }
				sops-nix.nixosModules.sops
				./nix/hosts/basic
				./nix/hosts/${hostname}
			];
		};
  in {
    nixosConfigurations.anton = mkSystem "anton";
    nixosConfigurations.maria = mkSystem "maria";
    nixosConfigurations.vds-ru1 = mkSystem "vds-ru1";
  };
}
