return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            heading = {
                icons = { " 󰼏 ", " 󰎨 ", " 󰼑 ", " 󰎲 ", " 󰼓 ", " 󰎴 " },
                border = true,
                render_modes = true, -- keep rendering while inserting
            },
            checkbox = {
                enabled = true,
                unchecked = {
                    icon = "󰄱",
                    highlight = "RenderMarkdownCodeFallback",
                    scope_highlight = "RenderMarkdownCodeFallback",
                },
                checked = {
                    icon = "󰄵",
                    highlight = "RenderMarkdownUnchecked",
                    scope_highlight = "RenderMarkdownUnchecked",
                },
                custom = {
                    question = {
                        raw = "[?]",
                        rendered = "",
                        highlight = "RenderMarkdownError",
                        scope_highlight = "RenderMarkdownError",
                    },
                    todo = {
                        raw = "[>]",
                        rendered = "󰦖",
                        highlight = "RenderMarkdownInfo",
                        scope_highlight = "RenderMarkdownInfo",
                    },
                    canceled = {
                        raw = "[-]",
                        rendered = "",
                        highlight = "RenderMarkdownCodeFallback",
                        scope_highlight = "@text.strike",
                    },
                    important = {
                        raw = "[!]",
                        rendered = "",
                        highlight = "RenderMarkdownWarn",
                        scope_highlight = "RenderMarkdownWarn",
                    },
                    favorite = {
                        raw = "[~]",
                        rendered = "",
                        highlight = "RenderMarkdownMath",
                        scope_highlight = "RenderMarkdownMath",
                    },
                },
            },
            pipe_table = {
                alignment_indicator = "─",
                border = { "╭", "┬", "╮", "├", "┼", "┤", "╰", "┴", "╯", "│", "─" },
            },
            link = {
                wiki = {
                    icon = " ",
                    highlight = "RenderMarkdownWikiLink",
                    scope_highlight = "RenderMarkdownWikiLink",
                },
                image = " ",
                custom = {
                    github = { pattern = "github", icon = " " },
                    gitlab = { pattern = "gitlab", icon = "󰮠 " },
                    youtube = { pattern = "youtube", icon = " " },
                },
                hyperlink = " ",
            },
            anti_conceal = {
                -- disabled_modes = { "n" },
                ignore = {
                    -- bullet = true, -- render bullet in insert mode
                    head_border = true,
                    head_background = true,
                },
            },
            -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/509
            -- win_options = { concealcursor = { rendered = "nvc" } },
            completions = {
                blink = { enabled = true },
                lsp = { enabled = true },
            }, -- Ensure the plugin is active for markdown
            enabled = true,
            render_modes = { "n", "c", "i", "v" }, -- Render in Normal, Insert, and Visual modes
            -- anti_conceal = {
            --     enabled = true, -- This prevents the "jumping" effect when your cursor is on a line
            -- },
            table = {
                enabled = true,
                style = "full", -- Options: 'full', 'header', 'none'
                cell = "padded",
            },
            win_options = {
                conceallevel = {
                    default = 2,
                    rendered = 2,
                    concealcursor = { rendered = "vc" },
                },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        opts = {
            linters = {
                ["markdownlint-cli2"] = {
                    -- This tells the linter to search for a config file starting from the file's directory
                    args = { "--" },
                },
            },
        },
    },
}
