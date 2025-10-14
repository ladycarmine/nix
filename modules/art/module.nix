{ config, pkgs, lib, inputs, ... }:

{
  users.users.carmine = {
    packages = with pkgs; [
      blender
      blockbench
      gimp
      krita
      inkscape
    ];
  };
}