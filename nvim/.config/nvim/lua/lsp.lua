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
