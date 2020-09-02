let mapleader=" "
syntax on   
set number
set wrap
set showcmd
set wildmenu
set hidden
set shortmess+=c

set hlsearch ":nohlsearch"
" set hlsearch exec ":nohlsearch"
set incsearch
set ignorecase
set smartcase
set number
set relativenumber

set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
" set mouse=a
set encoding=utf-8
let &t_ut=''
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set list
set listchars=tab:▸\ ,trail:▫
set scrolloff=5
set tw=0
set indentexpr=
set backspace=indent,eol,start
set foldmethod=indent
set foldlevel=99
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
set laststatus=2
set autochdir
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

map sv <C-w>t<C-w>H
map sh <C-w>t<C-w>K

noremap = nzz
noremap - Nzz
noremap <LEADER><CR> :nohlsearch<CR>

noremap l j
noremap o k
noremap k l
noremap j h
noremap L 10j
noremap O 10k
noremap K 10l
noremap J 10h

noremap m o
noremap M O
noremap h m
noremap H M

map Q :q<CR>
map W :w<CR>
map R :source $MYVIMRC<CR>
map s <nop>
map ; :

map sr :set splitright<CR>:vsplit<CR>
map sl :set nosplitright<CR>:vsplit<CR>
map su :set nosplitbelow<CR>:split<CR>
map sn :set splitbelow<CR>:split<CR>

map sv <C-w>t<C-w>H
map sh <C-w>t<C-w>K

" Pagination
map <LEADER>i <C-w>k
map <LEADER>k <C-w>j
map <LEADER>j <C-w>h
map <LEADER>l <C-w>l


" Modify page size
map <up> :resize +5<CR>
map <down> :resize -5<CR>
map <left> :vertical resize -5<CR>
map <right> :vertical resize +5<CR>

map tn :tabe<CR>
map tj :-tabnext<CR>
map tk :+tabnext<CR>

call plug#begin('~/.config/nvim/plugged')

" airline
Plug 'vim-airline/vim-airline'

" color theme
Plug 'drewtempelmeyer/palenight.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'joshdick/onedark.vim'
Plug 'KeitaNakamura/neodark.vim'

" file navigation
Plug 'junegunn/fzf.vim'

" Auto Complete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" Code commenter
Plug 'preservim/nerdcommenter'

call plug#end()

" ********************************************************************************************************************************
" ********************************************************************************************************************************
" ********************************************************************************************************************************
"
"   _____  _                _____      _   _   _
"  |  __ \| |              / ____|    | | | | (_)
"  | |__) | |_   _  __ _  | (___   ___| |_| |_ _ _ __   __ _
"  |  ___/| | | | |/ _` |  \___ \ / _ \ __| __| | '_ \ / _` |
"  | |    | | |_| | (_| |  ____) |  __/ |_| |_| | | | | (_| |
"  |_|    |_|\__,_|\__, | |_____/ \___|\__|\__|_|_| |_|\__, |
"                   __/ |                               __/ |
"                  |___/                               |___/
"
" ********************************************************************************************************************************
" ********************************************************************************************************************************
" ********************************************************************************************************************************

" ***
" FZF Setting
" ***
noremap <C-p> :Files<CR>
noremap <C-f> :Lines<CR>
noremap <C-h> :History<CR>
let g:fzf_layout = { 'window': { 'width': 0.6, 'height': 0.5 } }
let g:fzf_history_dir = '~/.config/share/fzf-history'
let g:fzf_preview_window = 'right:60%'
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept' }))

noremap <C-d> :BD<CR>

" ***
" coc.nvim
" ***
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-vimlsp',
  \ 'coc-marketplace',
  \ 'coc-tsserver',
  \ 'coc-python',
  \ 'coc-java']
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()

if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-x> to trigger completion.
inoremap <silent><expr> <c-x> coc#refresh()
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" auto find error place
" nmap <silent> [j <Plug>(coc-diagnostic-prev)
" nmap <silent> [k <Plug>(coc-diagnostic-next)

function! Show_documentation()
	call CocActionAsync('highlight')
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
nnoremap <LEADER>h :call Show_documentation()<CR>  " show help

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming. 让变量换名
nnoremap <leader>rn <Plug>(coc-rename)

" Formatting selected code. 整洁代码
nnoremap <leader>f  <Plug>(coc-format-selected)

nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" coc explorer
nmap ee :CocCommand explorer<CR>
nmap eq :CocCommand explorer --quit-on-open<CR>

" offical coc-explorer default setting
" function! s:coc_list_current_dir(args)
"   let node_info = CocAction('runCommand', 'explorer.getNodeInfo', 0)
"   execute 'cd ' . fnamemodify(node_info['fullpath'], ':h')
"   execute 'CocList ' . a:args
" endfunction
" 
" function! s:init_explorer(bufnr)
"   call setbufvar(a:bufnr, '&winblend', 50)
" endfunction
" 
" function! s:enter_explorer()
"   if !exists('b:has_enter_coc_explorer') && &filetype == 'coc-explorer'
"     " more mappings
"     nmap <buffer> <Leader>fg :call <SID>coc_list_current_dir('-I grep')<CR>
" r   nmap <buffer> <Leader>fG :call <SID>coc_list_current_dir('-I grep -regex')<CR>
"     nmap <buffer> <C-p> :call <SID>coc_list_current_dir('files')<CR>
"     let b:has_enter_coc_explorer = v:true
"   endif
"   " statusline
"   setl statusline=coc-explorer
" endfunction
" 
" augroup CocExplorerCustom
"   autocmd!
"   autocmd BufEnter call <SID>enter_explorer()
" augroup END
" 
" " hook for explorer window initialized
" function! CocExplorerInited(filetype, bufnr)
"   " transparent
"   call setbufvar(a:bufnr, '&winblend', 10)
" endfunction


