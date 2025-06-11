return {
  "voldikss/vim-floaterm",
  config = function()
    -- Floaterm settings
    vim.g.floaterm_position = "center"
    vim.g.floaterm_width = 0.9
    vim.g.floaterm_height = 0.9
    vim.g.floaterm_title = ""
    vim.g.floaterm_borderchars = "─│─│╭╮╯╰"
    vim.g.floaterm_autoclose = 2

    -- Keymaps (define them *after* Floaterm is loaded)
    vim.keymap.set("n", "<C-\\>", "<cmd>FloatermToggle<CR>", { noremap = true, silent = true })
    vim.keymap.set("t", "<C-\\>", [[<C-\><C-n>:FloatermToggle<CR>]], { noremap = true, silent = true })
    vim.keymap.set("t", "<C-h>", [[<C-\><C-n>:FloatermPrev<CR>]], { noremap = true, silent = true })
    vim.keymap.set("t", "<C-l>", [[<C-\><C-n>:FloatermNext<CR>]], { noremap = true, silent = true })
    vim.keymap.set("t", "<C-n>", [[<C-\><C-n>:FloatermNew<CR>]], { noremap = true, silent = true })
    vim.keymap.set("t", "<C-d>", [[<C-\><C-n>:FloatermKill<CR>]], { noremap = true, silent = true })
  end,
}
