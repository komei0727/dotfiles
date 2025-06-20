-- Basic Neovim Configuration

-- Options
vim.opt.number = true                -- Show line numbers
vim.opt.relativenumber = true        -- Show relative line numbers
vim.opt.tabstop = 4                  -- Tab width
vim.opt.shiftwidth = 4               -- Indent width
vim.opt.expandtab = true             -- Use spaces instead of tabs
vim.opt.smartindent = true           -- Smart indentation
vim.opt.wrap = false                 -- Disable line wrapping
vim.opt.swapfile = false             -- Disable swap files
vim.opt.backup = false               -- Disable backup files
vim.opt.undofile = true              -- Enable persistent undo
vim.opt.hlsearch = false             -- Don't highlight search results
vim.opt.incsearch = true             -- Incremental search
vim.opt.termguicolors = true         -- True color support
vim.opt.scrolloff = 8                -- Keep 8 lines above/below cursor
vim.opt.signcolumn = "yes"           -- Always show sign column
vim.opt.updatetime = 50              -- Faster completion
vim.opt.colorcolumn = "80"           -- Column marker at 80 characters
vim.opt.mouse = "a"                  -- Enable mouse support
vim.opt.clipboard = "unnamedplus"    -- Use system clipboard
vim.opt.ignorecase = true            -- Case insensitive search
vim.opt.smartcase = true             -- Smart case search

-- Key Mappings
vim.g.mapleader = " "                -- Set leader key to space

-- Normal mode mappings
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)              -- File explorer
vim.keymap.set("n", "<C-d>", "<C-d>zz")                    -- Center cursor after page down
vim.keymap.set("n", "<C-u>", "<C-u>zz")                    -- Center cursor after page up
vim.keymap.set("n", "n", "nzzzv")                          -- Center search results
vim.keymap.set("n", "N", "Nzzzv")                          -- Center search results
vim.keymap.set("n", "<leader>y", '"+y')                    -- Copy to system clipboard
vim.keymap.set("n", "<leader>Y", '"+Y')                    -- Copy line to system clipboard

-- Visual mode mappings
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")               -- Move line down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")               -- Move line up
vim.keymap.set("v", "<leader>y", '"+y')                    -- Copy to system clipboard

-- Replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Quick save and quit
vim.keymap.set("n", "<leader>w", ":w<CR>")                 -- Save
vim.keymap.set("n", "<leader>q", ":q<CR>")                 -- Quit
vim.keymap.set("n", "<leader>wq", ":wq<CR>")               -- Save and quit

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Disable arrow keys
vim.keymap.set("n", "<Up>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Left>", "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")

-- Auto commands
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.cmd([[%s/\s\+$//e]])
    end,
})

-- Set colorscheme (use default if not available)
vim.cmd.colorscheme("habamax")