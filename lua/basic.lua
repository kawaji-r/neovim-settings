local func = require("functions")

-- *****************************************
-- 基本設定
-- *****************************************
vim.opt.number = true -- 行番号
vim.opt.expandtab = true -- タブ文字をスペースに
vim.opt.shiftwidth = 4 -- インデント設定
vim.opt.tabstop = 4 -- インデント設定
vim.opt.showtabline = 2 -- タブを表示する
vim.opt.ignorecase = false -- 検索時の大文字小文字参照
vim.opt.list = true -- タブや改行を表示 (list:表示)
vim.opt.listchars = 'tab:>-,extends:<,trail:-,eol:↩' -- どの文字でタブや改行を表示するかを設定
vim.opt.display:append("lastline") -- ウィンドウの最下行に表示されるテキストが、行の一部が画面に収まらなくても、可能な限り表示されるようにする
vim.g.autoformat_enabled = true
vim.api.nvim_command("colorscheme material-theme") -- カラー設定
-- MAP
vim.keymap.set('v', '*', func.visual_search, { noremap = true, silent = true })
vim.keymap.set('n', 'Y', 'y$', { noremap = true })
vim.keymap.set('n', 'gg', 'gg0', { noremap = true })
vim.keymap.set('n', 'G', 'G0', { noremap = true })
vim.keymap.set('i', '@@', '<Esc>', { noremap = true })
-- ウィンドウ移動
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true }) -- これが効かないため保留
-- タブ移動
vim.keymap.set('n', '<Tab>', '<cmd>tabnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>tabprevious<CR>', { noremap = true, silent = true })
-- ウィンドウ幅変更
vim.keymap.set('n', '<A-right>', '<C-w>>', { noremap = true })
vim.keymap.set('n', '<A-left>', '<C-w><', { noremap = true })
vim.keymap.set('n', '<A-up>', '<C-w>-', { noremap = true })
vim.keymap.set('n', '<A-down>', '<C-w>+', { noremap = true })
-- ノーマルモードで <Down> を押すとターミナルにフォーカスする
vim.keymap.set('n', '<A-j>', function() func.open_terminal(1) end, { noremap = true, silent = true })
-- ターミナルモードでのキー割り当て
vim.keymap.set('t', '<A-l>', function() func.open_terminal(2) end, { noremap = true, silent = true })
vim.keymap.set('t', '<A-h>', function() func.open_terminal(3) end, { noremap = true, silent = true })
vim.keymap.set('t', '<A-j>', [[<C-\><C-n>:hide<CR>]], { noremap = true, silent = true })
vim.keymap.set('t', '<A-k>', [[<C-\><C-n>:wincmd k<CR>]], { noremap = true, silent = true })
vim.keymap.set('t', '<C-k>', [[<C-\><C-n>:wincmd k<CR>]], { noremap = true, silent = true })
vim.keymap.set('t', '<C-l>', [[<C-\><C-n>:wincmd l<CR>]], { noremap = true, silent = true })
vim.keymap.set('t', '<C-h>', [[<C-\><C-n>:wincmd h<CR>]], { noremap = true, silent = true })
vim.keymap.set('t', '@@', [[<C-\><C-n>]], { noremap = true, silent = true })

-- *****************************************
-- LSP設定
-- *****************************************
-- 保存時自動フォーマット
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        if vim.g.autoformat_enabled == nil or vim.g.autoformat_enabled then
            vim.lsp.buf.format()
        end
    end,
})

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
vim.opt.ambiwidth = 'single'
