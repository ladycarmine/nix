{ config, pkgs, lib, inputs, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        picom
        polybar
        rofi
      ];
    };
  };
  services.displayManager.defaultSession = "none+i3";
  programs.i3lock.enable = true;

  home-manager.users.carmine = {
    home.file.".config/i3/config".source = ../../dotfiles/.config/i3/config;
    home.stateVersion = "25.05";
  };


}