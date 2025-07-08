{
  config,
  lib,
  pkgs,
  ...
}:

{

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [
          "MiSans"
          "CaskaydiaMonoNerdFont"
        ];
        serif = [
          "CaskaydiaMonoNerdFont"
          "MiSans"
        ];
        monospace = [
          "CaskaydiaMonoNerdFont"
        ];
      };
    };
  };

  home.packages = with pkgs; [
    (stdenv.mkDerivation {
      pname = "symbols-nerd-font";
      version = "2.2.0";
      src = fetchFromGitHub {
        owner = "ryanoasis";
        repo = "nerd-fonts";
        rev = "v2.2.0";
        sha256 = "sha256-wCQSV3mVNwsA2TlrGgl0A8Pb42SI9CsVCYpVyRzF8Fg=";
        sparseCheckout = [
          "10-nerd-font-symbols.conf"
          "patched-fonts/NerdFontsSymbolsOnly"
        ];
      };
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        runHook preInstall

        fontconfigdir="$out/etc/fonts/conf.d"
        install -d "$fontconfigdir"
        install 10-nerd-font-symbols.conf "$fontconfigdir"

        fontdir="$out/share/fonts/truetype"
        install -d "$fontdir"
        install "patched-fonts/NerdFontsSymbolsOnly/complete/Symbols-2048-em Nerd Font Complete.ttf" "$fontdir"

        runHook postInstall
      '';
      enableParallelBuilding = true;
    })

    (stdenv.mkDerivation {
      pname = "CaskaydiaMono-nerd-font";
      version = "3.4.0";
      src = fetchzip {
        url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaMono.zip";
        sha256 = "sha256-ci1C2b4WDSnHEG2Cw6YPDWk5swD0bTcNV/cgSUriSfA=";
        stripRoot = false;
      };
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        runHook preInstall

        fontdir="$out/share/fonts/truetype"
        install -d "$fontdir"
        install "$src/CaskaydiaMonoNerdFont-Regular.ttf" "$fontdir"
        install "$src/CaskaydiaMonoNerdFont-Bold.ttf" "$fontdir"
        install "$src/CaskaydiaMonoNerdFont-Italic.ttf" "$fontdir"
        install "$src/CaskaydiaMonoNerdFont-BoldItalic.ttf" "$fontdir"

        runHook postInstall
      '';
      enableParallelBuilding = true;
    })

    (stdenv.mkDerivation {
      pname = "mi-sans-font";
      version = "1.0.0";
      src = fetchzip {
        url = "https://hyperos.mi.com/font-download/MiSans.zip";
        sha256 = "sha256-497H20SYzzUFaUHkqUkYlROLrqXRBLkBkylsRqZ6KfM=";
        stripRoot = false;
      };
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        runHook preInstall

        fontdir="$out/share/fonts/truetype"
        install -d "$fontdir"
        install "$src/MiSans/ttf/MiSans-Regular.ttf" "$fontdir"
        install "$src/MiSans/ttf/MiSans-Bold.ttf" "$fontdir"
        install "$src/MiSans/ttf/MiSans-Normal.ttf" "$fontdir"
        install "$src/MiSans/ttf/MiSans-Medium.ttf" "$fontdir"
        install "$src/MiSans/ttf/MiSans-Thin.ttf" "$fontdir"
        install "$src/MiSans/ttf/MiSans-Light.ttf" "$fontdir"
        install "$src/MiSans/ttf/MiSans-Heavy.ttf" "$fontdir"

        runHook postInstall
      '';
      enableParallelBuilding = true;
    })
  ];
}
