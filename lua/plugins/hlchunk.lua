local M = {}

function M.plugin_spec()
    return {
        'shellRaining/hlchunk.nvim',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            -- *****************************************
            -- 個別設定 hlchunk (開始と終了の紐付け)
            -- *****************************************
            require("hlchunk").setup({})
        end
    }
end

return M
