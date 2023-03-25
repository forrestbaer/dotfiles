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
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'tpope/vim-commentary'
    use 'svermeulen/vim-easyclip'
    use 'kyazdani42/nvim-web-devicons'
    use 'nvim-lualine/lualine.nvim'
    use 'akinsho/toggleterm.nvim'
    use 'norcalli/nvim-colorizer.lua'
    use 'forrestbaer/minimal_dark'
    use 'MattesGroeger/vim-bookmarks'
    use 'MunifTanjim/nui.nvim'
    use 'dpayne/CodeGPT.nvim'

    -- git
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'
    use {'akinsho/git-conflict.nvim', tag = '*', config = function()
      require('git-conflict').setup({
        default_mappings = false,
      })
    end}

    -- lsp/treesitter
    use 'nvim-treesitter/nvim-treesitter'
    use {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    }
    use({
      'glepnir/lspsaga.nvim',
      branch = 'main',
      config = function()
        require('lspsaga').setup({})
      end,
    })

    -- telescope
    use {
      'nvim-telescope/telescope.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      'nvim-telescope/telescope-file-browser.nvim'
    }

    use 'p00f/clangd_extensions.nvim'

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


--
-- lsp / mason
--
local mason = check_package('mason')
if (mason) then
  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'tsserver', 'html', 'bashls', 'eslint', 'clangd' }
  })
end


--
-- lspconfig
--
local lspconfig = check_package('lspconfig')
if (lspconfig) then
  -- gets rid of some stupid errors
  lspconfig.lua_ls.setup {
    settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
  }

  local servers = { 'html', 'tsserver', 'bashls', 'eslint', 'pylsp', 'jsonls'  }
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {}
  end

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = true,
      signs = true,
      update_in_insert = false,
      severity_sort = true,
    }
  )
end


--
---- treesitter
--
local treesitter = check_package('nvim-treesitter')
if (treesitter) then
  treesitter.setup {}

  require('nvim-treesitter.configs').setup {
    autotag = {
      enable = true
    },
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
  local Terminal = require('toggleterm.terminal').Terminal
  local gitui = Terminal:new({
    cmd = 'gitui',
    dir = '.',
    hidden = true,
    direction = 'float',
    close_on_exit = true,
    float_opts = { border = 'single' },
    on_open = function(term)
      vim.cmd('startinsert!')
      vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', ':close<cr>', { noremap = true, silent = true })
    end,
  })
  function GituiToggle()
    gitui:toggle()
  end
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
-- chatgpt
--
-- local codegpt = check_package('codegpt.config')
require("codegpt.config")
-- Open API key and api endpoint
vim.g["codegpt_openai_api_key"] = os.getenv("OPENAI_API_KEY")
vim.g["codegpt_chat_completions_url"] = "https://api.openai.com/v1/chat/completions"
vim.g["codegpt_openai_api_provider"] = "OpenAI" -- or Azure

-- clears visual selection after completion
vim.g["codegpt_clear_visual_selection"] = true


--
-- key mappings
--

-- lsp
map('n', '<leader>i', '<cmd>Lspsaga peek_definition<cr>')
map('n', '<leader>I', '<cmd>Lspsaga hover_doc<cr>')
map('n', '<leader>d', '<cmd>Lspsaga show_line_diagnostics<cr>')

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
map('', '<leader>ft', ':Telescope file_browser<cr>')
map('', '<leader>fb', ':Telescope buffers<cr>')
map('', '<leader>fh', ':Telescope help_tags<cr>')

-- bookmarks
map('', '<leader>ma', ':BookmarkShowAll<cr>')
map('', '<leader>mm', ':BookmarkToggle<cr>')
map('', '<leader>mi', ':BookmarkAnnotate<cr>')
map('', '<leader>mn', ':BookmarkNext<cr>')
map('', '<leader>mp', ':BookmarkPrev<cr>')
map('', '<leader>mc', ':BookmarkClear<cr>')
map('', '<leader>mx', ':BookmarkClearAll<cr>')

-- git
map('n', '<leader>gco', ':<plug>git-conflict-ours<cr>')
map('n', '<leader>gct', ':<plug>git-conflict-theirs<cr>')
map('n', '<leader>gcb', ':<plug>git-conflict-both<cr>')
map('n', '<leader>gcn', ':<plug>git-conflict-next-conflict<cr>')
map('n', '<leader>gcp', ':<plug>git-conflict-prev-conflict<cr>')
map('n', '<leader>gg', ':lua GituiToggle()<cr>')
map('n', '<leader>gl', ':Git log --<cr>')
map('n', '<leader>gb', ':Git blame<cr>')
map('n', '<leader>gd', ':Gvdiffsplit<cr>')

-- vim
map('', '<Space>', ':silent noh<Bar>echo<cr>')
map('n', 'U', '<C-r>')
map('n', '<leader>q', ':q!<cr>')
map('n', '<leader>s', ':w!<cr>')
map('n', '<leader>n', ':ene<cr>')
map('n', '<leader>x', ':bd!<cr>')
map('', '<c-o>', ':<cr>')
map('', '<c-n>', ':<cr>')
map('n', '<leader>ev', ':cd ~/code/dotfiles/config/nvim | e init.lua<cr>')
map('n', '<leader>rv', ':so ~/code/dotfiles/config/nvim/init.lua<cr>')

map('n', '<leader>h', ':DiffviewFileHistory<cr>')

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
