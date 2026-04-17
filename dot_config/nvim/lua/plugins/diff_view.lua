return {
    -- { "rickhowe/spotdiff.vim" },
    { "sindrets/diffview.nvim" },
    { "AndrewRadev/linediff.vim" },

    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                {
                    mode = { "n", "v" },
                    { "<leader>gv", group = "diffView" },
                    -- { "gv", group = "diffView" },
                    { "<leader>gvh", "<cmd>DiffviewFileHistory<CR>", desc = "File History Diff View" },
                    { "<leader>gvo", "<cmd>DiffviewOpen<CR>", desc = "Diff View (Root)" },
                    { "<leader>gvc", "<cmd>DiffviewClose<CR>", desc = "Close Diff View" },
                },
            },
        },
        -- opts = function()
        --   require("which-key").register({
        --     ["gv"] = { name = "+diffView" },
        --     ["<leader>gv"] = {
        --       name = "+diffView",
        --       h = { "<cmd>DiffviewFileHistory<CR>", "File History Diff View" },
        --       o = { "<cmd>DiffviewOpen<CR>", "Diff View (Root)" },
        --       c = { "<cmd>DiffviewClose<CR>", "Close Diff View" },
        --     },
        --   })
        -- end,
    },
}
