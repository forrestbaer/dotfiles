-- lua print(vim.inspect(vim.lsp.buf_get_clients()[1].resolved_capabilities))

--
-- constants
--
local fn, opt, api, cmd, g = vim.fn, vim.opt, vim.api, vim.cmd, vim.g

--
-- packer/plugins
--
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
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

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

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
  use 'akinsho/bufferline.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'akinsho/toggleterm.nvim'
  use 'norcalli/nvim-colorizer.lua'
  use 'forrestbaer/minimal_dark'
  use 'MattesGroeger/vim-bookmarks'

  -- git
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'
  use {'akinsho/git-conflict.nvim', tag = "*", config = function()
    require('git-conflict').setup({
      default_mappings = false,
    })
  end}

  -- lsp/treesitter
  use "nvim-treesitter/nvim-treesitter"
  use {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  }
  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
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
opt.termguicolors  = true
opt.foldmethod     = 'expr'
opt.foldexpr       = 'nvim_treesitter#foldexpr()'
opt.foldnestmax    = 1
opt.foldminlines   = 2
opt.foldlevelstart = 99
opt.foldcolumn     = "auto:1"
vim.wo.fillchars   = "foldopen:,foldsep:│,foldclose:,fold: "
vim.wo.foldtext    = [[substitute(getline(v:foldstart),'\\t',repeat(' ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' [' . (v:foldend - v:foldstart + 1) . ' lines]']]
opt.guifont        = 'Iosevka Nerd Font:h18'
opt.fileencoding   = 'utf-8'
opt.backspace      = 'indent,eol,start'
opt.tabstop        = 2
opt.shiftwidth     = 2
opt.expandtab      = true
opt.showmatch      = true
opt.signcolumn     = 'yes'
opt.number         = true
opt.numberwidth    = 5
opt.hidden         = true
opt.mouse          = 'a'
opt.autoread       = true
opt.pumheight      = 20
opt.ignorecase     = true
opt.smartcase      = true
opt.remap          = true
opt.timeout        = false
opt.guicursor      = 'i:ver20-blinkon100,n:blinkon100'
opt.linebreak      = true
opt.scrolloff      = 4
opt.backup         = false
opt.splitbelow     = true
opt.grepprg        = 'rg'
opt.updatetime     = 150
opt.undofile       = true
opt.undodir        = '/tmp'
opt.helpheight     = 15
opt.completeopt    = 'menuone,noselect,noinsert'
opt.omnifunc       = 'syntaxcomplete#Complete'
opt.clipboard      = 'unnamed'

g.mapleader                        = ','
g.maplocalleader                   = ','
g.gitgutter_terminal_reports_focus = 0
g.terminal_color_3                 = '#ac882f'
g.bookmark_no_default_key_mappings = 1

--
-- Create a keymap with some sane defaults.
--
local map = function(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

api.nvim_create_user_command(
  'Columnize',
  '<line1>,<line2>!column -t',
  { range = '%' }
)

--
-- lsp
--
require("mason").setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'tsserver', 'html', 'bashls', 'eslint', 'clangd' }
})

local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup {
  settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
}

local servers = { 'html', 'tsserver', 'bashls', 'eslint', 'pylsp', 'jsonls'  }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {}
end

require("clangd_extensions").setup(
  {
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      '--query-driver="/usr/local/opt/arm-none-eabi-gcc/bin/arm-none-eabi-gcc"'
    },
    filetypes = {"c", "cpp", "objc", "objcpp"},
  })
-- require('lspconfig').clangd.setup {
--         cmd = {
--             "clangd",
--             "--background-index",
--             "--suggest-missing-includes",
--             '--query-driver="/usr/local/opt/gcc-arm-none-eabi/bin/arm-none-eabi-gcc"'
--         },
--         filetypes = {"c", "cpp", "objc", "objcpp"},
-- }

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
}
)

--
---- treesitter
--

local ok, _ = pcall(require, 'nvim-treesitter')
if not ok then
  cmd "lua TSUpdate"
end

require('nvim-treesitter').setup {}
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

