" Forrest Baer's (forrest@forrestbaer.com) .vimrc
" This is my .vimrc. There are many like it, but this one is mine.

" set up packages if they dont' exist
let s:defaultNodeModules = '~/.vim/node_modules/.bin/'
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/vundle
    let iCanHazVundle=0
endif

set nocompatible

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

packadd termdebug
let g:termdebug_wide=1

Plugin 'VundleVim/Vundle.vim'
Plugin 'tidalcycles/vim-tidal'
Plugin 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
Plugin 'forrestbaer/minimal_dark'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

if iCanHazVundle == 0
    :PluginInstall
endif
call vundle#end()

let g:airline_powerline_fonts = 1

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

command! -nargs=* FZFExplore call FzfExplore(shellescape(<q-args>))

set fileencoding=utf-8                  " set default file encoding to utf-8
set showmode                            " show editing mode
set tabstop=2                          " ^^
set expandtab
set showmatch                           " show matching parens
set backspace=indent,eol,start          " make backspace back over everything
set autoindent                          " copy indentation from previous line
set autoread                            " automatically show outside changes
set number                              " show line numbers
set autochdir                           " set the working dir to where the open file lives
set mouse=a
set ruler                               " show cursor position
set ignorecase                          " ignore case sensitive searching
set smartcase                           " use smart case searching
set incsearch                           " search as we type
set hlsearch                            " highlight all search finds
set wrap                                " wrap text
set linebreak                           " shift long words to the next line
set hidden                              " hide buffers when abandoned
set viminfo=                            " no viminfo files please
set scrolloff=3                         " lets us see 3 lines ahead/behind
set nobackup                            " don't make backups everywhere
set splitbelow                          " open new splits below
set laststatus=2                        " always show last status
set t_Co=256                            " terminal option for number of colors
set grepprg=rg\ --vimgrep               " grep program
set pastetoggle=<F1>                    " paste toggle with f1 if needed

let g:airline_detect_spell = 0
let g:airline_section_c_only_filename = 1

" KEY MAPPINGS "

" set the leader key to comma
let mapleader = ","

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" hit spacebar to clear search highlights
nnoremap <silent><Space> :silent noh<Bar>echo<cr>

" remap semicolon
nnoremap ; :

" Open Goyo for distraction free editing
"nnoremap <leader>g :Goyo<cr>

" ,q gtfo quick
map <leader>q :q!<cr>
nnoremap Q @q

" buffers
nmap <leader>t :enew<cr>

" ,w save quick
map <leader>w :w!<cr>

" ,c to delete buffer
map <leader>c :bd<cr>

" ,ev to edit vimrc
map <leader>ev :vsp ~/.vimrc<cr>

" ,rv to reload vimrc
map <leader>rv :so ~/.vimrc<cr>

" ctrlp to fzf
nmap <C-p> :FZFExplore<cr>

" COLORSCHEME "
color minimal_dark
syntax enable
filetype plugin indent on

function! s:goyo_enter()
    nnoremap j gj
    nnoremap k gk
    nnoremap 0 g0
    nnoremap $ g$
    Limelight
    let b:quitting = 0
    let b:quitting_bang = 0
    autocmd QuitPre <buffer> let b:quitting = 1
    cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
    set noshowmode
    set noshowcmd
endfunction

function! s:goyo_leave()
    Limelight!
    set showmode
    set showcmd
    if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
      if b:quitting_bang
        qa!
      else
        qa
      endif
    endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Filetype stuff
autocmd BufNewFile,BufRead *.txt Goyo
