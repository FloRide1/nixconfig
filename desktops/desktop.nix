{ pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  sound.enable = true;

  networking.networkmanager.enable = true;
  virtualisation.libvirtd.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.pulseaudio.enable = true;

  programs.steam.enable = true;

  services.openssh.enable = true;
  services.blueman.enable = true;
  services.printing.enable = true;
  services.tailscale.enable = true;

  # Syncthing ports
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  virtualisation.docker.enable = true;

  security.polkit.enable = true;

  programs.fish.enable = true;
  programs.hyprland.enable = true;

  services.xserver = {
    layout = "gb";
    xkbVariant = "extd";
    enable = true;
  };

  security.pam.services.swaylock = { };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "floride";
      };

    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';

}
