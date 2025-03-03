return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      { 'fredrikaverpil/neotest-golang', version = '*' }, -- Installation
    },
    config = function()
      local neotest_golang_opts = {
        go_test_args = { '-v' }, -- Verbose output like go test -v
        warn_test_name_dupes = true, -- Warn about duplicate test names
      } -- Specify custom configuration
      require('neotest').setup {
        adapters = {
          require 'neotest-golang'(neotest_golang_opts), -- Registration
        },
      }

      vim.keymap.set('n', '<leader>gt', function()
        local neotest = require 'neotest'
        neotest.output.open { enter = true, auto_close = true, last_run = true }
        neotest.run.run()
      end, { desc = 'Run nearest Go test and show output' })

      vim.keymap.set('n', '<leader>go', function()
        require('neotest').output.open { enter = true }
      end, { desc = 'Open test output' })
    end,
  },
}
