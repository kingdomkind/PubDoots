{
  description = "pikalinux";

  nixConfig = {

    #> Noctalia cache
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";

    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = builtins.currentSystem;

      mkHost =
        hostDir:
        let
          userName = "pika";
          hostDirName = baseNameOf (toString hostDir);
          modulesDir = "/home/${userName}/PubDoots/Modules";
          uniqueDir = "/home/${userName}/PubDoots/Unique/${hostDirName}";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;

          #> Arguments passed to each module
          specialArgs = {
            inherit
              inputs
              modulesDir
              uniqueDir
              userName
              ;
          };

          #> Nix files to include
          modules = [
            "${uniqueDir}/system.nix"
            inputs.nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
          ];
        };
    in
    {
      nixosConfigurations = {
        pikalinux = mkHost ./Unique/pikalinux;
        brotop = mkHost ./Unique/brotop;
      };
    };
}
