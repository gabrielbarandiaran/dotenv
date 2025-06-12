return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "andrew-george/telescope-themes",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    telescope.load_extension("fzf")
    telescope.load_extension("themes")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
          },
        },
      },
      extensions = {
        themes = {
          enable_previewer = true,
          enable_live_preview = true,
          persist = {
            enabled = true,
            path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua",
          },
        },
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>sf", function()
      local ok = pcall(require("telescope.builtin").git_files)
      if not ok then
        require("telescope.builtin").find_files()
      end
    end, { desc = "Fuzzy find files (git-aware fallback)" })
    vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<CR>", { desc = "Fuzzy find words" })
    vim.keymap.set("n", "<leader>sw", function()
      local word = vim.fn.expand("<cWORD>")
      builtin.live_grep({ search = word })
    end, { desc = "Find Connected Words under cursor" })
  end,
}
