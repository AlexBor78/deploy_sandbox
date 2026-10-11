# /flake.nix
{
  description = "deploy dotfiles";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
		lexalib.url = "github:AlexBor78/nix-lexalib";
		sops-nix = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

  outputs = { self, nixpkgs, sops-nix, lexalib, ... }: 
  let
		# todo: remove username
    username = "admin";
    dotsroot = toString self;
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
    nixosConfigurations = {
    	anton = mkSystem "anton";
    	maria = mkSystem "maria";
    	vds-ru1 = mkSystem "vds-ru1";
		};
  };
}
