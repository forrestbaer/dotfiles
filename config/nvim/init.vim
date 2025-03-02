" packadd our packages
packadd vim-commentary
packadd vim-surround
packadd vim-easy-align
packadd vim-easyclip
packadd fzf.vim
packadd colorizer

" basic settings
syntax on
colorscheme minimal_dark

set path+=**
set tags+=tags;$HOME
set rtp+=~/.fzf
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

set statusline=
set statusline +=%1*\ %n\ %*            "buffer number
set statusline +=%3*%y%*                "file type
set statusline +=%4*\ %<%F%*            "full path
set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
set statusline +=%1*%4v\ %*             "virtual column number
set statusline +=%5*0x%04B\ %*          "character under cursor

hi User1 guifg=#eeeeee guibg=#111111
hi User2 guifg=#999999 guibg=#111111
hi User3 guifg=#6f5faf guibg=#111111
hi User4 guifg=#af875f guibg=#111111
hi User5 guifg=#cccc88 guibg=#111111

if executable("rg")
    set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading
    set grepformat+=%l:%f:%c:%m
endif

" global settings
let g:mapleader=","				                " set leader to comma
let g:netrw_banner=0				            " disable banner
let g:netrw_altv=1
let g:netrw_liststyle=3				            " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()	" hide .gitignore files
let g:netrw_list_hide=',\(^\|\s\s\)\zs\.\S\+'	" hide dotfiles?

let g:fzf_vim = {}
let g:fzf_vim.preview_window=[]
let g:fzf_vim.buffers_jump = 1
let g:fzf_vim.tags_command = 'ctags -R'

let g:airline#extensions#tabline#formatter = 'default'

" keymaps
nnoremap <leader>ff :silent Files<cr>
nnoremap <leader>fb :silent Buffers<cr>
nnoremap <leader>fg :silent RG!<cr>
nnoremap <leader>ft :silent Tags!<cr>
nnoremap <leader>fd :silent GFiles?!<cr>

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

" for some of our files, we want an empty line at end of file
function! AddLastLine()
    if getline('$') !~ "^$"
        call append(line('$'), '')
    endif
endfunction
autocmd BufWritePre *.s\|*.c\|*.h call AddLastLine()
