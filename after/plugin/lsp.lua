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

cmp.setup({
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
	sources = {
		{ name = 'lsp-zero' },
	}
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
require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = { 'rust_analyzer', 'pyright' },
	handlers = {
		lsp.default_setup,
	},
})
