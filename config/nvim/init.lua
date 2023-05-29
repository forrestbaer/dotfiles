--
-- helper functions
--
local check_package = function(package)
  local status_ok, pkg = pcall(require, package)
  if not status_ok then
    return nil
  end
  return pkg
end

-- Create a keymap with some sane defaults.
local map = function(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Columnize content
vim.api.nvim_create_user_command(
  'Columnize',
  '<line1>,<line2>!column -t',
  { range = '%' }
)

--
-- packer/plugins
--
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
    use 'airblade/vim-gitgutter'
    use 'akinsho/toggleterm.nvim'
    use 'forrestbaer/minimal_dark'
    use 'MattesGroeger/vim-bookmarks'
    use 'MunifTanjim/nui.nvim'
    use 'norcalli/nvim-colorizer.lua'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-lualine/lualine.nvim'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use 'svermeulen/vim-easyclip'
    use 'wbthomason/packer.nvim'
    use 'nvim-tree/nvim-tree.lua'
    use 'windwp/nvim-ts-autotag'
    use {
      "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup {} end
    }
    use {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-emoji',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'dcampos/nvim-snippy',
      'dcampos/cmp-snippy'
    }
    use {
      'stevearc/oil.nvim',
      config = function() require('oil').setup{
        columns = {
          'icon', 'size', 'mtime',
        },
        view_options = {
          show_hidden = true,
        }
      }
      end
    }
    use 'nvim-treesitter/nvim-treesitter'
    use {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    }
    use {
      'glepnir/lspsaga.nvim',
      branch = 'main',
      config = function()
        require('lspsaga').setup {
          diagnostic = { show_code_action = false, },
          lightbulb = { enable = false },
          ui = { title = false }
        }
      end
    }
    use {
      'nvim-telescope/telescope.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      'nvim-telescope/telescope-file-browser.nvim'
    }

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
    print 'Installing packer close and reopen Neovim...'
    vim.cmd [[packadd packer.nvim]]
  end
end


--
-- initialize colorscheme
--
local ok, _ = pcall(vim.cmd, 'colorscheme minimal_dark')
if not ok then
  return
end


--
-- options
--
vim.opt.termguicolors  = true
vim.opt.guifont        = 'Iosevka Nerd Font:h18'
vim.opt.fileencoding   = 'utf-8'
vim.opt.backspace      = 'indent,eol,start'
vim.opt.tabstop        = 2
vim.opt.shiftwidth     = 2
vim.opt.expandtab      = true
vim.opt.showmatch      = true
vim.opt.signcolumn     = 'yes'
vim.opt.number         = true
vim.opt.numberwidth    = 3
vim.opt.hidden         = true
vim.opt.mouse          = 'a'
vim.opt.autoread       = true
vim.opt.pumheight      = 20
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.remap          = true
vim.opt.timeout        = false
vim.opt.guicursor      = 'i:ver20-blinkon100,n:blinkon100'
vim.opt.linebreak      = true
vim.opt.scrolloff      = 4
vim.opt.backup         = false
vim.opt.splitbelow     = true
vim.opt.grepprg        = 'rg'
vim.opt.updatetime     = 150
vim.opt.undofile       = true
vim.opt.undodir        = '/tmp'
vim.opt.helpheight     = 15
vim.opt.completeopt    = 'menuone,noselect,noinsert'
vim.opt.omnifunc       = 'syntaxcomplete#Complete'
vim.opt.clipboard      = 'unnamed'

vim.g.mapleader                        = ','
vim.g.maplocalleader                   = ','
vim.g.gitgutter_terminal_reports_focus = 0
vim.g.terminal_color_3                 = '#ac882f'
vim.g.bookmark_no_default_key_mappings = 1
vim.g.loaded_netrw                     = 1
vim.g.loaded_netrwPlugin               = 1


--
-- nvim-tree
--
local nvimtree = check_package('nvim-tree')
if (nvimtree) then
  nvimtree.setup{}
end

--
-- lsp / mason
--
local lsp_servers = {
  'lua_ls', 'tsserver', 'html', 'bashls', 'eslint', 'jsonls' }

local mason = check_package('mason')
if (mason) then
  require('mason').setup {}
  require('mason-lspconfig').setup {
    ensure_installed = lsp_servers
  }
end

local lspconfig = check_package('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local cmp = check_package('cmp')
if (cmp) then
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
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
      { name = 'nvim_lsp' },
      { name = 'snippy' },
      { name = 'buffer' },
      { name = 'emoji' },
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
        capabilities = capabilities
      }
    end
    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = {'vim'} },
          telemetry = { enable = false },
        }
      },
    }
  end
