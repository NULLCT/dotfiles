"----------検索----------
set ignorecase "検索するときに大文字小文字を区別しない
set smartcase "小文字で検索すると大文字と小文字を無視して検索
set incsearch "インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
set hlsearch "検索結果をハイライト表示

"----------表示設定----------
syntax enable "シンタックスハイライト
colorscheme desert "カラースキームをdesertに
set cursorline "カーソルのある行を強調表示
set noerrorbells "エラーメッセージの表示時にビープを鳴らさない
set shellslash "Windowsでパスの区切り文字をスラッシュで扱う
set showmatch matchtime=1 "対応する括弧やブレースを表示
set showcmd "ウィンドウの右下にまだ実行していない入力中のコマンドを表示
set display=lastline "省略されずに表示
set list "タブ文字を CTRL-I で表示し、行末に $ で表示する
set listchars=tab:»\ ,trail:~,space:･,eol:↲,extends:»,precedes:«,nbsp:% "行末のスペースを可視化
set expandtab "入力モードでTabキー押下時に半角スペースを挿入
set shiftwidth=2 "インデント幅
set softtabstop=2 "タブキー押下時に挿入される文字幅を指定
set tabstop=2 "ファイル内にあるタブ文字の表示幅
set guioptions-=T "ツールバーを非表示にする
set guioptions+=a "yでコピーした時にクリップボードに入る
set guioptions+=R "右スクロールバーを非表示
set smartindent "改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set noswapfile "スワップファイルを作成しない
set nofoldenable "検索にマッチした行以外を折りたたむ(フォールドする)機能
set title "タイトルを表示
set number "行番号の表示
set relativenumber "行番号を動的表示
set clipboard=unnamed,autoselect "ヤンクでクリップボードにコピー
set nrformats= "すべての数を10進数として扱う
set mouse=a "バッファスクロール
"set completeopt=menuone,noinsert "補完
augroup HighlightTrailingSpaces "行末のスペースを可視化
  autocmd!
    autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

"----------ステータスライン----------
set laststatus=2
set statusline=%F%m%h%w[%Y]\ %=%<[%{&fenc!=''?&fenc:&enc}\/%{&ff}][\%03.3b/%04v:%04l/%L\]

"----------キーマップ----------
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

"----------その他----------
set nowritebackup "ファイルを上書きする前にバックアップを作ることを無効化
set nobackup
let _curfile=expand("%:r") "Makefileを書いてるときにtabにする
if _curfile == 'Makefile'
  set noexpandtab
endif
function! s:SID_PREFIX() "tabを便利に使うために
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示
" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor