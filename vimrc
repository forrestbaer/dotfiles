" Forrest Baer's (forrest@forrestbaer.com) .vimrc
" This is my .vimrc. There are many like it, but this one is mine.


" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-surround'
Plug 'tidalcycles/vim-tidal'
Plug 'forrestbaer/minimal_dark'
Plug 'vim-airline/vim-airline'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" Search pattern across repository files
function! FzfExplore(...)
    let inpath = substitute(a:1, "'", '', 'g')
    if inpath == "" || matchend(inpath, '/') == strlen(inpath)
        execute "cd" getcwd() . '/' . inpath
        let cwpath = getcwd() . '/'
        call fzf#run(fzf#wrap(fzf#vim#with_preview({'source': 'ls -1ap', 'dir': cwpath, 'sink': 'FZFExplore', 'options': ['--prompt', cwpath]})))
    else
        let file = getcwd() . '/' . inpath
        execute "e" file
    endif
endfunction

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
command! -nargs=* FZFExplore call FzfExplore(shellescape(<q-args>))

set fileencoding=utf-8
set showmode
set tabstop=4
set shiftwidth=4
set expandtab
set showmatch
set backspace=indent,eol,start
set autoindent
set autoread
set number
set autochdir
set mouse=a
set modifiable
set ruler
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrap
set linebreak
set hidden
set viminfo=
set scrolloff=3
set nobackup
set splitbelow
set laststatus=2
set t_Co=256
set grepprg=rg\ --vimgrep
set updatetime=300
let g:airline_powerline_fonts = 1
let g:airline_detect_spell = 0
let g:airline_section_c_only_filename = 1
let g:airline_section_y = ''
let g:airline_section_x = ''
let g:airline#extensions#whitespace#show_message = 0
let g:airline_detect_whitespace=0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:fzf_preview_window = []
let g:terminal_color_3 = '#ac882f'

let g:EasyMotion_smartcase = 1
let g:EasyMotion_do_mapping = 0
"let g:tidal_no_mappings = 1
let g:tidal_target = "terminal"

filetype plugin on

" KEY MAPPINGS "

" redo
noremap l <C-r>

" window switching
nnoremap <C-w> <C-W>W
tnoremap <Esc> <C-\><C-n>

" set the leader key to comma
let mapleader = ","

" easymotion
map <leader>s <Plug>(easymotion-bd-f)
nmap <leader>s <Plug>(easymotion-overwin-f)

map <leader>p :TidalLookupSignature<cr>
nmap <leader>p :TidalLookupSignature<cr>

" hit spacebar to clear search highlights
nnoremap <silent><Space> :silent noh<Bar>echo<cr>

nnoremap <leader>ff :FZFExplore<cr>
nnoremap <leader>fg :Ag<cr>
nnoremap <leader>fb :Buffers<cr>

" write/quit
map <leader>q :q!<cr>
map <leader>w :w!<cr>
nnoremap Q @q

" buffer stuff
nmap <leader>t :enew<cr>
map <leader>c :bd<cr>

" ,ev to edit vimrc
map <leader>ev :sp ~/.vimrc<cr>
" ,rv to reload vimrc
map <leader>rv :so ~/.vimrc<cr>

" COLORSCHEME "
color minimal_dark
syntax enable
filetype plugin indent on

set clipboard=unnamedplus

autocmd BufWritePre * :%s/\s\+$//e

hi link EasyMotionTarget Number
hi link EasyMotionShade  Comment

hi link EasyMotionTarget2First IncSearch
hi link EasyMotionTarget2Second IncSearch

hi link EasyMotionMoveHL Search
hi link EasyMotionIncSearch Search

nnoremap <silent> K :call <SID>show_documentation()<CR>

