" Forrest Baer's (gfbaer@gmail.com) .vimrc
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
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'othree/html5.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'alvan/vim-closetag'
Plugin 'junegunn/goyo.vim'
Plugin 'tpope/vim-markdown'
Plugin 'elzr/vim-json'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'w0rp/ale'
Plugin 'airblade/vim-gitgutter'
Plugin 'kien/ctrlp.vim'
Plugin 'forrestbaer/minimal_dark'
Plugin 'rking/ag.vim'

if iCanHazVundle == 0
    echo "Installing Vundles, please ignore key map error messages"
    echo ""
    :PluginInstall
endif
call vundle#end()

"-------------------------
" Javascript plugin

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

"-------------------------
" CtrlP settings

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_by_filename = 1
let g:ctrlp_switch_buffer = 0
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|.git'
let g:ctrlp_working_path_mode = 'c'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " Linux/MacOSX
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

"-------------------------
" ALE Config

let g:ale_linters_explicit = 1
let g:ale_set_highlights = 0
let g:airline#extensions#ale#enabled = 1

let g:ale_linters = {}
let g:ale_linters['javascript'] = ['eslint']
let g:ale_linters['json'] = ['jq']

let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['json'] = ['fixjson']

let g:ale_javascript_prettier_options = '--single-quote --no-semi --tab-width 4'

"-------------------------
" closetag config

let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.cshtml'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
let g:closetag_filetypes = 'cshtml,html,xhtml,phtml'
let g:closetag_xhtml_filetypes = 'xhtml,jsx'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

" bind \ (backward slash) to grep shortcut
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow!|redraw!
nnoremap \ :Ag<SPACE>

" Colorscheme for airline
let g:airline_theme='minimal_dark'
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline_section_y = ''
let g:airline_section_x = ''
let g:airline#extensions#whitespace#show_message = 0
let g:airline_detect_whitespace=0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" regular settings
set nocompatible
set fileencoding=utf-8                  " set default file encoding to utf-8
set showmode                            " show editing mode
set expandtab                           " expand tabs to spaces
set shiftwidth=4                        " 4 spaces when backspacing tabs
set tabstop=4                           " ^^
set showmatch                           " show matching parens
set backspace=indent,eol,start          " make backspace back over everything
set autoindent                          " copy indentation from previous line
set autoread                            " automatically show outside changes
set number                              " show line numbers
set autochdir                           " set the working dir to where the open file lives
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

" KEY MAPPINGS "

" set the leader key to comma
let mapleader = ","

" hit spacebar to clear search highlights
nnoremap <silent><Space> :silent noh<Bar>echo<cr>

" map something simple to repeat the normal macro
nnoremap <C-Q> @q

" remap semicolon
nnoremap ; :

" Open Goyo for distraction free editing
nnoremap <leader>g :Goyo<cr>

" mapping the jumping between splits. Hold control while using vim nav.
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l

" ,q gtfo quick
map <leader>q :q!<cr>
nnoremap Q @q

" buffers
nmap <leader>t :enew<cr>

" ,w save quick
map <leader>w :w!<cr>

" ,c to close
map <leader>c :clo<cr>

" ,d to delete buffer
map <leader>d :bd<cr>

" ,ev to edit vimrc
map <leader>ev :vsp ~/.config/nvim/init.vim<cr>

" ,rv to reload vimrc
map <leader>rv :so ~/.config/nvim/init.vim<cr>

" autocmd stuff for filetypes
if has("autocmd")
    augroup module
    autocmd BufRead,BufNewFile *.tt set filetype=tt
    autocmd VimEnter * set vb t_vb=
    autocmd FileType python setl shiftwidth=4 softtabstop=4
    autocmd FileType python syntax match Error "\t"
    autocmd BufReadPost * if line("'\"") > 0 && line ("'\"") <= line("$") | exe "normal! g'\"" | endif
    au BufRead,BufNewFile /etc/nginx/sites-available/* set ft=nginx
    au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby
    augroup END
endif

" toggle types of line numbers
function! NumberToggle()
    if(&nu == 1)
        set nu!
        set rnu
    else
        set nornu
        set nu
    endif
endfunction

nnoremap <leader>l :call NumberToggle()<cr>

" COLORSCHEME "
color minimal_dark
syntax enable
filetype plugin indent on

" Goyo Stuff
function! s:goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()

cnoreabbrev fmt ALEFix
cnoreabbrev hs vsplit
cnoreabbrev vs split
