{ pkgs, lib, config, ... }:

{
  imports = [ ../desktop.nix ];

  boot = {
    initrd.availableKernelModules =
      [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = with config.boot.kernelPackages; [ ];

    supportedFilesystems = [ "ntfs" ];

    loader = {
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };

      timeout = 0;
      grub = {
        enable = true;
        device = "nodev";
        default = "saved";
        efiSupport = true;
        version = 2;
      };
      systemd-boot.configurationLimit = 5;
    };
  };

  networking = {
    hostName = "legion";

    useDHCP = false;
    interfaces.enp7s0.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/a6195274-7b9c-4209-ad81-b2fb6e84303d";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/9C02-28F3";
      fsType = "vfat";
    };

    "/storage" = {
      device = "/dev/disk/by-uuid/bd022d60-aa7c-44af-aaee-9257033dd681";
      fsType = "ext4";
    };
  };

  # Maybe remove it later :/
  swapDevices =
    [{ device = "/dev/disk/by-uuid/c52bafff-92c8-4024-bb3c-abc25438d5b9"; }];

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
  environment.systemPackages = with pkgs; [ plasma-browser-integration ];
}
