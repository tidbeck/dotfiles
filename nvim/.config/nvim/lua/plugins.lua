-- Bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Files
    use { 'junegunn/fzf', run = ':call fzf#install()' }
    use 'junegunn/fzf.vim'

    -- Surround
    use 'tpope/vim-surround'

    -- Git
    use 'tpope/vim-fugitive'

    -- Completion
    use 'neovim/nvim-lspconfig'
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

