{ pkgs, ... }:

let
  setg = opt: val: "set -g @${opt} '${val}'";
  setg-1 = opt: val: "set -g @${opt} ${val}";
  catppuccin = which: "catppuccin_" + which;
  concatStrings = pkgs.lib.concatStringsSep "\n";
  in

{
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = concatStrings [
          (setg (catppuccin "flavour") "frappe")
          (setg-1 (catppuccin "window_tabs_enabled") "on")
          (setg-1 (catppuccin "date_time") ''"%H:%M"'')
        ];
      }
    ];

    extraConfig = concatStrings [
   
    # Cycle quickly through windows, shift + Alt + n => seuraava
    # shift + Alt + p => edellinen
    ''
    bind -n M-H previous-window
    bind -n M-L next-window
    ''];
  };

}
