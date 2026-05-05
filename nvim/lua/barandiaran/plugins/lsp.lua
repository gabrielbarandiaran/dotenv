return {
	-- ================
	-- Snippets
	-- ================
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	-- ================
	-- Completion (blink.cmp)
	-- ================
	{
		"saghen/blink.cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		version = "1.*",
		dependencies = { "L3MON4D3/LuaSnip" },
		opts = {
			keymap = {
				preset = "none",
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-e>"] = { "hide", "fallback" },
			},
			snippets = { preset = "luasnip" },
			completion = {
				menu = {
					draw = {
						treesitter = { "lsp" },
					},
				},
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
				ghost_text = { enabled = false },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			signature = { enabled = true },
		},
	},

	-- ==============
	-- Mason / LSP / Tools
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
				"vtsls",
				"eslint",
				"gopls",
				"pyright",
				"ruff",
				"html",
				"cssls",
				"tailwindcss",
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
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				-- Formatters
				"prettier",
				"prettierd",
				"stylua",
				"black",
				"isort",
				"goimports",
				"shfmt",
				-- Linters
				"eslint_d",
				"hadolint",
				-- DAP adapters
				"debugpy",
				"js-debug-adapter",
			},
			run_on_start = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "b0o/SchemaStore.nvim", "saghen/blink.cmp" },
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				vtsls = {
					settings = {
						typescript = {
							inlayHints = {
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								variableTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								enumMemberValues = { enabled = true },
							},
						},
						javascript = {
							inlayHints = {
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								variableTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								enumMemberValues = { enabled = true },
							},
						},
					},
				},
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
				tailwindcss = {},
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
					map("grn", vim.lsp.buf.rename, " Rename")
					map("gra", vim.lsp.buf.code_action, " Code Action", { "n", "x" })
					map("grr", require("telescope.builtin").lsp_references, " References")
					map("gri", require("telescope.builtin").lsp_implementations, " Implementation")
					map("grd", require("telescope.builtin").lsp_definitions, " Definition")
					map("grD", vim.lsp.buf.declaration, " Declaration")
					map("gO", require("telescope.builtin").lsp_document_symbols, " Document Symbols")
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, " Workspace Symbols")
					map("grt", require("telescope.builtin").lsp_type_definitions, " Type Definition")
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = { "n", "v" },
				desc = "Format buffer / selection",
			},
		},
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
		main = "nvim-treesitter.configs",
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
			incremental_selection = { enable = true },
		},
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {},
		ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
	},
	{ "b0o/SchemaStore.nvim", lazy = true, version = false },
}
