" プラグインの追加と管理
" プラグインの追加: Plug 'プラグインのリポジトリ'の形式でinit.vimにプラグインを追加します。例：Plug 'scrooloose/nerdtree'はNERDTreeプラグインを追加します。
" プラグインのインストール: Neovimを開いて、:PlugInstallコマンドを実行します。これにより、追加したプラグインがインストールされます。
" プラグインの更新: :PlugUpdateコマンドでインストールされているプラグインを更新できます。
" プラグインの削除: init.vimからプラグインの行を削除し、:PlugCleanを実行すると、不要なプラグインが削除されます。
" プラグインの確認: :PlugStatusコマンドでインストールされているプラグインの状態を確認できます。

call plug#begin(g:user_vim_dir . '/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sainnhe/everforest' " テーマ追加
Plug 'lambdalisue/fern.vim' " ファイラー
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
" Plug 'ctrlpvim/ctrlp.vim' " ファイル検索
Plug 'dinhhuy258/git.nvim' " Git管理
Plug 'nvim-lua/plenary.nvim' " ファイル検索
Plug 'nvim-telescope/telescope.nvim' " ファイル検索
Plug 'norcalli/nvim-colorizer.lua' " 色付け
Plug 'numToStr/Comment.nvim' " コメントアウト
call plug#end()

" -------------------   個別設定:Fern -------------------
let g:fern#renderer = "nerdfont"
augroup my-fern-mappings
  autocmd!
  autocmd FileType fern call s:fern_mappings()
augroup END
function! s:fern_mappings()
  nmap <buffer> cd <Plug>(fern-action-cd)
  nmap <buffer> cp <Plug>(fern-action-copy)
endfunction
let g:fern#default_hidden = 1
" ------------------- / 個別設定:Fern -------------------

" -------------------   個別設定:Telescope -------------------
nnoremap <C-p> :Telescope find_files<CR>
" ------------------- / 個別設定:Telescope -------------------

" -------------------   個別設定:Coc -------------------
highlight CocErrorSign ctermfg=15 ctermbg=196
highlight CocWarningSign ctermfg=0 ctermbg=172
" ------------------- / 個別設定:Coc -------------------

" -------------------   個別設定:Comment -------------------
" Luaブロック
lua << EOF
-- Comment.nvimのセットアップ（デフォルトのマッピングを無効化）
require('Comment').setup({
  mappings = {
    basic = false,
    extra = false,
  },
})

-- ノーマルモードで<C-/>（内部的には<C-_>）のマッピング
vim.api.nvim_set_keymap(
  'n',
  '<C-_>',
  '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>',
  { noremap = true, silent = true }
)

-- ビジュアルモードで<C-/>（内部的には<C-_>）のマッピング
vim.api.nvim_set_keymap(
  'v',
  '<C-_>',
  '<esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
  { noremap = true, silent = true }
)
EOF
" ------------------- / 個別設定:Comment -------------------
