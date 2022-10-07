{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in {
  imports = [ ./desktops/machines/legion.nix (import "${home-manager}/nixos") ];

  # Use NetworkManager
  networking.networkmanager.enable = true;

  # Syncthing ports
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  # Default
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";
  console.useXkbConfig = true;

  home-manager.users.floride = import ../nixhome/home.nix;

  # Define a users
  users.users.floride = import ./users/floride.nix { inherit pkgs; };
  environment.systemPackages = with pkgs; [ vim wget git firefox alacritty ];

  # LATER
  # programs.gnupg.agent.enable = true;
  # programs.gnupg.agent.enableSSHSupport = true;
  virtualisation.docker.enable = true;

  # Enable SSH
  services.openssh.enable = true;

  # Allow unfree package  
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "22.05";
}
