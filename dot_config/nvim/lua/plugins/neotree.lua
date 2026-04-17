return {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
        -- opts is the table that LazyVim uses to configure Neo-tree
        opts.filesystem = opts.filesystem or {}
        opts.filesystem.window = opts.filesystem.window or {}
        opts.filesystem.window.mappings = opts.filesystem.window.mappings or {}

        -- Disable 's' so it falls through to Neovim normal mode
        opts.filesystem.window.mappings["s"] = false
        -- opts.filesystem.window.mappings["S"] = false
        opts.filesystem.window.mappings["v"] = function(state)
            local node = state.tree:get_node()
            vim.cmd("vsplit " .. node.path)
        end
    end,
}
