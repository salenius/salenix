{
  description = "Tommin yleiskäyttöinen NixOS konfiguraatio";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    musnix.url = "github:musnix/musnix";
  };

  outputs = { self, nixpkgs, musnix }:
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
            musnix.nixosModules.musnix
           ./configuration.nix
         ];
        };

      };
    };
}
