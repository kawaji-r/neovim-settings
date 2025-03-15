-- メニュー項目の設定
local menu = {
    ['1'] = {method = nil, desc = 'ファイルを開く'},
    ['2'] = {method = 'OpenVimrc', desc = 'vim設定ファイルを開く'},
    ['3'] = {method = 'OpenTree', desc = 'Fernを開く'},
    ['4'] = {method = 'RecentFile', desc = '最近開いたファイルを開く'},
    ['5'] = {method = 'InsertCurrentDate', desc = '日付と曜日を挿入する'},
    ['6'] = {method = 'SetColorScheme', desc = 'テーマの変更（GUI限定）'},
    ['7'] = {method = 'CopyMessagesToClipboard', desc = ':messagesの内容をクリップボードにコピー'},
    ['8'] = {method = 'ExecuteTelescope', desc = 'Telescope'},
    ['9'] = {method = 'OpenTerminal', desc = '下半分にターミナルを表示'},
    ['q'] = {method = 'ToggleBackground', desc = 'ダークテーマとライトテーマ入れ替え'},
    ['y'] = {method = 'SetClipboard', desc = 'クリップボードにコピー'},
    ['p'] = {method = 'PasteClipboard', desc = 'クリップボードを貼り付け'}
}

-- ユーザー定義辞書とマージ
if vim.g.menuList and not vim.tbl_isempty(vim.g.menuList) then
    -- 辞書マージ用関数
    local function MergeDicts(dict1, dict2)
        local result = vim.deepcopy(dict1)
        for key, value in pairs(dict2) do
            result[key] = value
        end
        return result
    end

    menu = MergeDicts(vim.g.menuList, menu)
end

vim.g.menuList = menu

-- 配列を受け取って表示する
local function display_info_list(info_list)
    -- 元のコマンドラインサイズを記憶
    local cmdheight = vim.o.cmdheight
    -- コマンドラインサイズを一時的に変更
    vim.o.cmdheight = #info_list + 2
    -- 情報表示
    print('■■■■■■■■■■■■■■■■■■■■')
    for _, key in ipairs(info_list) do
        print(key .. ': ' .. vim.g.menuList[key].desc)
    end
    print('■■■■■■■■■■■■■■■■■■■■')
    -- 元のコマンドラインサイズに戻す
    vim.o.cmdheight = cmdheight
end

-- メニューを表示してユーザー入力に応じたアクションを実行する関数
function ShowMenu()
    -- メニュー表示
    local menu_list = vim.tbl_keys(vim.g.menuList)
    table.sort(menu_list)
    display_info_list(menu_list)

    -- ユーザーの入力を待つ
    local user_input = vim.fn.nr2char(vim.fn.getchar())

    -- 選択されたメニュー項目の実行
    if vim.g.menuList[user_input] then
        if vim.fn.exists('*' .. vim.g.menuList[user_input].method) == 1 then
            vim.cmd('call ' .. vim.g.menuList[user_input].method .. '()')
        elseif _G[vim.g.menuList[user_input].method] ~= nil then
            _G[vim.g.menuList[user_input].method]()  -- グローバルテーブルから関数を呼び出す
        else
            print('関数がありません／' .. vim.g.menuList[user_input].method)
        end
    else
        print('そのキーは設定されていません／' .. user_input)
    end
end

-- 現在のモードが引数に指定されたモードのいずれかであるかを判定する関数
local function IsCurrentMode(modes)
    local current_mode = vim.fn.mode()
    for _, mode in ipairs(modes) do
        -- 各モードと現在のモードを比較
        if mode == 'insert' and current_mode:match('^[iR]') then
            return true
        elseif mode == 'normal' and (current_mode == '' or current_mode == 'c' or current_mode == 'n') then
            return true
        elseif mode == 'visual' and current_mode:match('^v') then
            return true
        else
            error('Unknown mode: ' .. mode)
        end
    end
    return false
end

-- Vim設定ファイルを開くための関数
function OpenVimrc()
    -- ファイル選択リストの設定
    local fileList = {
        vim.g.user_vim_dir .. '/init.lua',
        vim.g.user_vim_dir .. '/src/ginit.lua',
        vim.g.user_vim_dir .. '/src/space_functions.lua',
    }
    local result = ReturnUserSelected(fileList)
    if result ~= nil then
        vim.cmd(':tabe ' .. result)
    end
end

