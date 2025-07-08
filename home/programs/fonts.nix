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
          "CaskaydiaMonoNerdFont"
          "Noto Sans CJK SC"
          "Noto Sans CJK TC"
          "Noto Sans CJK JP"
          "Noto Sans CJK KR"
        ];
        serif = [
          "CaskaydiaMonoNerdFont"
          "Noto Serif CJK SC"
          "Noto Serif CJK TC"
          "Noto Serif CJK JP"
          "Noto Serif CJK KR"
        ];
        monospace = [
          "CaskaydiaMonoNerdFont"
        ];
      };
    };
  };

  home.packages = with pkgs; [
    # Noto fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji

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
  ];
}
