" Updating: PlugUpdate
" Remove unneeded: PlugClean
" Install new: PlugInstall

" Start of pluginlist
call plug#begin('~/.config/nvim/plugs')
    " Themes
    Plug 'projekt0n/github-nvim-theme'
    Plug 'joshdick/onedark.vim'
    Plug 'katawful/kat.vim'

    " Builtin LSP support and autocompletion
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'onsails/lspkind-nvim'
    Plug 'RRethy/vim-illuminate'

    " Snippets
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'

	" Git highlighting
	Plug 'airblade/vim-gitgutter'

    " Latex in vim
    Plug 'lervag/vimtex'

    " Pretty statusline
	Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

	" Fuzzy file finder
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'

	" Auto pair things like quotes and paratheses
	Plug 'jiangmiao/auto-pairs'

    " Easy commenting
	Plug 'tomtom/tcomment_vim'

    " Adding tags to comments
    Plug 'nvim-lua/plenary.nvim'
    Plug 'folke/todo-comments.nvim'

    " File explorer
    Plug 'kyazdani42/nvim-web-devicons' " for file icons
    Plug 'kyazdani42/nvim-tree.lua'

    " Change surrounding characters easily
	Plug 'tpope/vim-surround'

    " Smooth scrolling
    Plug 'psliwka/vim-smoothie'

    " Better tabline
    Plug 'kyazdani42/nvim-web-devicons'

    " Startup screen
    Plug 'mhinz/vim-startify'

    " Searching project for occurrences
    Plug 'mileszs/ack.vim'

	" Python
    Plug 'google/yapf'

    " Markdown
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" End of pluginlist
call plug#end()

set nu
set rnu

colorscheme onedark
let g:airline_theme='onedark'

" Link the system and vim clipboard
set clipboard+=unnamedplus

" nvim-cmp completion setup
set completeopt=menu,menuone,noselect

" Lua configs
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For `vsnip` users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  local nvim_lsp = require('lspconfig')

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  local servers = { 'ccls', 'pyright' }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      }
    }
  end

  local lspkind = require('lspkind')
  cmp.setup {
    formatting = {
      format = lspkind.cmp_format({with_text = false, maxwidth = 50})
    }
  }

  -- following options are the default
  -- each of these are documented in `:help nvim-tree.OPTION_NAME`
  require'nvim-tree'.setup {
    disable_netrw       = true,
    hijack_netrw        = true,
    open_on_setup       = false,
    ignore_ft_on_setup  = {},
    auto_close          = false,
    open_on_tab         = false,
    hijack_cursor       = false,
    update_cwd          = false,
    update_to_buf_dir   = {
      enable = true,
      auto_open = true,
    },
    diagnostics = {
      enable = false,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      }
    },
    update_focused_file = {
      enable      = false,
      update_cwd  = false,
      ignore_list = {}
    },
    system_open = {
      cmd  = nil,
      args = {}
    },
    filters = {
      dotfiles = false,
      custom = {}
    },
    view = {
      width = 30,
      height = 30,
      hide_root_folder = false,
      side = 'left',
      auto_resize = false,
      mappings = {
        custom_only = false,
        list = {}
      }
    }
  }

  require("todo-comments").setup{
    keywords = {
        QUESTION = { icon = "? ", color = "hint", alt = { "ASK" }  }
    },
    merge_keywords = true
  }
EOF

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=#e74c3c
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

command! -range -nargs=* Reloadsettings source ~/.vimrc

" Standard tab navigation
map L :tabnext<CR>
map H :tabprev<CR>
" nnoremap <silent> L :BufferNext<CR>
" nnoremap <silent> H :BufferPrevious<CR>

" Tab management
map <C-t> :tabnew<CR>
" map <C-w> :tabclose<CR> " this one's useless, nothing wrong with :wq

set ignorecase
set smartcase
set showmatch
set tabstop=4
set sts=4 sw=4
set expandtab

" resize splits quickly
nnoremap <silent> <Leader>= :exe "vertical resize " . (winwidth(0) * 10/9)<CR>
nnoremap <silent> <Leader>- :exe "vertical resize " . (winwidth(0) * 9/10)<CR>

let g:indentLine_enabled = 1
let g:indentLine_color_term = 74

" Airline configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

map <F2> :echo 'Current date is ' . strftime('%H:%M:%S %a %d/%m/%y')<CR>

" NvimTree configs
nnoremap <C-q> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

set termguicolors " this variable must be enabled for colors to be applied properly

" a list of groups can be found at `:help nvim_tree_highlight`
" highlight NvimTreeFolderIcon guibg=blue

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Faster split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" use lualatex as default engine instead of pdflatex
let g:vimtex_compiler_latexmk_engines = {
    \ '_'                : '-xelatex',
    \ 'pdflatex'         : '-pdf',
    \ 'dvipdfex'         : '-pdfdvi',
    \ 'lualatex'         : '-lualatex',
    \ 'xelatex'          : '-xelatex',
    \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
    \ 'context (luatex)' : '-pdf -pdflatex=context',
    \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
    \}

" Fuzzy file finder
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()
noremap <C-p> :ProjectFiles<CR>

command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

set signcolumn=yes

" add english words to completion
set dictionary+=/usr/share/dict/american-english
set dictionary+=~/repositories/wordlists-master/english-all.txt
set dictionary+=~/repositories/wordlists-master/ukenglish.txt
" add Dutch words to completion
set dictionary+=~/repositories/wordlists-master/nederlands.txt

" let g:mkdp_markdown_css = expand('~/.config/nvim/plugs/markdown-preview.nvim/css_files/retro.css')

" enable folding based on syntax
set foldmethod=syntax
" but open all folds when opening a buffer
autocmd BufWinEnter * silent! :%foldopen!

" Finding occurrences in files
let g:ackprg = 'ag --nogroup --nocolor --column'

" Todo quick fix shortcut
noremap <leader>t :TodoQuickFix<CR>
