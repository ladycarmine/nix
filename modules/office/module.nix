{ config, pkgs, lib, inputs, ... }:

{
  users.users.carmine = {
    packages = with pkgs; [
      libreoffice-qt6-fresh
    ];
  };
}