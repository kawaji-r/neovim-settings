local mod = {}

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
        vim.cmd('normal! n')
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
-- クリップボードの内容を貼り付ける関数
-- *****************************************
function mod.paste_clipboard()
    vim.cmd('normal "+P')
end

-- *****************************************
-- 選択されたテキストをクリップボードにコピーする関数
-- *****************************************
function mod.set_clipboard()
    vim.cmd('normal! gv"+y')
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
    -- 元のコマンドラインサイズを記憶
    local cmdheight = vim.o.cmdheight
    -- コマンドラインサイズを一時的に変更
    vim.o.cmdheight = #info_list + 2
    -- 情報表示
    print('■■■■■■■■■■■■■■■■■■■■')
    for _, key in ipairs(info_list) do
        print(key .. ': ' .. vim.g.menu_list[key].desc)
    end
    print('■■■■■■■■■■■■■■■■■■■■')
    -- 元のコマンドラインサイズに戻す
    vim.o.cmdheight = cmdheight
end

return mod
