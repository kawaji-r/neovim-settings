local M = {}

function M.plugin_spec()
    return {
        { 'github/copilot.vim' },
        {
            "CopilotC-Nvim/CopilotChat.nvim",
            dependencies = {
                { "nvim-lua/plenary.nvim", branch = "master" },
            },
            build = "make tiktoken",
            opts = {
                -- See Configuration section for options
            },
        }
    }
end

return M
