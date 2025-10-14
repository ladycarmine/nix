{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix 
  ];

  # Misc
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Bootloader
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    useOSProber = true;
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };
  boot.initrd.services.lvm.enable = true;

  # Settings
  networking.hostName = "bootstrap";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  services.openssh.enable = true;
  users.users.root.hashedPassword = "";

  # Packages
  environment.systemPackages = with pkgs; [
    git
    vim
    nano
  ];

  system.stateVersion = "25.05";
}