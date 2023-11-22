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

  # LATER
  # programs.gnupg.agent.enable = true;
  # programs.gnupg.agent.enableSSHSupport = true;

  programs.fish.enable = true;

  services = {
    xserver = {
      enable = true;
      exportConfiguration = true;

      layout = "gb";
      xkbVariant = "extd";

      libinput = {
        enable = true;
        touchpad.naturalScrolling = false;
      };

      displayManager = {
        defaultSession = "none+i3";
        lightdm.enable = true;
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };
  };
}
