{ pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  sound.enable = true;

  networking.networkmanager.enable = true;
  virtualisation.libvirtd.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.pulseaudio.enable = false;

  programs.steam.enable = true;

  services.openssh.enable = true;
  services.blueman.enable = true;
  services.printing.enable = true;
  services.tailscale.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.utsushi ];
  services.udev.packages = [ pkgs.utsushi ];

  # Syncthing ports
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  virtualisation.docker.enable = true;

  security.polkit.enable = true;

  programs.fish.enable = true;
  programs.hyprland.enable = true;

  services.xserver = {
    xkb.layout = "gb";
    xkb.variant = "extd";
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
