{
  description = "pikalinux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arkenfox = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";

      mkHost =
        hostDir:
        let
          userName = "pika";
          hostDirName = builtins.baseNameOf (toString hostDir);
          modulesDir = "/home/${userName}/PubDoots/Modules";
          uniqueDir = "/home/${userName}/PubDoots/Unique/${hostDirName}";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;

          # only needed if your NixOS modules want `inputs`
          specialArgs = {
            inherit inputs modulesDir uniqueDir userName;
          };

          modules = [
            "${uniqueDir}/system.nix"
            home-manager.nixosModules.home-manager

            (
              { config, ... }:
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = {
                  inherit inputs modulesDir uniqueDir userName;
                };
              }
            )
          ];
        };
    in
    {
      nixosConfigurations = {
        pikalinux = mkHost ./Unique/pikalinux;
      };
    };
}
