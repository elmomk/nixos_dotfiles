# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.hosts = {
    "192.168.1.45" = ["traefik.local" "jelly.local" "ombi.local" "deluge.local" "sonarr.local" "radarr.local"];
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  #bluetooth
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings.General.Experimental = true;


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # i18n.defaultLocale = "zh_CN.UTF-8";

  fonts = {
    packages = with pkgs; [
      noto-fonts
      # noto-fonts-cjk-sans
      # noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      # sarasa-gothic  #更纱黑体
      source-code-pro
      hack-font
      jetbrains-mono
    ];

   # 简单配置一下 fontconfig 字体顺序，以免 fallback 到不想要的字体
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "Noto Sans Mono CJK SC"
          "Sarasa Mono SC"
          "DejaVu Sans Mono"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Source Han Sans SC"
          "DejaVu Sans"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Source Han Serif SC"
          "DejaVu Serif"
        ];
      };
    };
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-chinese-addons
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.displayManager.sddm.wayland.enable = true;
  # services.xserver.displayManager.sddm.theme = "where_is_my_sddm_theme";

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # services.xserver.windowManager.leftwm.enable = true;
  # services.xserver.displayManager = { defaultSession = "none+leftwm"; };
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mo = {
    isNormalUser = true;
    description = "mo";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

 fileSystems."/home/mo/data" = {
   device = "/dev/sda1";
   fsType = "ext4";
   options = [ # If you don't have this options attribute, it'll default to "defaults" 
     # boot options for fstab. Search up fstab mount options you can use
     "users" # Allows any user to mount and unmount
     "nofail" # Prevent system from failing if this drive doesn't mount
     
   ];
 };

  # virt-manager: libvirtd and qemu
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  
  #podman
    # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = false;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  virtualisation.docker.enable = true;
#   virtualisation.docker.rootless = {
#   enable = true;
#   setSocketVariable = true;
# };

  # Install firefox.
  programs.firefox.enable = true;
  programs.hyprland.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  neovim
  tmux
  git
  wget
  curl

  ];

  environment.variables.EDITOR = "nvim";

   services.kbfs = {
    enable = true;
    mountPoint = "%t/kbfs";
    extraFlags = [ "-label %u" ];
  };

  systemd.user.services = {
    keybase.serviceConfig.Slice = "keybase.slice";

    kbfs = {
      environment = { KEYBASE_RUN_MODE = "prod"; };
      serviceConfig.Slice = "keybase.slice";
    };

    keybase-gui = {
      description = "Keybase GUI";
      requires = [ "keybase.service" "kbfs.service" ];
      after    = [ "keybase.service" "kbfs.service" ];
      serviceConfig = {
        ExecStart  = "${pkgs.keybase-gui}/share/keybase/Keybase";
        PrivateTmp = true;
        Slice      = "keybase.slice";
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  networking.stevenblack = {
    enable = false;
    block = [ "fakenews" "gambling" "porn" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
