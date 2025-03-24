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
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;

  # ========================== Fix for Grub not detecting Arch Linux ==========================
  # boot.loader.grub.useOSProber = true;
  boot.loader.grub.extraEntries = ''
menuentry "Arch Linux" --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-cfbd4a9d-5fb7-44b9-9176-b4e4050cc7de' {
	set gfxpayload=keep
	insmod gzio
	insmod part_gpt
	insmod fat
	search --no-floppy --fs-uuid --set=root 18BC-49D5
	echo	'Loading Linux linux ...'
	linux	/vmlinuz-linux root=UUID=cfbd4a9d-5fb7-44b9-9176-b4e4050cc7de rw  loglevel=3 quiet
	echo	'Loading initial ramdisk ...'
	initrd	/intel-ucode.img /initramfs-linux.img
}
### END /etc/grub.d/43_linux_proxy ###

### BEGIN /etc/grub.d/44_os-prober ###
menuentry 'Windows Boot Manager (on /dev/nvme0n1p1)' --class windows --class os $menuentry_id_option 'osprober-efi-908A-8084' {
	insmod part_gpt
	insmod fat
	search --no-floppy --fs-uuid --set=root 908A-8084
	chainloader /efi/Microsoft/Boot/bootmgfw.efi
}
### END /etc/grub.d/44_os-prober ###

### BEGIN /etc/grub.d/45_linux_proxy ###
submenu "Advanced options for Arch Linux"{
menuentry "Arch Linux, with Linux linux" --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-advanced-cfbd4a9d-5fb7-44b9-9176-b4e4050cc7de' {
		set gfxpayload=keep
		insmod gzio
		insmod part_gpt
		insmod fat
		search --no-floppy --fs-uuid --set=root 18BC-49D5
		echo	'Loading Linux linux ...'
		linux	/vmlinuz-linux root=UUID=cfbd4a9d-5fb7-44b9-9176-b4e4050cc7de rw  loglevel=3 quiet
		echo	'Loading initial ramdisk ...'
		initrd	/intel-ucode.img /initramfs-linux.img
}
menuentry "Arch Linux, with Linux linux (fallback initramfs)" --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-fallback-cfbd4a9d-5fb7-44b9-9176-b4e4050cc7de' {
		set gfxpayload=keep
		insmod gzio
		insmod part_gpt
		insmod fat
		search --no-floppy --fs-uuid --set=root 18BC-49D5
		echo	'Loading Linux linux ...'
		linux	/vmlinuz-linux root=UUID=cfbd4a9d-5fb7-44b9-9176-b4e4050cc7de rw  loglevel=3 quiet
		echo	'Loading initial ramdisk ...'
		initrd	/intel-ucode.img /initramfs-linux-fallback.img
}
}
  '';
  # ========================== Fix for Grub not detecting Arch Linux ==========================

  networking.hostName = "Lappy"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Dhaka";

  # fcitx5 for OpenBangla Keyboard
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-openbangla-keyboard
    ];
  };

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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.smanahian = {
    isNormalUser = true;
    description = "S M A Nahian";
    extraGroups = [ "networkmanager" "wheel" ];
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
    git
    google-chrome
    neofetch
    sl
    telegram-desktop
    tmux
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vscode
    wget
  ];

  # Some fonts are needed for OpenBangla Keyboard
  fonts.packages = with pkgs; [
    noto-fonts
    # noto-fonts-cjk
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    # (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  fonts.enableDefaultPackages = false;

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
  system.stateVersion = "24.11"; # Did you read the comment?

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];
  
  # Enable hyprland
  programs.hyprland = {
    enable = true;
  };

  # For BigSaltyFishes End-4 Dotfiles===============
  services.udisks2.enable = true;
  # ================================================

}
