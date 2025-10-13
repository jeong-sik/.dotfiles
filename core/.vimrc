set encoding=utf-8
set fileencoding=utf-8
set nocompatible
set nobackup noswapfile
set autoread
set number
set nowrap
set startofline
set scrolloff=3
set splitbelow splitright

set hlsearch incsearch showmatch
set ignorecase smartcase nowrapscan

set textwidth=80
set formatoptions-=t

set cindent ai si et
set ts=2 sts=2 sw=2 bs=2

set hidden

set shell=/bin/bash

set backupcopy=yes

" pastetoggle not supported in Neovim
if !has('nvim')
  set pastetoggle=<F8>
endif

set termguicolors
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

filetype plugin on

nnoremap ; :
nnoremap ' ;
nnoremap <silent> <C-_> :split<CR>
nnoremap <silent> <C-\> :vertical split<CR>
nnoremap <silent> <C-h> :vertical resize -5<CR>
nnoremap <silent> <C-j> :resize -3<CR>
nnoremap <silent> <C-k> :resize +3<CR>
nnoremap <silent> <C-l> :vertical resize +5<CR>

nnoremap <silent> <tab><tab> :b#<CR>
nnoremap <silent> <tab>w <C-w><C-w>
nnoremap <silent> <tab>h <C-w><C-h>
nnoremap <silent> <tab>j <C-w><C-j>
nnoremap <silent> <tab>k <C-w><C-k>
nnoremap <silent> <tab>l <C-w><C-l>

" Persistent history
" from simnalamburt/.dotfiles
if has('persistent_undo')
  let vimdir='$HOME/.vim'
  let &runtimepath.=','.vimdir
  let vimundodir=expand(vimdir.'/undodir')
  call system('mkdir -p '.vimundodir)

  let &undodir=vimundodir
  set undofile
endif

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Editor enhancements
Plug 'ntpeters/vim-better-whitespace'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/seoul256.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" IME auto-switch (macOS)
autocmd InsertLeave * :silent call system('macism com.apple.keylayout.ABC')

" coc.nvim - Language Server Protocol support
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" CoC settings (already have set hidden above)
set updatetime=300
set shortmess+=c
set signcolumn=yes

" CoC extensions (install via :CocInstall, not Plug)
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-json',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-yaml',
  \ 'coc-rust-analyzer',
  \ 'coc-python',
  \ 'coc-prettier',
  \ 'coc-eslint',
  \ 'coc-highlight'
  \ ]
inoremap <silent><expr> <C-space> coc#refresh()
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <Tab>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<Tab>" :
  \ coc#refresh()
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)

nmap <leader>fx <Plug>(coc-fix-current)

nmap <leader>ff <Plug>(coc-format)
xmap <leader>ff <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
  autocmd FileType javascript,typescript,typescript.tsx,rust,json
        \ setl formatexpr=CocAction('formatSelected')
augroup end

nmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>ac <Plug>(coc-codeaction)
xmap <leader>ac <Plug>(coc-codeaction-selected)

nmap <leader>rn <Plug>(coc-rename)

Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'pangloss/vim-javascript'
Plug 'jason0x43/vim-js-indent'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'posva/vim-vue'
Plug 'hashivim/vim-terraform'
Plug 'digitaltoad/vim-pug'

call plug#end()

let g:fzf_layout = { 'right': '~40%' }
nmap <leader><tab> :Files<CR>
nmap <leader><leader><tab> :Files!<CR>
nmap <leader>q :Buffers<CR>
nmap <leader><leader>q :Buffers!<CR>
if executable('rg')
  " From junegunn/fzf.vim#readme
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \   <bang>0)
endif
if executable('fd')
  function! FindPackageRoot(startdir)
    let current = fnamemodify(a:startdir, ':p')
    while empty(glob(current.'/package.json'))
      if current ==# '/'
        return ''
      endif
      let current = fnamemodify(current, ':h')
    endwhile
    return current
  endfunction

  function! RunDtsFzf(base, bang)
    let package_root = FindPackageRoot(a:base)
    let node_modules_dir = glob(package_root . '/node_modules')
    if node_modules_dir ==# ''
      echoerr 'node_modules not found in ' . package_root
      return
    endif
    let fzf_dict = fzf#wrap(
      \ 'd-ts',
      \ {
      \   'source': "fd --no-ignore -c'always' -e'.d.ts' -tf",
      \   'dir': node_modules_dir,
      \   'options': ['--ansi', '--prompt=node_modules/']
      \ },
      \ a:bang)
    call fzf#run(fzf_dict)
  endfunction
  command! -bang Dts
    \ call RunDtsFzf(getcwd(), <bang>0)
  command! -bang BufferDts
    \ call RunDtsFzf(expand('%:p:h'), <bang>0)
  nmap <leader>d :Dts<cr>
  nmap <leader><leader>d :Dts!<cr>
endif

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'dark'

let g:strip_whitespace_on_save = 1

let g:jsx_ext_required = 0
let g:xml_syntax_folding = 0

" typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" colors
let g:seoul256_srgb = 1
let g:seoul256_background = 233
colorscheme seoul256
