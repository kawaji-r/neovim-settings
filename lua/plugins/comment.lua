local M = {}

function M.plugin_spec()
    return {
        'numToStr/Comment.nvim',
        config = function()
            -- *****************************************
            -- 個別設定 Comment
            -- *****************************************
            require("Comment").setup({
                mappings = {
                    basic = false,
                    extra = false,
                },
            })
            vim.keymap.set("n", "<C-_>", function()
                require("Comment.api").toggle.linewise.current()
            end, { noremap = true, silent = true })
            vim.keymap.set("v", "<C-_>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { noremap = true, silent = true })
        end
    }
end

return M
