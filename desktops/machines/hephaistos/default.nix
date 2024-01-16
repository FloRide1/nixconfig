{ config, lib, pkgs, modulesPath, ... }:

let cfg = config.hardware.framework.amd-7040;
in {
  imports = [ ./framework/13-inch/7040-amd/default.nix ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];

  services.fwupd.enable = true;

  boot = {
    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };

      #systemd-boot.enable = true;
      #systemd-boot.configurationLimit = 5;
      grub.enable = true;
      grub.efiSupport = true;
      grub.device = "nodev";
      grub.useOSProber = true;
    };
  };

  networking.hostName = "hephaistos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable PCSCD for smart card
  services.pcscd.enable = true;

  # Digital
  services.fprintd.enable = true;

  # Disable Power Button
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  services.xserver.videoDrivers = [ "amdgpu" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/02c3b24f-0535-4d24-b1c4-7b497243605c";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/1181-321F";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/52fb8889-7e1b-403e-8543-c8b168f0bdab"; }];

  networking.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
