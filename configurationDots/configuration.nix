# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  # Set default terminal to kitty
  environment.variables = {
    TERMINAL = "kitty";
  };

  boot.kernelModules = [ "ashmem_linux" "binder_linux" ];

  
  # Ensure you have Docker enabled
  virtualisation.docker.enable = true;

  # This tells NixOS to use Niri as the default desktop session
  services.displayManager.defaultSession = "niri";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.niri.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      zoxide init fish | source
      function adroid
        sudo docker run -itd --rm --memory-swappiness=0 --privileged -v ~/data:/data -p 5555:5555 redroid/redroid:11.0.0-latest
        echo "Waiting for Android to boot..."
        sleep 5
        adb connect localhost:5555
        scrcpy -s localhost:5555 --no-audio
      end
    '';
  };
  programs.nix-ld.enable = true;  


  # Enable hardware graphics and the NVIDIA VAAPI translator
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  # Ensure the proprietary NVIDIA driver is actually loaded
  services.xserver.videoDrivers = [ "nvidia" ];

  # Force Wayland apps (like wl-screenrec) to use the translator
  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  environment.sessionVariables = {
    # Force Chromium and Electron apps to bypass XWayland
    NIXOS_OZONE_WL = "1";
  };
  
  hardware.nvidia = {
    # This is required for Wayland compositors like Niri to work at all
    modesetting.enable = true;

    # THE FIX: Explicitly declare the open-source driver state
    # Change this to false ONLY if you have a GTX 10-series or older!
    open = true; 


    prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # We need to find your exact Bus IDs for these two lines!
    intelBusId = "PCI:0:2:0"; 
    nvidiaBusId = "PCI:1:0:0";
  };
  };


  # This will auto install iflow cli
  programs.fish.shellAliases = {
    iflow = "npx -y @iflow-ai/iflow-cli";
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
    
  # Setup rEFIne automatically
  boot.loader.refind = {
    enable = true;
    # This 'extraConfig' is appended to the bottom of the generated refind.conf
    extraConfig = ''
      resolution max

      # 1. Load the theme
      include /EFI/themes/RONBM/theme.conf

      # 2. Hide the generic auto-detected Linux icons
      scan_all_linux_kernels false
      # This forces rEFInd to use the manual entries or better-detected ones
      scanfor manual,external

      # 3. UI Tweaks (Optional)
      timeout 5
      selection_big   icons/selection_big.png
      selection_small icons/selection_small.png

      # 4. Load Windows
      dont_scan_dirs EFI/Microsoft,EFI/Boot
      dont_scan_files bootmgfw.efi
      menuentry "Windows 11" {
        icon /EFI/themes/RONBM/icons/os_win.png
        volume addb950f-a503-4ccf-b410-c07b0ed38122
        loader \EFI\Microsoft\Boot\bootmgfw.efi
      }

    '';
  };

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [ "nvidia.NVreg_EnableBacklightHandler=0" "acpi_backlight=video" "binder.devices=binder,hwbinder,vndbinder" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";

  services.illum.enable = true;


  # For at
  services.atd.enable = true;

  # Select internationalisation properties.
 # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {  
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
    ];
  };

  environment.variables = {
    GTK_IM_MODULE = pkgs.lib.mkForce null;
    QT_IM_MODULE = pkgs.lib.mkForce null;
    XMODIFIERS = pkgs.lib.mkForce "@im=ibus"; # Keep this one ONLY for old XWayland apps
  };


  # Enable standard web fonts and emojis
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans      # For Chinese/Japanese/Korean characters
    noto-fonts-color-emoji         # Emojis!
    liberation_ttf           # Free replacements for Arial, Times New Roman, etc.
    corefonts                # Standard Microsoft fonts
  ];
  


  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.loke = {
    isNormalUser = true;
    description = "loke";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "video" "input" "docker" "render" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };


  # Install firefox.
  programs.firefox.enable = false;

  # Install Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };


  programs.gamemode.enable = true;


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # For slow bongo
    evtest
    cava    

    #Editor --nano is being installed by default
    vim
    vscode
    jetbrains.idea
    pkgs.zed-editor

    pkgs.jdk25
    python3

    wget
    git
    curl

    #Chat
    vesktop
    telegram-desktop

    #Notes
    obsidian
    
    #Performance Monitor? Nah just leh your terminal looks better
    fastfetch
    btop

    #Browser
    chromium

    #Terminal rice
    kitty
    fish
    eza #Need to set fish alias to trigger the icon when ls already did in Arch config lz move now
    bat
    zoxide #For path tp can use z to tp or zi to search

    #Package Manager
    rofi #Using configuration from adi1090x ( https://github.com/adi1090x/rofi )
     
    #WM
    niri

    #Brightness
    brightnessctl

    # This pulls the 'default' package from the noctalia-qs input
    inputs.noctalia-qs.packages.${pkgs.system}.default
    inputs.noctalia.packages.${pkgs.system}.default
    libpulseaudio
    waybar
    fuzzel

    #fix Java based app cant open issue
    xwayland
    xwayland-satellite

    # CTF

    # Web
    burpsuite
    nmap # netowrk mapping
    ffuf # find network hidden directory
    sqlmap # sql injection

    # Forensic
    steghide
    binwalk
    exiftool
    wireshark

    # Reverse
    ghidra
    python3Packages.pwntools    

    # Crypto
    hashcat
    john    

    
    
    #!!More but lz to install now just testing with BP for the Java Based App openning issue
    
    #Wordlist    
    (wordlists.override { 
      lists = [ 
        seclists 
        rockyou 
      ]; 
    })


    # Ai - for iflow
    nodejs
    nodePackages.npm
    # Ai - claude
    # inputs.claude-code.packages.${pkgs.system}.default


    #Music
    musikcube

    #File Manager + other dependancy
    yazi
    ffmpegthumbnailer
    jq
    poppler
    fd
    ripgrep
    fzf
    
    # Screen Recorder
    wf-recorder
    obs-studio

    # Notif
    libnotify

    # zip & unzip
    zip
    unzip

    # storage usage
    ncdu   

    # Anime
    ani-cli     

    # Game
    #  heroic-bin
    scrcpy
    android-tools

    # YouTube audio download
    yt-dlp    

    # video compress
    pkgs.handbrake
  ];

  # Enable XDG portals for screen sharing/compatibility
  xdg.portal = {
    enable = true;
    wlr.enable = true; 
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
