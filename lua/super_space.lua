local M = {}

-- モジュール ロード
local funcs = require("functions")
local gitsigns = require('gitsigns')


-- neo-treeで開きたいパスリスト
local neotree_list = {
    '現在のファイルのパス',
    vim.fn.stdpath("config"),
}

-- スペース2回で開くメニュー
local next_menu = {
    { desc = 'Neotreeを色々な場所で開く', method = function() funcs.neotree_anywhere(neotree_list) end },
    { desc = '最近開いたファイルを開く', method = function() vim.cmd('browse oldfiles') end },
    { desc = 'Gitsignsを開く', method = function() vim.cmd('Gitsigns') end },
    { desc = 'Telescopeを開く', method = function() vim.cmd('Telescope') end },
    { desc = '自動フォーマット設定の切り替え', method = funcs.toggle_auto_format },
}

local function open_next_menu()
    vim.cmd('redraw')

    local select_opts = {
        prompt = "Next Menu",
        format_item = function(item)
            return item.desc
        end,
    }
    vim.ui.select(next_menu, select_opts, function(choice, idx)
        if choice then
            choice.method()
        else
            print("該当する選択肢がありません。")
            print(char)
        end
    end)
end

-- スペース1回で開くメニュー
local menu_list = {
    { key = '1', desc = 'Neotreeを開く', method = function() vim.cmd('Neotree toggle') end },
    { key = '2', desc = '[Git] 差分表示', method = function() vim.cmd('DiffviewOpen') end },
    { key = '3', desc = '[Git] 変更履歴表示', method = function() vim.cmd('DiffviewFileHistory %') end },
    { key = '4', desc = '[Git] 現在のハンクをステージング', method = gitsigns.stage_hunk },
    { key = '5', desc = '[LSP] フォーマット', method = vim.lsp.buf.format },
    { key = '6', desc = '[LSP] 診断結果を開く', method = vim.diagnostic.open_float },
    { key = '7', desc = '[LSP] ヒント', method = vim.lsp.buf.code_action },
    { key = '8', desc = '[LSP] 定義ジャンプ', method = vim.lsp.buf.definition },
    { key = '9', desc = '[Telescope] Grep検索', method = function() vim.cmd('Telescope live_grep') end },
    { key = '0', desc = '[Telescope] ファイル検索', method = function() vim.cmd('Telescope find_files') end },
    { key = 'y', desc = 'クリップボードにヤンク', method = function() vim.cmd('normal! "+y') end },
    { key = 'p', desc = 'クリップボードを貼り付け', method = function() vim.cmd('normal "+P') end },
    { key = ' ', desc = '次のメニューを開く', method = open_next_menu },
}

-- オプションの各要素の型や値の妥当性を検証する関数
local function validate_menu_list(menu_list)
    if type(menu_list) ~= "table" then
        error("menu_list はテーブルである必要があります")
    end

    for index, opt in ipairs(menu_list) do
        if type(opt) ~= "table" then
            error("menu_list の各要素はテーブルである必要があります (index " .. index .. ")")
        end
        if type(opt.key) ~= "string" then
            error("menu_list の各要素の 'key' は文字列である必要があります (index " .. index .. ")")
        end
        if type(opt.method) ~= "function" then
            error("menu_list の各要素の 'method' は関数である必要があります (index " .. index .. ")")
        end
        if type(opt.desc) ~= "string" then
            error("menu_list の各要素の 'desc' は文字列である必要があります (index " .. index .. ")")
        end
    end
end

-- 外部からオプションを追加する関数
function M.add_menu(new_list)
    validate_menu_list(new_list)
    for _, opt in ipairs(new_list) do
        table.insert(menu_list, opt)
    end
end

function M.run_input_methods_visual()
    vim.api.nvim_input("<Esc>")
    vim.defer_fn(function()
        M.run_input_methods()
    end, 50) -- 50ミリ秒遅延
end

-- ユーザー入力を取得し、対応する method を実行する関数
function M.run_input_methods()
    local org_cmdheight = vim.o.cmdheight
    vim.o.cmdheight = #menu_list + 1

    validate_menu_list(menu_list)

    print("Super Menu")
    for _, opt in ipairs(menu_list) do
        print(string.format("  [%s] %s", opt.key, opt.desc))
    end

    local char = vim.fn.nr2char(vim.fn.getchar())
    vim.o.cmdheight = org_cmdheight

    local selected_menu = nil
    for _, opt in ipairs(menu_list) do
        if opt.key == char then
            selected_menu = opt
            break
        end
    end

    if selected_menu then
        selected_menu.method()
    else
        print("該当する選択肢がありません。")
        print(char)
    end
end

-- run_input_methods を Vim コマンドとして登録
vim.api.nvim_create_user_command("SuperSpace", M.run_input_methods, {
    desc = "ユーザー入力に基づくメソッドの実行"
})

vim.keymap.set('n', '<Space>', '<cmd>SuperSpace<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<Space>', '<cmd>SuperSpace<CR>', { noremap = true, silent = true })

return M
