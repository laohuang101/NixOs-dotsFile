# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  # This tells NixOS to use Niri as the default desktop session
  services.displayManager.defaultSession = "niri";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.niri.enable = true;
  programs.fish.enable = true;
  
  # This will auto install iflow cli
  programs.fish.shellAliases = {
    iflow = "npx iflow-cli";
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.refind.enable = true;
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [ "nvidia.NVreg_EnableBacklightHandler=0" "acpi_backlight=video" ];

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


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ms_MY.UTF-8";
    LC_IDENTIFICATION = "ms_MY.UTF-8";
    LC_MEASUREMENT = "ms_MY.UTF-8";
    LC_MONETARY = "ms_MY.UTF-8";
    LC_NAME = "ms_MY.UTF-8";
    LC_NUMERIC = "ms_MY.UTF-8";
    LC_PAPER = "ms_MY.UTF-8";
    LC_TELEPHONE = "ms_MY.UTF-8";
    LC_TIME = "ms_MY.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true; # Critical for Niri/Wayland
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk            # Support for GTK apps
      fcitx5-rime           # Optional: If you prefer the Rime engine
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    vscode
    wget
    git
    curl
    
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

    #CTF
    burpsuite
    #More but lz to install now just testing with BP for the Java Based App openning issue

    #Ai - for iflow
    nodejs
    nodePackages.npm

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
