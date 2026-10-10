# /flake.nix
{
  description = "deploy dotfiles";
    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    };
  
  outputs = { self, nixpkgs, ... }: 
  let
    username = "admin";
    dotsroot = toString self;
		mkSystem = hostname: nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { 
				inherit self hostname username dotsroot;
			};
			modules = [
				{ nixpkgs.config.allowUnfree = true; }
				./nix/hosts/${hostname}
				./nix/modules/common
			];
		};

  in {
    nixosConfigurations.anton = mkSystem "anton";
    nixosConfigurations.maria = mkSystem "maria";
    nixosConfigurations.vds-ru1 = mkSystem "vds-ru1";
  };
}
