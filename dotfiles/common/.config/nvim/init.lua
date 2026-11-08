-- Omiden OS - Neovim Configuration
-- Path: ~/.config/nvim/init.lua

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Key mappings
local keymap = vim.keymap.set

-- Save and quit
keymap('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
keymap('n', '<leader>q', ':q<CR>', { desc = 'Quit' })

-- Better window navigation
keymap('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows
keymap('n', '<C-Up>', ':resize -2<CR>', { desc = 'Resize up' })
keymap('n', '<C-Down>', ':resize +2<CR>', { desc = 'Resize down' })
keymap('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Resize left' })
keymap('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Resize right' })

-- Better indenting
keymap('v', '<', '<gv', { desc = 'Indent left' })
keymap('v', '>', '>gv', { desc = 'Indent right' })

-- Move text up and down
keymap('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
keymap('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })

-- Clear search highlight
keymap('n', '<Esc>', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

-- File explorer
keymap('n', '<leader>e', ':Explore<CR>', { desc = 'File explorer' })

-- Colorscheme (default, users can install their own)
vim.cmd('colorscheme default')

-- Auto commands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd('TextYankPost', {
    group = augroup('YankHighlight', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Remove trailing whitespace on save
autocmd('BufWritePre', {
    group = augroup('TrimWhitespace', { clear = true }),
    pattern = '*',
    command = [[%s/\s\+$//e]],
})
