function main()
    require("lazy").setup({
        spec = {
            require("plugins.lsp").plugin_spec(),
            require("plugins.lsp_cmp").plugin_spec(),
            require("plugins.testing").plugin_spec(),
            require("plugins.copilot").plugin_spec(),
            require("plugins.surround").plugin_spec(),
            require("plugins.prettier").plugin_spec(),
            require("plugins.telescope").plugin_spec(),
            require("plugins.symbol_jump").plugin_spec(),
            require("plugins.diagnostic").plugin_spec(),
            require("plugins.gitsigns").plugin_spec(),
            require("plugins.neotree").plugin_spec(),
            require("plugins.markdown").plugin_spec(),
            require("plugins.comment").plugin_spec(),
            require("plugins.treesitter").plugin_spec(),
            require("plugins.scrollbar").plugin_spec(),
            require("plugins.hlchunk").plugin_spec(),
            require("plugins.zen").plugin_spec(),
            { 'f-person/git-blame.nvim' },     -- コメントアウト
            { 'akinsho/toggleterm.nvim' },     -- ターミナル強化 -- まだ使いこなせない
            { 'sindrets/diffview.nvim' },      -- Gitビューワー
            { 'nvim-lualine/lualine.nvim' },   -- ステータスライン
            { 'jdkanani/vim-material-theme' }, -- カラースキーム
            { 'folke/tokyonight.nvim' },       -- カラースキーム
            { 'Bekaboo/dropbar.nvim' },        -- TODO
        },
        install = { colorscheme = { "habamax" } },
        checker = { enabled = true },
    })
end

function prepare()
    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out,                            "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.rtp:prepend(lazypath)
end

prepare()
main()
