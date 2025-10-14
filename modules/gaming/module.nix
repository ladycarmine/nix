{ config, pkgs, lib, inputs, ... }:

{
  programs.steam.enable = true;

  users.users.carmine = {
    packages = with pkgs; [
      prismlauncher
    ];
  };
}