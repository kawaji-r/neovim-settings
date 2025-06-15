local M = {}

function M.plugin_spec()
    return {
        { "neovim/nvim-lspconfig" },   -- LSP
        {
            "williamboman/mason.nvim", -- lspconfigとセット
            config = function()
                require("mason").setup()
            end
        },
        {
            "williamboman/mason-lspconfig.nvim", -- lspconfigとセット
            config = function()
                require("mason-lspconfig").setup {
                    ensure_installed = {
                        "lua_ls", -- Lua 言語サーバー
                        "rust_analyzer", -- Rust 言語サーバー
                        "pyright", -- Python 言語サーバー
                        "tsserver", -- TypeScript/JavaScript 言語サーバー
                    },
                }
            end
        }
    }
end

return M
