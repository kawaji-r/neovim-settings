## インストール
git clone git@github.com:kawaji-r/neovim-settings.git ~/.config/nvim

## 使い方
### Git
- 使用プラグイン
    - `sindrets/diffview.nvim`
    - `lewis6991/gitsigns.nvim`
- 差分表示: コマンド`DiffviewOpen`（SuperSpace[2]にマッピング）
- 変更履歴表示: コマンド`DiffviewFileHistory %`（SuperSpace[3]にマッピング）
- ファイルパネルで `s` → ステージとアンステージをトグル
- コマンド`require('gitsigns').stage_hunk()` → 現在のハンクをステージ（SuperSpace[4]にマッピング）
- コマンド`require('gitsigns').next_hunk()` → 次のハンクへ移動（ `]c` にマッピング）

