-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Autocmds are automatically loaded on the VeryLazy event
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--     pattern = { "python" },
--     callback = function()
--         vim.b.autoformat = false
--     end,
-- })

vim.api.nvim_create_autocmd("User", {
    pattern = "LinediffBufferReady",
    callback = function()
        vim.keymap.set("n", "q", "<cmd>LinediffReset<cr>", {
            buffer = true,
            desc = "Reset Linediff",
            noremap = true,
            silent = true,
        })
    end,
})
