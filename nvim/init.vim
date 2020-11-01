"-----Vim-Plug auto install-----"
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"-----Plugin-----"
call plug#begin(stdpath('data') . '/plugged')
"ColorScheme
Plug 'sainnhe/gruvbox-material'

"Status
Plug 'vim-airline/vim-airline'

"File explor
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ryanoasis/vim-devicons', { 'on': 'NERDTreeToggle' }

"Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

"Complete
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'jiangmiao/auto-pairs'

"Looks
Plug 'sheerun/vim-polyglot'
Plug 'Yggdroot/indentLine'

"Add function
Plug 'markonm/traces.vim'
Plug 'liuchengxu/vista.vim'
call plug#end()

"--------Vim Setting--------"
"Search
set ignorecase
set smartcase
set incsearch
set hlsearch
set nofoldenable

"Hightlight and Color
syntax on
set background=dark
set cursorline
set showmatch matchtime=1

"Look
set termguicolors
set title
set number
set relativenumber
set showcmd
set display=lastline
set pumblend=16
set noshowmode
set list
set listchars=tab:=>,trail:·
language messages en_US.UTF-8
if exists('$TMUX') && !exists('$NORENAME')
  au BufEnter * if empty(&buftype) | call system('tmux rename-window "nvim->"'.expand('%:t:S')) | endif
  au VimLeave * call system('tmux set-window automatic-rename on')
endif

"Edit
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set autoindent
set smartindent
set clipboard+=unnamedplus
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif

"File
set noswapfile
set nowritebackup
set nobackup

"-----KeyMap-----"
"nvim
let mapleader="\<Space>"

"nerdtree
map <Leader>n :NERDTreeToggle<CR>

"vim-lsp
nmap <buffer> <leader>rn <plug>(lsp-rename)
nmap <buffer> <leader>K <plug>(lsp-hover)

"vista
map <Leader>v :Vista!!<CR>

"-----Plugin Setting-----"
"gruvbox-material
let g:gruvbox_material_palette = 'material'
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_enable_italic = 1
colorscheme gruvbox-material

highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

"airline
let g:airline_powerline_fonts = 1

"indentLine
let g:indentLine_char = '¦' "use ¦, ┆ or │

"fzf
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

"vim-lsp
let g:lsp_signs_error = {'text': '✗'}
if executable('clangd')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'allowlist': ['c','cpp'],
        \ })
endif
if executable('pyls')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
endfunction
augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"acynccomplete-file
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
\ 'name': 'file',
\ 'whitelist': ['*'],
\ 'priority': 10,
\ 'completor': function('asyncomplete#sources#file#completor')
\ }))

"vista
let g:vista_default_executive = 'vim_lsp'
let g:vista_icon_indent = ["╰ ", "├ "]
