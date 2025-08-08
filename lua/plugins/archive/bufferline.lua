local M = {}

function M.plugin_spec()
    return {
        {
            'akinsho/bufferline.nvim',
            version = "*",
            dependencies = 'nvim-tree/nvim-web-devicons',
            config = function()
                vim.opt.termguicolors = true
                require("bufferline").setup {
                    custom_filter = function(buf_number)
                        if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
                            return true
                        end
                    end
                }
            end,
        }
    }
end

return M
