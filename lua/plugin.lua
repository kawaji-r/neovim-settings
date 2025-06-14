function main()
    require("lazy").setup({
        spec = {
            { "neovim/nvim-lspconfig" },             -- LSP
            { "williamboman/mason.nvim" },           -- lspconfigとセット
            { "williamboman/mason-lspconfig.nvim" }, -- lspconfigとセット
            { 'neovim/nvim-lspconfig' },             -- 補完プラグイン
            { 'hrsh7th/cmp-nvim-lsp' },              -- 補完プラグイン
            { 'hrsh7th/cmp-buffer' },                -- 補完プラグイン
            { 'hrsh7th/cmp-path' },                  -- 補完プラグイン
            { 'hrsh7th/cmp-cmdline' },               -- 補完プラグイン
            { 'hrsh7th/nvim-cmp' },                  -- 補完プラグイン
            { 'hrsh7th/cmp-vsnip' },                 -- 補完プラグイン
            { 'hrsh7th/vim-vsnip' },                 -- 補完プラグイン
            { 'github/copilot.vim' },                -- Github Copilot
            { 'tpope/vim-surround' },            -- vim surround
            { 'bassamsdata/namu.nvim' },         -- シンボルジャンプ
            {  -- 診断結果表示
                "rachartier/tiny-inline-diagnostic.nvim",
                event = "VeryLazy", -- Or `LspAttach`
                priority = 1000, -- needs to be loaded in first
                config = function()
                    require('tiny-inline-diagnostic').setup()
                    vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
                end
            },
            { 'nvim-telescope/telescope.nvim' }, -- ファイル検索
            { 'numToStr/Comment.nvim' },         -- コメントアウト
            { 'f-person/git-blame.nvim' },       -- カーソル行の編集日時などを表示
            { 'akinsho/toggleterm.nvim' },       -- ターミナル強化 -- まだ使いこなせない
            { 'sindrets/diffview.nvim' },        -- Gitビューワー
            { 'lewis6991/gitsigns.nvim' },       -- Gitクライアント
            -- { 'OXY2DEV/markview.nvim' }, -- マークダウンプレビュー
            { 'MeanderingProgrammer/render-markdown.nvim' }, -- マークダウンプレビュー
            { 'nvim-lualine/lualine.nvim' },     -- ステータスライン
            { 'jdkanani/vim-material-theme' },   -- カラースキーム
            { 'folke/tokyonight.nvim' },   -- カラースキーム
            {                                    -- ファイラー
                "nvim-neo-tree/neo-tree.nvim",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                    'nvim-tree/nvim-web-devicons', -- アイコンを表示
                    "MunifTanjim/nui.nvim",
                },
            },
            { 'folke/zen-mode.nvim' },   -- 禅モード
            {  -- スクロールバー
                'petertriho/nvim-scrollbar',
                config = function()
                    require("scrollbar").setup({})
                end
            },
            {  -- 開始と終了の紐付け
                "shellRaining/hlchunk.nvim",
                event = { "BufReadPre", "BufNewFile" },
                config = function()
                    require("hlchunk").setup({})
                end
            },
            { 'nvim-treesitter/nvim-treesitter-context' },   -- TreeSitter
            { 'nvim-treesitter/nvim-treesitter' },
            { 'Bekaboo/dropbar.nvim' },   -- TODO
            require("plugins/prettier").plugin_spec(),
        },
        -- Configure any other settings here. See the documentation for more details.
        -- colorscheme that will be used when installing plugins.
        install = { colorscheme = { "habamax" } },
        -- automatically check for plugin updates
        checker = { enabled = true },
    })

    -- *****************************************
    -- 個別設定 mason
    -- *****************************************
    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers {
        function(server_name)
            require("lspconfig")[server_name].setup {}
        end,
    }

    -- *****************************************
    -- 個別設定 Gitsigns
    -- *****************************************
    local gs = require('gitsigns')
    gs.setup {
        signs                        = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        signs_staged                 = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        signs_staged_enable          = true,
        signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir                 = {
            follow_files = true
        },
        auto_attach                  = true,
        attach_to_untracked          = false,
        current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts      = {
            virt_text = true,
            virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
            virt_text_priority = 100,
            use_focus = true,
        },
        current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
        sign_priority                = 6,
        update_debounce              = 100,
        status_formatter             = nil,   -- Use default
        max_file_length              = 40000, -- Disable if file is longer than this (in lines)
        preview_config               = {
            -- Options passed to nvim_open_win
            border = 'single',
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1
        },
    }
    vim.keymap.set("n", "]c", function() gs.next_hunk() end)
    vim.keymap.set("n", "[c", function() gs.prev_hunk() end)

    -- *****************************************
    -- 個別設定 nvim-cmp
    -- *****************************************

    local cmp = require('cmp')

    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

                -- For `mini.snippets` users:
                -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
                -- insert({ body = args.body }) -- Insert at cursor
                -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
                -- require("cmp.config").set_onetime({ sources = {} })
            end,
        },
        window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' }, -- For vsnip users.
            -- { name = 'luasnip' }, -- For luasnip users.
            -- { name = 'ultisnips' }, -- For ultisnips users.
            -- { name = 'snippy' }, -- For snippy users.
        }, {
            { name = 'buffer' },
        })
    })

    -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
    -- Set configuration for specific filetype.
    --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]] --

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
    })

    -- Set up lspconfig.
    -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
    --     capabilities = capabilities
    -- }

    -- *****************************************
    -- 個別設定 neo-tree
    -- *****************************************
    -- user/nerdfont.lua があれば読み込む
    local file_path = vim.fn.stdpath("config") .. '/user/nerdfont.lua'
    if vim.fn.filereadable(file_path) == 1 then
        dofile(file_path)
    end
    local fs = require("neo-tree.sources.filesystem")
    require("neo-tree").setup({
        default_component_configs = {
            folder_closed = "", -- Nerd Font 使用時
            folder_open = "",
            folder_empty = "",
            default = "",
        },
        git_status = {
            added = "✚",
            modified = "",
            deleted = "",
            renamed = "➜",
            untracked = "★",
            ignored = "◌",
            unstaged = "✗",
            staged = "✓",
            conflict = "",
        },
        sources = { "filesystem", "buffers", "git_status" },
        open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
        filesystem = {
            filtered_items = {
                visible = true, -- 隠しファイルを表示
                hide_dotfiles = false,
                hide_gitignored = false,
            },
            bind_to_cwd = false,
            follow_current_file = true,
            use_libuv_file_watcher = true,
        },
        window = {
            mappings = {
                ["l"] = function(state)
                    local node = state.tree:get_node()
                    if node.type == "directory" then
                        if not node:is_expanded() then
                            -- フォルダを開く
                            fs.toggle_directory(state, node)
                        end
                        -- フォルダを開いた後に最初の項目へ移動
                        vim.defer_fn(function()
                            vim.api.nvim_feedkeys("j", "n", false)
                        end, 100)
                    else
                        -- フォルダが既に開いている場合やファイルなら開く
                        require("neo-tree.sources.filesystem.commands").open(state)
                    end
                end,
                ["h"] = "close_node",
                ["<space>"] = "none",
                ["Y"] = {
                    function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        vim.fn.setreg("+", path, "c")
                    end,
                    desc = "Copy Path to Clipboard",
                },
                ["O"] = {
                    function(state)
                        require("lazy.util").open(state.tree:get_node().path, { system = true })
                    end,
                    desc = "Open with System Application",
                },
                ["P"] = { "toggle_preview", config = { use_float = false } },
                ["."] = function(state)
                    local node = state.tree:get_node()
                    if node.type == "directory" then
                        fs.navigate(state, node.path) -- フォルダをルートに設定
                        vim.cmd("tcd " .. node.path)                                      -- tcd でカレントディレクトリを変更
                        print("Changed directory to: " .. node.path)
                    else
                        print("Not a directory: " .. node.path)
                    end
                end,
                ["/"] = "noop", -- `/` のデフォルト検索を無効化
                ["z"] = "noop", -- zzを使いたい
            },
        },
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        callback = function()
            vim.keymap.set("n", "cd", function()
                local state = require("neo-tree.sources.manager").get_state("filesystem")
                local node = state.tree:get_node()

                if node.type == "directory" then
                    vim.cmd("tcd " .. node.path) -- カレントディレクトリを変更
                    print("Changed directory to: " .. node.path)
                else
                    print("Not a directory: " .. node.path)
                end
            end, { buffer = true, noremap = true, silent = true })
        end,
    })

    -- *****************************************
    -- 個別設定 Markdown
    -- *****************************************
    require('render-markdown').setup({
        anti_conceal = {
            -- This enables hiding any added text on the line the cursor is on.
            enabled = false,
        },
    })

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
    vim.keymap.set("v", "<C-_>"
        , "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>"
        , { noremap = true, silent = true })

    -- *****************************************
    -- 個別設定 Treesitter
    -- *****************************************
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "python", "lua", "javascript" },
      highlight = { enable = true },
      indent = { enable = true },
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