" ***
" Markdown Preview Setting
" ***
" nvim will open the preview window after entering the markdown buffer
let g:mkdp_auto_start = 0
" auto refresh markdown as you edit or move the cursor
let g:mkdp_refresh_slow = 0
" the MarkdownPreview only can be use in markdown file
let g:mkdp_command_for_global = 0
" use custom IP to open preview page, default is 127.0.0.1
let g:mkdp_open_ip = '127.0.0.1'
" specify browser to open preview page
" let g:mkdp_browser = ''
" use a custom markdown style must be absolute path
let g:mkdp_markdown_css = '~/.config/Typora/themes/whitey.css'
" preview page title
let g:mkdp_page_title = '「${name}」'
" use a custom port to start server or random for empty
let g:mkdp_port = '2020'
" options for markdown render
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false
    \ }
" MarkdownPreview key mappings
nmap <LEADER>ss <Plug>MarkdownPreview
nmap <LEADER>se <Plug>MarkdownPreviewStop
nmap <LEADER>st <Plug>MarkdownPreviewToggle


" ***
" nerdcommenter
" ***
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1
" key mappings setting
" Comment out the current line or text selected in visual mode.
nmap <LEADER>cc <Plug>NERDCommenterComment<CR>
" Forces nesting comment out the current line or text selected in visual mode.
nmap <LEADER>ci <Plug>NERDCommenterNested<CR>
" Uncomments the selected line(s).
nmap <LEADER>cu <Plug>NERDCommenterUncomment<CR>


" **
" Color scheme
" ***
" colorscheme palenight
colorscheme nord
" colorscheme onedark
" colorscheme neodark
" hi Normal ctermbg=none
hi Normal ctermbg=235
let g:ctermbg_flag = 0
func! ChangeBackground()
  if g:ctermbg_flag == 0
    hi Normal ctermbg=none
    let g:ctermbg_flag = 1
  else
    hi Normal ctermbg=235
    let g:ctermbg_flag = 0
  endif
endfunction
" hi Normal ctermfg=252 ctermbg=none
" nmap bn :hi Normal ctermbg=none<CR>
" nmap bb :set background=dark<CR>
nmap <LEADER>bb :call ChangeBackground()<CR>
nmap <LEADER>bt :Colors<CR>


" ********************************************************************************************************************************
" ********************************************************************************************************************************
" ********************************************************************************************************************************
"
"   __  __          ____  _   _                  _____      _   _   _
"  |  \/  |        / __ \| | | |                / ____|    | | | | (_)
"  | \  / |_   _  | |  | | |_| |__   ___ _ __  | (___   ___| |_| |_ _ _ __   __ _
"  | |\/| | | | | | |  | | __| '_ \ / _ \ '__|  \___ \ / _ \ __| __| | '_ \ / _` |
"  | |  | | |_| | | |__| | |_| | | |  __/ |     ____) |  __/ |_| |_| | | | | (_| |
"  |_|  |_|\__, |  \____/ \__|_| |_|\___|_|    |_____/ \___|\__|\__|_|_| |_|\__, |
"           __/ |                                                            __/ |
"          |___/                                                            |___/
"
" ********************************************************************************************************************************
" ********************************************************************************************************************************
" ********************************************************************************************************************************
"语言设置

"这里嘛。。是用来一键编译代码的
noremap <A-c> :call CompileRunGcc()<CR>
func! CompileRunGcc()
  exec "w"
  if &filetype == 'c'
    exec "!g++ % -o %<"
    exec "!time ./%<"
  elseif &filetype == 'cpp'
    set splitbelow
    exec "!g++ -std=c++11 % -Wall -o %<"
    :sp
    :res -10
    :term ./%<
    exec "!rm -rf ./%<"
  elseif &filetype == 'java'
    exec "!javac %"
    exec "!time java %<"
  elseif &filetype == 'sh'
    :!time bash %
  elseif &filetype == 'python'
    set splitbelow
    :sp
    :term python3 %
  elseif &filetype == 'html'
    silent! exec "!" google-chrome-stable " % &"
  elseif &filetype == 'markdown'
    exec "InstantMarkdownPreview"
  elseif &filetype == 'tex'
    silent! exec "VimtexStop"
    silent! exec "VimtexCompile"
  elseif &filetype == 'dart'
    exec "CocCommand flutter.run -d ".g:flutter_default_device
    CocCommand flutter.dev.openDevLog
  elseif &filetype == 'javascript'
    set splitbelow
    :sp
    :term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
  elseif &filetype == 'go'
    set splitbelow
    :sp
    :term go run .
  endif
endfunc

"每次创建C++文件都会初始化一些内容
autocmd BufNewFile *.cpp exec ":call CppInit()"
func CppInit()
  if expand("%:e") == "cpp"
    call setline(1,"/*")
    call setline(2,"*******************************************************************")
    call setline(3,"Author:                Sun")
    call setline(4,"Date:                  ".strftime("%Y-%m-%d"))
    call setline(5,"FileName：             ".expand("%"))
    call setline(6,"Copyright (C):         ".strftime("%Y")." All rights reserved")
    call setline(7,"*******************************************************************")
    call setline(8,"*/")
    call setline(9,"#include<iostream>")
    call setline(10,"")
    call setline(11,"int main(int argc, const char *argv[]){")
    call setline(12,"")
    call setline(13,"  return 0;")
    call setline(14,"}")
  endif
endfunc

autocmd BufNewFile * normal G'
