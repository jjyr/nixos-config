return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          mason = false,
        },
        zls = {
          mason = false,
          filetypes = { "zig", "zon" },
          settings = {
            zls = {
              enable_snippets = true,
            },
          },
        },
      },
    },
  },
}
