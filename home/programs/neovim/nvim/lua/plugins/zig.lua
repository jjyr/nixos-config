return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        zls = {
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
