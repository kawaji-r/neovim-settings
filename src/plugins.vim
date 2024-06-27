" プラグインの追加と管理
" プラグインの追加: Plug 'プラグインのリポジトリ'の形式でinit.vimにプラグインを追加します。例：Plug 'scrooloose/nerdtree'はNERDTreeプラグインを追加します。
" プラグインのインストール: Neovimを開いて、:PlugInstallコマンドを実行します。これにより、追加したプラグインがインストールされます。
" プラグインの更新: :PlugUpdateコマンドでインストールされているプラグインを更新できます。
" プラグインの削除: init.vimからプラグインの行を削除し、:PlugCleanを実行すると、不要なプラグインが削除されます。
" プラグインの確認: :PlugStatusコマンドでインストールされているプラグインの状態を確認できます。

call plug#begin(g:user_vim_dir . '/plugged')
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lambdalisue/fern.vim' " ファイラー
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'ctrlpvim/ctrlp.vim' " ファイル検索
Plug 'tpope/vim-fugitive' " Git管理
call plug#end()

" -------------------   個別設定:Fern -------------------

" Fern
let g:fern#renderer = "nerdfont"
augroup my-fern-mappings
  autocmd!
  autocmd FileType fern call s:fern_mappings()
augroup END
function! s:fern_mappings()
  nmap <buffer> cd <Plug>(fern-action-cd)
  nmap <buffer> cp <Plug>(fern-action-copy)
endfunction

" ------------------- / 個別設定:Fern -------------------