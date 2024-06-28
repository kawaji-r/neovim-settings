-- ユーザーフォルダ設定
vim.g.user_vim_dir = vim.fn.expand('<sfile>:p:h')

-- エラーキャプチャ関数
local function capture_init_error(msg)
    local errmsg = "Error in init.lua: " .. tostring(msg)
    local log_file = vim.g.user_vim_dir .. '/logs/error.log'
    local f = io.open(log_file, "a")
    if f then
        f:write(errmsg .. "\n")
        f:close()
    end
    print(errmsg)
end

-- エラーハンドリングを設定
local status, err = pcall(function()

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- -------------------- シンプル設定 --------------------
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.showtabline = 2
vim.opt.ignorecase = false
-- 日本語の幅がおかしいため、設定
vim.opt.ambiwidth = 'double'
-- タブや改行を表示 (list:表示)
vim.opt.list = true
-- どの文字でタブや改行を表示するかを設定
vim.opt.listchars = 'tab:>-,extends:<,trail:-,eol:~'
vim.opt.display:append("lastline")
-- ------------------- / シンプル設定 -------------------

-- -------------------- シンプルMAP --------------------
vim.api.nvim_set_keymap('v', '*', ':<C-u>lua VisualSearch()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-j>', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-h>', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-k>', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-l>', '<C-w>l', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-right>', '<C-w>>', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-left>', '<C-w><', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-up>', '<C-w>-', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-down>', '<C-w>+', {noremap = true})
vim.api.nvim_set_keymap('n', 'Y', 'y$', {noremap = true})
-- Esc SETTINGS
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', {noremap = true})
-- ターミナルにてESCキーでインサートモード解除
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
-- ------------------- / シンプルMAP -------------------

-- -------------------- BK設定 --------------------
-- バックアップファイル
vim.g.BK = vim.g.user_vim_dir .. '/backup'
if not vim.fn.isdirectory(vim.g.BK) then
    vim.fn.mkdir(vim.g.BK)
end
vim.opt.directory = vim.g.BK
vim.opt.backupdir = vim.g.BK
vim.opt.undodir = vim.g.BK
-- ------------------- / BK設定 -------------------

-- -------------------- 外部ファイル読み込み --------------------
-- ユーザーファイル読み込み
local files = vim.fn.globpath(vim.g.user_vim_dir .. '/user_src', "*.{vim,lua}", false, true)
for _, file in ipairs(files) do
    vim.cmd('source ' .. file)
end

-- Spaceのマッピングを外部ファイルで定義
vim.cmd('source ' .. vim.g.user_vim_dir .. '/src/space_functions.lua')
-- ------------------- / 外部ファイル読み込み -------------------

-- -------------------- VimEnter設定（スクリプト読込後に実施） --------------------
-- カラーテーマ設定
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.api.nvim_command("colorscheme peachpuff") -- 気に入ったため
    end
})
-- ターミナルを開いたら入力モードに
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd("startinsert")
    end
})
-- ------------------- / VimEnter設定 -------------------

-- -------------------- 関数定義 --------------------
-- ファイルをechoする
function EchoFile(path)
    for _, line in ipairs(vim.fn.readfile(path)) do
        if line == "" then
            print(".")
        else
            print(line)
        end
    end
end

-- 選択範囲の文字列で検索
function VisualSearch()
    -- 一時的に無名レジスタの内容を保存
    local original_reg = vim.fn.getreg('@')
    -- 選択範囲を無名レジスタにヤンク
    vim.cmd('normal! gv"xy')
    -- ヤンクしたテキストを変数に格納
    local text = vim.fn.getreg('@')
    -- 元の無名レジスタの内容を復元
    vim.fn.setreg('@', original_reg)
    -- 改行をVimの検索パターン表現に変換
    local escaped_text = vim.fn.substitute(text, '\n', '\\n', 'g')
    -- 改行以降を削除
    text = vim.fn.substitute(text, '\n.*', '', '')
    -- 特殊文字のエスケープ
    escaped_text = vim.fn.escape(text, '\\.*$^~[]')
    -- 検索履歴に追加
    vim.fn.histadd('search', escaped_text)
    -- 検索パターンの設定
    vim.fn.setreg('/', escaped_text)
    vim.opt.hlsearch = true
    -- 最初の一致に移動
    vim.cmd('normal! n')
end

-- ランダムに色スキームを選択して適用する関数
function SetColorScheme()
    -- 色スキームのリストを定義
    local colorschemes = {
        'blue', 'darkblue', 'delek', 'desert', 'elflord', 
        'evening', 'industry', 'koehler', 'morning', 'murphy', 'pablo', 
        'peachpuff', 'ron', 'slate', 'torte', 'zellner'
    }
    -- 'shine', 'default'
    local index = tonumber(vim.fn.matchstr(vim.fn.reltimestr(vim.fn.reltime()), '\\v\\d+')) % #colorschemes + 1
    vim.api.nvim_command('color ' .. colorschemes[index])
end
-- ------------------- / 関数定義 -------------------

-- -------------------- プラグイン設定 --------------------
vim.cmd('source ' .. vim.g.user_vim_dir .. '/src/plugins.vim')
-- ------------------- / プラグイン設定 -------------------

end)

-- エラーが発生した場合にキャプチャ関数を呼び出す
if not status then
    print(err)
    capture_init_error(err)
end

-- -------------------- その他 --------------------
--     Old text                    Command         New text
-- --------------------------------------------------------------------------------
--     surr*ound_words             ysiw)           (surround_words)
--     *make strings               ys$"            "make strings"
--     [delete ar*ound me!]        ds]             delete around me!
--     remove <b>HTML t*ags</b>    dst             remove HTML tags
--     'change quot*es'            cs'"            "change quotes"
--     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
--     delete(functi*on calls)     dsf             function calls
-- ------------------- / その他 -------------------

if vim.fn.has("gui_running") == 1 then
    vim.cmd('source ' .. vim.g.user_vim_dir .. '/src/ginit.lua')
end
