--
-- constants
--
local fn, opt, api, cmd, g = vim.fn, vim.opt, vim.api, vim.cmd, vim.g


--
-- packer/plugins
--
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

opt.termguicolors = true

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

require('packer').startup({function(use)
  use 'wbthomason/packer.nvim'

  use 'forrestbaer/minimal_dark'

  use {
    'williamboman/nvim-lsp-installer',
    'neovim/nvim-lspconfig'
    }
  use 'nvim-lua/plenary.nvim'

  use {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {}
    end }

  use 'nvim-telescope/telescope.nvim'
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-telescope/telescope-file-browser.nvim'

  use 'kyazdani42/nvim-web-devicons'
  use 'davidgranstrom/scnvim'
  use 'davidgranstrom/scnvim-tmux'
  use 'akinsho/bufferline.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'tpope/vim-eunuch'
  use 'airblade/vim-gitgutter'
  use 'akinsho/toggleterm.nvim'
  use 'svermeulen/vim-easyclip'

  use 'vimwiki/vimwiki'
  use {
    'elihunter173/dirbuf.nvim',
    config = function()
      require('dirbuf').setup {
        sort_order = 'directories_first',
        -- file_handlers = {
        --   wav = "!afplay",
        -- },
      }
    end }

  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end})



--
-- helper functions & commands
--
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

local function nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        api.nvim_command('augroup '..group_name)
        api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
            api.nvim_command(command)
        end
        api.nvim_command('augroup END')
    end
end

api.nvim_create_user_command(
  'Columnize',
  '<line1>,<line2>!column -t',
  {range = '%'}
)



--
-- lsp
--
local lspconfig = require('lspconfig')
require('nvim-lsp-installer').setup({
    automatic_installation = true,
    ui = {
        icons = {
            server_installed = '✓',
            server_pending = '➜',
            server_uninstalled = '✗'
        }
    }
})

lspconfig.sumneko_lua.setup{
  settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
}

local servers = { 'html', 'tsserver', 'clangd', 'bashls' }
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


--
-- telescope stuff
--

local telescope = require('telescope')
local actions = require('telescope.actions')
local telescope_custom_actions = {}
local fb_actions = require('telescope').extensions.file_browser.actions

