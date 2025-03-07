" Basic settings
set number
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set ignorecase
set smartcase
set notimeout
set mouse=a

" Set leader key to <SPACE>
let mapleader = "\<SPACE>"

" =======================
" ===  Plugins Begin  ===
" =======================
call plug#begin('~/.config/nvim/plugged')

  " Editor enhancements
  Plug 'tomtom/tcomment_vim' " Easy commenting
  Plug 'vim-airline/vim-airline' " Status line

  " Theml
  Plug 'catppuccin/nvim'

  " Terminal
  Plug 'skywind3000/vim-terminal-help'

  " File explorer
  Plug 'preservim/nerdtree'

  " File finder
  Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

  " Syntax highlighting
  Plug 'jackguo380/vim-lsp-cxx-highlight'

  " Debugging
  Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-rust --enable-python'}

  " LSP and autocompletion
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'

call plug#end()
" =======================
" ===   Plugins End   ===
" =======================

" =================================
" === Shortcuts Configurations ===
" =================================

" Reload init.vim
nnoremap <space>rl :so ~/.config/nvim/init.vim<CR>
" Open init.vim for editing
nnoremap <space>rc :e ~/.config/nvim/init.vim<CR>
" Open terminal
nnoremap <leader>t :below split \| term<CR> :resize 8<CR> 


" =================================
" === Plugin Configurations ===
" =================================

" ==== tomtom/tcomment_vim ====
" Key mappings for commenting
let g:tcomment_textobject_inlinecomment = ''
nmap <LEADER>cn g>c
vmap <LEADER>cn g>
nmap <LEADER>cu g<c
vmap <LEADER>cu g<

" ==== preservim/nerdtree ====
" Toggle NERDTree
nnoremap <LEADER>e :NERDTreeToggle<CR>

" ==== Yggdroot/LeaderF ====
" LeaderF configuration
let g:Lf_WindowPosition='right'
let g:Lf_PreviewInPopup=1
let g:Lf_CommandMap = {
\   '<M-p>': ['<C-k>'],
\   '<M-k>': ['<C-p>'],
\   '<M-j>': ['<C-n>']
\}
nmap <leader>f :Leaderf file<CR>
nmap <leader>b :Leaderf! buffer<CR>
nmap <leader>F :Leaderf rg<CR>
let g:Lf_DevIconsFont = "DroidSansMono Nerd Font Mono"

" ==== jackguo380/vim-lsp-cxx-highlight ====
" Syntax highlighting for C/C++
hi default link LspCxxHlSymFunction cxxFunction
hi default link LspCxxHlSymFunctionParameter cxxParameter
hi default link LspCxxHlSymFileVariableStatic cxxFileVariableStatic
hi default link LspCxxHlSymStruct cxxStruct
hi default link LspCxxHlSymStructField cxxStructField
hi default link LspCxxHlSymFileTypeAlias cxxTypeAlias
hi default link LspCxxHlSymClassField cxxStructField
hi default link LspCxxHlSymEnum cxxEnum
hi default link LspCxxHlSymVariableExtern cxxFileVariableStatic
hi default link LspCxxHlSymVariable cxxVariable
hi default link LspCxxHlSymMacro cxxMacro
hi default link LspCxxHlSymEnumMember cxxEnumMember
hi default link LspCxxHlSymParameter cxxParameter
hi default link LspCxxHlSymClass cxxTypeAlias

" ==== puremourning/vimspector ====
" Vimspector configuration
let g:vimspector_enable_mappings = 'HUMAN'

function! s:generate_vimspector_conf()
  if empty(glob( '.vimspector.json' ))
    if &filetype == 'c' || 'cpp' 
      !cp ~/.config/nvim/vimspector_conf/c.json ./.vimspector.json
    elseif &filetype == 'python'
      !cp ~/.config/nvim/vimspector_conf/python.json ./.vimspector.json
    endif
  endif
  e .vimspector.json
endfunction

command! -nargs=0 Gvimspector :call s:generate_vimspector_conf()

nmap <Leader>v <Plug>VimspectorBalloonEval
xmap <Leader>v <Plug>vimspectorBalloonEval

" ==== LSP and Autocompletion ====
lua << EOF
-- Configure mason
require('mason').setup()

-- Configure mason-lspconfig
require('mason-lspconfig').setup()

-- Configure nvim-cmp
local cmp = require'cmp'
local lspconfig = require'lspconfig'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<M-p>'] = cmp.mapping.select_prev_item(),
    ['<M-n>'] = cmp.mapping.select_next_item(),
    ['<M-y>'] = cmp.mapping.confirm({ select = true }),
    ['<M-space>'] = cmp.mapping.complete(),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'luasnip' },
  },
})

-- Set LSP server capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configure clangd and rust-analyzer
lspconfig.clangd.setup({
  capabilities = capabilities,
})

lspconfig.rust_analyzer.setup({
  cmd = { "rust-analyzer" },  -- Use system-installed rust-analyzer
  capabilities = capabilities,
})
EOF