end


--
---- treesitter
--
local autotag = check_package('nvim-ts-autotag')
if (autotag) then autotag.setup {} end

local treesitter = check_package('nvim-treesitter')
if (treesitter) then
  treesitter.setup {}

  require('nvim-treesitter.configs').setup {
    ensure_installed = { 'regex', 'javascript', 'lua', 'typescript', 'html' },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      },
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
    },
    indent = {
      enable = true,
    },
  }
else
  vim.cmd('lua TSUpdate')
end


--
-- telescope stuff
--
local telescope = check_package('telescope')
if (telescope) then
  local actions = require('telescope.actions')
  telescope.load_extension('fzf')
  telescope.load_extension('file_browser')
  telescope.setup {
    defaults = {
      initial_mode = 'insert',
      selection_strategy = 'reset',
      sorting_strategy = 'descending',
      color_devicons = true,
      file_ignore_patterns = {
        'node_modules',
        'vendor',
        '__tests__',
        '__snapshots__',
      },
      layout_strategy = 'vertical',
      layout_config = {
        preview_height = 0.4,
        width = 0.8,
        height = 0.9,
      },
      mappings = {
        i = {
          ['<esc>'] = actions.close,
          ['<C-i>'] = actions.preview_scrolling_up,
          ['<C-e>'] = actions.preview_scrolling_down,
        },
      },
      pickers = {
        find_files = {
          follow = true,
          hidden = true,
        },
      },
      extensions = {
        file_browser = {
          mappings = {
            i = {
              ['<esc>'] = actions.close,
            },
          },
        },
      },
    },
  }
end


--
-- devicons
--
local devicons = check_package('nvim-web-devicons')
if (devicons) then
  devicons.setup { default = true }
end


--
-- lualine
--
local lualine = check_package('lualine')
if (lualine) then
  lualine.setup {
    options = {
      icons_enabled = true,
      fmt = string.lower,
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = { 'toggleterm' },
      always_divide_middle = true,
      color = {
        fg = '#CCCCCC',
        bg = '#222222'
      }
    },
    sections = {
      lualine_a = {
        { 'mode',
          separator = { right = '' },
          color = { fg = '#000000', bg = '#009933' } }
      },
      lualine_b = {
        {
          'filename',
          file_status = true,
          newfile_status = true,
          path = 1,
          shorting_target = 40,
          symbols = {
            modified = '[+]',
            readonly = '[-]',
            unnamed = '[No Name]',
            newfile = '[New]',
          },
          separator = { right = '' },
          color = { fg = '#999999' }
        },
        { 'diff', colored = false, separator = { right = '' }},
        { 'diagnostics',
          colored = true,
          padding = 2,
          separator = { right = '' },
          sections = { 'error', 'warn', 'info' } }
      },
      lualine_c = {
        { '', separator = { right = '' } },
      },
      lualine_x = {
        { 'encoding', separator = { left = '' } },
        { 'filetype', colored = true, color = { bg = '#222222' } }
      },
      lualine_y = {
        { 'progress', 'location', color = { fg = '#FFFFFF' } }
      },
      lualine_z = { {
        'location',
        separator = { left = '' },
        color = { fg = '#000000', bg = '#009933' }
      }
      }
    },
  }
end


--
-- toggleterm
--
local toggleterm = check_package('toggleterm')
if (toggleterm) then
  toggleterm.setup {
    size = 25,
    hide_numbers = true,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'horizontal',
    close_on_exit = true,
    shell = '/usr/local/bin/bash --login',
  }
end


--
-- colorizer
--
local colorizer = check_package('colorizer')
if (colorizer) then
  colorizer.setup {
    '*';
    css = { rgb_fn = true; };
    html = { names = false; }
  }
end


--
-- key mappings
--

