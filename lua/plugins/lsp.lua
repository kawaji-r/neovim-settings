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
            "williamboman/mason-lspconfig.nvim",
            config = function()
                require("mason-lspconfig").setup {
                    ensure_installed = {
                        "marksman",
                        "lua_ls",
                        "ts_ls",
                        "rust_analyzer",
                    },                       -- 必要なサーバー名を列挙
                    automatic_enable = true, -- 既定でオン (インストール済みサーバーを LSP クライアントとして起動)
                }
            end
        } -- lspconfigとセット
    }
end

return M
