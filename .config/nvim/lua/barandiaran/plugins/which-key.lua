return {
	"folke/which-key.nvim",
	event = "VimEnter",
	opts = {
		delay = 0,
		icons = {
			mappings = vim.g.have_nerd_font,
			keys = vim.g.have_nerd_font and {} or {
				Up = "<Up>",
				Down = "<Down>",
				Left = "<Left>",
				Right = "<Right>",
				C = "<C-",
				M = "<M-",
				D = "<D-",
				S = "<S-",
				CR = "<CR>",
				Esc = "<Esc>",
				ScrollWheelDown = "<ScrollWheelDown>",
				ScrollWheelUp = "<ScrollWheelUp>",
				NL = "<NL>",
				BS = "<BS>",
				Space = "<Space>",
				Tab = "<Tab>",
			},
		},
		spec = {
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>x", group = "[X]Error handling" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
		},
	},
}
