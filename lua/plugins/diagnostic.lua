local M = {}

function M.plugin_spec()
    return {
        "rachartier/tiny-inline-diagnostic.nvim",         -- 診断結果表示
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require('tiny-inline-diagnostic').setup()
            vim.diagnostic.config({ virtual_text = false })         -- Only if needed in your configuration, if you already have native LSP diagnostics
        end
    }
end

return M
