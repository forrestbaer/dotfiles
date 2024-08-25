local map = function(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

vim.api.nvim_create_user_command(
  "Columnize",
  "<line1>,<line2>!column -t",
  { range = "%" }
)

local check_package = function(package)
  local status_ok, pkg = pcall(require, package)
  if not status_ok then
    return nil
  end
  return pkg
end

local packer = check_package('packer')
if (packer) then
  packer.init {
    display = {
      open_fn = function()
        return require('packer.util').float { border = 'rounded' }
      end,
    },
  }

  require('packer').startup({ function(use)
    use {
      'junegunn/fzf.vim',
      cmd = { 'fzf#install()' }
    }
    use 'wbthomason/packer.nvim'
    use 'forrestbaer/minimal_dark'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
        })
      end,
    }
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-commentary'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-lualine/lualine.nvim'
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'eraserhd/parinfer-rust'
    use 'norcalli/nvim-colorizer.lua'
    use 'airblade/vim-gitgutter'
    use {
      "zbirenbaum/copilot-cmp",
      after = { "copilot.lua" },
      config = function ()
        require("copilot_cmp").setup()
      end
    }
    use {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-emoji',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'dcampos/nvim-snippy',
      'dcampos/cmp-snippy'
    }
    use {
      "stevearc/oil.nvim",
      config = function()
        require("oil").setup()
      end,
    }
    use {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      }
    }
    use 'nvim-telescope/telescope.nvim'
    if PACKER_BOOTSTRAP then
      require('packer').sync()
    end
  end })
else
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system {
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    }
    print 'Packer added close and reopen Neovim... run PackerSync'
    vim.cmd [[packadd packer.nvim]]
  end
end

local oil = check_package('oil')
if oil then
  oil.setup()
end

local ok, _ = pcall(vim.cmd, 'colorscheme minimal_dark')
if not ok then
  return
end

vim.opt.guifont        = "Iosevka Nerd Font:h16"
vim.opt.termguicolors  = true
vim.opt.fileencoding   = "utf-8"
vim.opt.backspace      = "indent,eol,start"
vim.opt.tabstop        = 2
vim.opt.shiftwidth     = 2
vim.opt.expandtab      = true
vim.opt.showmatch      = true
vim.opt.signcolumn     = "yes"
vim.opt.number         = true
vim.opt.numberwidth    = 3
vim.opt.hidden         = true
vim.opt.autoread       = true
vim.opt.pumheight      = 20
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.remap          = true
vim.opt.wrap           = false
vim.opt.timeout        = false
vim.opt.guicursor      = "i:ver20-blinkon100,n:blinkon100"
vim.opt.linebreak      = true
vim.opt.scrolloff      = 4
vim.opt.backup         = false
vim.opt.splitbelow     = true
vim.opt.grepprg        = "rg"
vim.opt.updatetime     = 150
vim.opt.undofile       = true
vim.opt.undodir        = "/tmp"
vim.opt.undolevels     = 2000
vim.opt.helpheight     = 15
vim.opt.completeopt    = "menuone,noselect,noinsert"
vim.opt.omnifunc       = "syntaxcomplete#Complete"

vim.g.mapleader          = ","
vim.g.maplocalleader     = ","
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.clipboard      =  "unnamedplus"

local lsp_servers = { "lua_ls", "tsserver", "html", "bashls", "eslint", "jsonls", "emmet_ls" }

local mason = check_package("mason")
if (mason) then
  mason.setup {}
  require("mason-lspconfig").setup {
    ensure_installed = lsp_servers
  }
end

local lspconfig = check_package("lspconfig")
local cmp = check_package('cmp')
if (cmp) then
   local capabilities = require('cmp_nvim_lsp').default_capabilities()

   cmp.setup({
    snippet = {
      expand = function(args)
        require('snippy').expand_snippet(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    sources = {
      { name = 'copilot' },
      { name = 'nvim_lsp' },
      { name = 'snippy' },
      -- { name = 'buffer' },
      { name = 'emoji' },
      { name = 'nvim_lua' },
      { name = 'nvim_lsp_signature_help' }
    }
  })

  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' },
    }, {
      { name = 'buffer' },
    })
  })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  if (lspconfig) then
    for _, lsp in ipairs(lsp_servers) do
      lspconfig[lsp].setup {
        capabilities = capabilities,
      }
    end

    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = {"vim"} },
          telemetry = { enable = false },
        }
      },
    }
  end
end

local colorizer = check_package("colorizer")
if (colorizer) then
  colorizer.setup {
    "css",
    "javascript",
    "typescript",
    "html",
    "vim",
    "lua",
  }
end

local treesitter = check_package("nvim-treesitter")
if (treesitter) then
  treesitter.setup {}

  require("nvim-treesitter.configs").setup {
    ensure_installed = { "vim", "c", "regex", "javascript", "lua", "typescript", "html", "vimdoc" },
    highlight = { enable = true, },
    indent = { enable = true, },
  }
else
  vim.cmd("lua TSUpdate")
end

