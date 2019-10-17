"ファイルを上書きする前にバックアップを作ることを無効化
set nowritebackup
set nobackup
"vimの矩形選択で文字がなくても右に進める
set virtualedit=block
"挿入モードでバックスペースで削除できるようにする
set backspace=indent,eol,start
"全角文字専用の設定
set ambiwidth=double
"wildmenuオプションを有効
set wildmenu

"##表示設定##
"エラーメッセージの表示時にビーぷを鳴らさない
set noerrorbells
" 行番号を追加
set number
" 行が折り返し表示されていた場合、行単位ではなく表示行単位でカーソルを移動する
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk
" カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set whichwrap=b,s,h,l,<,>,[,],~
" カーソルラインハイライト
set cursorline
" 編集中のファイル名を表示
set title
"括弧入力時に対応する括弧を表示
set showmatch matchtime=1
"インデント方法の変更
set cinoptions+=0
"メッセージの表示欄を２行確保
set cmdheight=2
"ステータス行を常に表示
set laststatus=2
"ウィンドウの右下にまだ実行していない入力中のコマンドを表示
set showcmd
"省略されずに表示
set display=lastline
"コードの色分け
syntax on
"インデントをスペース4つ分に設定
set tabstop=4
"タブ入力を複数の空白入力に置き換える
set expandtab
" 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set softtabstop=4
"オートインデント
set smartindent
set autoindent
set shiftwidth=4
set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数
 
"##検索設定##
"大文字/小文字の区別なく検索
set ignorecase
"検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
"検索時最後まで行ったら最初に戻る
set wrapscan
"インクリメンタル検索（検索ワードの最初の文字を入力した時点で検索が開始）
set incsearch
"検索結果をハイライト表示
set hlsearch

""""""""""""""""""""""""""""""
" プラグインのセットアップ
""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" ファイルオープンを便利に
"Plug 'Shougo/unite.vim'
" Unite.vimで最近使ったファイルを表示できるようにする
"Plug 'Shougo/neomru.vim'
" カラースキームmolokai
Plug 'tomasr/molokai'
" ステータスラインの表示内容強化
Plug 'itchyny/lightline.vim'
" ファイルをtree表示してくれる
Plug 'scrooloose/nerdtree'
" 末尾の全角と半角の空白文字を赤くハイライト
Plug 'bronson/vim-trailing-whitespace'
"Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}


call plug#end()
""""""""""""""""""""""""""""""
"----------------------------------------------------------
" molokaiの設定
"----------------------------------------------------------

colorscheme molokai " カラースキームにmolokaiを設定する


set t_Co=256 " iTerm2など既に256色環境なら無くても良い
syntax enable " 構文に色を付ける

"----------------------------------------------------------
" ステータスラインの設定
"----------------------------------------------------------
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの現在位置を表示する

nnoremap <silent><C-e> :NERDTreeToggle<CR>
