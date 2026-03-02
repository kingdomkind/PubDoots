{
  pkgs,
  userName,
  modulesDir,
  ...
}:
{
  home-manager.users.${userName} =
    { config, ... }:
    {
      programs.neovim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [
          # Core plugins
          # (nvim-treesitter.withPlugins (p: [
          #   p.lua
          #   p.rust
          #   p.nix
          #   p.css
          #   p.markdown
          #   p.java
          # ]))
          toggleterm-nvim
          lualine-nvim
          snacks-nvim
          mini-comment
          conform-nvim
          mini-starter
          live-preview-nvim
          vim-suda
          cutlass-nvim
          catppuccin-nvim

          # Telescope + deps
          telescope-nvim
          plenary-nvim

          # Barbar + deps
          barbar-nvim
          gitsigns-nvim
          nvim-web-devicons

          # nvim-cmp + deps
          nvim-cmp
          luasnip
          cmp-buffer
          cmp-nvim-lsp
          cmp_luasnip

          # LSP configs
          nvim-lspconfig

          # Neo-tree + deps
          neo-tree-nvim
          nui-nvim
        ];
      };

      home.packages = with pkgs; [
        rust-analyzer
        nixd
        nixfmt
        llvmPackages_20.clang-tools
        emmylua-ls
      ];

      xdg.configFile."nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink (
        modulesDir + "/neovim/init.lua"
      );
    };
}
