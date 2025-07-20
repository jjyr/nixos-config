return {
  -- Configure DAP for codelldb
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local codelldb_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb"

      -- Adapter configuration
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      }

      -- Configuration for C, C++, Rust
      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      -- Reuse the same configuration for C and Rust
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
    end,
  },
}
