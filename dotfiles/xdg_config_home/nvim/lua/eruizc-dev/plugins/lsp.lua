return {
	{
		'zbirenbaum/copilot.lua',
		cmd = 'Copilot',
		build = ':Copilot auth',
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
		},
		config = function()
			require('copilot').setup({})
		end,
	},
	{
		'neovim/nvim-lspconfig',
		cmd = 'LspInfo',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			{
				'williamboman/mason-lspconfig.nvim',
				dependencies = 'williamboman/mason.nvim',
				opts = {
					automatic_installation = true,
				}
			},
		},
		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				virtual_text = {
					severity = vim.diagnostic.severity.WARN,
					source = 'if_many',
					spacing = 4,
				},
				signs = false,
				severity_sort = true,
				update_in_insert = false,
			},
			inlay_hints = { enabled = true },
			servers = {
				clangd = {},
				gopls = {},
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = 'LuaJIT' }, -- Which version, LuaJIT for Neovim
							workspace = {
								library = vim.api.nvim_get_runtime_file('', true), -- Make the server aware of Neovim runtime files
								checkThirdParty = false,
							},
							diagnostics = { globals = { 'vim' } },
							telemetry = { enable = false },
						},
					},
				},
				vimls = {},
			},
		},
		config = function(_, opts)
			local completion_capabilities = require'cmp_nvim_lsp'.default_capabilities()
			for server, server_opts in pairs(opts.servers) do
				local final_opts = vim.tbl_extend('force', { capabilities = completion_capabilities }, server_opts)
				require('lspconfig')[server].setup(final_opts)
			end
			vim.diagnostic.config(opts) -- Must be after setup
		end,
	},
}
