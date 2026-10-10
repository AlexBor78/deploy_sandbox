# /nix/hosts/anton/pkgs.nix
{ pkgs, ... }: {
	nixpkgs.config.allowUnfree = true;
	
  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
  ];
}
