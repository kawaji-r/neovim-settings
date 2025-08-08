local M = {}

function M.plugin_spec()
    return {
        {
            "kiran94/s3edit.nvim", -- lspconfigとセット
            -- config = true,
            config = function()
                require('s3edit').setup({
                    aws = {
                        command = "aws-noerr",            -- ここをラッパー名に
                        args    = { "--profile", "dev" }, -- 必要なら
                    },
                })
            end,
            cmd = "S3Edit",
        },
    }
end

return M
-- 上手くいかないので使ってない
