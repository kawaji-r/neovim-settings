function main()
  require("lazy").setup({
    spec = {
      { "neovim/nvim-lspconfig" },  -- LSP
      { "williamboman/mason.nvim" },  -- lspconfigとセット
      { "williamboman/mason-lspconfig.nvim" },  -- lspconfigとセット
      { 'tpope/vim-surround' },  -- vim surround
      { 'nvim-telescope/telescope.nvim' },  -- ファイル検索
      { 'numToStr/Comment.nvim' },  -- コメントアウト
      { 'f-person/git-blame.nvim' },  -- カーソル行の編集日時などを表示
      { 'akinsho/toggleterm.nvim' },  -- ターミナル強化 -- まだ使いこなせない
      { 'lewis6991/gitsigns.nvim' },  -- Gitクライアント
      { 'lambdalisue/fern.vim' },  -- ファイラー
      -- { 'lambdalisue/nerdfont.vim', lazy = true, keys = {{"j"}}},  -- Fernとセット
      -- { 'lambdalisue/glyph-palette.vim', lazy = true, keys = {{"j"}} },  -- Fernとセット
      -- { 'lambdalisue/fern-renderer-nerdfont.vim', lazy = true, keys = {{"j"}} },  -- Fernとセット
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
  })

  -- *****************************************
  -- 個別設定 LSP
  -- *****************************************
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ctx)
      local set = vim.keymap.set
  --     set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = true })
  --     set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = true })
  --     set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = true })
  --     set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = true })
  --     set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = true })
  --     set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { buffer = true })
  --     set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { buffer = true })
  --     set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", { buffer = true })
  --     set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { buffer = true })
  --     set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = true })
  --     set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = true })
  --     set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = true })
  --     set("n", "dg", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", { buffer = true })
  --     set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { buffer = true })
  --     set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { buffer = true })
  --     set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", { buffer = true })
  --     set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", { buffer = true })
      set("n", "dg", "<cmd>lua vim.diagnostic.open_float()<CR>", { buffer = true })
    end,
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
    signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged_enable = true,
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      follow_files = true
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
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
  -- 個別設定 toggleterm
  -- *****************************************
    -- まだ使いこなせない
    -- require("toggleterm").setup()
    -- ノーマルモードで <Down> を押すとターミナルにフォーカスする
    -- vim.keymap.set('n', '<Down>', ':ToggleTerm<CR>', { noremap = true, silent = true })
    -- vim.keymap.set('t', '<Down>', [[<C-\><C-n>:ToggleTerm<CR>]], { noremap = true, silent = true })
    -- vim.keymap.set('t', '<Up>', [[<C-\><C-n>:wincmd p<CR>]], { noremap = true, silent = true })

  -- -------------------   個別設定:Fern -------------------
  local function fern_mappings()
      vim.keymap.set("n", "cd", "<Plug>(fern-action-cd)", { buffer = true })
      vim.keymap.set("n", "cp", "<Plug>(fern-action-copy)", { buffer = true })
  end

  vim.api.nvim_create_autocmd("FileType", {
      pattern = "fern",
      callback = function()
          fern_mappings()
      end,
  })

  vim.g['fern#renderer'] = 'nerdfont'
  vim.g['fern#default_hidden'] = 1
  -- ------------------- / 個別設定:Fern -------------------

  -- -------------------   個別設定:Telescope -------------------
  vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { noremap = true, silent = true })
  -- ------------------- / 個別設定:Telescope -------------------

  -- -------------------   個別設定:Comment -------------------
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
  -- ------------------- / 個別設定:Comment -------------------
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
        { out, "WarningMsg" },
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
