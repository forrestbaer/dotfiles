local api, cmd, fn, g, lsp = vim.api, vim.cmd, vim.fn, vim.g, vim.lsp
local opt, wo = vim.opt, vim.wo
local fmt = string.format

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

require 'paq' {
	{'savq/paq-nvim'},
	{'tpope/vim-surround'},
	{'tidalcycles/vim-tidal'},
	{'forrestbaer/minimal_dark'},
	{'vim-airline/vim-airline'},
	{'easymotion/vim-easymotion'},
  {'nvim-lua/plenary.nvim'},
  {'nvim-telescope/telescope.nvim'},
  {'neovim/nvim-lspconfig'},
  {'kabouzeid/nvim-lspinstall'},
  {'hrsh7th/nvim-compe'},
  {'nvim-treesitter/nvim-treesitter'},
  {'tpope/vim-fugitive'},
  {'nvim-telescope/telescope-fzf-native.nvim'},
}

local actions = require('telescope.actions')
local previewers = require("telescope.previewers")

local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > 100000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

require('telescope').setup{
  defaults = {
    buffer_preview_maker = new_maker,
    prompt_prefix = ' $ ',
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "vertical",
    color_devicons = false,
    layout_config = {
      vertical = {
        height = 0.6,
        preview_height = 0.4,
        mirror = false,
      },
    },
    file_ignore_patterns = {},
    mappings = {
      i = {
        ['<esc>'] = actions.close
      },
    },
  },
  pickers = {
    file_browser = {
      disable_devicons = true,
    }
  }
}

require('telescope').load_extension('fzf')

cmd 'colorscheme minimal_dark'

-- options
--
opt.fileencoding = 'utf-8'
opt.backspace = 'indent,eol,start'
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.showmatch = true
opt.number = true
opt.numberwidth = 3
opt.hidden = true
opt.mouse = 'a'
opt.ignorecase = true
opt.smartcase = true
opt.timeout = false
opt.linebreak = true
opt.scrolloff = 4
opt.backup = false
opt.splitbelow = true
opt.grepprg = 'rg'
opt.updatetime = 300

-- global opts
--
g.mapleader = ','

g.airline_powerline_fonts = 1
g.airline_detect_spell = 0
g.airline_section_c_only_filename = 1
g.airline_section_y = ''
g.airline_section_x = ''
g.airline_detect_whitespace=0
g.terminal_color_3 = '#ac882f'
g.EasyMotion_smartcase = 1
g.EasyMotion_do_mapping = 0
g.tidal_target = "terminal"
g['airline#extensions#tabline#enabled'] = 1
g['airline#extensions#tabline#fnamemod'] = ':t'

-- key mappings
--
map('n', 'l', '<C-r>')

map('', '<C-w>', '<C-W>W')
map('t', '<Esc>', '<C-\\><C-n>')

map('', '<leader>s', '<Plug>(easymotion-bd-f)')
map('n', '<leader>s', '<Plug>(easymotion-overwin-f)')

-- map <leader>p :TidalLookupSignature<cr>
-- nmap <leader>p :TidalLookupSignature<cr>

map('', '<Space>', ':silent noh<Bar>echo<cr>')

map('', '<leader>ff', '<cmd>Telescope find_files<CR>')
map('', '<leader>fg', '<cmd>Telescope find_files<CR>')
map('', '<leader>fb', '<cmd>Telescope buffers<CR>')
map('', '<leader>ft', '<cmd>Telescope help_tags<CR>')

map('n', '<leader>q', ':q!<cr>')
map('n', '<leader>w', ':w!<cr>')
-- nnoremap Q @q
--
-- " buffer stuff
map('n', '<leader>t', '<cmd>enew<cr>')
map('', '<leader>c', '<cmd>bd<cr>')
--
map('n', '<leader>ev', '<cmd>sp ~/.config/nvim/init.lua<CR>')
map('n', '<leader>rv', '<cmd>so ~/.config/nvim/init.lua<CR>')

-- nnoremap <silent> K :call <SID>show_documentation()<CR>

function init_term()
  cmd 'setlocal nonumber norelativenumber'
  cmd 'setlocal nospell'
  cmd 'setlocal signcolumn=auto'
end

function toggle_wrap()
  wo.breakindent = not wo.breakindent
  wo.linebreak = not wo.linebreak
  wo.wrap = not wo.wrap
end
