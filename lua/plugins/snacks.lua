return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = {
        enabled = true,
        -- hidden = true,
        -- ignored = true,
        -- exclude = { "node_modules", ".git" },
      },
      indent = { enabled = true, animate = { enabled = false } },
      input = { enabled = true },
      lazygit = { enabled = true },
      picker = { enabled = true, hidden = false, ignored = false, exclude = { "node_modules", ".git" } },
      -- notifier = { enabled = true },
      -- quickfile = { enabled = true },
      scope = { enabled = true },
      -- scroll = { enabled = true },
      -- statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {

      {
        "<leader>e",
        function()
          require("snacks").explorer()
        end,
        desc = "Snack Explorer",
      },
      {
        "<leader>lg",
        function()
          require("snacks").lazygit()
        end,
        desc = "lazygit",
      },
    },
  },
}
