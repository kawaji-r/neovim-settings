local M = {}

function M.plugin_spec()
    return {
        'folke/zen-mode.nvim',
        config = function()
            -- *****************************************
            -- 個別設定 hlchunk (開始と終了の紐付け)
            -- *****************************************
            require("zen-mode").setup({
                window = {
                    width = 1,
                }
            })
        end
    }
end

return M
