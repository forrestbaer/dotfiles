" global settings
let g:mapleader=","				" set leader to comma
let g:netrw_banner=0				" disable banner
let g:netrw_alto=1				" splits to the bottom
let g:netrw_altv=0
let g:netrw_liststyle=3				" tree view
let g:netrw_list_hide=netrw_gitignore#Hide()	" hide .gitignore files
let g:netrw_list_hide=',\(^\|\s\s\)\zs\.\S\+'	" hide dotfiles?

" basic settings
syntax on
colorscheme minimal_dark

set path+=**
set expandtab
set number
set nowrap
set smartcase
set smartindent
set wildmenu
set undofile
set undodir=/tmp
set undolevels=2000
set updatetime=150
set tabstop=4
set shiftwidth=4
set scrolloff=4
set helpheight=15
set clipboard="unnamedplus"

if executable("rg")
    set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading
    set grepformat+=%l:%f:%c:%m
endif

" packadd our packages
packadd vim-commentary
packadd vim-surround
packadd vim-easy-align

" keymaps
nnoremap <leader>fg :silent Grep<Space>

nnoremap <leader>s :w<cr>
nnoremap <leader>x :bd<cr>
nnoremap <leader>q :q!<cr>

nnoremap <leader>rv :source ~/.config/nvim/init.vim<cr>:echo "vimrc reloaded..."<cr>
nnoremap <leader>ev :e ~/.config/nvim/init.vim<cr>

" binary file operations
nnoremap <leader>bd :%!xxd<cr>:set ft=xxd<cr>
nnoremap <leader>br :%!xxd -r<cr>:set ft=elf<cr>

nnoremap <Space> :silent noh<cr>

" highlight lines when yanked, 100ms
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=100})
augroup END

function! Grep(...)
	return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup quickfix
	autocmd!
	autocmd QuickFixCmdPost cgetexpr cwindow
	autocmd QuickFixCmdPost lgetexpr lwindow
augroup END
