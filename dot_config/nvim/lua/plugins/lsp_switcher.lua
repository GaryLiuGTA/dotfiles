-- LSP Switcher: floating window with toggleable LSP servers (installed only)
-- Keymap: <leader>cls
-- Usage: <Space> toggle selection, <CR> apply, q/Esc close

local function lsp_switcher()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local servers = {}
  local seen = {}

  -- Get installed servers from mason-lspconfig
  local installed_set = {}
  local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
  if ok_mason then
    for _, name in ipairs(mason_lspconfig.get_installed_servers()) do
      installed_set[name] = true
    end
  end

  -- 1) Active clients on this buffer (always shown)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    seen[client.name] = true
    table.insert(servers, { name = client.name, active = true, client = client, selected = false })
  end

  -- 2) Installed-but-not-running servers for this filetype
  if ok_mason then
    local filetype_map = require("mason-lspconfig.mappings").get_filetype_map()
    local ft_servers = filetype_map[ft] or {}
    for _, name in ipairs(ft_servers) do
      if not seen[name] and installed_set[name] then
        seen[name] = true
        table.insert(servers, { name = name, active = false, selected = false })
      end
    end
  end

  if #servers == 0 then
    vim.notify("No installed LSP servers for filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  -- Sort: active first, then alphabetical
  table.sort(servers, function(a, b)
    if a.active ~= b.active then
      return a.active
    end
    return a.name < b.name
  end)

  -- Create floating buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"

  local function render()
    local lines = {}
    for _, srv in ipairs(servers) do
      local check = srv.selected and "[x]" or "[ ]"
      local status = srv.active and "● running" or "○ stopped"
      table.insert(lines, string.format(" %s  %s  (%s)", check, srv.name, status))
    end
    table.insert(lines, "")
    table.insert(lines, " <Space> toggle  <CR> apply  q close")
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
  end

  render()

  -- Window sizing
  local width = 50
  local height = #servers + 2
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " LSP Switcher (" .. ft .. ") ",
    title_pos = "center",
  })

  -- Keep cursor on server lines only
  local function clamp_cursor()
    local row = vim.api.nvim_win_get_cursor(win)[1]
    if row > #servers then
      vim.api.nvim_win_set_cursor(win, { #servers, 0 })
    end
  end

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  -- Toggle selection on current line
  vim.keymap.set("n", "<Space>", function()
    clamp_cursor()
    local row = vim.api.nvim_win_get_cursor(win)[1]
    if row <= #servers then
      servers[row].selected = not servers[row].selected
      render()
      if row < #servers then
        vim.api.nvim_win_set_cursor(win, { row + 1, 0 })
      end
    end
  end, { buffer = buf, nowait = true })

  -- Apply: toggle all selected servers
  vim.keymap.set("n", "<CR>", function()
    local started, stopped = {}, {}
    for _, srv in ipairs(servers) do
      if srv.selected then
        if srv.active then
          srv.client:stop()
          table.insert(stopped, srv.name)
        else
          vim.cmd("LspStart " .. srv.name)
          table.insert(started, srv.name)
        end
      end
    end
    close()
    local msgs = {}
    if #started > 0 then
      table.insert(msgs, "Started: " .. table.concat(started, ", "))
    end
    if #stopped > 0 then
      table.insert(msgs, "Stopped: " .. table.concat(stopped, ", "))
    end
    if #msgs > 0 then
      vim.notify(table.concat(msgs, "\n"), vim.log.levels.INFO)
    end
  end, { buffer = buf })

  -- Close keymaps
  vim.keymap.set("n", "q", close, { buffer = buf })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf })

  -- Clamp cursor when moving
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = buf,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        clamp_cursor()
      end
    end,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>cls", lsp_switcher, desc = "LSP Switcher (start/stop)" },
    },
  },
}