-- Fernをトグルする関数
function OpenTree()
    local fern_win_id = -1
    -- 既にウィンドウが開かれているかを確認
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
        if filetype == "fern" then
            fern_win_id = win
            break
        end
    end
    if fern_win_id ~= -1 then
        -- 開いていれば閉じる
        vim.api.nvim_win_close(fern_win_id, true)
        return
    else
        -- 開いていないため、開くための処理
        -- ディレクトリ選択リストの設定
        local dirList = {'現在のファイルのパス', vim.g.user_vim_dir}
        if vim.g.fernList and not vim.tbl_isempty(vim.g.fernList) then
            vim.list_extend(dirList, vim.g.fernList)
        end
        local result = ReturnUserSelected(dirList)
        if result == '現在のファイルのパス' then
            vim.cmd('Fern %:h -reveal=% -drawer -width=35')
            return
        end
        if result ~= nil then
            vim.cmd('Fern ' .. result .. ' -drawer -toggle -width=35')
        end
    end
end

-- 最近開いたファイルを開く
function RecentFile()
    vim.cmd(':browse oldfiles')
end

-- 日付と曜日を挿入する関数
function InsertCurrentDate()
    local days = {'日', '月', '火', '水', '木', '金', '土'}
    local date = os.date("%Y-%m-%d")
    local day = days[tonumber(os.date("%w")) + 1]
    local result = date .. '(' .. day .. ')'
    vim.cmd('normal! A' .. result)
end

-- 選択されたテキストをクリップボードにコピーする関数
function SetClipboard()
    vim.cmd('normal! gv"+y')
end

-- クリップボードの内容を貼り付ける関数
function PasteClipboard()
    vim.cmd('normal "+P')
end

function ReturnUserSelected(array)
    vim.cmd('redraw')

    local cmdheight = vim.o.cmdheight
    vim.o.cmdheight = #array + 4

    print('-------------------------------------------')
    print('選択してください')
    for i, item in ipairs(array) do
        print(i .. ': ' .. item)
    end
    print('-------------------------------------------')

    vim.o.cmdheight = cmdheight

    -- ユーザーの入力に基づいてディレクトリを開く
    local user_input = tonumber(vim.fn.nr2char(vim.fn.getchar()))
    if user_input and user_input >= 1 and user_input <= #array then
        return array[tonumber(user_input)]
    else
        print('そのキーは設定されていません／' .. tostring(user_input))
        return nil
    end
end

-- ランダムに色スキームを選択して適用する関数
function SetColorScheme()
    -- 色スキームのリストを定義
    local colorschemes = {
        'blue', 'darkblue', 'delek', 'desert', 'elflord', 
        'evening', 'industry', 'koehler', 'morning', 'murphy', 'pablo', 
        'peachpuff', 'ron', 'slate', 'torte', 'zellner', 'everforest'
    }
    -- 'shine', 'default'
    local index = tonumber(vim.fn.matchstr(vim.fn.reltimestr(vim.fn.reltime()), '\\v\\d+')) % #colorschemes + 1
    vim.api.nvim_command('color ' .. colorschemes[index])
    print('New Theme is: ' .. colorschemes[index])
end

-- ****************************
-- Space + 7 :messagesの内容をクリップボードにコピー
-- ****************************
function CopyMessagesToClipboard()
    -- Get the messages
    local messages = vim.fn.execute('messages')
    -- Set the messages to the clipboard
    vim.fn.setreg('+', messages)
    print("Messages copied to clipboard")
end

-- ****************************
-- Space + 8 Telescope
-- ****************************
function ExecuteTelescope()
    vim.cmd('Telescope')
end

-- ****************************
-- Space + 9 下半分にターミナルを表示
-- ****************************
-- ターミナル用のグローバル変数
term_buf = nil
term_win = nil

function OpenTerminal()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    if term_win and vim.api.nvim_win_is_valid(term_win) then
      vim.api.nvim_set_current_win(term_win)
    else
      vim.cmd("botright split")
      term_win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(term_win, term_buf)
    end
  else
    vim.cmd("botright split")
    term_win = vim.api.nvim_get_current_win()
    term_buf = vim.api.nvim_create_buf(false, true)  -- 一時的なターミナルバッファ
    vim.api.nvim_win_set_buf(term_win, term_buf)
    vim.fn.termopen(vim.o.shell)
    -- ターミナルモードでのキー割り当て
    vim.api.nvim_buf_set_keymap(term_buf, 't', '<A-j>', [[<C-\><C-n>:hide<CR>]], { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(term_buf, 't', '<A-k>', [[<C-\><C-n>:wincmd p<CR>]], { noremap = true, silent = true })
  end
  vim.cmd("startinsert")  -- 初回オープン時にターミナルモードにする
  vim.cmd("resize 15")  -- 初回オープン時にターミナルモードにする
end
-- ノーマルモードで <A-j> を押すとターミナルにフォーカスする
vim.api.nvim_set_keymap('n', '<A-j>', ':lua OpenTerminal()<CR>', { noremap = true, silent = true })

function ToggleBackground()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end
end

-- Spaceキーにメニュー表示関数をマッピング
vim.api.nvim_set_keymap('n', '<Space>', ':lua ShowMenu()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<Space>', ':<C-u>lua ShowMenu()<CR>', {noremap = true, silent = true})
