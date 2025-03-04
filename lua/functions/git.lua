--- @type vim.api.keyset.win_config[]
local windows = {
  staged = {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.4),
    height = math.floor(vim.o.lines * 0.4),
    style = 'minimal',
    border = 'rounded',
    row = 1,
    col = 1,
  },
  unstaged = {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.4),
    height = math.floor(vim.o.lines * 0.4),
    style = 'minimal',
    border = 'rounded',
    col = 1,
    row = 23,
  },
  diff = {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.4),
    height = math.floor(vim.o.lines * 0.8) + 1,
    style = 'minimal',
    border = 'rounded',
    col = 50,
    row = 1,
  },
}

local list_buf = vim.api.nvim_create_buf(false, true)

local staged_win, unstaged_win, diff_win

-- Function to create a centered floating window (80% of editor size)
local function create_float_win()
  -- local width = math.floor(vim.o.columns * 0.8)
  -- local height = math.floor(vim.o.lines * 0.8)
  -- local row = math.floor((vim.o.lines - height) / 2)
  -- local col = math.floor((vim.o.columns - width) / 2)
  --
  -- local opts = {
  --   relative = 'win',
  --   width = width,
  --   height = height,
  --   row = row,
  --   col = col,
  --   style = 'minimal',
  --   border = 'rounded',
  -- }
  --
  staged_win = vim.api.nvim_open_win(list_buf, true, windows.staged)
  vim.api.nvim_set_current_win(staged_win)

  unstaged_win = vim.api.nvim_open_win(list_buf, true, windows.unstaged)
  vim.api.nvim_set_current_win(unstaged_win)

  diff_win = vim.api.nvim_open_win(list_buf, true, windows.diff)
  vim.api.nvim_set_current_win(diff_win)

  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(staged_win, true)
    vim.api.nvim_win_close(unstaged_win, true)
    vim.api.nvim_win_close(diff_win, true)
    vim.keymap.del('n', 'q')
  end)
end

-- print(vim.api.nvim_buf_get_number(list_buf))
print(list_buf)
-- local diff_buf = nil

local function trim(str)
  return str:match '^%s*(.-)%s*$'
end

-- Function to retrieve changed files from Git
local function get_changed_files()
  local result = vim.fn.systemlist 'git status --porcelain'
  local staged, unstaged = {}, {}
  local status, file
  for _, line in ipairs(result) do
    status = line:sub(1, 2) -- First 2 characters
    file = trim(line:sub(3))

    if status == 'M ' then
      table.insert(staged, file)
    else
      table.insert(unstaged, line)
    end
  end

  vim.api.nvim_buf_set_lines(list_buf, 0, -1, false, unstaged)

  create_float_win()
end

vim.keymap.set('n', '<leader>gc', function()
  get_changed_files()
end, { desc = 'Start git commiting' })