local telescope = check_package("telescope")
if (telescope) then
  local actions = require("telescope.actions")
  telescope.setup {
    defaults = {
      initial_mode = "insert",
      selection_strategy = "reset",
      wrap_results = true,
      sorting_strategy = "ascending",
      file_ignore_patterns = {
        "node_modules",
        "vendor",
        "__tests__",
        "__snapshots__",
        "ttf",
        "otf",
        "png",
      },
      layout_strategy = "horizontal",
      layout_config = {
        preview_width = 80,
        width = 0.9,
        height = 0.9,
      },
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-i>"] = actions.preview_scrolling_up,
          ["<C-e>"] = actions.preview_scrolling_down,
        },
      },
      pickers = {
        find_files = {
          follow = true,
          hidden = true,
        },
      },
    },
  }
end

local lualine = check_package("lualine")
if (lualine) then
  lualine.setup {
    options = {
      icons_enabled = true,
      fmt = string.lower,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      always_divide_middle = true,
      color = {
        fg = "#CCCCCC",
        bg = "#222222"
      }
    },
    sections = {
      lualine_a = {
        { "mode",
          color = function (section)
            local mode = vim.api.nvim_get_mode().mode
            local fgc = "#000000"

            if (mode == "n") then
              if (vim.bo.modified) then
                return { fg = "#CCC", bg = "#880033" }
              else
                return { fg = fgc, bg = "#00AF87" }
              end
            elseif (mode == "v") then
              return { fg = fgc, bg = "#EEEEEE" }
            elseif (mode == "i") then
              return { fg = fgc, bg = "#A0A0A0" }
            end

          end}
      },
      lualine_b = {
        {
          "filename",
          file_status = true,
          newfile_status = true,
          path = 4,
          shorting_target = 40,
          symbols = {
            modified = "*",
            readonly = "-",
            unnamed = "[No Name]",
            newfile = "[New]",
          },
          color = { fg = "#999999" }
        },
        { "diff", colored = false},
        { "branch" },
        { "fugitive" },
      },
      lualine_c = {
        { "diagnostics",
          sources = { "nvim_diagnostic", "nvim_lsp" },
          colored = true,
          padding = 1,
          sections = { "error", "warn", "info" },
          color = { fg = "#CCCCCC", bg = "#000" }
        },
      },
      lualine_x = {
        { "encoding"},
        { "filetype", colored = true, color = { bg = "#222222" } }
      },
      lualine_y = {
        { "progress", "location", color = { fg = "#FFFFFF" } }
      },
      lualine_z = { {
        "location",
        color = { fg = "#000000", bg = "#009933" }
      }
      }
    },
  }
end

map("", "<leader>D", ":put =strftime('### %A %Y-%m-%d %H:%M:%S')<CR>")

-- lsp
map("", "<leader>i", ":lua vim.lsp.buf.hover()<cr>")
map("", "<leader>I", ":lua vim.lsp.buf.type_definition()<cr>")
map("", "<leader>d", ":lua vim.lsp.buf.definition()<cr>")
map("", "<leader>D", ":lua vim.lsp.buf.declaration()<cr>")
map("", "<leader>x", ":lua vim.diagnostic.open_float()<cr>")
map("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>")
map("n", "<leader>r", ":lua vim.lsp.buf.rename()<cr>")

-- telescope
map("", "<leader>ff", ":Telescope find_files<cr>")
map("", "<leader>fg", ":Telescope live_grep<cr>")
map("", "<leader>ft", ":Neotree toggle bottom<cr>")
map("", "<leader>fb", ":Telescope buffers<cr>")
map("", "<leader>fh", ":Telescope help_tags<cr>")
map("", "<leader>fd", ":Telescope diagnostics<cr>")

-- git
map("", "<leader>gs", ":Git<cr>")
map("", "<leader>gc", ":Git commit<cr>")
map("", "<leader>gp", ":Git push<cr>")
map("", "<leader>gP", ":Git pull<cr>")
map("", "<leader>gF", ":Git fetch<cr>")
map("", "<leader>gb", ":Git blame<cr>")

map("", "<Space>", ":silent noh<Bar>echo<cr>")
map("n", "U", "<C-r>")
map("n", "<leader>q", ":q!<cr>")
map("n", "<leader>s", ":w!<cr>")
map("n", "<leader>n", ":ene<cr>")
map("n", "<leader>x", ":bd<cr>")

map("v", "<", "<gv")
map("v", ">", ">gv")

map("", "<C-w>", "<C-W>W")
map("t", "<C-z>", "<C-\\><C-n>")
map("n", "<C-z>", "<C-w>W")
map("i", "<C-z>", "<C-w>W")

map("", "<leader>rv", ":source ~/.config/nvim/init.lua<cr>")
map("", "<leader>ev", ":e ~/.config/nvim/init.lua<cr>")

vim.api.nvim_create_autocmd("TextYankPost", {
  command = "silent! lua vim.highlight.on_yank()",
})

vim.api.nvim_create_autocmd("FocusGained", {
  command = [[:checktime]]
})

vim.api.nvim_create_autocmd("BufEnter", {
  command = [[set formatoptions-=cro]]
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown", command = "set awa"
})
