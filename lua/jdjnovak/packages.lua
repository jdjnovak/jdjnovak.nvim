return {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.3',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'AlexvZyl/nordic.nvim',
        lazy = false,
		priority = 1000,
        config = function()
            require 'nordic' .load()
        end
	},
    {
        'jacoborus/tender.vim',
        lazy = false,
        priority = 1000
    },
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
	},
	{ 'mbbill/undotree' },
	{ 'tpope/vim-fugitive' },
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
	},
	{
		'williamboman/mason.nvim',
		ui = {
			icons = {
				package_installed = "✓",
            			package_pending = "➜",
            			package_uninstalled = "✗"
			}
		}
        },
	{ 'williamboman/mason-lspconfig.nvim' },
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp'
		},
	},
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'L3MON4D3/LuaSnip'
		},
	},
}
