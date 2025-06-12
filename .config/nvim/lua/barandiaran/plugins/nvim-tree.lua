return {
  "nvim-tree/nvim-tree.lua",
  enabled = true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Disable netrw (conflicts with nvim-tree)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Safely load nvim-tree
    local nvimtree = require("nvim-tree")

    nvimtree.setup({
      hijack_directories = {
        enable = false,
        auto_open = false,
      },
      view = {
        width = 60,
        relativenumber = true,
        side = "left",
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "→", -- arrow when folder is closed
              arrow_open = "↓", -- arrow when folder is open
            },
          },
        },
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    })

    -- Don’t open NvimTree on empty session if using Alpha
    local function is_startup()
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      return #lines == 1 and lines[1] == ""
    end

    if vim.fn.argc(-1) == 0 and not vim.g.started_by_alpha then
      -- Avoid race condition with Alpha dashboard
      vim.schedule(function()
        if is_startup() then
          vim.cmd("NvimTreeOpen")
        end
      end)
    end

    -- Keymap
    vim.keymap.set("n", "<S-q>", "<cmd>NvimTreeFindFileToggle<CR>", {
      desc = "Toggle file explorer on current file",
    })
  end,
}
