{
  description = "Personal development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix.url = "github:nix-community/fenix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      fenix,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        fenix = import (fetchTarball "https://github.com/nix-community/fenix/archive/main.tar.gz") { };

        # Common dependencies for all Rust projects
        commonDeps = with pkgs; [
          clang
          clang-tools
          pkg-config
          openssl
          lldb
          gnumake
          procps # provides pkill
        ];

        # GUI development dependencies
        guiDeps = with pkgs; [
          wayland
          wayland-scanner
          wayland-protocols
          libxkbcommon
          xorg.libX11
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXi
          xorg.libxcb
          xorg.xcbutilwm
          xorg.xcbutilimage
          xorg.xcbutilkeysyms
          xorg.xcbutilrenderutil
          vulkan-loader
          vulkan-tools
          vulkan-headers
          libGLU
          libGL
        ];

        # Audio dependencies
        audioDeps = with pkgs; [
          alsa-lib
          alsa-lib.dev
          alsa-tools
        ];

        # PKG_CONFIG_PATH for common libraries
        pkgConfigPaths = with pkgs; [
          "${alsa-lib.dev}/lib/pkgconfig"
          "${wayland.dev}/lib/pkgconfig"
          "${libxkbcommon.dev}/lib/pkgconfig"
          "${xorg.libX11.dev}/lib/pkgconfig"
          "${xorg.libxcb.dev}/lib/pkgconfig"
        ];

      in
      {
        devShells =
          let
            workDir = builtins.getEnv "PWD";
            rustToolchain = fenix.fromToolchainFile { dir = workDir; };
            rustStable = fenix.complete.withComponents [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
            ];
          in
          {
            # Rust development
            rust = pkgs.mkShell {
              buildInputs = commonDeps ++ [
                rustToolchain
              ];
              LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
              RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

              shellHook = ''
                echo "⚙ Rust Dev"
                echo "Rust: $(rustc --version)"
                echo "Cargo: $(cargo --version)"
              '';
            };

            # Rust game development (Bevy, etc.)
            rust-game = pkgs.mkShell {
              buildInputs = commonDeps ++ guiDeps ++ audioDeps ++ [ rustToolchain ];

              nativeBuildInputs = with pkgs; [
                pkg-config
              ];

              LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
              RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
              LD_LIBRARY_PATH = builtins.foldl' (a: b: "${a}:${b}/lib") "${pkgs.vulkan-loader}/lib" (
                guiDeps ++ audioDeps
              );
              PKG_CONFIG_PATH = "${builtins.concatStringsSep ":" pkgConfigPaths}";

              shellHook = ''
                echo "🎮 Rust Game Dev"
                echo "Rust: $(rustc --version)"
                echo "Cargo: $(cargo --version)"
              '';
            };

            # Zig development
            zig = pkgs.mkShell {
              buildInputs =
                commonDeps
                ++ guiDeps
                ++ audioDeps
                ++ (with pkgs; [
                  zig
                  zls
                  inotify-tools
                  entr
                ]);

              nativeBuildInputs = with pkgs; [
                pkg-config
              ];

              LD_LIBRARY_PATH = builtins.foldl' (a: b: "${a}:${b}/lib") "${pkgs.vulkan-loader}/lib" (
                guiDeps
                ++ audioDeps
                ++ [
                  pkgs.mesa
                  pkgs.libGL
                ]
              );
              PKG_CONFIG_PATH = "${builtins.concatStringsSep ":" pkgConfigPaths}";

              shellHook = ''
                echo "⚡ Zig Dev"
                echo "Zig: $(zig version)"
              '';
            };

            # Python development
            python = pkgs.mkShell {
              buildInputs =
                with pkgs;
                [
                  python3
                  python3Packages.pip
                  python3Packages.pytest
                  python3Packages.black
                  python3Packages.flake8
                  uv
                  rustStable
                ]
                ++ commonDeps;

              LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
              RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

              shellHook = ''
                echo "🐍 Python Dev Environment"
                echo "Python: $(python3 --version)"
                echo "Pip: $(pip3 --version)"
              '';
            };

          };

        # Legacy compatibility for nix-shell
        legacyPackages = {
          inherit (pkgs) mkShell;
        };
      }
    );
}
