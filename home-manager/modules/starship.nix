{ lib, ... }:

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
{ programs.starship = {
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
} 

