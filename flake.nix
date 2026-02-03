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
          systemPath = hostDir + "/system.nix";
          homePath = hostDir + "/home.nix";
          modulesDir = ./Modules;
          uniqueDir = hostDir;
          userName = "pika";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;

          # only needed if your NixOS modules want `inputs`
          specialArgs = {
            inherit inputs;
            inherit modulesDir uniqueDir;
            inherit userName;
          };

          modules = [
            systemPath
            home-manager.nixosModules.home-manager

            (
              { config, ... }:
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  inherit (config.networking) hostName;
                  inherit modulesDir uniqueDir;
                  inherit userName;
                };

                home-manager.users.pika = import homePath;
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
