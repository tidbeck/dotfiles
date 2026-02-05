---------------------------------------
-- LAZY.NVIM BOOTSTRAP
---------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

---------------------------------------
-- PLUGINS
---------------------------------------
require("lazy").setup({

    -- Fuzzy finder: search files, buffers, grep content
    -- https://github.com/junegunn/fzf
    -- https://github.com/junegunn/fzf.vim
    -- Usage: :Files, :Rg, :Buffers, :GFiles
    {
        "junegunn/fzf",
        build = ":call fzf#install()",
    },
    { "junegunn/fzf.vim" },

    -- Surround text with quotes, brackets, tags: cs'" (change), ds" (delete), ysiw] (add)
    -- https://github.com/tpope/vim-surround
    { "tpope/vim-surround" },
    -- Make surround commands repeatable with .
    -- https://github.com/tpope/vim-repeat
    { "tpope/vim-repeat" },

    -- Git commands in vim: :Git blame, :Git diff, :Git log
    -- https://github.com/tpope/vim-fugitive
    { "tpope/vim-fugitive" },

    -- LSP configurations for various languages
    -- https://github.com/neovim/nvim-lspconfig
    { "neovim/nvim-lspconfig" },
    -- Easy LSP server installation (deprecated, consider mason.nvim)
    -- https://github.com/williamboman/nvim-lsp-installer
    { "williamboman/nvim-lsp-installer" },

    -- Autocompletion engine
    -- https://github.com/hrsh7th/nvim-cmp
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",      -- Complete from buffer words
            "hrsh7th/cmp-nvim-lsp",    -- Complete from LSP
            "hrsh7th/cmp-nvim-lua",    -- Complete Neovim Lua API
            "hrsh7th/cmp-path",        -- Complete file paths
            "hrsh7th/cmp-calc",        -- Math calculations
            "f3fora/cmp-spell",        -- Spelling suggestions
            "hrsh7th/cmp-emoji",       -- Emoji completion :emoji:
            "onsails/lspkind-nvim",    -- VSCode-like icons in completion menu
        },
    },

    -- File type icons (used by lualine, nvim-tree, etc)
    -- https://github.com/kyazdani42/nvim-web-devicons
    {
        "kyazdani42/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup()
            require("nvim-web-devicons").get_icons()
        end,
    },

    -- Status line at bottom of screen
    -- https://github.com/nvim-lualine/lualine.nvim
    {
        "hoob3rt/lualine.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "tokyonight",
                },
                sections = {
                    lualine_c = {
                        {
                            "filename",
                            file_status = true,
                            path = 1,  -- 0=filename, 1=relative, 2=absolute
                        },
                    },
                },
                extensions = {
                    "fugitive",
                },
            })
        end,
    },

    -- File tree sidebar, toggle with <leader>e
    -- https://github.com/kyazdani42/nvim-tree.lua
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                diagnostics = {
                    enable = true,
                    show_on_dirs = true,
                },
                update_focused_file = {
                    enable = true,       -- Auto-highlight current file in tree
                    update_root = false, -- Don't change root dir when switching files
                },
            })
        end,
    },

    -- Colorscheme: dark theme with good contrast
    -- https://github.com/folke/tokyonight.nvim
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
    },

    -- Pretty diagnostics list, toggle with <leader>t
    -- https://github.com/folke/trouble.nvim
    {
        "folke/trouble.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("trouble").setup()
        end,
    },

    -- Language syntax support
    { "keith/swift.vim" },       -- https://github.com/keith/swift.vim
    { "udalov/kotlin-vim" },     -- https://github.com/udalov/kotlin-vim
    { "towolf/vim-helm" },       -- https://github.com/towolf/vim-helm
    { "sebdah/vim-delve" },      -- https://github.com/sebdah/vim-delve (Go debugger)
    {
        -- Go development: :GoBuild, :GoTest, :GoRun, :GoDebugStart
        -- https://github.com/fatih/vim-go
        "fatih/vim-go",
        build = ":GoUpdateBinaries",
    },

    -- Treesitter: better syntax highlighting, code understanding
    -- https://github.com/nvim-treesitter/nvim-treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")
            ts.setup({
                ensure_installed = "all",
            })
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.opt.foldenable = false
        end,
    },

    -- Render markdown with formatting in buffer
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("render-markdown").setup({})
        end,
    },

    -- Auto-detect indent settings (tabs vs spaces, width) from file content
    -- https://github.com/tpope/vim-sleuth
    { "tpope/vim-sleuth" },

    -- LSP progress indicator in bottom right corner
    -- https://github.com/j-hui/fidget.nvim
    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({})
        end,
    },

    -- Format on save with external formatters (prettier, ruff, gofmt, etc)
    -- https://github.com/stevearc/conform.nvim
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    python = { "ruff_format" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
                    json = { "prettier" },
                    html = { "prettier" },
                    css = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                    go = { "gofmt" },
                    kotlin = { "ktlint" },  -- brew install ktlint
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
            })
        end,
    },

})

