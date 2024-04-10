local vim = vim -- You need to define vim before using it
vim.cmd [[colorscheme habamax]]
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
vim.opt.pumheight = 10


-- Plug configuration
local Plug = vim.fn['plug#']
vim.call('plug#begin')

-- autocompletion
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('L3MON4D3/LuaSnip')
Plug('VonHeikemen/lsp-zero.nvim', { branch = 'v3.x' })
Plug('nvim-treesitter/nvim-treesitter')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { tag = '0.1.6' })

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

require("nvim-treesitter.configs").setup({highlight={enable=true, disable=turn_on_only_on_specific_files}})
local telescope = require('telescope.builtin')

-- KEY BINDINGS

-- Telescope
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})

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
vim.keymap.set('n', '<leader>term', "':sp<CR>:edit term://zsh<CR>:set nonumber<CR>aclear<CR>'", opts) 
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
-- Skip a paragraph up/down
vim.keymap.set('n', 'ò', "'{'", opts)
vim.keymap.set('n', 'à', "'}'", opts)
-- Go to beginning/end of line
vim.keymap.set('n', '!', "'$'", opts)
vim.keymap.set('n', '|', "'0'", opts)

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
					    vim.fn.feedkeys('aint main(int argc, char** argv)\n{\n \n\b}')
					  end

vim.keymap.set('n', '<leader>main', generate_main, opts)


-- LSP
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
cmp.setup({
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<Down>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<S-Space>'] = cmp.mapping.complete(),
  }
})

require('lspconfig').clangd.setup({})
require('lspconfig').cmake.setup({})

-- Global mappings for completion
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'S', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', 'D', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
