{ config, lib, pkgs, modulesPath, ... }:

let cfg = config.hardware.framework.amd-7040;
in {
  imports = [ ./framework/13-inch/7040-amd/default.nix ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];

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
}
