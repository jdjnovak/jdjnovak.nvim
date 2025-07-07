local lsp = require("lsp-zero")

lsp.preset("recommended")

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

local cmp_select = { behavior = cmp.SelectBehavior.Select }
--local cmp_mappings = lsp.defaults.cmp_mappings({
	--['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	--['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	--['<C-y>'] = cmp.mapping.confirm({ select = true }),
	--['<C-Space>'] = cmp.mapping.complete(),
--})
--lsp.configure('gdscript', {
cmp.setup({
	sources = {
		{ name = 'nvim_lsp' },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		['<C-y>'] = cmp.mapping.confirm({ select = true }),
		['<C-Space>'] = cmp.mapping.complete(),
	}),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})

-- Disable sign icons
--lsp.set_preferences({
	--sign_icons = { }
--})

lsp.extend_lspconfig()

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false } 
	vim.keymap.set("n", "<leader>lj", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "<leader>lh", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>lw", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>lf", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "<leader>ln", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "<leader>lp", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>le", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

local uname = vim.loop.os_uname()
local OS = uname.sysname

if OS:find 'Windows' and true then
    local gdport = os.getenv('GDScript_Port') or '6005'
    local gdcmd = {'nc', '127.0.0.1', gdport}
    local gdpipe = [[\\.\pipe\godot.pipe]]
    
    require('mason').setup({})
    require('mason-lspconfig').setup({
    	ensure_installed = { 'rust_analyzer', 'pyright', 'gopls', 'lua_ls' },
    	handlers = {
    		--lsp.default_setup,
            function(server_name)
                require('lspconfig')[server_name].setup({})
            end,
            require('lspconfig').gdscript.setup({
                cmd = gdcmd,
                --root_dir = require('lspconfig.util').root_pattern('project.godot', '.git'),
                on_attach = function(client, bufnr)
                    print("Starting Godot LSP for windows")
                    vim.api.nvim_command([[echo serverstart(']] .. gdpipe .. [[')]])
                end
            })
    	},
    })
else
    --local gdport = os.getenv('GDScript_Port') or '6005'
    --local gdcmd = vim.lsp.rpc.connect('127.0.0.1', gdport)
    --local gdpipe = '/tmp/godot.pipe'
    
    require('mason').setup({})
    require('mason-lspconfig').setup({
    	ensure_installed = { 'rust_analyzer', 'pyright', 'gopls', 'lua_ls' },
    	handlers = {
    		--lsp.default_setup,
            function(server_name)
                require('lspconfig')[server_name].setup({})
            end,
            --require('lspconfig').gdscript.setup({
                --cmd = gdcmd,
                --root_dir = require('lspconfig.util').root_pattern('project.godot', '.git'),
                --on_attach = function(client, bufnr)
                    --vim.api.nvim_command('echo serverstart("'..gdpipe..'")')
                --end
            --})
    	},
    })
    require("lspconfig")["gdscript"].setup({
        name = "godot",
        cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
    })
    local dap = require("dap")
    dap.adapters.godot = {
        type = "server",
        host = "127.0.0.1",
        port = 6006,
    }
    dap.configurations.gdscript = {
        {
            type = "godot",
            request = "launch",
            name = "Launch scene",
            project = "${workspaceFolder}",
            launch_scene = true,
        }
    }
end
