set number
set showmatch
set visualbell
set smartcase
set ignorecase
set incsearch
set autoindent
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set signcolumn=no
set shell=/bin/bash
set mouse=n
set mousemodel=""

call plug#begin()
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
    Plug 'navarasu/onedark.nvim'
    Plug 'tikhomirov/vim-glsl'
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'rust-lang/rust.vim'
call plug#end()

let g:onedark_config = {
  \ 'style': 'warmer',
  \ 'transparent': v:false,
\}
colorscheme onedark
set colorcolumn=100
au BufRead,BufNewFile *.h set filetype=c
au BufRead,BufNewFile *.slang set filetype=slang
let g:c_syntax_for_h = 1
let g:rustfmt_autosave = 1
let g:zig_fmt_autosave = 0
hi ErrGroup guibg=Red

lua <<EOF
    local telescope = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = 'Telescope help tags' })
    local cmp = require('cmp')
    local types = require('cmp.types')

    local priority_map = {
	[types.lsp.CompletionItemKind.Constant] = 1,
	[types.lsp.CompletionItemKind.EnumMember] = 2,
	[types.lsp.CompletionItemKind.Variable] = 3,
	[types.lsp.CompletionItemKind.Method] = 4,
	[types.lsp.CompletionItemKind.Field] = 5,
	[types.lsp.CompletionItemKind.Snippet] = 200,
      	[types.lsp.CompletionItemKind.Text] = 100,
    }

    local kind = function(entry1, entry2)
	local kind1 = entry1:get_kind()
	local kind2 = entry2:get_kind()
	kind1 = priority_map[kind1] or kind1
	kind2 = priority_map[kind2] or kind2
	if kind1 ~= kind2 then
	    local diff = kind1 - kind2
	    if diff < 0 then
		return true
	    elseif diff > 0 then
		return false
	    end
	end
    end

    cmp.setup({
	snippet = {
	    expand = function(args)
		vim.snippet.expand(args.body)
	    end,
	},
	sources = cmp.config.sources({
	    { name = 'nvim_lsp' },
	}, {
	    { name = 'buffer' },
	}),
	completion = {
	    completeopt = 'menu,menuone,noinsert'  
	},
	mapping = cmp.mapping.preset.insert({
	    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
	    ['<C-f>'] = cmp.mapping.scroll_docs(4),
	    ['<C-Space>'] = cmp.mapping.complete(),
	    ['<C-e>'] = cmp.mapping.abort(),
	    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
	}),
	preselect = cmp.PreselectMode.None,
	sorting = {
	    priority_weight = 100,
	    comparators = {
		cmp.config.compare.offset,
	    	cmp.config.compare.exact,
	    	cmp.config.compare.score,
	    	kind,
	    	cmp.config.compare.recently_used,
	    	cmp.config.compare.locality,
	    	cmp.config.compare.sort_text,
	    	cmp.config.compare.length,
	    	cmp.config.compare.order,
	    },
	},
	formatting = {
	    format = function(entry, item)
		item.menu = ''
        	local content = item.abbr
        	local win_width = vim.api.nvim_win_get_width(0)
        	local max_content_width = math.floor(win_width * 0.2)
        	if #content > max_content_width then
        	    item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
        	else
        	    item.abbr = content .. (" "):rep(max_content_width - #content)
        	end
        	return item
	    end,
	}
    })

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require('lspconfig')
    lspconfig.rust_analyzer.setup {
	capabilities = capabilities,
	settings = {
	    ['rust-analyzer'] = {
		diagnostics = {
		    experimental = {
			enable = true,
		    },
		    disabled = {
			'unlinked-file',
		    },
		}
	    }
	}
    }
    lspconfig.clangd.setup {
	capabilities = capabilities,
	cmd = {
	    "clangd",
	    "-header-insertion=never",
	}
    }
    lspconfig.glsl_analyzer.setup {
	capabilities = capabilities
    }
    lspconfig.cmake.setup {
	capabilities = capabilities
    }

    vim.diagnostic.config({
	update_in_insert = true,
	severity_sort = true,
	virtual_text = {
	    hl_eol = true,
	    virt_text_repeat_linebreak = true,
	},
	signs = {
	    numhl = {
		[vim.diagnostic.severity.ERROR] = 'ErrGroup',
		[vim.diagnostic.severity.WARN] = 'WarningMsg',
		[vim.diagnostic.severity.INFO] = 'Whitespace',
		[vim.diagnostic.severity.HINT] = 'Directory',
	    },
	},
    })

    vim.api.nvim_create_autocmd({'BufWritePre'}, {
	callback = function()
	    vim.lsp.buf.format()
	end,
    })
EOF
