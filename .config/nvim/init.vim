if exists('g:vscode')
    nnoremap <space>o <Cmd>call VSCodeNotify('workbench.action.closeOtherEditors')<CR>
    nnoremap <space>t <Cmd>call VSCodeNotify('workbench.action.toggleMaximizedPanel')<CR>

    nnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
    nnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
    nnoremap <C-k> <Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
    nnoremap <C-j> <Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>

    nmap <leader>rn <Cmd>call VSCodeNotify('editor.action.rename')<CR>
    nnoremap <silent> K :call VSCodeNotify('editor.action.showHover')<CR>
    nmap <silent> K :call VSCodeNotify('editor.action.showHover')<CR>
else
    let loaded_matchparen = 1

    set number
    set relativenumber
    syntax enable
    set noswapfile
    set scrolloff=7
    set backspace=indent,eol,start

    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set expandtab
    set autoindent
    set fileformat=unix
    set autoread

    set termguicolors

    call plug#begin()

    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'preservim/nerdtree'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    Plug 'https://github.com/tomasr/molokai.git'
    Plug 'morhetz/gruvbox'
    Plug 'sonph/onehalf', { 'rtp': 'vim' }
    Plug 'xiyaowong/nvim-transparent'

    Plug 'easymotion/vim-easymotion'
    Plug 'preservim/nerdcommenter'

    Plug 'luochen1990/rainbow'
    Plug 'jiangmiao/auto-pairs'

    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'kyazdani42/nvim-web-devicons'

    Plug 'neoclide/coc.nvim', { 'branch': 'release' }

    call plug#end()

    let g:rainbow_active =1
    colorscheme molokai
    "colorscheme onehalfdark
    let g:dracula_colorterm = 0
    let g:airline_theme='molokai'
    let g:transparent_enabled = v:true

    "nnoremap <C-p> :Files<CR>
    nnoremap <C-p> <cmd>Telescope find_files<CR>
    nnoremap <C-e> :NERDTreeToggle<CR>
    nnoremap <C-f> :NERDTreeFind<CR>
    nnoremap <C-W>O :call MaximizeToggle()<CR>
    nnoremap <space>o :tabonly<CR>
    nnoremap <space>f :call StyleCppAndReload()<CR>
    nmap <leader>rn <Plug>(coc-rename)
    nmap <leader>gd <Plug>(coc-definition)
    nmap <leader>qf  <Plug>(coc-fix-current)
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    noremap <silent> <C-h> :call WinMove('h')<CR>
    nnoremap <silent> <C-j> :call WinMove('j')<CR>
    nnoremap <silent> <C-k> :call WinMove('k')<CR>
    nnoremap <silent> <C-l> :call WinMove('l')<CR>

    tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<C-\><C-n>"

    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

    " Formatting selected code.
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: There's always complete item selected by default, you may want to enable
    " no select by `"suggest.noselect": true` in your configuration file.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config.
    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1) :
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    " Make <CR> to accept selected completion item or notify coc.nvim to format
    " <C-g>u breaks current undo, please make your own choice.
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif

    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocActionAsync('format')

    " Escape terminal
    :tnoremap <Esc> <C-\><C-n>

endif

function! StyleCppAndReload()
    :execute 'silent !clang-format -i --style=file %'
    :edit!
endfunction

function! MaximizeToggle()
  if exists("s:maximize_session")
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    only
  endif
endfunction

function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
