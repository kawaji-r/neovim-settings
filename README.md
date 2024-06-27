## Install
git clone git@github.com:kawaji-r/vim-settings.git ~/.config/nvim

## Structure
* init.lua・・・設定ファイル
* src/ginit.lua・・・GUI用設定ファイル
* src/plugins.vim・・・プラグイン関連の設定を記述
* src/space_functions.lua・・・プラグイン関連の設定を記述
* backup・・・バックアップフォルダ（init.luaで定義）
* user_src・・・この中のvimファイルを読み込まれる。ユーザー定義用。
* autoload・・・vim-plugを利用するために必要
* plugged・・・システム利用
