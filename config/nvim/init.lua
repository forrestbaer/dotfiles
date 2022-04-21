--
-- constants
--
local fn, opt, api, cmd, g = vim.fn, vim.opt, vim.api, vim.cmd, vim.g

--
-- plugins
--
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  Packer_Bootstrap = true
end

require('packer').startup({function(use)
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'forrestbaer/minimal_dark'
  use 'nvim-lua/plenary.nvim'
  use 'rmagatti/goto-preview'
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
  use {'ms-jpq/coq_nvim', branch = 'coq'}
  use {'ms-jpq/coq.artifacts', branch = 'artifacts'}
	use {'tidalcycles/vim-tidal', ft = 'tidal'}
  use {'fatih/vim-go', ft = 'go'}

  use {
    'vimwiki/vimwiki',
    config = function()
      vim.g.vimwiki_list = {{
        path = '~/store/wiki',
        syntax = 'markdown',
        ext = '.md'
      }}
    end
  }

  if Packer_Bootstrap then
    require('packer').sync()
  end
end,
config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
}})


--
-- helper functions
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

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


--
-- lsp
--
local lspconfig = require('lspconfig')
lspconfig.sumneko_lua.setup{
  settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = true,
    signs = true,
    update_in_insert = false,
  }
)

local coq = require "coq"

local servers = { 'html', 'tsserver', 'gopls'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {coq.lsp_ensure_capabilities{}}
end

vim.cmd('COQnow -s')

g.coq_settings = {
  clients = {
    buffers = {
      enabled = false,
      same_filetype = true
    }
  }
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
		underline = true,
		signs = true,
	}
)

require('goto-preview').setup{}

--
-- telescope stuff
--
local actions = require('telescope.actions')

require('telescope').load_extension('fzf')
require('telescope').setup{
  defaults = {
    prompt_prefix = ' $ ',
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "vertical",
    color_devicons = true,
    file_ignore_patterns = {
      "node_modules",
      "vendor",
      "__tests__",
      "__snapshots__",
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
  },
}
require("telescope").load_extension "file_browser"


--
-- other plugin initializations
--
require('nvim-web-devicons').setup{ default = true }

require'lualine'.setup{
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
    lualine_b = {
      {'branch',
        separator = {right = ''},
        color = {fg = '#999999'}},
      {'diff', colored = false},
      {'diagnostics',
        colored = false,
        padding = 2,
        sections = { 'error', 'warn', 'info' }}
    },
    lualine_c = {
      {'filename', separator = { right = ''}},
    },
    lualine_x = {
      {'encoding', separator = { left = ''}},
      {'filetype', colored = false, color = { bg = '#222222'}}
    },
    lualine_y = {
      {'progress', color = { fg = '#FFFFFF'}}
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
      separator = { right = '' },
      buffers_color = {
        active = { fg = '#000000', bg = '#DDDDDD'},
        inactive = { fg = '#000000', bg = '#444444'}
      }
    }},
    lualine_b = {}
  },
}


--
-- toggleterm
--
require("toggleterm").setup{
  size = 15,
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
  cmd = "gitui",
  dir = ".",
  direction = "float",
  close_on_exit = true,
  float_opts = { border = "single", },
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
})
function GituiToggle()
  gitui:toggle()
end


--
-- visual setup
--
cmd 'colorscheme minimal_dark'

g.gitgutter_sign_added = '+'
g.gitgutter_sign_modified = '~'
g.gitgutter_sign_removed = '-'
g.gitgutter_sign_removed_first_line = '^^'
g.gitgutter_sign_removed_above_and_below = '{'
g.gitgutter_sign_modified_removed = '-'

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end


--
-- options
--
opt.fileencoding = 'utf-8'
opt.backspace = 'indent,eol,start'
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.showmatch = true
opt.number = true
opt.numberwidth = 5
opt.hidden = true
opt.mouse = 'a'
opt.pumheight = 20
opt.ignorecase = true
opt.smartcase = true
opt.remap = true
opt.timeout = false
opt.guicursor = 'i:ver20-blinkon100,n:blinkon100'
opt.linebreak = true
opt.scrolloff = 4
opt.backup = false
opt.splitbelow = true
opt.grepprg = 'rg'
opt.updatetime = 150
opt.undofile = true
opt.undodir = '/Users/forrestbaer/tmp'
opt.helpheight = 15
opt.completeopt = 'menuone,noselect,noinsert'
opt.omnifunc = 'syntaxcomplete#Complete'
opt.clipboard = 'unnamedplus'


--
-- vim global opts
--
g.mapleader = ','
g.maplocalleader = ','
g.gitgutter_terminal_reports_focus = 0
g.terminal_color_3 = '#ac882f'
g.tidal_target = "terminal"
g.go_gopls_enabled = 1
g.go_auto_type_info = 1
g.go_info_mode = 'gopls' -- or guru
g.go_doc_balloon = 1
g.go_doc_popup_window = 1
g.go_def_reuse_buffer = 1


--
-- key mappings
--

-- lsp
map('n', 'K', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
map('n', '<leader>i', '<Cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<leader>I', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n', 'gD', '<Cmd>lua vim.lsp.buf.definition()<CR>')
map('n', 'gd', '<cmd>lua require("goto-preview").goto_preview_definition()<CR>')
map('n', '<leader>d', "<cmd>lua vim.diagnostic.open_float()<CR>")

-- git
map('n', '<leader>gb', "<cmd>G blame<CR>")
map('n', '<leader>ga', "<cmd>G add .<CR>")
map('n', '<leader>gc', "<cmd>G commit<CR>")
map('n', '<leader>gp', "<cmd>G push<CR>")

-- terminal
map('', '<C-w>', '<C-W>W')
map('t', '<C-z>', '<C-\\><C-n>')
map('n', '<C-z>', '<C-w>W')
map('i', '<C-z>', '<C-w>W')
map('', '<leader>t', '<cmd>ToggleTerm<CR>')
map('t', '<leader>t', '<cmd>ToggleTerm<CR>')
map("n", "<leader>g", "<cmd>lua GituiToggle()<CR>")

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
map('n', '<leader>ev', '<cmd>e ~/.config/nvim/init.lua<CR>')
map('n', '<leader>rv', '<cmd>so ~/.config/nvim/init.lua<CR>')

map('i', '<leader><tab>', '<c-x><c-o>')

map("v", "<", "<gv")
map("v", ">", ">gv")

local autocmds = {
    comment_strings = {
      { 'FileType', 'tidal', 'setlocal commentstring=--%s' },
    },
    packer = {
      { 'BufWritePost', 'init.lua', 'source ~/.config/nvim/init.lua | PackerCompile' },
    },
}
nvim_create_augroups(autocmds)
