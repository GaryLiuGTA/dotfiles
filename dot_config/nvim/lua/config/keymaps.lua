-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set({ "i", "v" }, "jk", "<ESC>", { silent = true })
vim.keymap.set({ "i" }, "<C-h>", "<Left>", { desc = "Move left in insert mode" })
vim.keymap.set({ "i" }, "<C-l>", "<Right>", { desc = "Move right in insert mode" })
vim.keymap.set({ "i" }, "<C-/>", "<cmd>norm gcc<CR>", { desc = "Move right in insert mode" })
vim.keymap.set({ "n" }, "<leader>O", "O<ESC>", { desc = "Add new line above" })
vim.keymap.set({ "n" }, "<leader>o", "o<ESC>", { desc = "Add new line below" })
vim.keymap.set({ "n", "v" }, "<ESC>", "<cmd>nohl<CR>", { desc = "cancel search highlight" })
-- vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>", { desc = "exit insert mode in terminal" })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "exit insert mode in terminal" })
-- vim.keymap.set({ "n", "v" }, "gB", "<cmd>bp<CR>", { desc = "previous buffer" })
-- vim.keymap.set({ "n", "v" }, "gb", "<cmd>bn<CR>", { desc = "next buffer" })
vim.keymap.set({ "n", "v", "o" }, "H", "^")
vim.keymap.set({ "n", "v", "o" }, "L", "$")
vim.keymap.set({ "n", "v", "x", "i" }, "<M-h>", "<cmd>bp<CR>", { desc = "previous buffer" })
vim.keymap.set({ "n", "v", "x", "i" }, "<M-l>", "<cmd>bn<CR>", { desc = "next buffer" })
vim.keymap.set({ "t" }, "<M-Down>", "<cmd>resize -2<CR>", { desc = "Shrink terminal size by 2 vertically" })
vim.keymap.set({ "t" }, "<M-Up>", "<cmd>resize +2<CR>", { desc = "Increase terminal size by 2 vertically" })
-- vim.keymap.set({ "t" }, "<M-l>", "<Right>", { desc = "terminal auto complete history" })

-- execute buffer code
local function table_contains(t, value)
    if t and type(t) == "table" and value then
        for _, v in ipairs(t) do
            if v == value then
                return true
            end
        end
        return false
    end
    return false
end
vim.keymap.set({ "n", "v" }, "<leader>bk", function()
    if table_contains({ "python", "rust" }, vim.bo.filetype) then
        if vim.bo.modified then
            vim.api.nvim_command("w")
        end
        if vim.bo.filetype == "python" then
            vim.api.nvim_command("term python3 %")
        elseif vim.bo.filetype == "rust" then
            vim.api.nvim_command("term cargo run %")
        end
        local current_buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_keymap(current_buf, "n", "q", "", {
            noremap = true,
            silent = true,
            callback = function()
                vim.api.nvim_command("bd")
            end,
        })
    else
        vim.api.nvim_command("echo 'this is not a valid executable code file (Python or Rust)'")
    end
end, { desc = "execute python/rust file in current buffer" })
-- expression print in DAP REPL
local dap = require("dap")
local last_expr = nil
local function get_visual_selection_region()
    -- getregion() uses the '< and '> marks
    local lines = vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"))
    -- local selected_text = table.concat(lines, "\n")
    return lines[1] --selected_text
end

local function print_bigquery_expression(expr)
    if expr ~= nil then
        require("dap.repl").execute("print(" .. expr .. '.sql(pretty=True, dialect="bigquery"))\n')
    end
end
local function print_expression_ast(expr)
    if expr ~= nil then
        require("dap.repl").execute("print(repr(" .. expr .. "))\n")
    end
end

local function print_expression(mode)
    local expr = nil
    if mode == "n" then
        expr = vim.fn.expand("<cword>")
    elseif mode == "v" then
        expr = get_visual_selection_region()
    end
    print_bigquery_expression(expr)
end
local function set_repl_keymap()
    vim.keymap.set("n", "<M-e>", function()
        print_expression("n")
    end, { desc = "Print BigQuery SQL of current expression" })
    vim.keymap.set("v", "<M-e>", function()
        print_expression("v")
    end, { desc = "Print BigQuery SQL of selected expression" })
    vim.keymap.set({ "n", "v" }, "<M-E>", function()
        vim.ui.input("BigQuery AST:", print_bigquery_expression)
    end, { desc = "Print a given BigQuery expression" })
    vim.keymap.set({ "n", "v" }, "<M-r>", function()
        vim.ui.input("BigQuery AST", print_expression_ast)
    end, { desc = "Print AST of given expression" })
    vim.keymap.set({ "n", "v" }, "<M-;>", function()
        if last_expr ~= nil then
            print_bigquery_expression(last_expr)
        end
    end, { desc = "Print sql of last expression" })
    vim.keymap.set({ "n", "v" }, "<M-'>", function()
        if last_expr ~= nil then
            print_expression_ast(last_expr)
        end
    end, { desc = "Print AST of last expression" })
end

local function del_repl_keymap()
    pcall(vim.keymap.del, { "n", "v" }, "<leader>dz")
    last_expr = nil
end

dap.listeners.after.event_initialized["sqlglot_dap"] = function()
    set_repl_keymap()
end

dap.listeners.before.event_terminated["sqlglot_dap"] = function()
    del_repl_keymap()
end

dap.listeners.before.event_exited["sqlglot_dap"] = function()
    del_repl_keymap()
end
