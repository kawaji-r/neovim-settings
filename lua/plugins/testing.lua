local M = {}

function M.plugin_spec()
    return {
        "vim-test/vim-test",
        config = function()
            vim.g["test#strategy"] = "neovim"
        end,
    }
end

return M
