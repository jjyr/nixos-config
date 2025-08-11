return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          mason = false,
        },
        clangd = {
          mason = false,
        },
        zls = {
          mason = false,
          filetypes = { "zig", "zon" },
          settings = {
            zls = {
              enable_snippets = true,
              enable_build_on_save = true,
            },
          },
        },
        gopls = {
          mason = false,
        },
        pyright = {
          mason = false,
        },
        tsserver = {
          mason = false,
        },
        nil_ls = {
          mason = false,
        },
        yamlls = {
          mason = false,
        },
        bashls = {
          mason = false,
        },
        html = {
          mason = false,
        },
        cssls = {
          mason = false,
        },
        jsonls = {
          mason = false,
        },
        taplo = {
          mason = false,
        },
      },
    },
  },
}
