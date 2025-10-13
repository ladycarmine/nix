# NOTE: This is a bootstrap NixOS configuration and isn't meant
# for daily use. Please replace with a more appropriate configuration.
{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader (GRUB)
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    useOSProber = true;

    # Edit this line to reflect the appropriate drive to install GRUB to
    device = "/dev/disk/by-id/<YOUR DISK ID>";
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  boot.initrd = {
    luks.devices = {

      # Edit this block to reflect the UUID of the root partition
      luks_root = {
        device = "/dev/disk/by-uuid/<ROOT PARTITION UUID>";
      };
      
      # Uncomment/edit this block to reflect the UUID of the home partition (when applicable)
      # luks_home = {
      #   device = "/dev/disk/by-uuid/<HOME PARTITION UUID>";
      # };

    };
    services.lvm.enable = true;
  };

  # Basic Settings
  boot.kernelPackages = pkgs.linuxPackages_latest;
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
    wget
  ];

  system.stateVersion = "25.05";
}