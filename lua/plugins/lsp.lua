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
        { "williamboman/mason-lspconfig.nvim",
            config = function()
            require("mason-lspconfig").setup()
            require("mason-lspconfig").setup_handlers {
                function(server_name)
                require("lspconfig")[server_name].setup {}
            end,
        }
        end
} -- lspconfigとセット
    }
end


return M
