{ config, pkgs, lib, ... }:

let
  # --- Yhteiset komentojen aliakset shelleille
  shell-alias-set = {
        "ls" = "eza";
        "sl" = "eza";
        "hm" = "vim ~/Projects/salenix/home-manager/home.nix";
        "hms" = "home-manager switch";
      };

  # --- Yhteiset rc-tiedostojen komennot (.bashrc, .zshrc jne)
  shell-init-rc-common = ''
       eval "$(zoxide init bash)"
   '';
in

{
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
  ];

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
      
    };


    emacs = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "salenius";
      userEmail = "tommisalenius@gmail.com";
      aliases = {
        s = "status";
      };
    };

    starship =
     let
      programming-language-format = "[[ $symbol  ]]()";
      programming-symbol = smbol: {
          symbol = smbol;
          style = "bg:#212736";
          format = programming-language-format;
        };
      # ----- Kansiopolkujen värit -----
      iron-color = "#e3e5e5"; # Alkuperäinen polun väri, itselle liian tumma taustaan nähden
      white-color = "#fdfdfd";

     in
     {
      enable = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";
        add_newline = true;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
        format = lib.concatStrings [
        "[░▒▓](#a3aed2)"
        "[  ](bg:#a3aed2 fg:#090c0c)"
        "[](bg:#769ff0 fg:#a3aed2)"
        "$directory"
        "[](fg:#769ff0 bg:#394260)"
        "$git_branch"
        "$git_status"
        "[](fg:#394260 bg:#212736)"
        "$nodejs"
        "$rust"
        "$golang"
        "$php"
        "[](fg:#212736 bg:#1d2230)"
        "$time"
        "[ ](fg:#1d2230)"
        "$nix_shell"
        "\n$character"
        ];
        directory = {
          style = "fg:${white-color} bg:#769ff0";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = " ";
            "Pictures" = " ";
          };
        };
        git_branch = {
          symbol = "";
          style = "bg:#394260";
          format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
        };
        git_status = {
          style = "bg:#394260";
          format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
        };
        time = {
          disabled = false;
          time_format = "%R"; # Hour:Minute Format
          style = "bg:#1d2230";
          format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
        };
        nix_shell = {
          disabled = false;
          format = "[$symbol$state](bold blue) nix-shell";
        };

        rust = programming-symbol "";
        golang = programming-symbol "";
        php = programming-symbol "";
       

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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
