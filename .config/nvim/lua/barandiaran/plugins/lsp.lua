return {
  -- CMP (completion)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lsp_kinds = {
        Class = " ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = " ",
        Keyword = " ",
        Method = " ",
        Module = " ",
        Operator = " ",
        Property = " ",
        Reference = " ",
        Snippet = " ",
        Struct = " ",
        Text = " ",
        TypeParameter = " ",
        Unit = " ",
        Value = " ",
        Variable = " ",
      }
      cmp.setup({
        formatting = {
          format = function(entry, vim_item)
            vim_item.kind = (lsp_kinds[vim_item.kind] or "") .. vim_item.kind
            return vim_item
          end,
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
  -- Mason (LSP, DAP, Linter/Formatter Installer)
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "ts_ls",
        "eslint",
        "gopls",
        "pyright",
        "html",
        "cssls",
      },
    },
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        ts_ls = {},
        eslint = {},
        gopls = {},
        pyright = {},
        html = {},
        cssls = {},
      }

      for name, opts in pairs(servers) do
        opts.capabilities = capabilities
        lspconfig[name].setup(opts)
      end

      -- Keymaps
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

  -- Treesitter (syntax highlighting and more)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "go",
        "python",
        "lua",
        "html",
        "css",
        "json",
        "bash",
        "markdown",
        "markdown_inline",
        -- Other
        "bash",
        "lua",
        "vim",
        "svelte",
        "graphql",
        "prisma",
        "yaml",
        "json",
        "dockerfile",
        "gitignore",
        "c",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
    config = function()
      -- Independent nvim-ts-autotag setup
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
        per_filetype = {
          ["html"] = {},
          ["typescriptreact"] = {
            enable_close = true, -- Explicitly enable auto-closing (optional, defaults to `true`)
          },
        },
      })
    end,
  },

  -- Formatter: Conform
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        go = { "gofmt" },
        python = { "black" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
  },
}
