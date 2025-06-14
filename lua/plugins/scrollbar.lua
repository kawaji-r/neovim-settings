local M = {}

function M.plugin_spec()
    return {
        'petertriho/nvim-scrollbar',
        config = function()
            -- *****************************************
            -- 個別設定 Scrollbar
            -- *****************************************
            require("scrollbar").setup({})
        end
    }
end

return M
