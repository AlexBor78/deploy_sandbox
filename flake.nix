# /flake.nix
{
  description = "anton server config";
    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    };
  
  outputs = { self, nixpkgs, sops-nix, ... }: 
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
    nixosConfigurations.tempate = nixpkgs.lib.nixosSystem {
			inherit system;
      specialArgs = { 
 	      inherit self username;
   			hostname = "tamplate";
      };
      modules = [
        ./nix/modules/common
      ];
    };
  };
}
