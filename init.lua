-- *****************************************
-- プラグイン設定
-- *****************************************
require("plugins")

-- *****************************************
-- 基本設定
-- *****************************************
require("basic")

-- *****************************************
-- スーパースペース設定
-- *****************************************
local space = require("super_space")

-- *****************************************
-- userフォルダ配下のファイルを全て読み込み
-- *****************************************
-- ユーザー設定用ディレクトリのパスを設定
local user_config_dir = vim.fn.stdpath("config") .. '/lua/user'

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
-- カレントディレクトリの `.nvim/init.lua` があればロードする
-- *****************************************
local local_init = vim.fn.getcwd() .. "/.nvim/init.lua"
if vim.fn.filereadable(local_init) == 1 then
    dofile(local_init)
end
