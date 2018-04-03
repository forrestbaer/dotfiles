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
Plugin 'maksimr/vim-jsbeautify'
Plugin 'tpope/vim-markdown'
Plugin 'scrooloose/syntastic'
Plugin 'elzr/vim-json'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'kien/ctrlp.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'pangloss/vim-javascript'
Plugin 'forrestbaer/minimal_dark'
Plugin 'rking/ag.vim'

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

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_by_filename = 1
let g:ctrlp_switch_buffer = 0
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'


" automatically open files in a new tab
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
    \ 'AcceptSelection("t")': ['<cr>'],
    \ }

"-------------------------
" Replace grep with ag

set grepprg=ag\ --nocolor\ --nogroup\ 

"-------------------------
" Javascript stuff
let g:javascript_plugin_jsdoc = 1

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

" ignore for html files
let g:syntastic_mode_map={ 'mode': 'active',
                     \ 'active_filetypes': [],
                     \ 'passive_filetypes': ['html'] }

" open quicfix window with all error found
nmap <silent> <leader>e :Errors<cr>
" previous syntastic error
nmap <silent> [ :lprev<cr>
" next syntastic error
nmap <silent> ] :lnext<cr>

" need to paste something? use F1
set pastetoggle=<F1>

" bind \ (backward slash) to grep shortcut
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow!|redraw!
nnoremap \ :Ag<SPACE>

" Colorscheme for airline
let g:airline_theme='minimal_dark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline_skip_empty_sections = 1
let g:airline_section_y = ''
let g:airline_section_x = ''
let g:airline#extensions#whitespace#show_message = 0
let g:airline_detect_whitespace=0

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
set viminfo=                            " no viminfo files please
set scrolloff=3                         " lets us see 3 lines ahead/behind
set nobackup                            " don't make backups everywhere
set softtabstop=4                       " soft tab stop to 4
set smarttab                            " smart backspacing over tabs
set expandtab                           " tab expansion??
set splitbelow                          " open new splits below
set shiftwidth=4                        " 4 spaces when backspacing tabs
set laststatus=2                        " always show last status
set t_Co=256                            "terminal option for number of colors

" KEY MAPPINGS "

" set the leader key to comma
let mapleader = ","

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" hit spacebar to clear search highlights
nnoremap <silent><Space> :silent noh<Bar>echo<CR>

" remap semicolon
nnoremap ; :

" open a new tab with a file browser
nnoremap <leader>n :tabe %:p:h<CR>

" show/hide NERDTree
nmap <leader><tab> :NERDTreeToggle<CR>

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

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

" determine what color is under the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

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

nnoremap <leader>l :call NumberToggle()<CR>

" COLORSCHEME "
color minimal_dark

syntax enable
filetype plugin indent on
