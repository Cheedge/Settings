" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

set nocompatible              " required
" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on
colorscheme default

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
filetype plugin indent on

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
set mouse=r		" Enable mouse usage (all modes), if set to a it cannot work.

set clipboard=unnamed	"Notice, check your clipboard by:
			"vim --version | grep clipboard
			"when the +clipboard and +xterm_clipboard that fine.
"set paste		"Notice, first ensure u have installed vim-gtk or vim-gnome, (not vim-tiny, remove it!!!), set paste not competable with ycm, so comment it and everytime use just in the vim :set paste
"set go+=a
":set nu  #set order number
:colorscheme default
:set viminfo='1000,<500


filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly, for html.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}


" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

" ...
""Plugin 'lervag/vimtex'
"Nerdtree to make a catalog for file system
Plugin 'scrooloose/nerdtree'

Plugin 'valloric/youcompleteme'
"Plugin 'neoclide/coc.nvim'
"Deoplete will consume more than other complete plugs.
"Plugin 'Shougo/deoplete.nvim'

" Track the engine, this two plugin all for ultisnips.
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"open catalog on left
cnoremap <F6> Vexplore<CR> :vertical resize 20<CR>
"fix the error:NoExtraConf, but just run youcompleteme/instal.py is fine

"let g:ycm_extra_conf_globlist = ['~/dev/*','!~/*']
"let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/youcompleteme/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py’

"###############################################################################
"                               latex plugin and settings
"###############################################################################
"compile use pdflatex
nnoremap 22 :! pdflatex -synctex=1 -interaction=nonstopmode %:p<CR>
"nnoremap 44 :! zathura %:p:r.pdf<CR>
"nnoremap 22 :! pdflatex %<CR><CR>
nnoremap 44 :! zathura $(echo % \| sed 's/tex$/pdf/') & disown<CR><CR>
"
"nnoremap :<C-u>w <bar> ! pdflatex -synctex=1 -interaction=nonstopmode %:p<CR>
"nnoremap :<C-u>! zathura %:p:r.pdf<CR>
"zathura forward/inverse search
"set synctex true
""set synctex-editor-command 'gvim +%{line} %{input}'
"above 2 line can be add into ~/.config/zathura/zathurarc file.
"and the single quota should be changed to double quota.

" the next line need as the UltiSnip can only detect the *.tex file with
" premeble. so u should set tex_lavor as latex.
let g:tex_flavor = "latex"
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"UltiSnips Configuration.
let g:UltiSnipsExpandTrigger="<C-t>"
let g:UltiSnipsJumpForwardTrigger="<C-f>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
let g:UltiSnipsListSnippets = '<C-l>'

let g:UltiSnipsSnippetDirectories=['~/.vim/UltiSnips/', 'UltiSnips']
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" make the YCM close the buffer after insertion
let g:ycm_autoclose_preview_window_after_insertion = 1
" for latex to make a catalog (table of contents).
" this cnoremap also can use define a function to instead as:
" function Func()
" 	:grep ...
" 	:windo wincmd H
" 	: vertical resize 75
" endfunction
" after, use command: exec Func()
	"windo wincmd H = <C-w><H>
	"windo wincmd K = <C-w><K>
cnoremap <F9>  :grep -w -e \section -e \subsection %<CR><CR>:windo wincmd H<CR>:windo wincmd H<CR>:vertical resize 75<CR>

" create a self-clearing autocommand group called 'qf', to let the above grep
" to directly open QiuckFix window.
augroup qf
    " clear all autocommands in this group
    autocmd!
    " do :cwindow if the quickfix command doesn't start with a 'l' (:grep, :make, etc.)
    autocmd QuickFixCmdPost [^l]* cwindow
    " do :lwindow if the quickfix command starts with a 'l' (:lgrep, :lmake, etc.)
    autocmd QuickFixCmdPost l*    lwindow
    " do :cwindow when Vim was started with the '-q' flag
    autocmd VimEnter        *     cwindow
augroup END

"add comment method:
"1, <C-v>; go into VISUAL mode
"2, up and down (hjkl) to choose block;
"3, <S-i>; into INSERT mode
"4, add %;
"5, <Esc> wait a second.
"uncomment method:
"1, <C-v>
"2, hjkl :just use jk to choose the %
"3, d
"4, <Esc>
"copy part of line: use your cursor to choose and 'y' enough
"or 'y$' to copy to end of the line

"#######################################################################################
"					Python IDE setting
"#######################################################################################
set encoding=utf-8
set tabstop=4
set softtabstop=4
set number "relativenumber
set shiftwidth=4

" set ycm to 
  let g:ycm_python_interpreter_path = ''
  let g:ycm_python_sys_path = []
  let g:ycm_extra_conf_vim_data = [
    \  'g:ycm_python_interpreter_path',
    \  'g:ycm_python_sys_path'
    \]
  let g:ycm_global_ycm_extra_conf = '~/global_extra_conf.py'


" elk.in file
au BufRead,BufNewFile elk.in set filetype=elk

