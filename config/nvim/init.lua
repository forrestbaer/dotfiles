--
-- constants
--
local fn, opt, api, cmd, g = vim.fn, vim.opt, vim.api, vim.cmd, vim.g

--
-- plugins
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

  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'windwp/nvim-autopairs'
  use 'nvim-lua/plenary.nvim'
  use {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {}
    end
  }

  use 'nvim-telescope/telescope.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
  use 'nvim-telescope/telescope-file-browser.nvim'

  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'airblade/vim-gitgutter'
  use 'akinsho/toggleterm.nvim'

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'saadparwaiz1/cmp_luasnip'
  use 'hrsh7th/cmp-nvim-lsp'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  use 'nvim-treesitter/playground'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'

  use 'junegunn/goyo.vim'
  use 'vimwiki/vimwiki'

  use {
    'norcalli/nvim-colorizer.lua',
    ft = { 'scss', 'css', 'javascript', 'vim', 'html', 'typescript' },
    config = [[require('colorizer').setup {'scss', 'css', 'javascript', 'vim', 'html', 'typescript'}]],
  }

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
  api.nvim_set_keymap(mode, lhs, rhs, options)
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

local servers = { 'html', 'tsserver', 'gopls'}
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
local action_state = require('telescope.actions.state')
local telescope_custom_actions = {}
local fb_actions = require('telescope').extensions.file_browser.actions

local function multiopen(prompt_bufnr, open_cmd)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local num_selections = #picker:get_multi_selection()
  if not num_selections or num_selections <= 1 then
    actions.add_selection(prompt_bufnr)
  end
  actions.send_selected_to_qflist(prompt_bufnr)

  local results = vim.fn.getqflist()

  for _, result in ipairs(results) do
    local current_file = vim.fn.bufname()
    local next_file = vim.fn.bufname(result.bufnr)

    if current_file == '' then
      vim.api.nvim_command('edit' .. ' ' .. next_file)
    else
      vim.api.nvim_command(open_cmd .. ' ' .. next_file)
    end
  end

  vim.api.nvim_command('cd .')
end
function telescope_custom_actions.multi_selection_open_vsplit(prompt_bufnr)
    multiopen(prompt_bufnr, 'vsplit')
end
function telescope_custom_actions.multi_selection_open_split(prompt_bufnr)
    multiopen(prompt_bufnr, 'split')
end
function telescope_custom_actions.multi_selection_open_tab(prompt_bufnr)
    multiopen(prompt_bufnr, 'tabe')
end

telescope.setup{
  defaults = {
    prompt_prefix = ' $ ',
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
        ['<tab>'] = actions.toggle_selection,
        ['<C-v>'] = telescope_custom_actions.multi_selection_open_vsplit,
        ['<C-s>'] = telescope_custom_actions.multi_selection_open_split,
        ['<C-t>'] = telescope_custom_actions.multi_selection_open_tab,
        ['<C-r>'] = fb_actions.rename,
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

local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, 'luasnip')
if not snip_status_ok then
  return
end

require('luasnip/loaders/from_vscode').lazy_load()

local check_backspace = function()
  local col = vim.fn.col '.' - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s'
end

--   פּ ﯟ  
local kind_icons = {
  Text           =  '',
  Method         =  'm',
  Function       =  '',
  Constructor    =  '',
  Field          =  '',
  Variable       =  '',
  Class          =  '',
  Interface      =  '',
  Module         =  '',
  Property       =  '',
  Unit           =  '',
  Value          =  '',
  Enum           =  '',
  Keyword        =  '',
  Snippet        =  '',
  Color          =  '',
  File           =  '',
  Reference      =  '',
  Folder         =  '',
  EnumMember     =  '',
  Constant       =  '',
  Struct         =  '',
  Event          =  '',
  Operator       =  '',
  TypeParameter  =  '',
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(),
		['<Down>'] = cmp.mapping.select_next_item(),
    ['<C-i>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-q>'] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ['<CR>'] = cmp.mapping.confirm { select = true },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        luasnip = '[Snippet]',
        buffer = '[Buffer]',
        path = '[Path]',
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    bordered = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  },
  experimental = {
    ghost_text = false,
    native_menu = false,
  },
}

--
-- treesitter
--

