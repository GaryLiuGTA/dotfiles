return {
    -- {
    --     "neovim/nvim-lspconfig",
    --     opts = {
    --         servers = {
    --             pyright = {
    --                 enabled = false,
    --             },
    --         },
    --     },
    -- },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "nvim-neotest/nvim-nio",
        },
        opts = {
            controls = {
                icons = {
                    pause = " (F4)",
                    play = " (F5)",
                    step_into = " (F6)",
                    step_over = " (F7)",
                    step_out = " (F8)",
                    step_back = " (F9)",
                    run_last = " (F10)",
                    terminate = " (F11)",
                    disconnect = " (F12)",
                },
            },
        },
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            if dap.configurations.python and dap.configurations.python[1] then
                dap.configurations.python[1].justMyCode = false
            end
            for name, sign in pairs(LazyVim.config.icons.dap) do
                sign = type(sign) == "table" and sign or { sign }
                vim.fn.sign_define(
                    "Dap" .. name,
                    ---@diagnostic disable-next-line: assign-type-mismatch
                    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
                )
            end
            vim.keymap.set({ "n", "v" }, "<leader>dq", function()
                require("dap").list_breakpoints()
            end, { desc = "add all breakpoints to quicklist" })
            vim.keymap.set(
                { "n", "v" },
                "<F5>",
                "<cmd>DapContinue<CR>",
                { silent = true, desc = "DAP launch or continue" }
            )
            vim.keymap.set({ "n", "v", "i" }, "<F6>", "<cmd>DapStepInto<CR>", { silent = true, desc = "DAP step into" })
            vim.keymap.set({ "n", "v", "i" }, "<F7>", "<cmd>DapStepOver<CR>", { silent = true, desc = "DAP step over" })
            vim.keymap.set({ "n", "v", "i" }, "<F8>", "<cmd>DapStepOut<CR>", { silent = true, desc = "DAP step out" })
            vim.keymap.set(
                { "n", "v", "i" },
                "<F10>",
                "<cmd>DapRestartFrame<CR>",
                { silent = true, desc = "DAP run last" }
            )
            vim.keymap.set(
                { "n", "v", "i" },
                "<F11>",
                "<cmd>DapTerminate<CR>",
                { silent = true, desc = "DAP terminate" }
            )
            vim.keymap.set(
                { "n", "v", "i" },
                "<F12>",
                "<cmd>DapDisconnect<CR>",
                { silent = true, desc = "DAP disconnet" }
            )
        end,
    },
}
