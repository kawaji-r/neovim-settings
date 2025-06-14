local M = {}

function M.plugin_spec()
    return {
        'MeanderingProgrammer/render-markdown.nvim',
        config = function()
            -- *****************************************
            -- 個別設定 Markdown
            -- *****************************************
            require('render-markdown').setup({
                anti_conceal = {
                    -- This enables hiding any added text on the line the cursor is on.
                    enabled = false,
                },
            })
        end
    }
end

return M
