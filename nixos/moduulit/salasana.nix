{ pkgs, lib, config, ... }:

let
  # Muokkaa tätä jos haluat vaihtaa ohjelmaa, joka kysyy salasanan
  # kun käytät passmenua
  pinentry-program = pkgs.pinentry-gtk2;

in 
{
  environment.systemPackages = [
    pkgs.pass
    pkgs.gnupg # GPG-avaimien generointi
    pinentry-program
  ];

  programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pinentry-program;
      enableSSHSupport = true;
    };


}

