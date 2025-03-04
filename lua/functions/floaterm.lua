local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_terminal(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.width or math.floor(vim.o.lines * 0.9)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = vim.api.nvim_create_buf(false, true)

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

vim.api.nvim_create_user_command('FloatingTerminal', function()
  if state.floating.buf == -1 or state.floating.win == -1 then
    state.floating = create_floating_terminal()
  else
    vim.api.nvim_win_close(state.floating.win, true)
    state.floating = {
      buf = -1,
      win = -1,
    }
  end
end, {})

print(vim.inspect(state.floating))

vim.keymap.set('n', '<leader>tt', function() vim.cmd FloatingTerminal end, { desc = 'Toggle Floating Terminal' })
