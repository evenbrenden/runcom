{ config, pkgs, ... }:

let
  dotnet = (with pkgs.dotnetCorePackages; combinePackages [ sdk_6_0 sdk_5_0 ]);
in {
  home.packages = [ dotnet ];
  programs.bash = let
    # Workaround for .NET Core SDK installed with Nix (https://wiki.archlinux.org/index.php/.NET_Core)
    dotnet_root = ''
      export DOTNET_ROOT=${dotnet}
    '';
    dotnet_tools = ''
      PATH=$PATH:${config.home.homeDirectory}/.dotnet/tools
    '';
  in {
    bashrcExtra = dotnet_root + dotnet_tools;
    profileExtra = dotnet_root + dotnet_tools;
  };
}
