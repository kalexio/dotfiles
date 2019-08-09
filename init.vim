" ==============================================================================
"                       kalexio's neovim configuration
" ==============================================================================
"
" My simple neovim (vim compatible) configurations in order to use
" neovim like a lightweight IDE :)

" ==============================================================================
" 1. Set common options
" ==============================================================================

"filetype plugin on   " some of vim's built-in features are implemented with
                      " vim script which will work when plugins are enabled
"syntax on            " What is this doing?
set colorcolumn=81    " set the 80th character column
set number            " show number line of the files
set splitbelow        " horizontal split below current (when opening new file)
set splitright        " vertical split right of current (when opening new file)

if (has("termguicolors"))
    set termguicolors " enable 256 true colors
endif

set showmatch         " highlight matching [{()}]
set tags=./tags,tags; " neovim looks for a tags file in the directory of the current file
                      " and in the working directory (from which you launched neovim)
set path=$PWD/**      " search down into subfolders for a specific file with ":find" command
                      " this will set your search path variable to current directory
                      " (from which you launched neovim) and to all directories under current directory recursively
set mouse=v           " enable mouse usage (for selecting, copying etc with mouse)
set noshowmode        " mode information is displayed from the lightline plugin from now on

" Tabulation and spaces
set tabstop=2         " show existing tab with 2 spaces width
set shiftwidth=2      " when identing with tab use 2 spaces width
set softtabstop=2     " on pressing tab, insert 2 spaces
set expandtab         " tabs are spaces

" Invisible characters
set list              " reveal hidden characters (tabs, trail, nbsp) :set listchars? for more
set listchars=tab:<->,trail:-,nbsp:+

" Search
set ignorecase        " case insensitive search
set smartcase         " case sensitive only if search contains uppercase letter
" ==============================================================================

" ==============================================================================
" 2. Key Binding/Mapping
" ==============================================================================

" make these commonly mistyped commands still work as expected
command! WQ wq
command! Wq wq
command! W w
command! Q q

" SEARCH PROJECT-WIDE (IDE emulation)

" cscope
if has("cscope")
  " add any database in current directory
  if filereadable("cscope.out")
      silent cs add cscope.out
  endif
endif

" ctags (jumping to definitions)
" for global configuration edit ~/.ctags file
" update tags from neovim (--exclude to exclude folders)
command! MakeTags !ctags -R .

" Fast searching inside neovim
" use Ag with [ack.vim] plugin (as ag a.k.a the silver searcher is
" faster than ack and grep)
" :grep command can still be used as a new command
" :Ack has been created by this plugin
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" search the word under the cursor in the files of the project
" using Ack plugin (<C-r><C-w> copies the word under the cursor)
nmap <F3> :Ack --ignore=tags <c-r>=expand("<cword>")<cr><cr>

" don't jump to the first result automatically
cnoreabbrev Ack Ack!

" open/close tagbar plugin with F2
nmap <F2> :TagbarToggle<CR>

" list all loaded buffers and wait my selection
" this map works in normal mode and is not recursive
nnoremap gb :ls<CR>:b<Space>

" traverse easier the buffer list
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
" ==============================================================================

" ==============================================================================
" 3. Plugin section
" ==============================================================================

" Specify the directory for plugins of vim-plug
call plug#begin('~/.local/share/nvim/plugged')

Plug 'bronson/vim-trailing-whitespace' " Clean with trailing spaces :FixWhitespace command
Plug 'majutsushi/tagbar' " File scope
Plug 'morhetz/gruvbox' " Nice colorscheme
Plug 'tpope/vim-fugitive' "Git wrapper
Plug 'tpope/vim-vinegar' " Enhance file editor netrw (now the netrw does not open in a new split window)
Plug 'itchyny/lightline.vim' " Status line at the bottom
Plug 'mileszs/ack.vim' " Fronted for searching with ag (faster than grep for programming) and present the results in quickfix
Plug 'airblade/vim-gitgutter' " Shows a git diff

call plug#end()
" ==============================================================================

" ==============================================================================
" 4. Plugin Configuration
" ==============================================================================

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" Colorscheme configuration
set background=dark
let g:gruvbox_italic=1
colorscheme gruvbox
" ==============================================================================


" TODO highlight hidden characters
" TODO use quickfix with csope
" TODO use quickfix with ctags
