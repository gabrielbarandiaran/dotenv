return {
  -- vim-fugitive
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      { "<leader>gg", "<cmd>Git<CR>", desc = "Git status (Fugitive)" },
    },
    config = function()
      local augroup = vim.api.nvim_create_augroup("FugitiveMappings", { clear = true })

      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = augroup,
        pattern = "*",
        callback = function()
          if vim.bo.filetype ~= "fugitive" then
            return
          end

          local opts = { buffer = true, silent = true }

          vim.keymap.set("n", "<leader>gP", function()
            vim.cmd.Git("push")
          end, vim.tbl_extend("keep", { desc = "Git push" }, opts))

          vim.keymap.set("n", "<leader>gp", function()
            vim.cmd.Git({ "pull", "--rebase" })
          end, vim.tbl_extend("keep", { desc = "Git pull --rebase" }, opts))

          vim.keymap.set(
            "n",
            "<leader>gt",
            ":Git push -u origin ",
            vim.tbl_extend("keep", { desc = "Git push -u" }, opts)
          )
        end,
      })
    end,
  },
  {
    {
      'lewis6991/gitsigns.nvim',
      opts = {
        on_attach = function(bufnr)
          local gitsigns = require 'gitsigns'

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              gitsigns.nav_hunk 'next'
            end
          end, { desc = 'Jump to next git [c]hange' })

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              gitsigns.nav_hunk 'prev'
            end
          end, { desc = 'Jump to previous git [c]hange' })

          -- Actions
          -- visual mode
          map('v', '<leader>hs', function()
            gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'git [s]tage hunk' })
          map('v', '<leader>hr', function()
            gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'git [r]eset hunk' })
          -- normal mode
          map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
          map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
          map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
          map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
          map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
          map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
          map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
          map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
          map('n', '<leader>hD', function()
            gitsigns.diffthis '@'
          end, { desc = 'git [D]iff against last commit' })
          -- Toggles
          map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
          map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
        end,
      },
    },
  },
}
