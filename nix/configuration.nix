{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
         ({pkgs,...}: {
      environment.defaultPackages = [ ( import (pkgs.fetchFromGitHub {
        owner = "bolives-hax";
        repo = "nixpkgs";
        rev = "c927a5be2b178e2bd584d55784fab05358e90c40";
        sha256 = "sha256-r/YBcN+0raNd/AcGIx++M+5hNtn10pNcY3bVacumX28=";
      }) { system="x86_64-linux";} ).fumosay ];
    })
    ];
  nix.settings.experimental-features = [ "nix-command flakes" ];	

  ### Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kok_pech";
  ### Network
  networking.networkmanager.enable = true;

  ### time zone
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

 
  ### Users
  users.users.coal = {
    isNormalUser = true;
    description = "coal";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  ### Packages
  nixpkgs = {
  	config = {
	allowUnfree = true;
	packageOverrides = pkgs: {
		unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz"){  config = { allowUnfree = true; }; }; 
		};
	};
  };


  environment.systemPackages = with pkgs; [
    # wine
     wineWowPackages.waylandFull
    # dekstop
     alacritty
     vulkan-tools
	 ranger
     wl-clipboard
     nftables
     unstable.legcord
     mc
     egl-wayland
     firefox
     swayfx
     waybar
     slurp
     grim
     unstable.wlroots_0_18
     fuzzel
     unstable.nushell
    # c things
     gcc14
     clang
     cmake
     bear
     glibc
     libclang
     clang-tools
     llvmPackages_latest.lldb
     llvmPackages_latest.libllvm
     llvmPackages_latest.libcxx
     llvmPackages_latest.clang
     libunistring
     icu.dev
     cargo
    #  
     openssl
     qbittorrent
     neovim
     unstable.osu-lazer-bin
    # python things
     kotatogram-desktop
     unstable.python312
	 yt-dlp
	 ytmdl
	 spotdl
     unstable.python312Packages.i3ipc
	 unstable.python312Packages.numpy
     unstable.i3ipc-glib
    # 
     git
     jdk
	 gtk3
     # sound
     pipewire
     pavucontrol
     #
     btop
     xdg-utils
     nodejs_23
     fastfetch
	 microfetch
     mesa
     rar
     ffmpeg
     mpv
	# music
	 ncmpcpp
	 cli-visualizer
     mpd
	 mpc
	#
     wf-recorder
     unzip
     libz
     dbus
     curl
  ];


  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
  ];

environment.extraOutputsToInstall = [ "dev" ];
environment.variables.PATH = "${pkgs.clang-tools}/bin:$PATH";
environment.variables.C_INCLUDE_PATH = "${pkgs.expat.dev}/include";

### Font
fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = ["Gohu"];})
    gohufont
	noto-fonts-emoji
	ipafont
    kochi-substitute
];

### Drivers
services.xserver.videoDrivers = ["nvidia"];


hardware = {
    graphics = {
        enable = true;
	enable32Bit = true;
	extraPackages = with pkgs; [
	vulkan-validation-layers
	];
    };    
    nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.latest;
	modesetting.enable = true;
	powerManagement.enable = false;
	powerManagement.finegrained = false;
	nvidiaSettings = true;
	open = false;
    };
};

### Pipewire
security.rtkit.enable = true;
services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	jack.enable = true;
};

### Mpd
services.mpd = {
	enable = true;
	network.listenAddress = "127.0.0.1";
	musicDirectory = "/music";
	playlistDirectory = "/music/playlists";
	extraConfig = ''
		audio_output {
			type "httpd"
			name "coke music"
			format "48000:16:1"
			always_on "yes"
			tags "yes"
			}
		audio_output {
			type "fifo"
			name "coke visualizer"
			format "48000:16:2"
			path "/tmp/mpd.fifo"
			}
		
		'';
};

  system.stateVersion = "24.11";  

}
