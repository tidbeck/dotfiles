require('plugins')
require('lsp')

-- General options
vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.ruler = true
vim.clipboard = 'unnamedplus'
vim.opt.inccommand = 'nosplit'

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.backupdir = vim.fn.stdpath('config')..'/swpfiles'
vim.opt.directory = vim.fn.stdpath('config')..'/swpfiles'
vim.opt.undodir = vim.fn.stdpath('config')..'/undodir'
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

vim.g.mapleader = ','

vim.opt.list = true
vim.opt.listchars = {
    -- tab = "»\ ", -- TODO: Fix this
    trail = '·',
    nbsp = '⎵',
    precedes = '<',
    extends = '>'
}

-- Colors
vim.cmd[[colorscheme tokyonight]]
vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = true
vim.g.tokyonight_italic_functions = true

-- Mappings
vim.api.nvim_set_keymap('n', 'ö', '[', {noremap = true, silent = false})
vim.api.nvim_set_keymap('n', 'ä', '[', {noremap = true, silent = false})
vim.api.nvim_set_keymap('o', 'ö', '[', {noremap = true, silent = false})
vim.api.nvim_set_keymap('o', 'ä', '[', {noremap = true, silent = false})
vim.api.nvim_set_keymap('x', 'ö', '[', {noremap = true, silent = false})
vim.api.nvim_set_keymap('x', 'ä', '[', {noremap = true, silent = false})

vim.api.nvim_set_keymap('n', '.', '.`[', {noremap = true, silent = false}) -- Insert newline
vim.api.nvim_set_keymap('n', 'j', 'gj', {noremap = true, silent = false})
vim.api.nvim_set_keymap('n', 'k', 'gk', {noremap = true, silent = false})

vim.api.nvim_set_keymap('n', '<leader>a', ':bnext', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>s', ':bprevious', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<CR>', ':nohlsearch<CR><CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>p', ':execute %!python -m json.tool<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>t', ':TroubleToggle<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-E>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>f', ':Files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>r', ':Rg<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>g', ':GFiles<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>m', ':make<CR>:cw<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true, silent = true})


-- Completion
vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.shortmess = 'c' -- Avoid showing message extra message when using completion
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
vim.g.completion_matching_ignore_case = false
vim.g.completion_trigger_keyword_length = 2
vim.g.enable_auto_popup = true

-- Yaml
vim.cmd [[autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2 expandtab]]

-- Ruby
vim.cmd [[autocmd BufNewFile,BufRead Podfile,*.podspec set filetype=ruby]]

-- Go
vim.g.go_term_enabled = true
vim.g.go_term_mode = "split"

vim.cmd [[autocmd Filetype go setlocal list listchars=tab:\ \ ,trail:·,nbsp:⎵,precedes:<,extends:>]]

vim.cmd [[autocmd Filetype go nnoremap <F1> :GoBuild<CR>]]
vim.cmd [[autocmd Filetype go nnoremap <F2> :GoTest<CR>]]
vim.cmd [[autocmd Filetype go nnoremap <F3> :GoRun<CR>]]
vim.cmd [[autocmd Filetype go nnoremap <F4> :GoDebugStart<CR>]]
-- vim.cmd [[autocmd Filetype go nnoremap <F5> :GoDebugContinue<CR>]]
-- vim.cmd [[autocmd Filetype go nnoremap <F6> :GoDebugPrint ]]
-- vim.cmd [[autocmd Filetype go nnoremap <F8> :GoDebugHalt<CR>]]
vim.cmd [[autocmd Filetype go nnoremap <F9> :GoDebugBreakpoint<CR>]]
-- vim.cmd [[autocmd Filetype go nnoremap <F10> :GoDebugNext<CR>]]
-- vim.cmd [[autocmd Filetype go nnoremap <F11> :GoDebugStep<CR>]]
vim.cmd [[autocmd Filetype go nnoremap <F12> :GoDebugStop<CR>]]

-- Swift
-- TODO: Fix this in lua
-- let iPhoneSimulatorSDKPath = system('xcrun --sdk iphonesimulator --show-sdk-path')[:-2]
-- let iPhoneSimulatorSDKVersion = system('xcrun --sdk iphonesimulator --show-sdk-version')[:-2]
-- autocmd Filetype swift let &makeprg = "xcrun swift build -Xswiftc -continue-building-after-errors -Xswiftc -sdk -Xswiftc " . iPhoneSimulatorSDKPath . " -Xswiftc -target -Xswiftc x86_64-apple-ios" . iPhoneSimulatorSDKVersion . "-simulator"

-- Pretty diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    -- This sets the spacing and the prefix, obviously.
    virtual_text = {
        spacing = 4,
        prefix = "●",
    }
}
)

