local M = {}

function M.plugin_spec()
    return {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            'nvim-tree/nvim-web-devicons',
            "MunifTanjim/nui.nvim",
        },
        config = function()
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
                                vim.cmd("tcd " .. node.path)  -- tcd でカレントディレクトリを変更
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
        end
    }
end

return M
