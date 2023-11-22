{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./common/cpu/intel
    ./common/gpu/nvidia/prime.nix
    ./common/pc/laptop
    ./common/pc/laptop/ssd
    # ./common/pc/laptop/hdd
  ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.supportedFilesystems = [ "ntfs" ];

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

  hardware = {
    nvidia = {
      modesetting.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault true;

      /* prime = {
              intelBusId = "PCI:0:2:0"; Why i dont find it ?!?!?
              nvidiaBusId = "PCI:1:0:0";
            };
      */
    };
  };

  services.thermald.enable = lib.mkDefault true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/98eb6bb8-275a-4154-8501-e04275111e7b";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/5ADA-BD09";
      fsType = "vfat";
    };
    "/storage" = {
      device = "/dev/disk/by-uuid/91c2c6df-952d-4ab7-a50f-2ac2eefd7f09";

      fsType = "ext4";
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/27a1055f-80c4-45a1-a724-d4e3eb2946f1"; }];

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
  environment.systemPackages = with pkgs; [ plasma-browser-integration ];
}
