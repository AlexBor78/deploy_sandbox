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
		deploy-rs ={
			url = "github:serokell/deploy-rs";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

  outputs = { self, nixpkgs, sops-nix, lexalib, deploy-rs, ... }: 
  let
		username = "admin"; # todo: remove username
		system = "x86_64-linux";
    dotsroot = toString self;
		lib = nixpkgs.lib;
		pkgs = import nixpkgs { inherit system; };
    deployPkgs = import nixpkgs { # nixpkgs with deploy-rs overlay but force the nixpkgs package
			inherit system;
      overlays = [
        deploy-rs.overlays.default
        (self: super: { deploy-rs = { inherit (pkgs) deploy-rs; lib = super.deploy-rs.lib; }; })
      ];
    };

		mkSystem = hostname: nixpkgs.lib.nixosSystem {
			inherit system;
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
		mkNode = hostname: {
			hostname = lexalib.infra.${hostname}.ip;
			sshUser = "deploy";
			profiles.system = {
				sudo = "sudo -u";
				user = "root";
				path = deploy-rs.lib.${system}.activate.nixos (mkSystem "${hostname}");
				sshOpts = [ "-i" "/home/alex/.ssh/deploy-${hostname}" "-o" "IdentitiesOnly=yes" ];
				magicRollback = false;
			};
		};

		hosts = [
			"anton"
			"maria"
			"vds-ru1"
		];
		perHost = lib.genAttrs hosts (name: {
			system = mkSystem name;
			node = mkNode name;
		});

  in {
		nixosConfigurations = lib.mapAttrs (_: h: h.system) perHost;
		deploy.nodes        = lib.mapAttrs (_: h: h.node)  perHost;
		#checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
		checks.x86_64-linux = deploy-rs.lib.x86_64-linux.deployChecks self.deploy;
  };
}
