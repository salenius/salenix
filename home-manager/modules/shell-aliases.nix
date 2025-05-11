{
  "ls"  = "eza --color=always --group-directories-first --icons";
  "ll"  = "eza -la --icons --octal-permissions --group-directories-first";
  "l"   = "eza -bGF --header --git --color=always --group-directories-first --icons";
  "llm" = "eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons"; 
  "la"  = "eza --long --all --group --group-directories-first";
  "lx"  = "eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons";

  "sl" = "eza --color=always --group-directories-first --icons";
  "hms" = "home-manager switch";
  "cat" = "bat";
  "e" = "devour emacs";
  "conf" = "devour emacs ~/Projects/salenix/nixos/configuration.nix";
  "skriptit" = "devour emacs ~/Projects/salenix/nixos/skriptit.nix";
  "home" = "devour emacs ~/Projects/salenix/home-manager/home.nix";
  "hm" = "home";
  "dwm" = "devour emacs ~/Projects/dwm/config.def.h";
  "clipboard" = "xclip -selection clipboard"; # Tällä saadaan kopioitua leikepöydälle
  "clip" = "clipboard";
  "aliases" = "e ~/Projects/salenix/home-manager/modules/shell-aliases.nix";
  "rangr" = "devour rangr";
}


