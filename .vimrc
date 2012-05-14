" vi互換off
set nocompatible
" カラースキーマ
colorscheme desert

" 文字コードの自動認識 http://www.kawaz.jp/pukiwiki/?vim#cb691f26
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" ファイルタイプの自動識別
filetype on
filetype plugin on

" コマンドライン補完
set wildmenu
" ステータスラインを末尾2行目に表示
set laststatus=2
" ステータスライン　http://sourceforge.jp/magazine/07/11/06/0151231
:set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
" モード：ステータスラインカラー
augroup statuslinechangebymode
  autocmd!
  autocmd InsertEnter * highlight StatusLine guifg=Black guibg=Gray gui=none ctermfg=Black ctermbg=Gray cterm=none
  autocmd InsertLeave * highlight StatusLine guifg=White guibg=Blue gui=none ctermfg=White ctermbg=Blue cterm=none
augroup END

" 右下ルーラー
set ruler
" カーソル行にライン
set cursorline

syntax on
set showcmd

" 制御コードの表示
" set list
" 制御コードの表意フォーマット
"set listchars=eol:c,tab:xy
"" 行番号の表示
set number
" カーソルの行頭、行末の移動
set whichwrap=b,s,h,l,<,>,[,]
" カーソルを表示行単位で移動
noremap j gj
noremap k gk
" クリップボードの操作
"set clipboard+=unnamed


" 新しい行はC言語スタイルのインデント
set cindent
" 高度な自動インデント
set smartindent

" tabを空白文字に
set expandtab
" 4tab
set ts=4


" インクリメンタル検索を有効
set incsearch
" 検索文字をハイライト
set hlsearch
" 検索文字の大文字、小文字を区別しない
set ic
" 検索時に大文字を含んでいたら大小区別
set smartcase
" 検索を先頭へ戻さない
set nowrapscan

" 入力時に対となる(){}の報告
set showmatch

