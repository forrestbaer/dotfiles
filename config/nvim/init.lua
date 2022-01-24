--
-- constants
--
local fn, opt, api, cmd, g = vim.fn, vim.opt, vim.api, vim.cmd, vim.g


--
-- plugins
--
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  Packer_Bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

require('packer').startup({function(use)
  use 'wbthomason/packer.nvim'
  use 'forrestbaer/minimal_dark'
  use 'nvim-lualine/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'airblade/vim-gitgutter'
  use 'akinsho/toggleterm.nvim'
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

-- converts contents of a register and converts to array of line terminated items
local function split_multiline_reg(reg)
  local st = {}
  local ss = vim.fn.getreg(reg)
  for s in ss:gmatch("[^\r\n]+") do
      table.insert(st, s)
  end
  return st
end

-- sends contents of table to terminal
local function send_to_terminal(t)
  for k,v in ipairs(t) do
    -- vim.cmd(':TermExec --cmd="'..tostring(v)..'"')
  end
end


--
-- other plugin initializations
--
require('nvim-web-devicons').setup{ default = true }

require'lualine'.setup {
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
      {'filename', separator = { right = ''}}
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
opt.updatetime = 300
opt.undofile = true
opt.undodir = '/Users/forrestbaer/tmp'
opt.helpheight = 15
opt.completeopt = 'menuone,noselect,noinsert'
opt.omnifunc = 'syntaxcomplete#Complete'


--
-- vim global opts
--
g.mapleader = ','
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

-- terminal
map('', '<C-w>', '<C-W>W')
map('t', '<C-z>', '<C-\\><C-n>')
map('n', '<C-z>', '<C-w>W')
map('i', '<C-z>', '<C-w>W')
map('', '<leader>t', '<cmd>ToggleTerm<CR>')
map('t', '<leader>t', '<cmd>ToggleTerm<CR>')
map("n", "<leader>g", "<cmd>lua GituiToggle()<CR>")

map('', '<leader>ff', '<cmd><CR>')
map('', '<leader>fg', '<cmd><CR>')
map('', '<leader>fb', '<cmd><CR>')

-- vim
map('', '<Space>', ':silent noh<Bar>echo<cr>')
map('n', 'l', '<C-r>')
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
