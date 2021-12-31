--
-- lua remappings
--
local opt, api, cmd, g = vim.opt, vim.api, vim.cmd, vim.g


--
-- helper functions
--
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
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


--
-- Plugins
--
require 'paq' {
	{'savq/paq-nvim'},
	{'tidalcycles/vim-tidal'},
  {'sophacles/vim-processing'},
	{'forrestbaer/minimal_dark'},
	{'vim-airline/vim-airline'},
	{'easymotion/vim-easymotion'},
  {'kyazdani42/nvim-web-devicons'},
  {'nvim-lua/plenary.nvim'},
  {'nvim-telescope/telescope.nvim'},
  {'neovim/nvim-lspconfig'},
  {'kabouzeid/nvim-lspinstall'},
  {'hrsh7th/nvim-cmp'},
  {'folke/trouble.nvim'},
	{'tpope/vim-surround'},
  {'tpope/vim-commentary'},
  {'nvim-telescope/telescope-fzf-native.nvim'},
  {'airblade/vim-gitgutter'},
  {'akinsho/toggleterm.nvim'},
}


--
-- lsp
--
require('lspconfig').tailwindcss.setup{}  -- npm install -g @tailwindcss/language-server
require('lspconfig').eslint.setup{} -- npm i -g vscode-langservers-extracted
require('lspconfig').tsserver.setup{} -- npm install -g typescript typescript-language-server
require('lspconfig').sumneko_lua.setup{
  settings = { Lua = { diagnostics = { globals = { 'vim' } } } } -- brew install lua-language-server
}
require'lspconfig'.bashls.setup{} -- npm i -g bash-language-server
require'lspconfig'.jsonls.setup{} -- npm i -g jsonls


--
-- other plugin initializations
--
require('nvim-web-devicons').setup{ default = true }
require("trouble").setup {}


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
    layout_config = {
      vertical = {
        height = 0.6,
        preview_height = 0.4,
        mirror = false,
      },
    },
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

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  virtual_text = {
    prefix = '',
  },
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
})

g.gitgutter_sign_added = ''
g.gitgutter_sign_modified = ''
g.gitgutter_sign_removed = ''
g.gitgutter_sign_removed_first_line = '^^'
g.gitgutter_sign_removed_above_and_below = '{'
g.gitgutter_sign_modified_removed = ''


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
opt.linebreak = true
opt.scrolloff = 4
opt.backup = false
opt.splitbelow = true
opt.grepprg = 'rg'
opt.updatetime = 300
opt.undofile = true
opt.undodir = '/Users/forrestbaer/tmp'


--
-- vim global opts
--
g.mapleader = ','
g.gitgutter_terminal_reports_focus = 0
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


--
-- key mappings
--

-- terminal
map('', '<C-w>', '<C-W>W')
map('t', '<C-z>', '<C-\\><C-n>')
map('', '<leader>t', '<cmd>ToggleTerm<CR>')
map('t', '<leader>t', '<cmd>ToggleTerm<CR>')
map("n", "<leader>g", "<cmd>lua GituiToggle()<CR>", {noremap = true, silent = true})

-- easymotion
map('', '<leader>s', '<Plug>(easymotion-bd-f)', { noremap = false })
map('n', '<leader>s', '<Plug>(easymotion-overwin-f)', { noremap = false })

-- diagnostic
map('', '<leader>d', '<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<CR>')
map('', '<leader>fd', '<cmd>TroubleToggle<CR>')

-- telescope
map('', '<leader>ff', '<cmd>Telescope find_files<CR>')
map('', '<leader>fg', '<cmd>Telescope live_grep<CR>')
map('', '<leader>fb', '<cmd>Telescope buffers<CR>')
map('', '<leader>ft', '<cmd>Telescope lsp_document_symbols<CR>')
map('', '<leader>fm', '<cmd>Telescope marks<CR>')

-- vim
vim.cmd([[
if &wildoptions =~ "pum"
    cnoremap <expr> <up> pumvisible() ? "<C-p>" : "\\<up>"
    cnoremap <expr> <down> pumvisible() ? "<C-n>" : "\\<down>"
endif
]])
map('', '<Space>', ':silent noh<Bar>echo<cr>')
map('n', 'l', '<C-r>')
map('n', '<leader>q', ':q!<cr>')
map('n', '<leader>w', ':w!<cr>')
map('n', '<leader>n', '<cmd>enew<cr>')
map('', '<leader>c', '<cmd>bd<cr>')
map('', '<leader><Tab>', '<cmd>bNext<cr>')
map('', '<leader><S-Tab>', '<cmd>bprevious<cr>')
map('n', '<leader>ev', '<cmd>e ~/.config/nvim/init.lua<CR>')
map('n', '<leader>rv', '<cmd>so ~/.config/nvim/init.lua<CR>')

map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })

local autocmds = {
    comment_strings = {
      { 'FileType', 'tidal', 'setlocal commentstring=--%s' },
    }
}

nvim_create_augroups(autocmds)

vim.cmd([[
augroup MyColors
autocmd!
hi link EasyMotionTarget Number
hi link EasyMotionShade  Comment
hi link EasyMotionTarget2First IncSearch
hi link EasyMotionTarget2Second IncSearch
hi link EasyMotionMoveHL Search
hi link EasyMotionIncSearch Search
hi SignColumn ctermfg=White ctermbg=Black
hi Comment ctermfg=236 ctermbg=Black
hi Pmenu ctermfg=249 ctermbg=233
hi GitGutterAdd ctermfg=28 ctermbg=Black
hi GitGutterChange ctermfg=112 ctermbg=Black
hi GitGutterDelete ctermfg=8 ctermbg=Black
hi DiagnosticError ctermfg=124 ctermbg=Black
hi DiagnosticWarn ctermfg=135
hi DiagnosticInfo ctermfg=24
hi DiagnosticUnderlineWarn ctermfg=135
hi DiagnosticHint ctermfg=116
hi DiagnosticVirtualTextHint ctermfg=238 ctermbg=233
hi DiagnosticVirtualTextWarn ctermfg=242 ctermbg=233
hi MarkSignNumHL ctermfg=116
hi MarkSignHL ctermfg=73
hi Operator ctermfg=43
augroup end
]])

