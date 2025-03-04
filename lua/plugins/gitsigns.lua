-- -- Function to stage/unstage the file under cursor in neo-tree
-- local function git_toggle_stage_current_file()
--   -- Get the neo-tree state
--   local state = require('neo-tree.sources.manager').get_state 'filesystem'
--   local tree = state.tree
--
--   if not tree then
--     print 'No neo-tree instance found'
--     return
--   end
--
--   -- Get the node under cursor
--   local node = tree:get_node()
--   if not node then
--     print 'No file selected'
--     return
--   end
--
--   -- Check if it's a file (not a directory)
--   if node.type ~= 'file' then
--     print 'Selected item is not a file'
--     return
--   end
--
--   -- Get the file path
--   local file_path = node.path
--
--   -- Check if file is already staged
--   local staged = vim.fn.systemlist 'git diff --name-only --cached'
--   local is_staged = false
--   for _, staged_file in ipairs(staged) do
--     if vim.fn.fnamemodify(file_path, ':t') == vim.fn.fnamemodify(staged_file, ':t') then
--       is_staged = true
--       break
--     end
--   end
--
--   if is_staged then
--     -- Unstage the file
--     vim.cmd(string.format('Git reset %s', vim.fn.fnameescape(file_path)))
--     print('File unstaged: ' .. file_path)
--   else
--     -- Stage the file
--     vim.cmd(string.format('Git add %s', vim.fn.fnameescape(file_path)))
--     print('File staged: ' .. file_path)
--   end
-- end
--
-- -- Create a command to call this function
-- vim.api.nvim_create_user_command(
--   'GitToggleStageCurrent',
--   git_toggle_stage_current_file,
--   { desc = 'Toggle staging of the current file under cursor in neo-tree' }
-- )
--
-- -- Keymapping example
-- vim.keymap.set('n', 'ga', git_toggle_stage_current_file, {
--   desc = 'Git toggle stage current file in neo-tree',
--   silent = false,
-- })
--
-- vim.keymap.set('n', '<leader>gc', function()
--   vim.cmd 'Git commit'
-- end, {
--   desc = 'Git commit staged files',
--   silent = false,
-- })

return {

  {
    'tpope/vim-fugitive',
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {

      signs = {
        add = { text = '|' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
}