api.nvim_set_hl(0, "punctuation.bracket", { link = "@Title" })
api.nvim_set_hl(0, "constructor", { link = "@Title" })
api.nvim_set_hl(0, "string", { link = "@Normal" })
api.nvim_set_hl(0, "keyword", { link = "@String" })

--
-- telescope stuff
--
local telescope = require('telescope')
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

--
-- devicons
--
require('nvim-web-devicons').setup { default = true }

--
-- lualine
--
require('lualine').setup {
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
    lualine_b = { {
      '%{expand("%:~:.")}',
      separator = { right = '' },
      color = { fg = '#999999' }
    },
      { 'diff', colored = false },
      { 'diagnostics',
        colored = false,
        padding = 2,
        sections = { 'error', 'warn', 'info' } }
    },
    lualine_c = {
      { '', separator = { right = '' } },
    },
    lualine_x = {
      { 'encoding', separator = { left = '' } },
      { 'filetype', colored = false, color = { bg = '#222222' } }
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

--
-- toggleterm
--
require('toggleterm').setup {
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

--
-- bufferline
--
require('bufferline').setup {
  highlights = {
    separator = { fg = '#000000', bg = '#111111' },
    separator_selected = { fg = '#DDDDDD', bg = '#111111' },
    fill = {
      fg = '#DDDDDD',
      bg = '#111111',
    },
    background = {
      fg = '#AAAAAA',
      bg = '#111111',
    },
  },
  options = {
    indicator = {
      style = 'underline',
    },
    numbers = "none",
    max_name_length = 15,
    max_prefix_length = 15,
    tab_size = 22,
    diagnostics = false,
    color_icons = false,
    separator_style = 'thick',
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    show_buffer_default_icon = true,
    show_close_icon = false,
    show_tab_indicators = false,
    always_show_bufferline = true,
  },
}

--
-- colorizer
--
require 'colorizer'.setup {
  '*';
  css = { rgb_fn = true; };
  html = { names = false; }
}

--
-- key mappings
--

-- lsp
map('n', '<leader>i', '<cmd>Lspsaga peek_definition<cr>')
map('n', '<leader>I', '<cmd>Lspsaga hover_doc<cr>')
map('n', '<leader>d', '<cmd>Lspsaga show_line_diagnostics<cr>')
map('n', 'K', '<cmd>Lspsaga hover_doc ++keep<cr>')

-- terminal
map('', '<C-w>', '<C-W>W')
map('t', '<C-z>', '<C-\\><C-n>')
map('n', '<C-z>', '<C-w>W')
map('i', '<C-z>', '<C-w>W')
map('', '<leader>t', ':ToggleTerm<cr>')
map('t', '<leader>t', '<cmd>ToggleTerm<cr>')
map('', '<leader>rl', '<cmd>ToggleTermSendCurrentLine<cr>')
map({'n', 'v'}, '<leader>rv', ":'<,'>ToggleTermSendVisualLines<cr>")
map({'n', 'v'}, '<leader>rs', "<cmd>ToggleTermSendVisualSelection<cr>")

-- telescope
map('', '<leader>ff', ':Telescope find_files<cr>')
map('', '<leader>fg', ':Telescope live_grep<cr>')
map('n', '<leader>ft', ':Telescope file_browser<cr>')
map('', '<leader>fm', ':Telescope man_pages<cr>')
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
map('', '<c-o>', ':BufferLineCycleNext<cr>')
map('', '<c-n>', ':BufferLineCyclePrev<cr>')
map('n', '<leader>ev', ':cd ~/.config/nvim | e init.lua<cr>')
map('n', '<leader>rv', ':so ~/.config/nvim/init.lua<cr>')

map('n', '<leader>h', ':DiffviewFileHistory<cr>')

map('v', '<', '<gv')
map('v', '>', '>gv')

--
-- autocmds
--
api.nvim_create_autocmd('TextYankPost', {
  command = 'silent! lua vim.highlight.on_yank()',
})

api.nvim_create_autocmd('FocusGained', {
  command = [[:checktime]]
})

api.nvim_create_autocmd('BufReadPre,FileReadPre', {
  pattern = { 'bash*' },
  command = [[set ft=bash]]
})

api.nvim_create_autocmd('BufEnter', {
  command = [[set formatoptions-=cro]]
})
