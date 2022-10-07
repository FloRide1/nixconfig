{ pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  programs.steam.enable = true;

  virtualisation.libvirtd.enable = true;

  services = {
    printing.enable = true;

    xserver = {
      enable = true;
      exportConfiguration = true;

      layout = "gb";
      xkbVariant = "extd";

      libinput = {
        enable = true;
        touchpad.naturalScrolling = false;
        # accelProfile = "flat";
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
