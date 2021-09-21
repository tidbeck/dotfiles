local nvim_lsp = require('lspconfig')

function execute(cmd)
    local file = io.popen(cmd, 'r')
    local output = file:read('*all')
    file:close()
    return output
end

local iPhoneSimulatorSDKPath = execute('xcrun --sdk iphonesimulator --show-sdk-path'):gsub('\n', '')
local iPhoneSimulatorSDKVersion = execute('xcrun --sdk iphonesimulator --show-sdk-version'):gsub('\n', '')

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
    on_attach = require'completion'.on_attach
}

-- Javascript/TypeScript
nvim_lsp.tsserver.setup {
    on_attach = require'completion'.on_attach
}

-- HTML
nvim_lsp.html.setup {
    on_attach = require'completion'.on_attach
}

-- Ruby
nvim_lsp.solargraph.setup {
    cmd = {
        'bundle',
        'exec', 
        'solargraph',
        'stdio'
    };
    on_attach = require'completion'.on_attach
}

-- Go
nvim_lsp.gopls.setup {
    on_attach = require'completion'.on_attach
}

-- Debug
--vim.lsp.set_log_level("debug")
