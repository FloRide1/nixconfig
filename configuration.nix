{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in {
  imports = [
    ./desktops/desktop.nix
    ./desktops/machines/legion.nix
    (import "${home-manager}/nixos")
  ];

  # Default
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    useXkbConfig = true;
    font = "Lat2-Terminus16";
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.utf8";
    LC_IDENTIFICATION = "fr_FR.utf8";
    LC_MEASUREMENT = "fr_FR.utf8";
    LC_MONETARY = "fr_FR.utf8";
    LC_NAME = "fr_FR.utf8";
    LC_NUMERIC = "fr_FR.utf8";
    LC_PAPER = "fr_FR.utf8";
    LC_TELEPHONE = "fr_FR.utf8";
    LC_TIME = "fr_FR.utf8";
  };

  # Define a users
  users.users.floride = import ./users/floride.nix { inherit pkgs; };
  home-manager.users.floride = import ../nixhome/home.nix;

  networking.extraHosts = ''
    127.0.0.1 dps.epita.local
  '';

  environment.shells = with pkgs; [ fish ];
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    firefox
    alacritty
    fish
  ];

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 8d";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.hardwareClockInLocalTime = true;

  # Allow unfree package  
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
}
