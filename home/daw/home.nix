{ config, pkgs, ... }:

{
  imports = [
    ../common-home.nix
  ];

  nixpkgs.overlays = [
    (import ../../overlays/reaper.nix)
  ];

  home.packages = with pkgs;
    let
      fluidsynth-220 = pkgs.fluidsynth.overrideAttrs (_: rec {

        name = "fluidsynth-${version}";
        version = "2.2.0";

        src = pkgs.fetchFromGitHub {
          owner = "FluidSynth";
          repo = "fluidsynth";
          rev = "v${version}";
          sha256 = "1769aqkw2hv9yfazyd8pmbfhyjk8k8bgdr63fz5w8zgr4n38cgqm";
        };
      });
    in [

    # Plugins
    (carla.override { fluidsynth = fluidsynth-220; })
    (pkgs.callPackage (import ../../pkgs/fluida) { fluidsynth = fluidsynth-220; })
    sfizz

    # Programs
    polyphone
    reaper
    (renoise.override {
        releasePath = builtins.fetchTarball {
          url = "file://${builtins.toString ./.}/rns_324_linux_x86_64.tar.gz";
          sha256 = "0jwk9z62kk5dk95cbqasjrbag0qwvl2lix5k0pd98dmx05lxvbi5";
        };
      }
    )
  ];

  # Terrible workaround until I can figure out how to make the desktop item
  # supplied with the Renoise tarball to work when installed via the package
  xdg.dataFile."applications/renoise.desktop".source = ./renoise.desktop;

  # Terrible workaround until I can figure out how to make the desktop item
  # supplied with the Reaper tarball to work when installed via the package
  xdg.dataFile."applications/cockos-reaper.desktop".source = ./cockos-reaper.desktop;
}