---------------------------------------
-- Setup LSP
---------------------------------------
vim.lsp.config("*", {
    flags = {
        debounce_text_changes = 150,
    },
})

local nvim_lsp = require("lspconfig")

-- LSP servers to enable (must be installed separately)
-- ts_ls: JavaScript/TypeScript (npm i -g typescript-language-server typescript)
-- ty: Python type checker (pip install ty)
-- ruff: Python linter/formatter (pip install ruff)
local servers = {
    "ts_ls",
    "ty",
    "ruff",
}
vim.lsp.enable(servers)

-- Kotlin LSP (brew install JetBrains/utils/kotlin-lsp)
-- https://github.com/Kotlin/kotlin-lsp
-- Note: Experimental, JVM-only Gradle projects
vim.api.nvim_create_autocmd("FileType", {
    pattern = "kotlin",
    callback = function(args)
        local bufpath = vim.api.nvim_buf_get_name(args.buf)
        -- Skip empty buffers and special URIs (fugitive://, gitsigns://, etc.)
        if bufpath == "" or bufpath:match("^%w+://") then return end
        local root_files = { "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts" }
        local root_dir = vim.fs.dirname(vim.fs.find(root_files, {
            upward = true,
            path = vim.fs.dirname(bufpath),
        })[1])
        if root_dir then
            vim.lsp.start({
                name = "kotlin-lsp",
                cmd = { "kotlin-lsp", "--stdio" },
                root_dir = root_dir,
                init_options = {},
                settings = {},
            }, { bufnr = args.buf })
        end
    end,
})

function execute(cmd)
    local file = io.popen(cmd, "r")
    local output = file:read("*all")
    file:close()
    return output
end

local iPhoneSimulatorSDKPath = execute("xcrun --sdk iphonesimulator --show-sdk-path"):gsub("\n", "")
local iPhoneSimulatorSDKVersion = execute("xcrun --sdk iphonesimulator --show-sdk-version"):gsub("\n", "")

local cmp = require("cmp")
cmp.setup({
    formatting = {
        snippet = {
            expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
            end,
        },
        format = function(entry, vim_item)
            vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
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
                emoji = "[Emoji]",
            })[entry.source.name]
            return vim_item
        end,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
    },
    sources = {
        { name = "buffer" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "calc" },
        { name = "spell" },
        { name = "emoji" },
    },
})

---------------------------------------
-- Configure
---------------------------------------
vim.opt.termguicolors = true       -- Enable 24-bit RGB colors
vim.opt.mouse = "a"                -- Enable mouse in all modes
vim.opt.ruler = true               -- Show cursor position in status line
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard (yank/paste)
vim.opt.inccommand = "nosplit"     -- Live preview of :substitute

vim.opt.tabstop = 4                -- Tab = 4 spaces visually
vim.opt.shiftwidth = 4             -- Indent = 4 spaces
vim.opt.expandtab = true           -- Convert tabs to spaces

vim.opt.hlsearch = true            -- Highlight search matches
vim.opt.incsearch = true           -- Show matches while typing search

-- Swap and undo files stored in config dir (not in working directory)
vim.opt.backupdir = vim.fn.stdpath("config") .. "/swpfiles"
vim.opt.directory = vim.fn.stdpath("config") .. "/swpfiles"
vim.opt.undodir = vim.fn.stdpath("config") .. "/undodir"
vim.opt.undofile = true            -- Persist undo history to file
vim.opt.undolevels = 1000          -- Max undo steps
vim.opt.undoreload = 10000         -- Max lines to save for undo on reload

vim.g.mapleader = ","              -- Leader key for custom mappings

-- Show invisible characters
vim.opt.list = true
vim.opt.listchars = {
    tab = "» ",       -- Tab characters
    trail = "·",      -- Trailing spaces
    nbsp = "⎵",       -- Non-breaking spaces
    precedes = "<",   -- Content extends left of screen
    extends = ">",    -- Content extends right of screen
}

-- Colors
vim.g.tokyonight_style = "storm"
vim.g.tokyonight_transparent = false
vim.g.tokyonight_italic_comments = true
vim.g.tokyonight_italic_functions = true
vim.cmd([[colorscheme tokyonight]])

