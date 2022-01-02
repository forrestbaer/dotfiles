--
-- lua remappings
--
local fn, opt, api, cmd, g = vim.fn, vim.opt, vim.api, vim.cmd, vim.g


--
-- Plugins
--
require('plugins')
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end


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
    --vim.cmd(':TermExec --cmd="'..tostring(v)..'"')
  end
end


--
-- lsp
--
require('lspconfig').sumneko_lua.setup{
  settings = { Lua = { diagnostics = { globals = { 'vim' } } } } -- brew install lua-language-server
}
require'lspconfig'.bashls.setup{} -- npm i -g bash-language-server
require'lspconfig'.jsonls.setup{} -- npm i -g jsonls

local lspconfig = require"lspconfig"

local function set_lsp_config(client)
  if client.resolved_capabilities.document_formatting then
    vim.cmd [[autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 300)]]
  end
end

local function eslint_config_exists()
  local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)
  local packagejson = vim.fn.glob("package.json", 0, 1)
  if not vim.tbl_isempty(eslintrc) then
    return true
  end
  if not vim.tbl_isempty(packagejson) then
    if vim.fn.filereadable("package.json") then
      if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
        return true
      end
    end
  end

  return false
end

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

lspconfig.tsserver.setup {
  on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
    set_lsp_config(client)
  end
}

lspconfig.efm.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.goto_definition = false
    set_lsp_config(client)
  end,
  root_dir = function()
    if not eslint_config_exists() then
      return nil
    end
    return vim.fn.getcwd()
  end,
  settings = {
    languages = {
      javascript = {eslint},
      javascriptreact = {eslint},
      ["javascript.jsx"] = {eslint},
      typescript = {eslint},
      ["typescript.tsx"] = {eslint},
      typescriptreact = {eslint}
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact"
  },
}


--
-- other plugin initializations
--
require('nvim-web-devicons').setup{ default = true }
require("trouble").setup {}

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


--
-- vim global opts
--
g.mapleader = ','
g.gitgutter_terminal_reports_focus = 0
g.terminal_color_3 = '#ac882f'
g.EasyMotion_smartcase = 1
g.EasyMotion_do_mapping = 0
g.tidal_target = "terminal"


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
map('', '<leader>ft', '<cmd>Telescope file_browser<CR>')
map('', '<leader>fm', '<cmd>Telescope man_pages<CR>')
map('', '<leader>fh', '<cmd>Telescope help_tags<CR>')

-- vim
map('', '<Space>', ':silent noh<Bar>echo<cr>')
map('n', 'l', '<C-r>')
map('n', '<leader>q', ':q!<cr>')
map('n', '<leader>w', ':w!<cr>')
map('n', '<leader>n', '<cmd>enew<cr>')
map('', '<leader>c', '<cmd>bd<cr>')
map('', '<leader><Tab>', '<cmd>bNext<cr>')
map('', '<leader><S-Tab>', '<cmd>bprevious<cr>')
map('n', '<leader>ev', '<cmd>e ~/.config/nvim/init.lua<CR>')
map('n', '<leader>ep', '<cmd>e ~/.config/nvim/lua/plugins.lua<CR>')
map('n', '<leader>rv', '<cmd>so ~/.config/nvim/init.lua<CR>')

map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })

local autocmds = {
    comment_strings = {
      { 'FileType', 'tidal', 'setlocal commentstring=--%s' },
    }
}
nvim_create_augroups(autocmds)


--
-- extra colors
--
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
hi Comment ctermfg=242 ctermbg=234
hi Pmenu ctermfg=249 ctermbg=233
hi GitGutterAdd ctermfg=28 ctermbg=Black
hi GitGutterChange ctermfg=112 ctermbg=Black
hi GitGutterDelete ctermfg=8 ctermbg=Black
hi DiagnosticError ctermfg=5 ctermbg=Black
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
