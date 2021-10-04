" Updating: PlugUpdate
" Remove unneeded: PlugClean
" Install new: PlugInstall

" Start of pluginlist
call plug#begin('~/.config/nvim/plugs')
    " Themes
    Plug 'projekt0n/github-nvim-theme'
    Plug 'joshdick/onedark.vim'

	" Git highlighting
	Plug 'airblade/vim-gitgutter'

    " Completions
    Plug 'Shougo/deoplete.nvim'

    " Syntax checking
    Plug 'dense-analysis/ale'

    " Latex in vim
    Plug 'lervag/vimtex'

    " Pretty statusline
	Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

	" completions
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'

	" Formatting code
	Plug 'google/vim-maktaba'
	Plug 'google/vim-codefmt'
	Plug 'google/vim-glaive'

	" Auto pair things like quotes and paratheses
	Plug 'jiangmiao/auto-pairs'

	" Easy commenting
	Plug 'tomtom/tcomment_vim'

    " Nerdtree
    Plug 'preservim/nerdtree'

	Plug 'Yggdroot/indentLine'
    Plug 'dense-analysis/ale'
	Plug 'tpope/vim-surround'
	Plug 'vim-syntastic/syntastic'

	" Python
	Plug 'nvie/vim-flake8'
    Plug 'davidhalter/jedi-vim'

    " C
    Plug 'wolfgangmehner/c.vim'

" End of pluginlist
call plug#end()

set nu
set rnu

colorscheme onedark

" Link the system and vim clipboard
set clipboard=unnamedplus

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	function! InsertTabWrapper()
	    let col = col('.') - 1
	    if !col || getline('.')[col - 1] !~ '\k'
	        return "\<tab>"
	    else
	        return "\<c-n>"
	    endif
	endfunction
	inoremap <expr> <tab> InsertTabWrapper()
	inoremap <s-tab> <c-n>

" Highligh trailing whitespace
	highlight ExtraWhitespace ctermbg=red guibg=red
	match ExtraWhitespace /\s\+$/
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()

command! -range -nargs=* Reloadsettings source ~/.vimrc

map L :tabnext<CR>
map H :tabprev<CR>
map <C-t> :tabnew<CR>
" map <C-w> :tabclose<CR>

set ignorecase
set smartcase
set showmatch
set tabstop=4
set sts=4 sw=4
set expandtab

" resize splits quickly
nnoremap <silent> <Leader>= :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

let g:indentLine_enabled = 1
let g:indentLine_color_term = 74

" Airline configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

map <F2> :echo 'Current date is ' . strftime('%H:%M:%S %a %d/%m/%y')<CR>

" Toggle NERDTree
nnoremap <C-q> :NERDTreeToggle<CR>

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

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

" TODO: add hightlighting for keywords like TODO
