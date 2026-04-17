return {
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
     ██████╗  █████╗ ██████╗ ██╗   ██╗█╗███████╗    ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
    ██╔════╝ ██╔══██╗██╔══██╗╚██╗ ██╔╝╚╝██╔════╝    ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
    ██║  ███╗███████║██████╔╝ ╚████╔╝   ███████╗    ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
    ██║   ██║██╔══██║██╔══██╗  ╚██╔╝    ╚════██║    ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
    ╚██████╔╝██║  ██║██║  ██║   ██║     ███████║    ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
     ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝     ╚══════╝    ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
    ]],
        },
      },
    },
  },
  {
    "tokyonight.nvim",
    opts = {
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        colors.fg_gutter = "#62636a"
      end,
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },
  -- {
  --     "nvim-treesitter/nvim-treesitter-context",
  --     event = "LazyFile",
  --     opts = function()
  --         local tsc = require("treesitter-context")
  --         Snacks.toggle({
  --             name = "Treesitter Context",
  --             get = tsc.enabled,
  --             set = function(state)
  --                 if state then
  --                     tsc.enable()
  --                 else
  --                     tsc.disable()
  --                 end
  --             end,
  --         }):map("<leader>ut")
  --         return { mode = "cursor", max_lines = 8 }
  --     end,
  -- },
}
