local function get_commenter()
    local commenter = { python = "# ", lua = "-- ", julia = "# ", fennel = ";; ", scala = "// ", r = "# " }
    -- local bufnr = vim.api.nvim_get_current_buf()
    -- local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
    local ft = vim.bo.buftype
    if ft == nil or ft == "" then
        return commenter["python"]
    elseif commenter[ft] == nil then
        return commenter["python"]
    end

    return commenter[ft]
end

local CELL_MARKER = get_commenter() .. "%%"
vim.api.nvim_set_hl(0, "CellMarkerHl", { default = true, bg = "#c5c5c5", fg = "#111111" })

local function select_cell()
    local bufnr = vim.api.nvim_get_current_buf()
    local current_row = vim.api.nvim_win_get_cursor(0)[1]
    local current_col = vim.api.nvim_win_get_cursor(0)[2]

    local start_line = nil
    local end_line = nil

    for line = current_row, 1, -1 do
        local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
        if line_content:find("^" .. CELL_MARKER) then
            start_line = line
            break
        end
    end
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    for line = current_row + 1, line_count do
        local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
        if line_content:find("^" .. CELL_MARKER) then
            end_line = line
            break
        end
    end

    if not start_line then
        start_line = 1
    end
    if not end_line then
        end_line = line_count
    end
    return current_row, current_col, start_line, end_line
end

local function execute_cell()
    local current_row, current_col, start_line, end_line = select_cell()
    if start_line and end_line then
        vim.fn.setpos("'<", { 0, start_line + 1, 0, 0 })
        vim.fn.setpos("'>", { 0, end_line - 1, 0, 0 })
        require("iron.core").visual_send()
        vim.api.nvim_win_set_cursor(0, { current_row, current_col })
    end
end

local function delete_cell()
    local _, _, start_line, end_line = select_cell()
    if start_line and end_line then
        vim.api.nvim_buf_set_lines(0, start_line - 1, end_line - 1, false, {})
    end
end

local function navigate_cell(up)
    local is_up = up or false
    local _, _, start_line, end_line = select_cell()
    if is_up and start_line ~= 1 then
        vim.api.nvim_win_set_cursor(0, { start_line - 1, 0 })
    elseif end_line then
        local bufnr = vim.api.nvim_get_current_buf()
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        if end_line ~= line_count then
            vim.api.nvim_win_set_cursor(0, { end_line + 1, 0 })
            _, _, start_line, end_line = select_cell()
            vim.api.nvim_win_set_cursor(0, { end_line - 1, 0 })
        end
    end
end

local function add_new_block(up)
    local is_up = up or false
    local _, _, start_line, end_line = select_cell()
    if is_up and start_line then
        vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, false, { CELL_MARKER, "" })
        vim.api.nvim_win_set_cursor(0, { start_line + 1, 0 })
    elseif end_line then
        local bufnr = vim.api.nvim_get_current_buf()
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        if end_line < line_count then
            vim.api.nvim_buf_set_lines(0, end_line - 1, end_line - 1, false, { CELL_MARKER, "" })
            vim.api.nvim_win_set_cursor(0, { end_line + 1, 0 })
        elseif end_line == line_count then
            vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { CELL_MARKER, "" })
            vim.api.nvim_win_set_cursor(0, { end_line + 2, 0 })
        end
    end
end

