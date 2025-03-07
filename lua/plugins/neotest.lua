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
        neotest.run.run()
        neotest.output.open { enter = true }
      end, { desc = 'Run nearest Go test and show output' })

      vim.keymap.set('n', '<leader>go', function()
        require('neotest').output.open { enter = true }
      end, { desc = 'Open test output' })

      vim.keymap.set('n', '<leader>gs', function()
        require('neotest').summary.open()
      end, { desc = 'Open test summary panel' })

      vim.keymap.set('n', '<leader>gd', function()
        require('neotest').run.run { vim.fn.expand '%', strategy = 'dap' }
      end, { desc = 'Run and debug nearest Go test and show output' })
    end,
  },
}
