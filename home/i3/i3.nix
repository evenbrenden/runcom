{ pkgs, ... }:

{
  home.packages = with pkgs; [
    autorandr
    brightnessctl
    flameshot
    (import ./i3quo.nix { inherit pkgs; })
    playerctl
    sakura
    (import ./toggle_keyboard_layout.nix { inherit pkgs; })
    (import ./toggle_wifi.nix { inherit pkgs; })
    xrandr-invert-colors
  ];
  xdg.configFile = {
    "i3/config".source = ./config;
    "i3status/config".source = ./statusconfig;
  };
}
