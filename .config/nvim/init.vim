if exists('g:vscode')
    nnoremap <space>o <Cmd>call VSCodeNotify('workbench.action.closeOtherEditors')<CR>
    nnoremap <space>t <Cmd>call VSCodeNotify('workbench.action.toggleMaximizedPanel')<CR>

    nnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
    nnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
    nnoremap <C-k> <Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
    nnoremap <C-j> <Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>

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

    call plug#begin('~/.vim/plugged')

    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'dracula/vim', { 'name': 'dracula' }
    Plug 'morhetz/gruvbox'
    Plug 'preservim/nerdtree'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'https://github.com/tomasr/molokai.git'

    Plug 'fatih/vim-go', { 'do' :':GoUpdateBinaries' }
    Plug 'easymotion/vim-easymotion'
    Plug 'preservim/nerdcommenter'

    Plug 'luochen1990/rainbow'
    Plug 'jiangmiao/auto-pairs'

    Plug 'Rigellute/shades-of-purple.vim'

    Plug 'neoclide/coc.nvim', { 'branch': 'release' }

    call plug#end()

    let g:rainbow_active =1
    colorscheme dracula
    let g:dracula_colorterm = 0
    let g:airline_theme='dracula'

    nnoremap <C-p> :Files<CR>
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

endif

function! StyleCppAndReload()
    :execute 'silent !clang-format -i --style=Google %'
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
