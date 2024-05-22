{ config, pkgs, inputs, ... }:

{
  dconf.settings = {
  "org/virt-manager/virt-manager/connections" = {
    autoconnect = ["qemu:///system"];
    uris = ["qemu:///system"];
  };
};

  home.username = "mo";
  home.homeDirectory = "/home/mo";

  home.file.".config/nvim" = {
    source = ./dotfiles/mo-vim/.config/nvim;
    recursive = true;
  };
  home.file.".tmux.conf".source = ./dotfiles/tmux/.tmux.conf;
  home.file."bin" = {
    source = ./dotfiles/scripts/bin;
    recursive = true;
    executable = true;
  };
  # home.file.".config/leftwm/config.ron".source = ./dotfiles/leftwm/.config/leftwm/config.ron;

  home.file.".config/waybar" = {
    source = ./dotfiles/waybar;
    recursive = true;
  };
  home.file.".config/sxhkd/sxhkdrc".source = ./dotfiles/sxhkdrc/.config/sxhkd/sxhkdrc;
  #
  # home.file.".config/dunst" = {
  #   source = ./dotfiles/dunst/.config/dunst;
  #   recursive = true;
  # };

  # home.file.".config/rofi" = {
  #   source = ./dotfiles/rofi;
  #   recursive = true;
  # };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  #xresources.properties = {
  #  "Xcursor.size" = 16;
  #  "Xft.dpi" = 172;
  #};

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch
    #nnn # terminal file manager

    ## archives
    #zip
    #xz
    #unzip
    #p7zip

    ## utils
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq

    ## networking tools
    #mtr # A network diagnostic tool
    #iperf3
    dnsutils  # `dig` + `nslookup`
    #ldns # replacement of `dig`, it provide the command `drill`
    #aria2 # A lightweight multi-protocol & multi-source command-line download utility
    #socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    #ipcalc  # it is a calculator for the IPv4/v6 addresses

    ## misc
    #cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    starship
    fzf
    bat
    eza
    #git-delta
    lazygit
    fd
    ripgrep
    zoxide
    fnm
    go
    rustup
    unzip

    #neovim setup
    nerdfonts
    neovim
    nodejs
    python3
    python311Packages.pynvim
    python311Packages.pip
    gnumake
    #luarocks
    #composer
    #php


    tmux

    keybase
    kbfs
    keybase-gui
    dunst
    libnotify

    ## nix related
    ##
    ## it provides the command `nom` works just like `nix`
    ## with more details log output
    nix-output-monitor

    ## productivity
    #hugo # static site generator
    #glow # markdown previewer in terminal

    #btop  # replacement of htop/nmon
    #iotop # io monitoring
    #iftop # network monitoring

    ## system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    ## system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    gcc
    kitty
    waybar
    hyprpaper
    wofi
    sxhkd

    spotify

    podman
    podman-compose
    docker-compose
    dive
    distrobox
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Salomo";
    userEmail = "salomob@gmail.com";
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      scrolling.history = 50000;
      window.opacity = 0.9;
      env.TERM = "xterm-256color";
      font = {
        size = 14;
        draw_bold_text_with_bright_colors = true;
        family = "nerdfonts";
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
      colors = {
            # Default colors
    primary = {
      background = "0x1f1f28";
      foreground = "0xdcd7ba";
    };

    # Normal colors
    normal = {
      black = "0x090618";
      blue = "0x7e9cd8";
      cyan = "0x6a9589";
      green = "0x76946a";
      magenta = "0x957fb8";
      red = "0xc34043";
      white = "0xc8c093";
      yellow = "0xc0a36e";
    };

    # Bright colors
    bright = {
      black = "0x727169";
      blue = "0x7fb4ca";
      cyan = "0x7aa89f";
      green = "0x98bb6c";
      magenta = "0x938aa9";
      red = "0xe82424";
      white = "0xdcd7ba";
      yellow = "0xe6c384";
      };
    };
   };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    #shellAliases = {
    #  k = "kubectl";
    #  urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    #  urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    #};
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

#   wayland.windowManager.hyprland = {
# extraConfig = ''test'';
# settings = {
# general = {
# gaps_in = 0;
# gaps_out = 0;
# border_size = 20;
# };
# };
# };

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind =
      [
        "$mod, F, exec, firefox"
        "$mod, J, exec, alacritty"
        ", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
  };
  wayland.windowManager.hyprland.plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
  ];
}
