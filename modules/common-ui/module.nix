{ config, pkgs, lib, inputs, ... }:

{

  hardware.graphics.enable = true;

  users.users.carmine = {
    packages = with pkgs; [
      alacritty
    ];
  };
}