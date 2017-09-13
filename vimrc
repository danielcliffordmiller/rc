syntax on
set softtabstop=4
set tabstop=4
set shiftwidth=4
set noexpandtab
set ruler
set relativenumber
set hlsearch
"set ts=4 sts=4 sw=4 noexpandtab

nmap <F5> :! perl -c %
nmap <F6> :! perl %
nmap <F7> :! perl -d %

set mouse=n

let g:slimv_swank_cmd = '!osascript -e "tell application \"Terminal\" to do script \"sbcl --load ~/.vim/slime/start-swank.lisp\""'

let java_highlight_java_lang_ids=1
let java_highlight_functions="style"
let java_highlight_all=1

let mapleader = ""

nnoremap <leader>j :! tmux paste-buffer -t:1.3; tmux send -t:1.3 Enter
nnoremap <leader>b :! tmux send -t:.2 Enter; tmux send -t:.2 './gradlew build' Enter
nnoremap <leader>r :! tmux send -t:.2 Enter; if pgrep -f -q $(pwd); then tmux send -t:.2 C-c; else tmux send -t:.2 './gradlew bootRun' Enter; fi
nnoremap <leader>t :! tmux send -t:.2 Enter; tmux send -t:.2 './gradlew test --info' Enter

if has("autocmd")
	augroup filetype_netrw
		autocmd!
		autocmd FileType netrw nunmap <buffer> <LeftMouse>
		autocmd FileType netrw nmap <buffer> <2-LeftMouse> <Plug>NetrwLeftmouse
	augroup END
	augroup filetype_yaml
		autocmd!
		autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
		autocmd BufRead ingress.yml,deployment.yml nnoremap <buffer> <leader>r :! kubectl apply -f %
	augroup END
	augroup filetype_groovy
		autocmd FileType groovy setlocal expandtab
	augroup END
	augroup filetype_java
		autocmd Filetype java setlocal omnifunc=javacomplete#Complete
		autocmd!
		autocmd FileType java setlocal expandtab
		autocmd FileType java nnoremap <leader>c I//<esc>
		autocmd FileType java nnoremap <leader>C ^2x
        autocmd FileType java nnoremap <leader>s ^cwpublic voidldEepBbyiwvUisetf;i pa) { this.pa = pA }^2wf r(
        autocmd FileType java nnoremap <leader>g ^cwpublicwWyiwvUigetf;i() { return pA }
	augroup END
	" augroup buffer_leave
	" 	autocmd!
	" 	autocmd BufRead * exe "normal :! tmux send -t:.2 'foobar';"
	" augroup END
" autocmd FileType java vnoremap <leader>c <esc>'<'>0I//<esc>
" autocmd FileType java vnoremap <leader>C <esc>'<0'>0lx
endif

nnoremap <leader>ev :tabe ~/.vimrc
nnoremap <leader>sv :source ~/.vimrc
nnoremap <leader>o :set rnu mouse=n
nnoremap <leader>O :set nornu mouse=

