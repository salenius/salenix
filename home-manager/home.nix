{ config, pkgs, lib, ... }@input:

let
  # --- Yhteiset komentojen aliakset shelleille
  shell-alias-set = import ./modules/shell-aliases.nix;
  # --- Yhteiset rc-tiedostojen komennot (.bashrc, .zshrc jne)
  shell-init-rc-common = ''
       eval "$(zoxide init bash)"
   '';
  tmux-enabled = true;
in

{

  imports = [
     ./modules/starship.nix
     ./modules/editor/emacs.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tommi";
  home.homeDirectory = "/home/tommi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.eza
    pkgs.tmux
    pkgs.bat
  ] ++ (if tmux-enabled then [
   pkgs.zsh-prezto # Automaattinen tmux-launch 
  ] else []);
    

  programs = {

    bash = {
      enable = true;
      bashrcExtra = shell-init-rc-common;
      shellAliases = shell-alias-set;
      
    };

    zsh = {
      enable = true;
      initExtra = shell-init-rc-common;
      shellAliases = shell-alias-set;
      autosuggestion = {
         enable = true;
       };
      prezto = {
        enable = true;
        tmux.autoStartLocal = if tmux-enabled then true else null;
      };
    };

    tmux = {
      enable = tmux-enabled;
      mouse = true;
      extraConfig = ''
      set -g visual-bell off
     '';
      
    };

    # Alacritty asetukset kopioitu Eric Murphy (Youtubettaja) esimerkistä
    alacritty = {
      enable = true;
      settings = {
         window = {
           padding = { x = 5; y = 5; };
           class = {
             instance = "Alacritty";
             general = "Alacritty";
           };
           opacity = 0.75; # 0-1 välillä
         };
         scrolling = {
           history = 10000;
           multiplier = 3; # Kuinka monta riviä yksi skrollaus etenee
         };
      };
    };


    #emacs.enable = true;
    #emacs.extraPackages = epkgs: with epkgs; [
    #  evil
    #  dracula-theme
    #  haskell-mode
    #];
    emacs.package = pkgs.emacs-gtk;

    git = {
      enable = true;
      userName = "salenius";
      userEmail = "tommisalenius@gmail.com";
      aliases = {
        s = "status";
      };
    };

  };
     
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tommi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    # NOTE: Ei riitä tekemään Alacrittystä oletusterminaalia, piti säätää manuaalisesti vielä koneella
    TERMINAL = "alacritty"; 
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
