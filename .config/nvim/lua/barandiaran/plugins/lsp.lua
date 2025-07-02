return {
	-- ================
	-- Completion (CMP)
	-- ================
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"onsails/lspkind-nvim", -- For nice icons
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
				}),
			})
		end,
	},

	-- ==============
	-- Mason/LSP/Linters
	-- ==============
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		opts = { ui = { border = "rounded" } },
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"ts_ls",
				"eslint",
				"gopls",
				"pyright",
				"ruff",
				"html",
				"cssls",
				"jsonls",
				"svelte",
				"dockerls",
				"yamlls",
				"lua_ls",
				"bashls",
				"graphql",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "b0o/SchemaStore.nvim" },
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local servers = {
				ts_ls = {},
				eslint = {},
				gopls = {},
				pyright = {},
				ruff = {},
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				svelte = {},
				html = {},
				cssls = {},
				jsonls = {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = { enable = true, url = "" },
							schemas = require("schemastore").yaml.schemas(),
							validate = true,
							hover = true,
							completion = true,
						},
					},
				},
				dockerls = {},
				bashls = {},
				graphql = {},
			}

			for name, opts in pairs(servers) do
				opts.capabilities = capabilities
				lspconfig[name].setup(opts)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local map = function(keys, func, desc, modes)
						vim.keymap.set(modes or "n", keys, func, { buffer = event.buf, desc = desc })
					end
					map("grn", vim.lsp.buf.rename, " Rename")
					map("gra", vim.lsp.buf.code_action, " Code Action", { "n", "x" })
					map("grr", require("telescope.builtin").lsp_references, " References")
					map("gri", require("telescope.builtin").lsp_implementations, " Implementation")
					map("grd", require("telescope.builtin").lsp_definitions, " Definition")
					map("grD", vim.lsp.buf.declaration, " Declaration")
					map("gO", require("telescope.builtin").lsp_document_symbols, " Document Symbols")
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, " Workspace Symbols")
					map("grt", require("telescope.builtin").lsp_type_definitions, " Type Definition")
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				go = { "goimports", "gofmt" },
				python = { "black", "isort", "ruff_format" },
				lua = { "stylua" },
				sh = { "shfmt" },
				dockerfile = { "hadolint" },
			},
			format_on_save = {
				timeout_ms = 1000,
				lsp_fallback = true,
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("lint").linters_by_ft = {
				javascript = { "eslint" },
				typescript = { "eslint" },
				javascriptreact = { "eslint" },
				typescriptreact = { "eslint" },
				svelte = { "eslint" },
			}
			-- Optionally lint on save:
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"css",
				"dockerfile",
				"go",
				"graphql",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"prisma",
				"python",
				"svelte",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
			highlight = { enable = true },
			indent = { enable = true },
			autotag = { enable = true },
			incremental_selection = { enable = true },
		},
	},
	{
		"windwp/nvim-ts-autotag",
		opts = { enable = true },
		ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
	},
	{ "b0o/SchemaStore.nvim", lazy = true, version = false },
}
