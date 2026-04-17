return {
    {
        "knubie/vim-kitty-navigator",
        lazy = false,
        keys = {
            { "<C-h>", ":KittyNavigateLeft<cr>", desc = "Move to left Kitty/Vim window" },
            { "<C-j>", ":KittyNavigateDown<cr>", desc = "Move to bottom Kitty/Vim window" },
            { "<C-k>", ":KittyNavigateUp<cr>", desc = "Move to top Kitty/Vim window" },
            { "<C-l>", ":KittyNavigateRight<cr>", desc = "Move to right Kitty/Vim window" },
        },
    },
}