telescope.setup{
  defaults = {
    prompt_prefix = ' -> ',
    initial_mode = 'insert',
    selection_strategy = 'reset',
    sorting_strategy = 'descending',
    layout_strategy = 'vertical',
    color_devicons = true,
    file_ignore_patterns = {
      'node_modules',
      'vendor',
      '__tests__',
      '__snapshots__',
    },
    mappings = {
      i = {
        ['<esc>'] = actions.close,
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
    },
    extensions = {
      file_browser = {
        mappings = {
          i = {
            ['<esc>'] = actions.close,
            ['<tab>'] = actions.toggle_selection,
            ['<C-v>'] = telescope_custom_actions.multi_selection_open_vsplit,
            ['<C-s>'] = telescope_custom_actions.multi_selection_open_split,
            ['<C-t>'] = telescope_custom_actions.multi_selection_open_tab,
            ['<C-r>'] = fb_actions.rename,
          },
        },
      },
    },
  },
}

telescope.load_extension('fzf')
telescope.load_extension('file_browser')



--
-- other plugin initializations
--
require('nvim-web-devicons').setup{ default = true }

require('lualine').setup{
  options = {
    icons_enabled = true,
    fmt = string.lower,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {'toggleterm'},
    always_divide_middle = true,
    color = {
      fg = '#CCCCCC',
      bg = '#222222'
    }
  },
  sections = {
    lualine_a = {
      {'mode',
      separator = {right = ''},
      color = {fg = '#000000', bg = '#009933'}}
    },
    lualine_b = {{
      '%{expand("%:~:.")}',
        separator = {right = ''},
        color = {fg = '#999999'}},
      {'diff', colored = false},
      {'diagnostics',
        colored = false,
        padding = 2,
        sections = { 'error', 'warn', 'info' }}
    },
    lualine_c = {
      {'', separator = { right = ''}},
    },
    lualine_x = {
      {'encoding', separator = { left = ''}},
      {'filetype', colored = false, color = { bg = '#222222'}}
    },
    lualine_y = {
      {'progress', 'location', color = { fg = '#FFFFFF'}}
    },
    lualine_z = {{
      'location',
      separator = {left = '' },
      color = {fg = '#000000', bg = '#009933' }}
    }
  },
}



--
-- toggleterm
--
require('toggleterm').setup{
  size = 25,
  hide_numbers = true,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = true,
  shell = '/bin/zsh',
}
local Terminal  = require('toggleterm.terminal').Terminal
local gitui = Terminal:new({
  cmd = 'gitui',
  dir = '.',
  hidden = true,
  direction = 'float',
  close_on_exit = true,
  float_opts = { border = 'single' },
  on_open = function(term)
    vim.cmd('startinsert!')
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', ':close<cr>', {noremap = true, silent = true})
  end,
})
function GituiToggle()
  gitui:toggle()
end


--
-- vimwiki
--
vim.g.vimwiki_list = {{
  path = '~/store/wiki',
  syntax = 'markdown',
  ext = '.md'
}}


--
-- bufferline
--
require('bufferline').setup {
  highlights = {
    separator = { fg = '#AAAAAA', bg = '#222222' },
    separator_selected = { fg = '#FFFFFF' },
  },
  options = {
    numbers = "none",
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count)
      return "("..count..")"
    end,
    custom_filter = function(buf_number)
      if vim.bo[buf_number].filetype ~= "scnvim" then
        return true
      end
    end,
    color_icons = true,
    separator_style = {'..', '..'},
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    show_buffer_default_icon = true,
    show_close_icon = false,
    show_tab_indicators = true,
    always_show_bufferline = true,
  },
}


--
-- scnvim
--
local scnvim = require 'scnvim'
local m = scnvim.map
local map_expr = scnvim.map_expr
scnvim.setup {
  keymaps = {
    ['<leader>re'] = m('editor.send_line', {'i', 'n'}),
    ['<leader>ra'] = {
      m('editor.send_block', {'i', 'n'}),
      m('editor.send_selection', 'x'),
    },
    ['<CR>'] = m('postwin.toggle'),
    ['<M-CR>'] = m('postwin.toggle', 'i'),
    ['<M-L>'] = m('postwin.clear', {'n', 'i'}),
    ['<leader>ri'] = m('signature.show', {'n', 'i'}),
    ['<leader>rs'] = m('sclang.hard_stop', {'n', 'x', 'i'}),
    ['<leader>rt'] = m('sclang.start'),
    ['<leader>rk'] = m('sclang.recompile'),
    ['<leader>rb'] = map_expr('s.boot'),
    ['<leader>rm'] = map_expr('s.meter'),
  },
  editor = {
    highlight = {
      color = 'IncSearch',
    },
  },
  extensions = {
    tmux = {
    }
  }
  -- postwin = {
  --   float = {
  --     enabled = true,
  --   },
  -- },
}
scnvim.load_extension 'tmux'



--
-- visual setup
--
cmd 'colorscheme minimal_dark'

g.gitgutter_sign_added                    =  '+'
g.gitgutter_sign_modified                 =  '~'
g.gitgutter_sign_removed                  =  '-'
g.gitgutter_sign_removed_first_line       =  '^'
g.gitgutter_sign_removed_above_and_below  =  '{'
g.gitgutter_sign_modified_removed         =  '~-'
g.gitgutter_map_keys                      =  0

local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end



