" Forrest Baer's (gfbaer@gmail.com) .vimrc
" This is my .vimrc. There are many like it, but this one is mine.

" set up packages if they dont' exist
let isNpmInstalled = executable("npm")
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
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-markdown'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'elzr/vim-json'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'kien/ctrlp.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'hai2u/vim-css3-syntax'
Plugin 'forrestbaer/minimal_dark'

if iCanHazVundle == 0
    echo "Installing Vundles, please ignore key map error messages"
    echo ""
    :PluginInstall
endif
call vundle#end() 

if isNpmInstalled
    if !executable(expand(s:defaultNodeModules . 'jshint'))
        silent ! echo 'Installing jshint' && npm --prefix ~/.vim/ install jshint
    endif
    if !executable(expand(s:defaultNodeModules . 'csslint'))
        silent ! echo 'Installing csslint' && npm --prefix ~/.vim/ install csslint
    endif
endif

"-------------------------
" CtrlP settings

let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

"-------------------------
" Syntastic

function! s:FindSyntasticExecPath(toolName)
    if executable(a:toolName)
        return a:toolName
    endif

    let fullPath=fnamemodify('.', ':p:h')
    while fullPath != fnamemodify('/', ':p:h')
        if filereadable(expand(fullPath . '/node_modules/.bin/' . a:toolName))
            return fullPath . '/node_modules/.bin/' . a:toolName
        endif
        let fullPath = fnamemodify(fullPath . '/../', ':p:h')
    endwhile

    return  s:defaultNodeModules . a:toolName

endfunction

" setting up jshint csslint and jscs if available
let g:syntastic_javascript_jshint_exec = s:FindSyntasticExecPath('jshint')
let g:syntastic_javascript_jscs_exec = s:FindSyntasticExecPath('jscs')
let g:syntastic_css_csslint_exec= s:FindSyntasticExecPath('csslint')

" Enable autochecks
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1

" For correct works of next/previous error navigation
let g:syntastic_always_populate_loc_list = 1

" check json files with jshint
let g:syntastic_filetype_map = { "json": "javascript", }

let g:syntastic_javascript_checkers = ["jshint", "jscs"]

" open quicfix window with all error found
nmap <silent> <leader>ll :Errors<cr>
" previous syntastic error
nmap <silent> [ :lprev<cr>
" next syntastic error
nmap <silent> ] :lnext<cr>

" Colorscheme for airline
let g:airline_theme='raven'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_section_y = ''
let g:airline_section_x = ''

" regular settings
set nocompatible
set showmode                            " show editing mode
set showmatch                           " show matching parens
set backspace=indent,eol,start          " make backspace back over everything
set autoindent                          " copy indentation from previous line
set autoread                            " automatically show outside changes
set wildmenu                            " use dat wild menu, yeewahawahhaaa
set wildmode=list:longest               " wild settings, gettin wild!
set number                              " show line numbers
set ruler                               " show cursor position
set incsearch                           " search as we type
set hlsearch                            " highlight all search finds
set wrap                                " wrap text
set scrolloff=3                         " lets us see 3 lines ahead/behind
set nobackup                            " don't make backups everywhere
set softtabstop=4                       " soft tab stop to 4
set smarttab                            " smart backspacing over tabs
set expandtab                           " tab expansion??
set splitbelow                          " open new splits below
set shiftwidth=4                        " 4 spaces when backspacing tabs
set laststatus=2                        " always show last status 
set t_Co=256                            "terminal option for number of colors
"set statusline=%<%f%h%m%r%h%w\ (%{&ff})\ lastmod:\ %{strftime(\"%x\ %X\",getftime(expand(\"%:p\")))}%=\ lin:%l\,%L\ col:%c%V\ [%P]

" KEY MAPPINGS "

" set the leader key to comma
let mapleader = ","


" hit spacebar to clear search highlights
nnoremap <silent><Space> :silent noh<Bar>echo<CR>

" remap semicolon
nnoremap ; :
 
" show/hide NERDTree
nmap <leader><tab> :NERDTreeToggle<CR>

" mapping the jumping between splits. Hold control while using vim nav.
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l

" ,q gtfo quick
map <leader>q :q!<cr>
nnoremap Q @q

" ,w save quick
map <leader>w :w!<cr>

" ,c to close
map <leader>c :clo<cr>

" ,ev to edit vimrc
map <leader>ev :vsp ~/.vimrc<cr>

" autocmd stuff for filetypes
if has("autocmd")
	augroup module
	autocmd BufRead,BufNewFile *.tt set filetype=tt
	autocmd FileType css setlocal foldmethod=indent shiftwidth=2 tabstop=2
	autocmd VimEnter * set vb t_vb=
	autocmd FileType python setl shiftwidth=4 softtabstop=4
	autocmd FileType python syntax match Error "\t"
	autocmd BufReadPost * if line("'\"") > 0 && line ("'\"") <= line("$") | exe "normal! g'\"" | endif
	au BufRead,BufNewFile /etc/nginx/sites-available/* set ft=nginx 
	au BufNewFile,BufRead *.json set ai filetype=javascript
	au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby
	augroup END
endif

" COLORSCHEME "
color minimal_dark

syntax enable
filetype plugin indent on
