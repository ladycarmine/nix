{ config, pkgs, lib, inputs, ... }:

{

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings.General.DisplayServer = "wayland";
  };

}