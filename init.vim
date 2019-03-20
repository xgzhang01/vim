" Set Path{
    set backupdir=~/.nvim/.backup/
    set directory=~/.nvim/.swp/
    set undodir=~/.nvim/.undo/
" }
" Vim UI {

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
    set t_Co=256
    set background=dark
    set completeopt=longest,menuone "set complete menu pop up automaticly"

    if has('statusline')
        set laststatus=2
        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif
" }

" Strip trailing whitespace and newlines on save
fun StripTrailingWhitespace()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    %s/\($\n\s*\)\+\%$//e
    call cursor(l, c)
endfun

" Formatting {
    syntax on
    set encoding=utf-8
    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    set nocompatible

    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.
    autocmd BufNewFile,BufRead *.coffee set filetype=coffee
    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell
" }


" Plugins {
" if filereadable(expand ("~/.vimrc.plug"))
"     source ~/.vimrc.plug
" endif

call plug#begin()
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'junegunn/vim-easy-align'
    Plug '/usr/local/opt/fzf'
    "Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'powerline/fonts'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'mbbill/undotree'
    "Plug 'scrooloose/syntastic'
    Plug 'luochen1990/rainbow'
    Plug 'aceofall/gtags.vim'
    if has('nvim')
        Plug 'Shougo/deoplete.nvim',{ 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
    Plug  'Shougo/denite.nvim'
    Plug 'zchee/deoplete-jedi'
    Plug 'davidhalter/jedi-vim'
    Plug 'ozelentok/deoplete-gtags'
    Plug 'jiangmiao/auto-pairs'
    Plug 'morhetz/gruvbox'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'rking/ag.vim'
    Plug 'scrooloose/nerdcommenter'
    "Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
    call plug#end()
" }


" Plugins Configuration{
    " wildcard setting {
        let g:Lf_WildIgnore = {
                    \ 'dir':  ['.git'],
                    \ 'file': ['*.o', '*.so', '*.d', '*.a'],
                    \}
    "}

    " fzf Configuration{
        set rtp+=~/.fzf
        nnoremap <silent> <Leader>f :Files<CR>
        nnoremap <silent> <Leader>b :Buffers<CR>

        let g:ackprg = 'ag --nogroup --nocolor --column'
    "}

    " GTAGS-Cscope Configuration{
        set cscopetag 
        set cscopeprg='gtags-cscope'
        let GtagsCscope_Auto_Load = 1
        let GtagsCscope_Auto_Map = 1
        let GtagsCscope_Quiet = 1
        let g:Gtags_Auto_Update = 1
        let g:Gtags_Auto_MAP = 1

        if has("cscope")
            set nocsverb
            if filereadable("GTAGS")
                cs add GTAGS $PWD -a -i
            endif
        endif
    "}

    " vim-airline {
        let g:airline#extensions#tabline#enabled = 1
        let g:ariline#extensions#tabline#left_sep = ' '
        let g:ariline#extensions#tabline#left_alt_sep = '|'
        let g:airline#extensions#tabline#buffer_nr_show = 1
        let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
        let g:airline#extensions#tabline#fnamemod = ':p:t'
        let g:airline#extensions#tabline#buffer_idx_mod = 1
    " }

    " Deoplete Config {
        let g:deoplete#enable_at_startup = 1
        let g:deoplete#enable_smart_case =1
        call deoplete#custom#source('LanguageClient',
                    \ 'min_pattern_length',
                    \2)
        autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
        call deoplete#custom#source('_', 'matchers', ['matcher_head'])
    " }

    " FZF Config {
        let g:fzf_action = {
                    \ 'ctrl-t': 'tab split',
                    \ 'ctrl-x': 'sp',
                    \ 'ctrl-v': 'vsp'
                    \}
    " }

    " indent_guides {
        let g:indent_guides_start_level = 2
        let g:indent_guides_guide_size = 1
        let g:indent_guides_enable_on_vim_startup = 1
    " }

    " undotree {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif
        nnoremap <Leader>u :UndotreeToggle<CR>
        " If undotree is opened, it is likely one wants to interact with it.
        let g:undotree_SetFocusWhenToggle=1
        " }
        " Rainbow{
        let g:rainbow_active = 1 
    " }

    " NerdTree {
        if isdirectory(expand("~/.config/nvim/plugged/nerdtree"))
            nnoremap <C-e> :NERDTreeToggle<CR>
            map <leader>e :NERDTreeFind<CR>
            nmap <leader>nt :NERDTreeFind<CR>

            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
        endif
    " }

    " Nerdcommenter {
        let g:NERDSpaceDelims=1
    " }
"}

"Other Configuration{
    colorscheme gruvbox
    set mouse=c
    set splitright
    set noautochdir
    " Do not auto comment in new line
    autocmd FileType * set formatoptions-=o
" }

" Key Binding {
    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
    " FZF Finder
    nnoremap <leader>ft :BTags <CR>
    nnoremap <leader>fm :History <CR>
    nnoremap <leader>ff :FZF 
    " LeaderF Finder
    "nnoremap <leader>ff :LeaderfFile 
    "nnoremap <leader>fm :Leaderf mru  <CR>
    "nnoremap <leader>ft :LeaderfFunction! <CR>

    "airline buffer operation
    nmap <leader>- <Plug>AirlineSelectPrevTab
    nmap <leader>+ <Plug>AirlineSelectNextTab

    command! -bang -nargs=* Ag
                \ call fzf#vim#ag(<q-args>,
                \                 <bang>0 ? fzf#vim#with_preview('up:60%')
                \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
                \                 <bang>0)

    nmap <C-\>a :Ag <CR>
    map <C-l> :nohl <CR>
" }

