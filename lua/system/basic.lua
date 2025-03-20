local func = require("system.functions")

-- *****************************************
-- 基本設定
-- *****************************************
vim.g.mapleader = '<Tab>'
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
vim.keymap.set('v', '*', func.visual_search, { noremap = true, silent = true })
vim.keymap.set('n', 'Y', 'y$', {noremap = true})
vim.keymap.set('n', 'gg', 'gg0', {noremap = true})
vim.keymap.set('n', 'G', 'G0', {noremap = true})
vim.keymap.set('i', 'jj', '<Esc>', {noremap = true})
-- ウィンドウ移動
vim.keymap.set('n', '<A-j>', '<C-w>j', {noremap = true})
vim.keymap.set('n', '<A-h>', '<C-w>h', {noremap = true})
vim.keymap.set('n', '<A-k>', '<C-w>k', {noremap = true})
vim.keymap.set('n', '<A-l>', '<C-w>l', {noremap = true})
-- タブ移動
vim.keymap.set('n', '<Right>', '<cmd>tabnext<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<Left>', '<cmd>tabprevious<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<Tab>', '<cmd>tabnext<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<S-Tab>', '<cmd>tabprevious<CR>', {noremap = true, silent = true})
-- ウィンドウ幅変更
vim.keymap.set('n', '<A-right>', '<C-w>>', {noremap = true})
vim.keymap.set('n', '<A-left>', '<C-w><', {noremap = true})
vim.keymap.set('n', '<A-up>', '<C-w>-', {noremap = true})
vim.keymap.set('n', '<A-down>', '<C-w>+', {noremap = true})
-- ノーマルモードで <Down> を押すとターミナルにフォーカスする
vim.keymap.set('n', '<Down>', function() func.open_terminal(1) end, { noremap = true, silent = true })
-- ターミナルモードでのキー割り当て
vim.keymap.set('t', '<Down>', [[<C-\><C-n>:hide<CR>]], { noremap = true, silent = true })
vim.keymap.set('t', '<Up>', [[<C-\><C-n>:wincmd p<CR>]], { noremap = true, silent = true })
vim.keymap.set('t', '<Right>', function() func.open_terminal(2) end, { noremap = true, silent = true })
vim.keymap.set('t', '<Left>', function() func.open_terminal(3) end, { noremap = true, silent = true })
vim.keymap.set('t', '<A-k>', [[<C-\><C-n>:wincmd k<CR>]], { noremap = true, silent = true })
vim.keymap.set('t', '<A-l>', [[<C-\><C-n>:wincmd l<CR>i]], { noremap = true, silent = true })
vim.keymap.set('t', '<A-h>', [[<C-\><C-n>:wincmd h<CR>i]], { noremap = true, silent = true })

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

