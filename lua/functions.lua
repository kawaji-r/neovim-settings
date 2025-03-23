local mod = {}

-- ****************************
-- 下半分にターミナルを表示
-- ****************************
-- ターミナル用のグローバル変数
local term_buf = nil
local term_win = nil

function mod.open_terminal(mode)
    if mode == 1 then
        -- ターミナルバッファが既に存在するかどうか
        if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
            -- ターミナルウィンドウが既に存在するかどうか
            if term_win and vim.api.nvim_win_is_valid(term_win) then
                -- ターミナルウィンドウに移動
                vim.api.nvim_set_current_win(term_win)
            else
                -- ウィンドウを生成してターミナルバッファを表示
                vim.cmd("botright split")
                term_win = vim.api.nvim_get_current_win()
                vim.api.nvim_win_set_buf(term_win, term_buf)
            end
        else
            -- ウィンドウを生成してターミナルバッファを生成
            vim.cmd("botright split")
            term_win = vim.api.nvim_get_current_win()
            term_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_win_set_buf(term_win, term_buf)
            vim.fn.termopen(vim.o.shell)
        end
    elseif mode == 2 then
        vim.cmd("leftabove vsplit")
        term_win = vim.api.nvim_get_current_win()
        term_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(term_win, term_buf)
        vim.fn.termopen(vim.o.shell)
    elseif mode == 3 then
        -- 左側に新規ターミナルを開く
        vim.cmd("vsplit")
        term_win = vim.api.nvim_get_current_win()
        term_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(term_win, term_buf)
        vim.fn.termopen(vim.o.shell)
    end
    vim.cmd("startinsert") -- ターミナルモードに入る
    vim.cmd("resize 15")   -- ウィンドウサイズを15行に設定
end

-- *****************************************
-- neo-treeをトグルする関数
-- *****************************************
function mod.neotree_anywhere(neotree_list)
    vim.cmd('redraw')
    -- ディレクトリ選択リストの設定
    if vim.g.neotree_list and not vim.tbl_isempty(vim.g.neotree_list) then
        vim.list_extend(neotree_list, vim.g.neotree_list)
    end

    vim.ui.select(neotree_list, { prompt = "どのフォルダを開きますか？" }, function(choice, idx)
        if choice then
            if choice == '現在のファイルのパス' then
                vim.cmd('Neotree %:h')
            else
                vim.cmd('Neotree ' .. choice)
            end
        else
            print("該当する選択肢がありません。")
            print(char)
        end
    end)
end

-- ****************************
-- 自動フォーマットをON/OFF切り替える
-- ****************************
function mod.toggle_auto_format()
    vim.g.autoformat_enabled = not vim.g.autoformat_enabled
    print("\nAutoformat: " .. (vim.g.autoformat_enabled and "ON" or "OFF"))
end

-- *****************************************
-- ファイルをechoする
-- *****************************************
function mod.echo_file(path)
    for _, line in ipairs(vim.fn.readfile(path)) do
        if line == "" then
            print(".")
        else
            print(line)
        end
    end
end

-- *****************************************
-- 選択範囲の文字列で検索
-- *****************************************
function mod.visual_search()
    -- 一時的に無名レジスタの内容を保存
    local original_reg = vim.fn.getreg('@')
    -- 選択範囲を無名レジスタにヤンク
    -- vim.cmd('normal! gv"xy')
    vim.cmd('normal! "xy')
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
    if escaped_text ~= "" then
        -- 検索履歴に追加
        vim.fn.histadd('search', escaped_text)
        -- 検索パターンの設定
        vim.fn.setreg('/', escaped_text)
        vim.opt.hlsearch = true
        -- 最初の一致に移動
        -- vim.cmd('normal! n')
    end
end

-- *****************************************
-- 配列を受け取り、ユーザーに選択させる
-- *****************************************
function mod.ReturnUserSelected(array)
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

-- *****************************************
-- 現在のモードが引数に指定されたモードのいずれかであるかを判定する関数
-- *****************************************
function mod.is_current_mode(modes)
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

-- *****************************************
-- 配列を受け取ってprint表示する
-- *****************************************
function mod.display_info_list(info_list)
    -- 情報表示
    for _, key in ipairs(info_list) do
        print(key .. ': ' .. vim.g.menu_list[key].desc)
    end
end

-- *****************************************
-- dictをマージする
-- *****************************************
function mod.merge_dicts(dict1, dict2)
    local result = vim.deepcopy(dict1)
    for key, value in pairs(dict2) do
        result[key] = value
    end
    return result
end

return mod
