local M = {}

function M.plugin_spec()
    return {
        { 'nvim-treesitter/nvim-treesitter-context' },
        { 'nvim-treesitter/nvim-treesitter',
            config = function()
                -- *****************************************
                -- 個別設定 Treesitter
                -- *****************************************
                require("nvim-treesitter.configs").setup({
                    ensure_installed = { "python", "lua", "javascript" },
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end
        },
    }
end

return M
