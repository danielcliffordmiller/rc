syntax on
set softtabstop=4
set tabstop=8
set shiftwidth=4
set noexpandtab
set ruler
set relativenumber
set hlsearch
set incsearch
"set ts=4 sts=4 sw=4 noexpandtab

" set cindent
set smartindent

set backspace=indent,eol,start

set noswapfile

set modelines=1

set foldlevelstart=0
set foldcolumn=2

set laststatus=2

set mouse=n

let g:slimv_swank_cmd = '!osascript -e "tell application \"Terminal\" to do script \"sbcl --load ~/.vim/slime/start-swank.lisp\""'

" let java_highlight_java_lang_ids=1
" let java_highlight_functions="style"
" let java_highlight_all=1

let mapleader = ","

let g:vrc_split_request_body = 1
let g:vrc_trigger = '<leader>r'
let g:vrc_set_default_mapping = 1

nnoremap <tab> %
xnoremap <tab> %
onoremap <tab> %

nnoremap <leader>h :nohlsearch<cr>

vnoremap * l`<y`>/"<cr>
vnoremap # l`<y`>?"<cr>

nnoremap <leader>l :source %<cr>
inoremap <leader>u viWUA
"nnoremap <leader>j :silent ! tmux paste-buffer -t:1.3; tmux send -t:1.3 Enter:redraw!
"nnoremap <leader>b :silent ! tmux send -t:.2 Enter; tmux send -t:.2 './gradlew build' Enter:redraw!
"nnoremap <leader>r :silent ! tmux send -t:.2 Enter; if pgrep -f -q $(pwd); then tmux send -t:.2 C-c; else tmux send -t:.2 './gradlew bootRun' Enter; fi:redraw!
"nnoremap <leader>t :silent ! tmux send -t:.2 Enter; tmux send -t:.2 './gradlew test --info' Enter:redraw!

" Vimscript autocmds ----------------------------{{{
if has("autocmd")
    " perl autocmds {{{
    augroup filetype_perl
	autocmd!
	autocmd FileType perl nnoremap <buffer> <leader>r :!perl %<cr>
	autocmd FileType perl nnoremap <buffer> <leader>d :!perl -d %<cr>
    augroup END "}}}
    " vimrc autocmds {{{
    augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
    augroup END "}}}
    " netrw autocmds {{{
    augroup filetype_netrw
	autocmd!
	autocmd FileType netrw nunmap <buffer> <LeftMouse>
	autocmd FileType netrw nmap <buffer> <2-LeftMouse> <Plug>NetrwLeftmouse
    augroup END "}}}
    " yaml autocmds {{{
    augroup filetype_yaml
	autocmd!
	autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead service.yml,ingress.yml,deployment.yml nnoremap <buffer> <leader>r :! kubectl apply -f %<cr>
    augroup END "}}}
    " json autocmd {{{
    augroup filetype_json
	autocmd FileType json set expandtab
    augroup END "}}}
    " javascript autocmds {{{
    augroup filetype_javascript
	autocmd FileType javascript nnoremap <buffer> <leader>r :! node %<cr>
	autocmd FileType javascript nnoremap <buffer> <leader>d :! node inspect %<cr>
	autocmd FileType javascript set sw=0 sts=0 ts=2
    augroup END "}}}
    " fugitive autocmds {{{
    augroup filetype_gitcommit
	"autocmd FileType gitcommit nnoremap <buffer> dc :Gdiff --cached<cr>
    augroup END "}}}
    " groovy autocmds {{{
    augroup filetype_groovy
	autocmd FileType groovy setlocal expandtab
    augroup END "}}}
    " java autocmds {{{
    augroup filetype_java
	autocmd!
	autocmd FileType java set omnifunc=javacomplete#Complete
	autocmd FileType java setlocal expandtab
	autocmd FileType java nnoremap <leader>c I//<esc>
	autocmd FileType java nnoremap <leader>C ^2x
	autocmd FileType java set suffixesadd=.java path+=src/main/java
	autocmd FileType java set includeexpr=substitute(v:fname,'\\.','/','g')
	autocmd FileType java set foldmethod=syntax foldlevel=1
	" autocmd FileType java set suffixesadd=.java
	" autocmd FileType java set path+=src/main/java
	" autocmd FileType java nnoremap <leader>s ^cwpublic voidldEepBbyiwvUisetf;i pa) { this.pa = pA }^2wf r(
	" autocmd FileType java nnoremap <leader>g ^cwpublicwWyiwvUigetf;i() { return pA }
    augroup END "}}}
    " augroup buffer_leave
    "    autocmd!
    "    autocmd BufRead * exe "normal :! tmux send -t:.2 'foobar';"
    " augroup END
" autocmd FileType java vnoremap <leader>c <esc>'<'>0I//<esc>
" autocmd FileType java vnoremap <leader>C <esc>'<0'>0lx
endif " }}}

set hidden

nnoremap <leader>g :Gstatus<cr>
nnoremap <leader>ev :tabe ~/.vimrc<cr>
nnoremap <leader>sv :source ~/.vimrc<cr>
nnoremap <leader>o :set rnu mouse=n<cr>
nnoremap <leader>O :set nornu mouse=<cr>

nnoremap <leader>/ :call <SID>gitGrep()<cr>
nnoremap <leader>z :copen<cr>
