# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

## Tämän voi buildaa seuraavalla komennolla:
# sudo nixos-rebuild switch --impure --flake ~/Projects/salenix/nixos/#tommiSetup


{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #(import "${home-manager}/nixos")
     <musnix>
    ];

  musnix.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";
 
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     keyMap = "fi";
     #useXkbConfig = true; # use xkb.options in tty.
   };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "fi";
    xkbVariant = "winkeys,";
  };
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;


  # Binäärivälimuisti Haskell.nixiä varten, jotta
  # vältytään liian monelta GHC:n kopiolta


  # Home manager
  #home-manager.users.tommi = { pkgs, ... }: {
  #  home.packages = [ pkgs.atool pkgs.httpie ];
  #  programs.bash.enable = true;
  #
  #  # The state version is required and should stay at the version you
  #  # originally installed.
  #  home.stateVersion = "24.11";
  # };

  
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #hardware.pulseaudio.enable = true;
  # OR
   services.pipewire = {
     enable = true;
     pulse.enable = true;
   };

  #services.jack = {
  #	   jackd.enable = true;
  #	   # support ALSA only programs via ALSA JACK PCM plugin
  #	   alsa.enable = false;
  #	   # support ALSA only programs via loopback device (supports programs like Steam)
  #	   loopback = {
  #	     enable = true;
  #	     # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
  #	     #dmixConfig = ''
  #	     #  period_size 2048
  #	     #'';
  #	   };
  #	  };

  # # rtkit is optional but recommended
  #security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true; # if not already enabled
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #  # If you want to use JACK applications, uncomment this
  #  #jack.enable = true;
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.tommi = {
     isNormalUser = true;
     extraGroups = [ 
	"wheel" 
	"audio" 
	#"jackaudio"  # Enable ‘sudo’ for the user.
	];
     packages = with pkgs; [
       tree
       librewolf
       fzf
       zoxide
       eza
     ];
   };

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     git
     wget
     curl
     home-manager
     vlc
     #emacs
     alsa-utils

     starship # Tekee command promptista nukean nakoisen
     nerdfonts # Starshipin prompteista upean nakoisia

     ffmpeg-full

     # Omat skriptit globaaliin käyttöön
     (writeShellScriptBin "mp4-to-gif" ''
     ffmpeg -i $1 "$\{1%.mp4\}.gif" 
     '')
     
     (writeShellScriptBin "videon-pituus" ''
     ffprobe -i $1 -show_entries format=duration -v quiet -of csv="p=0"
     '')

     # Salenix-configuraation buildien wrapper/alias käytännössä
     # laita argumentiksi switch yleisessä tapauksessa. Tämä on tehty
     # koska zsh ei tykkää #-merkistä, minkä vuoksi laitettu lainausmerkkeihin
     # ja käytetään HOME-ympäristömuuttujaa apuna
     (writeShellScriptBin "salenix-rebuild" ''
     nixos-rebuild $1 --flake "$HOME/Projects/salenix/nixos#tommiSetup" --impure
     '')
  ];

  environment.shells = with pkgs; [

     zsh

  ];

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

