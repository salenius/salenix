{
  description = "Tommin yleiskäyttöinen NixOS konfiguraatio";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
       inherit system;
       config = {
         allowUnfree = true;
       };     
    };
    in
    {

     nixosConfigurations = {
       tommiSetup = nixpkgs.lib.nixosSystem {
         specialArgs = { inherit system; };
         modules = [
           ./configuration.nix
         ];
        };

      };
    };
}
