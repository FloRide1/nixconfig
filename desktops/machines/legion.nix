{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Setup keyfile
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-a3c3f68a-9906-443d-93eb-38952151008e".device =
    "/dev/disk/by-uuid/a3c3f68a-9906-443d-93eb-38952151008e";
  boot.initrd.luks.devices."luks-16d3a52c-1210-4ebb-a4fb-165d66fd00c7".device =
    "/dev/disk/by-uuid/16d3a52c-1210-4ebb-a4fb-165d66fd00c7";
  boot.initrd.luks.devices."luks-16d3a52c-1210-4ebb-a4fb-165d66fd00c7".keyFile =
    "/crypto_keyfile.bin";

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

      #timeout = 0;
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
        useOSProber = true;
      };
      #systemd-boot.configurationLimit = 5;
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
      device = "/dev/disk/by-uuid/bfb74672-e281-4e1d-b53c-2c86d19511ea";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/6A68-E407";
      fsType = "vfat";
    };

    "/storage" = {
      device = "/dev/disk/by-uuid/9C882C65882C405E";
      fsType = "ntfs";
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/23a97d93-88eb-4b3c-9986-7d4ee0a204d9"; }];

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
  environment.systemPackages = with pkgs; [ plasma-browser-integration ];
}