return {
    {
        "Vigemus/iron.nvim",
        event = "VeryLazy",
        opts = function()
            return {
                config = {
                    -- Whether a repl should be discarded or not
                    scratch_repl = true,
                    -- Your repl definitions come here

                    repl_definition = {
                        -- python = require("iron.fts.python").ipython
                        python = {
                            command = { "ipython", "--no-autoindent" },
                            format = function(lines, extras)
                                -- local result_orig = require("iron.fts.common").bracketed_paste(lines)
                                -- print(result_orig)
                                -- print("*********", #result_orig, "*******")
                                -- for k, v in pairs(result_orig) do
                                --     print(k, "===", v)
                                -- end
                                local result = require("iron.fts.common").bracketed_paste_python(lines, extras)
                                return vim.tbl_filter(function(line)
                                    return not string.match(line, "^%s*#")
                                end, result)
                            end,
                            block_deviders = { CELL_MARKER },
                        },
                        -- scala = require("iron.fts.scala").scala,
                    },
                    -- How the repl window will be displayed
                    -- See below for more information
                    -- this open in DSL style, not able to switch window
                    -- repl_open_cmd = require("iron.view").right("40%"),
                    repl_open_cmd = "vertical split",
                },
                -- If the highliht is on, you can change how it looks
                -- For the available options, check nvim_set_hl
                highlight = {
                    italic = true,
                },
                ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
            }
        end,
      -- stylua: ignore
      keys = {
        { "<leader>r", function() end, mode = {"n", "x"}, desc = "+REPL" },
        -- { "<leader>rm", function() end, mode = {"n", "x"}, desc = "+Mark" },
        { "<leader>re", execute_cell, desc = "Execute Cell" },
        { "<leader>rx", delete_cell, desc = "Delete Cell" },
        { "<leader>rb", add_new_block, desc = "Add New Block Below" },
        { "<leader>ra", function() add_new_block(true) end, desc = "Add New Block Above" },
        { "<leader>rd", navigate_cell, desc = "Next Cell (Down)" },
        { "<leader>ru", function() navigate_cell(true) end, desc = "Previous Cell" },
        -- { "<leader>xs", function() require("iron.core").run_motion("send_motion") end, desc = "Send Motion" },
        { "<leader>rs", function() require("iron.core").visual_send() end, mode = {"v"}, desc = "Send" },
        { "<leader>rl", function() require("iron.core").send_line() end, desc = "Send Line" },
        { "<leader>rc", function() require("iron.core").send_until_cursor() end, desc = "Send Until Cursor" },
        { "<leader>rf", function() require("iron.core").send_file() end, desc = "Send File" },
        { "<leader>rp", function() require("iron.core").send_paragraph() end, desc = "Send Paragraph" },
        -- { "<leader>rb", function() require("iron.core").send_code_block(false) end, desc = "Send Code Block" },
        -- { "<leader>rd", function() require("iron.core").send_code_block(true) end, desc = "Send Code Block and Move Down" },
        -- { "<leader>xL", function() require("iron.marks").clear_hl() end, mode = {"v"}, desc = "Clear Highlight" },
        -- { "<leader>r<cr>", function() require("iron.core").send(nil, string.char(13)) end, desc = "ENTER" },
        { "<leader>rI", function() require("iron.core").send(nil, string.char(03)) end, desc = "Interrupt" },
        { "<leader>rC", function() require("iron.core").close_repl() end, desc = "Close REPL" },
        { "<leader>rc", function() require("iron.core").send(nil, string.char(12)) end, desc = "Clear" },
        -- { "<leader>xms", function() require("iron.core").send_mark() end, desc = "Send Mark" },
        -- { "<leader>xmm", function() require("iron.core").run_motion("mark_motion") end, desc = "Mark Motion" },
        -- { "<leader>xmv", function() require("iron.core").mark_visual() end, mode = {"v"}, desc = "Mark Visual" },
        -- { "<leader>xmr", function() require("iron.marks").drop_last() end, desc = "Remove Mark" },
        { "<leader>rr", "<cmd>IronRepl<cr>", desc = "REPL" },
        { "<leader>rS", "<cmd>IronRestart<cr>", desc = "Restart" },
        { "<leader>rF", "<cmd>IronFocus<cr>", desc = "Focus" },
        { "<leader>rH", "<cmd>IronHide<cr>", desc = "Hide" },
      },
        config = function(_, opts)
            local iron = require("iron.core")
            iron.setup(opts)
            vim.keymap.set("t", "<C-/>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
        end,
    },
}
