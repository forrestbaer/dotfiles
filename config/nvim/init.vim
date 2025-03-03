" packadd our packages
packadd vim-commentary
packadd vim-surround
packadd vim-repeat
packadd vim-easy-align
packadd vim-easyclip
packadd fzf.vim
packadd colorizer

" basic settings
syntax on

set nocompatible
set path+=**
set tags+=tags;$HOME
set rtp+=~/.fzf
set expandtab
set number
set nowrap
set incsearch
set hlsearch
set ignorecase
set smartcase
set smartcase
set smartindent
set wildmenu
set undofile
set undodir=/tmp
set undolevels=2000
set updatetime=150
set tabstop=2
set shiftwidth=2
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

" file / buffer / grep operations
nnoremap <leader>ff :silent Files<cr>
nnoremap <leader>fb :silent Buffers<cr>
nnoremap <leader>fg :silent RG!<cr>
nnoremap <leader>ft :silent Tags!<cr>
nnoremap <leader>fd :silent GFiles?!<cr>

" help
nnoremap <leader>h :silent Helptags<cr>

" save / kill / quit
nnoremap <leader>s :w<cr>
nnoremap <leader>x :bd!<cr>
nnoremap <leader>q :q!<cr>

" edit init.vim or load init.vim
nnoremap <leader>rv :source ~/.config/nvim/init.vim<cr>:echo "vimrc reloaded..."<cr>
nnoremap <leader>ev :e ~/.config/nvim/init.vim<cr>

" clear search results with space
nnoremap <Space> :silent noh<cr><cr>

" highlight lines when yanked, 100ms
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=100})
augroup END

" for some of our files, we want an empty line at end of file
function! s:add_last_line()
    if getline('$') !~ "^$"
        call append(line('$'), '')
    endif
endfunction
autocmd BufWritePre *.s\|*.c\|*.h call s:add_last_line()

" clean up lines ending with whitespace
function Trim()
    let sc = getpos(".")
    silent! %s/\s*$//g
    call setpos('.', sc)
endfunction

" hex editing cursor stuff, follows position assuming -g 2 -c 16
function! s:highlight()
    if exists('s:match') && s:match != -1
        call matchdelete(s:match)
        unlet s:match
    endif
    let syn = synIDattr(synID(line('.'), col('.'), 1), 'name')
    if syn != ''
        return
    endif
    let c = col('.') - 10
    if c % 5 == 0
        return
    endif
    let c = c / 5 * 2 + (c % 5 > 2 ? 1 : 0)
    let s:match = matchadd('MatchedBinary', '\%' . (c+52) .  'c\%' . line('.') . 'l')
endfunction

" run the higlight when we move our cursor
augroup XXD
    if &binary
        au!
        autocmd CursorMoved <buffer> call s:highlight()
    endif
augroup END

" auto binary disassembly / reassembly handling
" nnoremap <leader>bd :%!xxd -g 2 -c 16<cr>:set ft=xxd<cr>
" nnoremap <leader>br :%!xxd -r<cr>:set ft=elf<cr>
augroup Binary
    au!
    au BufReadPre *.bin,*.hex,*.elf,*.o setlocal binary
    au BufReadPost *
                \ if &binary |
                \   silent exe "%!xxd -g 2 -c 16" |
                \   silent exe "set ft=XXD" |
                \   redraw |
                \ endif
    au BufUnload *
                \ if &binary |
                \   setlocal! binary |
                \ endif
    au BufWritePre *
                \ if &binary |
                \  let oldro=&ro | let &ro=0 |
                \  let oldma=&ma | let &ma=1 |
                \  silent exe "%!xxd -r -g 2 -c 16" |
                \  let &ma=oldma | let &ro=oldro |
                \  unlet oldma | unlet oldro |
                \ endif
    au BufWritePost *
                \ if &binary |
                \  let oldro=&ro | let &ro=0 |
                \  let oldma=&ma | let &ma=1 |
                \  silent exe "%!xxd -g 2 -c 16" |
                \  exe "set nomod" |
                \  let &ma=oldma | let &ro=oldro |
                \  unlet oldma | unlet oldro |
                \ endif
augroup END

" colorscheme last word
colorscheme minimal_dark

hi User1 guifg=#eeeeee guibg=#111111
hi User2 guifg=#999999 guibg=#111111
hi User3 guifg=#6f5faf guibg=#111111
hi User4 guifg=#af875f guibg=#111111
hi User5 guifg=NvimLightYellow guibg=#111111
hi MatchedBinary guifg=#111111 guibg=#6f5faf
hi def link lCursor Cursor
