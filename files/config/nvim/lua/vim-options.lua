vim.opt.relativenumber = true
vim.cmd [[
    set nu rnu
]]
vim.opt.linebreak = true	-- Break lines at word (requires Wrap lines)
vim.opt.showbreak = '+++' 	-- Wrap-broken line prefix
vim.opt.textwidth = 160	-- Line wrap (number of cols)
vim.opt.showmatch = true	-- Highlight matching brace
vim.opt.visualbell = true	-- Use visual bell (no beeping)
 
vim.opt.hlsearch = true	-- Highlight all search results
vim.opt.smartcase = true	-- Enable smart-case search
vim.opt.incsearch = true	-- Searches for strings incrementally
 
vim.opt.autoindent = true	-- Auto-indent new lines
vim.opt.expandtab = true	-- Use spaces instead of tabs
vim.opt.shiftwidth = 4	-- Number of auto-indent spaces
vim.opt.smartindent = true	-- Enable smart-indent
vim.opt.smarttab = true	-- Enable smart-tabs
vim.opt.softtabstop = 4	-- Number of spaces per Tab
vim.opt.list = true     -- View invisible characters 

-- Advanced
vim.opt.ruler = true	-- Show row and column ruler information

vim.opt.undolevels = 1000	 -- Number of undo levels
vim.opt.undofile = true
vim.opt.backspace = {'indent', 'eol', 'start'}	-- Backspace behaviour<Paste>
vim.opt.inccommand = 'nosplit' -- Neovim only: Shows you in realtime what changes your ex command should make

vim.g.mapleader = ' '

vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('n', '<c-h>', '<c-w>h')
