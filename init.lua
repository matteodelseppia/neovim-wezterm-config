local vim = vim -- You need to define vim before using it
vim.cmd [[colorscheme default]]
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- Set tab to 4 spaces
vim.cmd [[set expandtab]]
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.wo.number = true

vim.opt.tabstop = 4
vim.g.mapleader = ' '


-- Plug configuration
local Plug = vim.fn['plug#']
vim.call('plug#begin')

-- autocompletion
Plug('neoclide/coc.nvim', { branch = 'release' })
vim.opt.pumheight = 10
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-treesitter/nvim-treesitter')
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}

-- If the autocompletion menu is open 
vim.call('plug#end') -- End plug definition

local turn_on_only_on_specific_files = function(lang)
	local buf_name = vim.fn.expand("%")
	if lang == "cpp" or lang == "lua" then
		return false
	end 
	return true
end	

require("nvim-tree").setup()
require("nvim-treesitter.configs").setup({highlight={enable=true, disable=turn_on_only_on_specific_files}})
-- KEY BINDINGS
-- If autocompletion menu is visible, pressing Down will go to the next completion option 
vim.keymap.set("i", "<Down>", "coc#pum#visible() ? coc#pum#next(1) : '<Down>'", opts)
-- If autocompletion menu is visible, pressing Up will go to the previous completion option 
vim.keymap.set("i", "<Up>", "coc#pum#visible() ? coc#pum#prev(1) : '<Up>'", opts)
-- If autocompletion menu is visible, pressing Enter will insert the completion
vim.keymap.set("i", "<CR>", "coc#pum#visible() ? coc#_select_confirm() : '<CR>'", opts)
-- Open/close file explorer
vim.keymap.set('n', '<leader>f', "':NvimTreeToggle<CR>'", opts)
-- Horizontal split 
vim.keymap.set('n', '<leader>hs', "':sp<CR>'", opts)
-- Vertical split
vim.keymap.set('n', '<leader>vs', "':vs<CR>'", opts)
-- Append to the beginning of the next line
vim.keymap.set('n', 'a', "'A<CR>'", opts)
-- Open this config file
vim.keymap.set('n', '<leader>conf', "':edit ~/.config/nvim/init.lua<CR>'", opts)
-- Go to EOF
vim.keymap.set('n', '<leader>eof', "'GA<CR>'", opts)
-- Open terminal
vim.keymap.set('n', '<leader>term', "':edit term://zsh<CR>:set nonumber<CR>aclear<CR>'", opts) 
-- Exit terminal mode
vim.keymap.set('t', '<Esc>', "'<C-\\><C-n>'", opts)
-- Change window
vim.keymap.set('n', '<Tab>', "'<C-w>w'", opts) 
-- Left: K, Right: L, Up: O, Down: M
vim.keymap.set('n', 'm', "'j'", opts)
vim.keymap.set('n', 'o', "'k'", opts)
vim.keymap.set('n', 'k', "'h'", opts)
-- Add blank line below this line without moving the cursor
vim.keymap.set('n', '<leader>-<CR>', "'A<CR><Esc>j'", opts)

-- Disable arrows in normal mode
local do_nothing = function() end
vim.keymap.set('n', '<Left>', do_nothing, opts)
vim.keymap.set('n', '<Right>', do_nothing, opts)
vim.keymap.set('n', '<Up>', do_nothing, opts)
vim.keymap.set('n', '<Down>', do_nothing, opts)

-- Copy entire file to clipboard
vim.keymap.set('n', '<leader>cp', "':%y+<CR>'", opts)

-- Copy current line to clipboard
vim.keymap.set('n', 'cp', "'yy+'", opts)

-- Paste to current line
vim.keymap.set('n', 'p', "'kp'", opts)

-- C/C++ helpers
local generate_main = function()
			vim.fn.feedkeys('aint main(int argc, char** argv)\n{\n//main body\n\b}')
		      end

vim.keymap.set('n', '<leader>main', generate_main, opts)
