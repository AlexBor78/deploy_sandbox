# /flake.nix
{
  description = "anton server config";
    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  
  outputs = { self, nixpkgs, home-manager, nixvim, ... }: 
  let
    username = "admin";
    dotsroot = toString self;
    system = "x86_64-linux";
  in {
    nixosConfigurations.anton = nixpkgs.lib.nixosSystem {
			inherit system;
      specialArgs = { 
 	      inherit self username nixvim;
   			hostname = "anton";
      };
      modules = [
				./nix/hosts/anton
				./nix/modules/common

#        home-manager.nixosModules.home-manager {
#          home-manager.useGlobalPkgs = true;
#          home-manager.useUserPackages = true;
#          home-manager.users.${username} = import ./nix/home;
#          home-manager.extraSpecialArgs = { 
#            inherit self username dotsroot nixvim tokyonight rofi-theme;
#						hostname = "x13";
#          };
#        }
      ];
    };
  };
}
