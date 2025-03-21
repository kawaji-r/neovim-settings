-- *****************************************
-- 基本設定
-- *****************************************
require("system.basic")

-- *****************************************
-- プラグイン設定
-- *****************************************
require("system.plugin")

-- *****************************************
-- スーパースペース設定
-- *****************************************
local space = require("system.super_space")
-- local menu_list = {}
-- space.add_menu(menu_list)

-- *****************************************
-- userフォルダ配下のファイルを全て読み込み
-- *****************************************
-- ユーザー設定用ディレクトリのパスを設定
local user_config_dir = vim.fn.stdpath("config") .. '/user'

-- 指定ディレクトリ内の全ファイルを取得（改行区切りの文字列をテーブルに変換）
local files = vim.fn.split(vim.fn.glob(user_config_dir .. '/*'), '\n')

for _, file in ipairs(files) do
  if file:match('%.lua$') then
    -- Lua ファイルの場合は dofile で実行
    dofile(file)
  elseif file:match('%.vim$') then
    -- Vimscript ファイルの場合は source で読み込み
    vim.cmd('source ' .. file)
  end
end

-- *****************************************
-- 最後に読まないと都合の悪いもの
-- *****************************************
require("system.defer")
