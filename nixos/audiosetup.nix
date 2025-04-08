{ config, lib, pkgs, ... }:

  users.users.tommi.extraGroups = [ "jackaudio" ];

}