-- lsp
map('', 'K', ':Lspsaga hover_doc ++quiet<cr>')
map('', '<leader>i', ':Lspsaga peek_definition<cr>')
map('', '<leader>lr', ':Lspsaga lsp_finder<cr>')
map('', '<leader>lo', ':Lspsaga outline<cr>')
map('', '<leader>gd', ':Lspsaga lsp_finder<cr>')
map('', '<leader>d', ':Lspsaga show_line_diagnostics<cr>')

-- terminal
map('', '<C-w>', '<C-W>W')
map('t', '<C-z>', '<C-\\><C-n>')
map('n', '<C-z>', '<C-w>W')
map('i', '<C-z>', '<C-w>W')
map('', '<leader>t', ':ToggleTerm<cr>')
map('t', '<leader>t', '<cmd>ToggleTerm<cr>')
map('', '<leader>rl', '<cmd>ToggleTermSendCurrentLine<cr>')
map({'n', 'v'}, '<leader>rv', ":'<,'>ToggleTermSendVisualLines<cr>")
map({'n', 'v'}, '<leader>rs', '<cmd>ToggleTermSendVisualSelection<cr>')

-- telescope
map('', '<leader>ff', ':Telescope find_files<cr>')
map('', '<leader>fg', ':Telescope live_grep<cr>')
map('', '<leader>ft', ':NvimTreeToggle<cr>')
map('', '<leader>fb', ':Telescope buffers<cr>')
map('', '<leader>fh', ':Telescope help_tags<cr>')
map('', '<leader>fd', ':Telescope diagnostics<cr>')

-- bookmarks
map('', '<leader>ma', ':BookmarkShowAll<cr>')
map('', '<leader>mm', ':BookmarkToggle<cr>')
map('', '<leader>mi', ':BookmarkAnnotate<cr>')
map('', '<leader>mn', ':BookmarkNext<cr>')
map('', '<leader>mp', ':BookmarkPrev<cr>')
map('', '<leader>mc', ':BookmarkClear<cr>')
map('', '<leader>mx', ':BookmarkClearAll<cr>')

-- git
map('n', '<leader>gxo', ':<plug>git-conflict-ours<cr>')
map('n', '<leader>gxt', ':<plug>git-conflict-theirs<cr>')
map('n', '<leader>gxb', ':<plug>git-conflict-both<cr>')
map('n', '<leader>gxn', ':<plug>git-conflict-next-conflict<cr>')
map('n', '<leader>gxp', ':<plug>git-conflict-prev-conflict<cr>')
map('n', '<leader>gg', ':Git<cr>')
map('n', '<leader>gl', ':Git log --<cr>')
map('n', '<leader>gB', ':Git blame<cr>')
map('n', '<leader>gb', ':Telescope git_branches<cr>')
map('n', '<leader>gP', ':Git push<cr>')
map('n', '<leader>gp', ':Git pull<cr>')
map('n', '<leader>gs', ':Git status<cr>')
map('n', '<leader>gc', ':Git commit<cr>')

-- vim
map('', '<Space>', ':silent noh<Bar>echo<cr>')
map('n', 'U', '<C-r>')
map('n', '<leader>q', ':q!<cr>')
map('n', '<leader>s', ':w!<cr>')
map('n', '<leader>n', ':ene<cr>')
map('n', '<leader>x', ':bd<cr>')
map('', '<c-o>', ':<cr>')
map('', '<c-n>', ':<cr>')
map('n', '<leader>ev', ':cd ~/code/dotfiles/config/nvim | e init.lua<cr>')
map('n', '<leader>rv', ':so ~/code/dotfiles/config/nvim/init.lua<cr>')

map('v', '<', '<gv')
map('v', '>', '>gv')


--
-- autocmds
--
vim.api.nvim_create_autocmd('TextYankPost', {
  command = 'silent! lua vim.highlight.on_yank()',
})

vim.api.nvim_create_autocmd('FocusGained', {
  command = [[:checktime]]
})

vim.api.nvim_create_autocmd('BufReadPre,FileReadPre', {
  pattern = { 'bash*' },
  command = [[set ft=bash]]
})

vim.api.nvim_create_autocmd('BufEnter', {
  command = [[set formatoptions-=cro]]
})

vim.api.nvim_create_autocmd('BufEnter', {
  command = [[silent! lcd %:p:h]]
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown", command = "set awa"
})
