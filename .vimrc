" fix backspace
set backspace=indent,eol,start

" seemed to need this for vim within my precise32 vagrant box
" otherwise utf stuff in this .vimrc (`listchars`) would fail
set encoding=utf-8
set fileencoding=utf-8

" to keep karma happy
set backupcopy=yes

" nerdcommenter settings
let g:NERDCustomDelimiters = {'scss': { 'left': '//' }}

execute pathogen#infect()
let g:syntastic_python_checkers = ['pyflakes', 'flake8']
let g:syntastic_javascript_checkers = ['eslint']
syntax on

" count hyphenated words as words
set iskeyword+=-

" Emacs-like beginning and end of line.
imap <c-e> <c-o>$
imap <c-a> <c-o>^

command! Q q " Bind :Q to :q
command! Qall qall
command! QA qall
command! E e
command! W w
command! Wq wq

" Same deal with X - don't ask me for encryption key, do same as `x`
cnoreabbrev X x

" ctrl p - disable 'working path mode' so can always find
" files relative to the (root) dir you launched vim from/cd'd to
let g:ctrlp_working_path_mode = 0

" stop being a nub
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

set rnu
set tabstop=4
set shiftwidth=4
set expandtab

" style-guide (120 minus 8)
:set colorcolumn=112

set autoindent
set smartindent
filetype indent on

" for nerdcommenter
filetype plugin on

set runtimepath^=~/.vim/bundle/ctrlp.vim

" theme
set t_Co=256
" colorscheme Tomorrow-Night-Bright
" color dracula

" theme - because otherwise syntastic error highlighting is unreadable
hi SpellBad ctermfg=015 ctermbg=160 guifg=#ffffff guibg=#d70000
hi SpellCap ctermfg=015 ctermbg=160 guifg=#ffffff guibg=#d70000

" ctrl-s to save
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" Insert a linebreak (with Ctrl-J) without leaving normal mode
:nnoremap <NL> i<CR><ESC>

" jk and kj to escape
" :imap jk <Esc>
" :imap kj <Esc>

" leader
let mapleader=','

nnoremap <leader>cd :cd %:p:h<CR>

" ,ew - expands to e: /path/to/dir/of/current/file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" HN
nmap <leader>h :HackerNews<CR>

" quickly edit vimrc
nmap <leader>v :tabedit $MYVIMRC<CR>

" quickly edit db_pw.py
nmap <leader>db :tabedit ~/.hive/db_pw.py<CR>

" invisibles (vimcasts) - Shortcut to toggle `set list`
nmap <leader>l :set list!<CR>

" shell commands
nmap <leader>g :!grunt<CR>
nmap <leader>b :!npm run browserify<CR>

" set paste
nmap <leader>p :set paste<CR>

" change current working dir to dir of current file -- keywords: pwd, cwd
nmap <leader>d :cd %:p:h<CR>

" ignore case on searches
nmap <leader>i :set ignorecase!<CR>

" wrap visual selection in an HTML tag
vmap <Leader>w <Esc>:call VisualHTMLTagWrap()<CR>
function! VisualHTMLTagWrap()
  let tag = input("Tag to wrap block: ")
  if len(tag) > 0
    normal `>
    if &selection == 'exclusive'
      exe "normal i</".tag.">"
    else
      exe "normal a</".tag.">"
    endif
    normal `<
    exe "normal i<".tag.">"
    normal `<
  endif
endfunction

" SYNTAX
" markdown for `.md` file extensions
au BufRead,BufNewFile *.md set filetype=markdown

" The Silver Searcher
" https://robots.thoughtbot.com/faster-grepping-in-vim
" ----------------------------------------------------
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" bind \ (backward slash) to grep shortcut
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

" ---- End The Silver Searcher -----------------------

" bind <leader>q to close the quickfix menu
map <leader>q :cclose<CR>

" open quickfix selections in a new tab
set switchbuf+=usetab,newtab

" mkdir - automatically make dirs if don't exist, when saving a file
" via: https://pbrisbin.com/tags/vim
function! Mkdir()
  let dir = expand('%:p:h')

  if !isdirectory(dir)
    call mkdir(dir, "p")
    echo "created non-existing directory: " . dir
  endif
endfunction

autocmd BufWritePre * call Mkdir()
