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
    system = "x86_64-linux";
  in {
    nixosConfigurations.anton = nixpkgs.lib.nixosSystem {
			inherit system;
      specialArgs = { 
 	      inherit self username;
   			hostname = "anton";
      };
      modules = [
        ./nix/modules/common
				./nix/hosts/anton
      ];
    };
    nixosConfigurations.maria = nixpkgs.lib.nixosSystem {
			inherit system;
      specialArgs = { 
 	      inherit self username;
   			hostname = "maria";
      };
      modules = [
        ./nix/modules/common
				./nix/hosts/maria
      ];
    };
  };
}
