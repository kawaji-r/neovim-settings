local M = {}

-- lazy.nvim の spec を返す関数
local ft = {
    "javascript", "javascriptreact", "typescript", "typescriptreact",
    "css", "scss", "less", "json", "jsonc", "yaml", "html",
}
function M.plugin_spec()
    return {
        "prettier/vim-prettier",
        run = "npm install --frozen-lockfile --production",
        ft = ft,
        config = function()
            -- 自動フォーマット設定など
            vim.g["prettier#autoformat"] = 1
            vim.g["prettier#autoformat_require_pragma"] = 0
            vim.g["prettier#config#config_precedence"] = "prefer-file"
            -- キーマッピング例
            vim.api.nvim_create_autocmd("FileType", {
                pattern = ft,
                callback = function()
                    vim.keymap.set("n", "<leader>p", ":Prettier<CR>", { buffer = true, silent = true })
                end,
            })
        end,
    }
end

return M
