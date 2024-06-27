vim.opt.guifont = 'Noto Sans Mono CJK JP:h12'
vim.api.nvim_set_keymap('n', '+', ':lua vim.o.guifont = vim.o.guifont:gsub("%d+", function(n) return tostring(tonumber(n) + 1) end)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-', ':lua vim.o.guifont = vim.o.guifont:gsub("%d+", function(n) return tostring(tonumber(n) - 1) end)<CR>', { noremap = true, silent = true })