--
-- options
--
opt.guifont       =  'Iosevka Nerd Font:h18'
opt.fileencoding  =  'utf-8'
opt.backspace     =  'indent,eol,start'
opt.tabstop       =  2
opt.shiftwidth    =  2
opt.expandtab     =  true
opt.showmatch     =  true
opt.signcolumn    =  'yes'
opt.number        =  true
opt.numberwidth   =  5
opt.hidden        =  true
opt.mouse         =  'a'
opt.autoread      =  true
opt.pumheight     =  20
opt.ignorecase    =  true
opt.smartcase     =  true
opt.remap         =  true
opt.timeout       =  false
opt.guicursor     =  'i:ver20-blinkon100,n:blinkon100'
opt.linebreak     =  true
opt.scrolloff     =  4
opt.backup        =  false
opt.splitbelow    =  true
opt.grepprg       =  'rg'
opt.updatetime    =  150
opt.undofile      =  true
opt.undodir       =  '/tmp'
opt.helpheight    =  15
opt.completeopt   =  'menuone,noselect,noinsert'
opt.omnifunc      =  'syntaxcomplete#Complete'
opt.clipboard     =  'unnamed'



--
-- vim global opts
--
g.mapleader                         =  ','
g.maplocalleader                    =  ','
g.gitgutter_terminal_reports_focus  =  0
g.terminal_color_3                  =  '#ac882f'



--
-- key mappings
--

-- lsp
map('n', '<leader>i', require("goto-preview").goto_preview_definition)
map('n', 'gd', vim.lsp.buf.definition)
map('n', '<leader>d', vim.diagnostic.open_float)

-- git
map('n', '<leader>gb', ':G blame<cr>')
map('n', '<leader>ga', ':G add .<cr>')
map('n', '<leader>gc', ':G commit<cr>')
map('n', '<leader>gp', ':G push<cr>')

-- terminal
map('', '<C-w>', '<C-W>W')
map('t', '<C-z>', '<C-\\><C-n>')
map('n', '<C-z>', '<C-w>W')
map('i', '<C-z>', '<C-w>W')
map('', '<leader>t', ':ToggleTerm<cr>')
map('t', '<leader>t', '<cmd>ToggleTerm<cr>')
map('n', '<leader>G', GituiToggle)

-- telescope
map('', '<leader>ff', ':Telescope find_files<cr>')
map('', '<leader>fg', ':Telescope live_grep<cr>')
map('', '<leader>fb', ':Telescope buffers<cr>')
map('n', '<leader>ft', ':Telescope file_browser<cr>')
map('', '<leader>fm', ':Telescope man_pages<cr>')
map('', '<leader>fh', ':Telescope help_tags<cr>')

-- vim
map('', '<Space>', ':silent noh<Bar>echo<cr>')
map('n', 'U', '<C-r>')
map('n', '<leader>q', ':q!<cr>')
map('n', '<leader>s', ':w!<cr>')
map('n', '<leader>n', ':ene<cr>')
map('', '<leader>c', ':bd!<cr>')
map('', '<c-o>', ':BufferLineCycleNext<cr>')
map('', '<c-n>', ':BufferLineCyclePrev<cr>')
map('n', '<leader>ev', ':cd ~/.config/nvim | e init.lua<cr>')
map('n', '<leader>rv', ':so ~/.config/nvim/init.lua<cr>')

map('v', '<', '<gv')
map('v', '>', '>gv')

-- vimwiki
map('', '<leader>/', ':VimwikiToggleListItem<cr>')



--
-- autocmds
--
local autocmds = {
    comment_strings = {
      { 'FileType', 'scnvim', 'setlocal wrap' },
    },
    supercollider_indent = {
      { 'FileType', 'supercollider', 'setlocal tabstop=4 softtabstop=4 shiftwidth=4' },
    },
    packer = {
      { 'BufWritePost', '~/.config/nvim/init.lua', 'source ~/.config/nvim/init.lua | PackerCompile' },
   },
    highlight_yank = {
      { 'TextYankPost', '*', 'lua require("vim.highlight").on_yank{"Search", 2000}' },
    },
}
nvim_create_augroups(autocmds)
