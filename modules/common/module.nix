{ config, pkgs, lib, inputs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  time.timeZone = "America/New_York";
  nixpkgs.config.allowUnfree = true;

  # Bootloader (GRUB)
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

  # NetworkManager
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  # CUPS Printing (w/ IPP)
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  # Audio (via Pipewire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Main User
  users.users.carmine = {
    isNormalUser = true;
    description = "Carmine";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      fastfetch
      nano
      neovim
      zsh
    ];
  };

  home-manager.users.carmine = {
    home.file."config/test".source = ./config/test;
    home.stateVersion = "25.05";
  };

  # Environment Packages
  environment.systemPackages = with pkgs; [
    curl
    git
    nano
    wget
  ];

  system.stateVersion = "25.05";
}