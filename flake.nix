{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {flakelight, ...}:
    flakelight ./. {
      package = {
        appimageTools,
        fetchurl,
        makeDesktopItem,
      }: let
        pname = "fluxer";
        version = "0.0.8";

        src = fetchurl {
          url = "https://api.fluxer.app/dl/desktop/stable/linux/x64/latest/appimage";
          sha256 = "sha256-GdoBK+Z/d2quEIY8INM4IQy5tzzIBBM+3CgJXQn0qAw=";
        };

        desktopItem = makeDesktopItem {
          name = pname;
          exec = pname;
          icon = pname;
          desktopName = "Fluxer";
          genericName = "Fluxer Desktop";
          categories = ["Utility"];
          terminal = false;
          startupWMClass = "fluxer_app";
        };
      in
        appimageTools.wrapType2 {
          inherit pname version src;

          extraInstallCommands = ''
            mkdir -p $out/share/applications
            cp ${desktopItem}/share/applications/* $out/share/applications/

            install -m 444 -D ${./logo.png} $out/share/icons/hicolor/256x256/apps/${pname}.png
          '';
        };
    };
}