require('nvim-treesitter').setup {}
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'regex', 'fennel', 'c', 'javascript', 'lua', 'typescript', 'go', 'html', 'python' },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  autopairs = {
    enable = true
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

require('nvim-treesitter.highlight').set_custom_captures {
  ['punctuation.bracket'] = 'Title',
  ['constructor'] = 'Title',
  ['string'] = 'Normal',
  ['keyword'] = 'String',
}


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
  tabline = {
    lualine_a = {{
      'buffers',
      mode = 0,
      separator = { right = '' },
      buffers_color = {
        active = { fg = '#000000', bg = '#DDDDDD'},
        inactive = { fg = '#DDDDDD', bg = '#000000'}
      },
    }},
    lualine_z = {{
      'branch',
      separator = {left = '' },
      color = {fg = '#000000', bg = '#009933' }
    }}
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
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
  end,
})
function GituiToggle()
  gitui:toggle()
end


--
-- vimwiki
--
--
vim.g.vimwiki_list = {{
  path = '~/store/wiki',
  syntax = 'markdown',
  ext = '.md'
}}

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
opt.undodir       =  '/Users/forrestbaer/tmp'
opt.helpheight    =  15
opt.completeopt   =  'menuone,noselect,noinsert'
opt.omnifunc      =  'syntaxcomplete#Complete'
opt.clipboard     =  'unnamedplus'


--
-- vim global opts
--
g.mapleader                         =  ','
g.maplocalleader                    =  ','
g.gitgutter_terminal_reports_focus  =  0
g.terminal_color_3                  =  '#ac882f'
g.tidal_target                      =  'terminal'


--
-- key mappings
--

-- lsp
map('n', 'K', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
map('n', '<leader>i', '<Cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<leader>I', '<Cmd>TSHighlightCapturesUnderCursor<CR>')
map('n', 'gD', '<Cmd>lua vim.lsp.buf.definition()<CR>')
map('n', 'gd', '<cmd>lua require("goto-preview").goto_preview_definition()<CR>')
map('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>')

-- git
map('n', '<leader>gb', '<cmd>G blame<CR>')
map('n', '<leader>ga', '<cmd>G add .<CR>')
map('n', '<leader>gc', '<cmd>G commit<CR>')
map('n', '<leader>gp', '<cmd>G push<CR>')

-- terminal
map('', '<C-w>', '<C-W>W')
map('t', '<C-z>', '<C-\\><C-n>')
map('n', '<C-z>', '<C-w>W')
map('i', '<C-z>', '<C-w>W')
map('', '<leader>t', '<cmd>ToggleTerm<CR>')
map('t', '<leader>t', '<cmd>ToggleTerm<CR>')
map('n', '<leader>G', '<cmd>lua GituiToggle()<CR>')

-- telescope
map('', '<leader>ff', '<cmd>Telescope find_files<CR>')
map('', '<leader>fg', '<cmd>Telescope live_grep<CR>')
map('', '<leader>fb', '<cmd>Telescope buffers<CR>')
map('n', '<leader>ft', '<cmd>Telescope file_browser<CR>')
map('', '<leader>fm', '<cmd>Telescope man_pages<CR>')
map('', '<leader>fh', '<cmd>Telescope help_tags<CR>')

-- vim
map('', '<Space>', ':silent noh<Bar>echo<cr>')
map('n', 'U', '<C-r>')
map('n', '<leader>q', ':q!<cr>')
map('n', '<leader>s', ':w!<cr>')
map('n', '<leader>n', '<cmd>enew<cr>')
map('', '<leader>c', '<cmd>bd!<cr>')
map('', '<c-o>', '<cmd>bn<cr>')
map('', '<c-n>', '<cmd>bp<cr>')
map('n', '<leader>ev', '<cmd>cd ~/.config/nvim | e init.lua<CR>')
map('n', '<leader>rv', '<cmd>so ~/.config/nvim/init.lua<CR>')
map('n', '<leader>n', '<cmd>-tabmove<CR>')
map('n', '<leader>o', '<cmd>+tabmove<CR>')

map('i', '<leader><tab>', '<c-x><c-o>')

map('v', '<', '<gv')
map('v', '>', '>gv')

local autocmds = {
    comment_strings = {
      { 'FileType', 'tidal', 'setlocal commentstring=--%s' },
    },
    packer = {
      { 'BufWritePost', '~/.config/nvim/init.lua', 'source ~/.config/nvim/init.lua | PackerCompile' },
    },
}
nvim_create_augroups(autocmds)
