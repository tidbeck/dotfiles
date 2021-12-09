---------------------------------------
-- Load plugins
---------------------------------------
-- Bootstrap packer
local fn = vim.fn
local packer_install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packer_install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_install_path})
  vim.cmd 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Themes
    use { 'arcticicestudio/nord-vim' }

    -- Files
    use { 'junegunn/fzf', run = ':call fzf#install()' }
    use 'junegunn/fzf.vim'

    -- Surround
    use 'tpope/vim-surround'

    -- Git
    use 'tpope/vim-fugitive'

    -- Completion
    use {
        'neovim/nvim-lspconfig',
        'williamboman/nvim-lsp-installer',
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-calc',
            'f3fora/cmp-spell',
            'hrsh7th/cmp-emoji',
            'onsails/lspkind-nvim'

        }
    }

    -- Icons
    use {
        'kyazdani42/nvim-web-devicons',
        config = function()
            require'nvim-web-devicons'.setup()
            require'nvim-web-devicons'.get_icons()
        end
    }

    -- Status line
    use {
        'hoob3rt/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require'lualine'.setup {
                options = {
                    theme = 'tokyonight',
                },
                sections = {
                    -- lualine_b = {
                    -- {
                    -- 'diagnostic',
                    -- source = {
                    -- 'nvim_lsp'
                    -- }
                    -- }
                    -- },
                    lualine_c = {
                        {
                            'filename',
                            file_status = true,
                            path = 1
                        }
                    }
                },
                extensions = {
                    'fugitive'
                }
            }
        end
    }

    -- File navigator
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require'nvim-tree'.setup()
        end
    }

    -- Colorscheme
    use 'folke/tokyonight.nvim'

    -- Pretty LSP diagnostics
    use {
        'folke/trouble.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require'trouble'.setup()
        end
    }
    use {
        'glepnir/lspsaga.nvim',
        config = function()
            require'lspsaga'.init_lsp_saga {
                -- icons / text used for a diagnostic
                error_sign = "",
                warn_sign = "",
                hint_sign = "",
                infor_sign = "",
            }
        end
    }

    -- Syntax
    use 'keith/swift.vim'
    use 'udalov/kotlin-vim'
    use 'towolf/vim-helm'
    use { 'sebdah/vim-delve', { 'fatih/vim-go', run = ':GoUpdateBinaries' } }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = "maintained",
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true
                }
            }
        end
    }

    use {
        'nvim-treesitter/playground',
        requires = 'nvim-treesitter/nvim-treesitter',
    }

    -- Github copilot
    use 'github/copilot.vim'

end)

---------------------------------------
-- Setup LSP
---------------------------------------
local nvim_lsp = require('lspconfig')
local lsp_installer = require("nvim-lsp-installer")

function execute(cmd)
    local file = io.popen(cmd, 'r')
    local output = file:read('*all')
    file:close()
    return output
end

local iPhoneSimulatorSDKPath = execute('xcrun --sdk iphonesimulator --show-sdk-path'):gsub('\n', '')
local iPhoneSimulatorSDKVersion = execute('xcrun --sdk iphonesimulator --show-sdk-version'):gsub('\n', '')

lsp_installer.on_server_ready(function(server)
    local opts = {}
    server:setup(opts)
end)

local cmp = require('cmp')
cmp.setup {

    formatting = {
        format = function(entry, vim_item)
            -- fancy icons and a name of kind
            vim_item.kind = require("lspkind").presets.default[vim_item.kind] ..
                                " " .. vim_item.kind
            -- set a name for each source
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                ultisnips = "[UltiSnips]",
                nvim_lua = "[Lua]",
                cmp_tabnine = "[TabNine]",
                look = "[Look]",
                path = "[Path]",
                spell = "[Spell]",
                calc = "[Calc]",
                emoji = "[Emoji]"
            })[entry.source.name]
            return vim_item
        end
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        })
    },
    sources = {
        {name = 'buffer'},
        {name = 'nvim_lsp'},
        {name = "nvim_lua"},
        {name = "path"},
        {name = "calc"},
        {name = "spell"},
        {name = "emoji"}
    }
}

-- Swift
nvim_lsp.sourcekit.setup {
    cmd = {
        'xcrun',
        'sourcekit-lsp',
        '-Xswiftc', '-sdk',
        '-Xswiftc', iPhoneSimulatorSDKPath,
        '-Xswiftc', '-target',
        '-Xswiftc', 'x86_64-apple-ios'..iPhoneSimulatorSDKVersion..'-simulator'
    };
}

-- Javascript/TypeScript
nvim_lsp.tsserver.setup {
}

-- HTML
nvim_lsp.html.setup {
}

-- Ruby
nvim_lsp.solargraph.setup {
    cmd = {
        'bundle',
        'exec', 
        'solargraph',
        'stdio'
    };
}

-- Go
nvim_lsp.gopls.setup {
}

-- Python
nvim_lsp.pyright.setup {
}

-- Debug
--vim.lsp.set_log_level("debug")

---------------------------------------
--  Configure
---------------------------------------
vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.ruler = true
vim.opt.clipboard = 'unnamedplus'
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

vim.api.nvim_set_keymap('n', '<leader>p', ':%!python -m json.tool<CR>', {noremap = true, silent = true})
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
vim.opt.shortmess:append('c') -- Avoid showing message extra message when using completion
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

