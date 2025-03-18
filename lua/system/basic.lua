-- *****************************************
-- 基本設定
-- *****************************************
vim.opt.number = true  -- 行番号
vim.opt.expandtab = true  -- タブ文字をスペースに
vim.opt.shiftwidth = 4  -- インデント設定
vim.opt.tabstop = 4  -- インデント設定
vim.opt.showtabline = 2  -- タブを表示する
vim.opt.ignorecase = false  -- 検索時の大文字小文字参照
vim.opt.list = true -- タブや改行を表示 (list:表示)
vim.opt.listchars = 'tab:>-,extends:<,trail:-,eol:↩' -- どの文字でタブや改行を表示するかを設定
vim.opt.display:append("lastline")  -- ウィンドウの最下行に表示されるテキストが、行の一部が画面に収まらなくても、可能な限り表示されるようにする
vim.api.nvim_command("colorscheme peachpuff") -- カラー設定
-- MAP
vim.api.nvim_set_keymap('v', '*', '<Cmd>lua require("system.functions").visual_search()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'Y', 'y$', {noremap = true})
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', {noremap = true})
-- ウィンドウ移動
vim.api.nvim_set_keymap('n', '<A-j>', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-h>', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-k>', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-l>', '<C-w>l', {noremap = true})
-- タブ移動
vim.api.nvim_set_keymap('n', '<Right>', '<cmd>tabnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Left>', '<cmd>tabprevious<CR>', {noremap = true, silent = true})
-- ウィンドウ幅変更
vim.api.nvim_set_keymap('n', '<A-right>', '<C-w>>', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-left>', '<C-w><', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-up>', '<C-w>-', {noremap = true})
vim.api.nvim_set_keymap('n', '<A-down>', '<C-w>+', {noremap = true})

-- *****************************************
-- バックアップ設定
-- *****************************************
local backup_dir = vim.fn.stdpath("config") .. '/backup'
-- フォルダが無かったら作成する
if not vim.fn.isdirectory(backup_dir) then
    vim.fn.mkdir(backup_dir)
end
vim.opt.directory = backup_dir
vim.opt.backupdir = backup_dir
vim.opt.undodir = backup_dir

-- 今や必要か分からない設定
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
-- 日本語の幅がおかしいため、設定
vim.opt.ambiwidth = 'double'

