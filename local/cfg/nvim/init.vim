" LOCALDIR/nvim/init.vim

if empty($LOCALDIR)
    let localdir = $HOME . '/local'
else
    let localdir = $LOCALDIR
endif

let pkgdir = localdir . '/data/nvim/packages'

call mkdir(pkgdir, "p")

call plug#begin(pkgdir)
    Plug 'neomake/neomake'
    autocmd! BufWritePost * Neomake

    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'keith/tmux.vim'
    Plug 'alerque/vim-sile', {'for': 'sile'}
    Plug 'weakish/rcshell.vim', {'for': 'rc'}
    Plug 'jakwings/vim-pony', {'for': 'pony'}
    Plug 'rust-lang/rust.vim', {'for': 'rust'}
    Plug 'vim-erlang/vim-erlang-runtime', {'for': 'erlang'}

    " Various local packages.
    Plug pkgdir . '/vim-ada', {'for': 'ada'}
    Plug pkgdir . '/vim-ktap', {'for': 'ktap'}
    Plug pkgdir . '/vim-spar', {'for': 'spar'}
    Plug pkgdir . '/vim-draft', {'for': 'draft'}
    Plug pkgdir . '/vim-myrddin', {'for': 'myr'}
    Plug pkgdir . '/vim-promela', {'for': 'promela'}
    Plug pkgdir . '/vim-ats', {'for': ['dats', 'sats']}
call plug#end()

unlet pkgdir

" Replace ex-mode with vim's command-line window.
map Q q:

" Settings.
set list
set cc=80
set title
set number
set hidden
set backup
set showcmd
set undofile
set linebreak
set nohlsearch
set scrolloff=1
set cinoptions+=t0

syntax on
filetype indent plugin on

runtime! macros/matchit.vim

" 4 spaced expanded tabs by default.
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

if &t_Co > 255 || has('gui_running')
    set background=dark
    set termguicolors
    let base16colorspace=256
    colorscheme base16-yesterdaynight

    " By default my theme highlights the matching bracket with a lighter
    " colour, while darkening the cursor, causing me endless confusion.  Using
    " standout reverses the effect.
    hi MatchParen gui=standout
endif

set smartcase
set ignorecase

set cursorline
set statusline=%n\ %F\ %M%=%y%w%r%h\ %{&fenc}\ %l,%c\ %p%%\ %L

" Speed up ESC in msec.
set ttimeoutlen=50

" Use the Xorg's primary buffer as default register.
set clipboard=unnamed

let &backupdir = localdir . '/data/nvim/backup'

" XXX Vim doesn't mkdir the backupdir path (bug?) so let's do that ourselves
" instead.
call mkdir(&backupdir, "p")

" Prevent neomake reporting its exit status and suppressing the write message.
" https://github.com/benekastah/neomake/issues/238
let neomake_verbose = 0

" Use clang when checking C/C++ syntax.
let g:neomake_cpp_clang_args = neomake#makers#ft#c#clang()['args'] + ['-std=c99']
let g:neomake_cpp_clang_args = neomake#makers#ft#cpp#clang()['args'] + ['-std=c++11']

" Use bsdtar for all the additional formats it supports over GNU tar.
let g:tar_cmd = 'bsdtar'
let g:tar_secure = 1

" Tell vim about the additional file extensions we can now use.
autocmd BufReadCmd *.iso,*.rar,*.7z call tar#Browse(expand("<amatch>"))
