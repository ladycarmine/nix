{ config, pkgs, lib, inputs, ... }:

{
  users.users.carmine = {
    packages = with pkgs; [
      audacity
      easytag
      handbrake
      obs-studio
      vlc
    ];
  };
}