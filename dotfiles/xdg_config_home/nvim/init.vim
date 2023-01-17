" Load plugins, stolen from BEGINBOT (https://github.com/davidbegin/beginfiles/blob/c72ef20f9c613528af9f7b34be8d03093ad0d873/nvim/init.vim#L9)
source $HOME/.config/nvim/plug_init.vim

" Quality of life
let mapleader=' '
set secure exrc
set ignorecase smartcase
set incsearch hlsearch
set splitright splitbelow
set noerrorbells
set number relativenumber
set nowrap
set scrolloff=4
set tabstop=4 softtabstop=0 shiftwidth=0 smartindent
set inccommand=nosplit

" Menu
set showcmd
set confirm

" Styling
set termguicolors
set cursorline
set guicursor=
try
  lua require('dracula').setup({ transparent_bg = true })
  colorscheme dracula
catch
  colorscheme default
endtry

augroup auto_mkdir_new_file
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force || input("'" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END

" Custom filetypes
au! BufRead,BufNewFile *.conf setfiletype conf
au! BufRead,BufNewFile *.njk setfiletype html
au! BufRead,BufNewFile flake.lock setfiletype json

lua require("eruizc")
