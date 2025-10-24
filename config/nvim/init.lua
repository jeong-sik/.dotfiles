-- ============================================================================
-- Neovim Configuration (Modern Lua with Lazy.nvim)
-- ============================================================================
-- Quick Reference:
--   Leader: <Space>
--   Git UI: <Space>gg (LazyGit), ]c/[c (hunks)
--   Files: <Ctrl-p> or <Space>ff (Telescope)
--   LSP: gd (definition), K (hover), <leader>vrn (rename)
--   Windows: <Ctrl-h/j/k/l>
--   IME: ESC (auto-switch to English)
--
-- Full keybindings: See ~/.dotfiles/README.md
-- ============================================================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Suppress deprecation warnings
vim.g.deprecation_warnings = false

-- Filter out specific deprecation warnings
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("tsserver.*deprecated") or msg:match("lspconfig.*deprecated") then
    return
  end
  notify(msg, ...)
end
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- Plugin setup
require("lazy").setup({
  -- Color scheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd[[colorscheme tokyonight-storm]]
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = { theme = 'tokyonight' }
      })
    end,
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "javascript", "typescript", "python", "rust", "go", "html", "css", "json", "yaml", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Telescope for fuzzy finding
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "dist/",
            "build/",
            "target/",
            "vendor/",
            "%.lock",
            "__pycache__",
            "%.pyc",
          },
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,  -- Show hidden files
          },
        },
      })
    end,
  },

  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'onsails/lspkind.nvim',
    },
    config = function()
      -- Mason setup (LSP installer)
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "vtsls",
          "html",
          "cssls",
          "jsonls",
          "yamlls",
          "pyright",
          "rust_analyzer",
          "gopls",
        },
        automatic_installation = true,
      })

      -- Completion setup
      local cmp = require('cmp')
      local lspkind = require('lspkind')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
          })
        },
      })

      -- LSP servers setup
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Setup LSP keymaps
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
      end

      -- Configure each LSP server
      local servers = {
        'lua_ls', 'vtsls', 'html', 'cssls', 'jsonls',
        'yamlls', 'pyright', 'rust_analyzer', 'gopls'
      }

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      -- Special config for lua_ls
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
      })
    end,
  },

  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },

  -- Comment toggling
  {
    'numToStr/Comment.nvim',
    config = true
  },

  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 300,
          ignore_whitespace = false,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true, desc = "Next hunk"})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true, desc = "Previous hunk"})

          -- Actions
          map('n', '<leader>hs', gs.stage_hunk, {desc = "Stage hunk"})
          map('n', '<leader>hr', gs.reset_hunk, {desc = "Reset hunk"})
          map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = "Stage hunk"})
          map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = "Reset hunk"})
          map('n', '<leader>hS', gs.stage_buffer, {desc = "Stage buffer"})
          map('n', '<leader>hu', gs.undo_stage_hunk, {desc = "Undo stage hunk"})
          map('n', '<leader>hR', gs.reset_buffer, {desc = "Reset buffer"})
          map('n', '<leader>hp', gs.preview_hunk, {desc = "Preview hunk"})
          map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc = "Blame line"})
          map('n', '<leader>tb', gs.toggle_current_line_blame, {desc = "Toggle blame"})
          map('n', '<leader>hd', gs.diffthis, {desc = "Diff this"})
          map('n', '<leader>hD', function() gs.diffthis('~') end, {desc = "Diff this ~"})
          map('n', '<leader>td', gs.toggle_deleted, {desc = "Toggle deleted"})

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc = "Select hunk"})
        end
      })
    end,
  },

  -- Which-key for keybinding help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },

  -- Terminal toggle
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
      })
    end,
  },

  -- Project management
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git", "package.json", "Cargo.toml", "go.mod" },
      })
    end,
  },

  -- File bookmarks
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup()
    end,
  },

  -- TODO comments highlight
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- Color highlighter
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup()
    end,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
  },

  -- Claude Code integration
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("claude-code").setup()
    end,
  },
})

-- Keymaps
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "File Explorer" })
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

-- Telescope keymaps
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { desc = "Find Files" })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = "Live Grep" })
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { desc = "Buffers" })
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', { desc = "Help Tags" })
vim.keymap.set('n', '<leader>fo', ':Telescope oldfiles<CR>', { desc = "Recent Files" })
vim.keymap.set('n', '<leader>fc', ':Telescope commands<CR>', { desc = "Commands" })
vim.keymap.set('n', '<leader>fs', ':Telescope git_status<CR>', { desc = "Git Status" })
vim.keymap.set('n', '<leader>fd', ':Telescope diagnostics<CR>', { desc = "Diagnostics" })

-- LazyGit keymaps
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = "LazyGit" })
vim.keymap.set('n', '<leader>gl', ':LazyGitCurrentFile<CR>', { desc = "LazyGit Current File" })
vim.keymap.set('n', '<leader>gc', ':LazyGitFilterCurrentFile<CR>', { desc = "LazyGit Commits (Current File)" })

-- Harpoon keymaps
vim.keymap.set('n', '<leader>a', function() require("harpoon.mark").add_file() end, { desc = "Harpoon Add" })
vim.keymap.set('n', '<C-e>', function() require("harpoon.ui").toggle_quick_menu() end, { desc = "Harpoon Menu" })
vim.keymap.set('n', '<leader>1', function() require("harpoon.ui").nav_file(1) end, { desc = "Harpoon 1" })
vim.keymap.set('n', '<leader>2', function() require("harpoon.ui").nav_file(2) end, { desc = "Harpoon 2" })
vim.keymap.set('n', '<leader>3', function() require("harpoon.ui").nav_file(3) end, { desc = "Harpoon 3" })
vim.keymap.set('n', '<leader>4', function() require("harpoon.ui").nav_file(4) end, { desc = "Harpoon 4" })

-- TODO comments keymaps
vim.keymap.set('n', ']t', function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
vim.keymap.set('n', '[t', function() require("todo-comments").jump_prev() end, { desc = "Previous TODO" })
vim.keymap.set('n', '<leader>ft', ':TodoTelescope<CR>', { desc = "Find TODOs" })

-- Markdown preview
vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>', { desc = "Markdown Preview" })
vim.keymap.set('n', '<leader>ms', ':MarkdownPreviewStop<CR>', { desc = "Stop Preview" })

-- Ctrl+P for file finding (like old CtrlP/FZF)
vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>', { desc = "Find Files (Ctrl+P)" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Move text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- IME auto-switch (macOS)
-- Save current input source on InsertEnter and restore English on InsertLeave
local saved_input_source = nil

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    -- Save current input source when entering insert mode
    saved_input_source = vim.fn.system("macism"):gsub("%s+", "")
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    -- Switch to English when leaving insert mode
    vim.fn.system("macism com.apple.keylayout.ABC")
  end,
})

-- Also switch to English when entering command mode
vim.keymap.set("i", "<Esc>", "<Esc>:silent !macism com.apple.keylayout.ABC<CR>", { silent = true })
vim.keymap.set("i", "<C-c>", "<C-c>:silent !macism com.apple.keylayout.ABC<CR>", { silent = true })

print("Neovim LSP configuration loaded! Run :Mason to manage LSP servers.")