-- Spellcheck (]s next, [s prev, z= suggestions, zg add to dict)
vim.opt.spell = true               -- Enable spell checking
vim.opt.spelllang = "en"           -- English dictionary
vim.opt.spelloptions = "camel"     -- Treat camelCase as separate words
vim.opt.spellcapcheck = ""         -- Don't flag uncapitalized sentences

---------------------------------------
-- Mappings (leader = ,)
---------------------------------------
-- Swedish keyboard: ö and ä as [ for easier navigation
-- noremap=false allows plugin mappings like [c (git hunk) to work
vim.api.nvim_set_keymap("n", "ö", "[", { noremap = false, silent = false })
vim.api.nvim_set_keymap("n", "ä", "[", { noremap = false, silent = false })
vim.api.nvim_set_keymap("o", "ö", "[", { noremap = false, silent = false })
vim.api.nvim_set_keymap("o", "ä", "[", { noremap = false, silent = false })
vim.api.nvim_set_keymap("x", "ö", "[", { noremap = false, silent = false })
vim.api.nvim_set_keymap("x", "ä", "[", { noremap = false, silent = false })

-- Navigation improvements
vim.api.nvim_set_keymap("n", ".", ".`[", { noremap = true, silent = false })  -- Stay at insert position after repeat
vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true, silent = false })   -- Move by visual line (wrapped)
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true, silent = false })   -- Move by visual line (wrapped)

-- Buffer navigation
vim.api.nvim_set_keymap("n", "<leader>a", ":bnext", { noremap = true, silent = true })      -- Next buffer
vim.api.nvim_set_keymap("n", "<leader>s", ":bprevious", { noremap = true, silent = true })  -- Prev buffer

-- Clear search highlight on Enter
vim.api.nvim_set_keymap("n", "<CR>", ":nohlsearch<CR><CR>", { noremap = true, silent = true })

-- Tools
vim.api.nvim_set_keymap("n", "<leader>p", ":%!python3 -m json.tool<CR>", { noremap = true, silent = true })  -- Format JSON
vim.api.nvim_set_keymap("n", "<leader>t", ":TroubleToggle<CR>", { noremap = true, silent = true })           -- Toggle diagnostics
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })          -- Toggle file tree
vim.api.nvim_set_keymap("n", "<leader>m", ":make<CR>:cw<CR>", { noremap = true, silent = true })             -- Run make

-- Fuzzy finder (fzf)
vim.api.nvim_set_keymap("n", "<leader>f", ":Files<CR>", { noremap = true, silent = true })    -- Find files
vim.api.nvim_set_keymap("n", "<leader>r", ":Rg<CR>", { noremap = true, silent = true })       -- Ripgrep search
vim.api.nvim_set_keymap("n", "<leader>b", ":Buffers<CR>", { noremap = true, silent = true })  -- List buffers
vim.api.nvim_set_keymap("n", "<leader>g", ":GFiles<CR>", { noremap = true, silent = true })   -- Git files

-- LSP
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })   -- Go to definition
vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true })   -- Find references
vim.api.nvim_set_keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true })  -- Code actions
vim.api.nvim_set_keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true }) -- Show diagnostic

-- Completion behavior
vim.opt.completeopt = "menuone,noinsert,noselect"  -- Show menu, don't auto-insert/select
vim.opt.shortmess:append("c")                       -- Don't show completion messages
vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy" }
vim.g.completion_matching_ignore_case = false
vim.g.completion_trigger_keyword_length = 2
vim.g.enable_auto_popup = true

-- Ruby
vim.cmd([[autocmd BufNewFile,BufRead Podfile,*.podspec set filetype=ruby]])

-- Go
vim.g.go_term_enabled = true
vim.g.go_term_mode = "split"

vim.cmd([[autocmd Filetype go setlocal list listchars=tab:\ \ ,trail:·,nbsp:⎵,precedes:<,extends:>]])

vim.cmd([[autocmd Filetype go nnoremap <F1> :GoBuild<CR>]])
vim.cmd([[autocmd Filetype go nnoremap <F2> :GoTest<CR>]])
vim.cmd([[autocmd Filetype go nnoremap <F3> :GoRun<CR>]])
vim.cmd([[autocmd Filetype go nnoremap <F4> :GoDebugStart<CR>]])
vim.cmd([[autocmd Filetype go nnoremap <F9> :GoDebugBreakpoint<CR>]])
vim.cmd([[autocmd Filetype go nnoremap <F12> :GoDebugStop<CR>]])

-- Pretty diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
        spacing = 4,
        prefix = "●",
    },
})
