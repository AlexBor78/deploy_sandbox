# /flake.nix
{
  description = "anton server config";
    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
      sops-nix.url = "github:Mic92/sops-nix";
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
        sops-nix.nixosModules.sops

      ];
    };
  };
}
