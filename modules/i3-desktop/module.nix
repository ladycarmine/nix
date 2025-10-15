{ config, pkgs, lib, inputs, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        i3status
      ];
    };
  };
  services.displayManager.defaultSession = "none+i3";
  programs.i3lock.enable = true;

  home-manager.users.carmine = {
    home.file.".config/i3/config".source = ./config/i3;
    home.stateVersion = "25.05";
  };


}