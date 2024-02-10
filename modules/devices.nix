{ pkgs, ... }:

{
  # amd stuff
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

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
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # network detection stuff
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # printer setup
  services.printing = {
    enable = true;
    drivers = [
      pkgs.epson-escpr
    ];
  };
  hardware.printers = {
    ensurePrinters = [
      {
	name = "EPSON_ET_2810_Series";
	location = "Home";
	deviceUri = "lpd://192.168.178.57:515/PASSTHRU";
	model = "epson-inkjet-printer-escpr/Epson-ET-2810_Series-epson-escpr-en.ppd";
	ppdOptions = {
	  PageSize = "A4";
	};
      }
    ];
    ensureDefaultPrinter = "EPSON_ET_2810_Series";
  };

  # scanner setup
  hardware.sane.enable = true;
}
