" rono.vim
"
" Copyright (2013) Ronoalado JLP (http://www.ronoaldo.net)
"
" Contributions:
"   Filipe Peixoto (http://www.filipenos.net)
"
" License:
"   Creative Commons CC-BY-SA
"

" Vundle - Plugin setup
filetype off

" Auto-setup of Vundle:
" Ref: http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
let g:vundle_installed=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
  echo "Installing Vundle..."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  let g:vundle_installed=0
endif

set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

" Basic plugins
Plugin 'gmarik/vundle'
" Snippets for quick code editing
Plugin 'snipMate'
" Some custom snippets
Plugin 'https://bitbucket.org/ronoaldo/custom-vim-snippets'
" Awesome file navigation
Plugin 'scrooloose/nerdtree'
" Syntax check for various files
Plugin 'scrooloose/syntastic'
" Tag navigator for current file (Outline)
Plugin 'majutsushi/tagbar'
" Fuzzy finder for current tree
Plugin 'kien/ctrlp.vim'
" Helper for open/close tags and other tools
Plugin 'tpope/vim-surround'
" Lots of color schemes
Plugin 'flazz/vim-colorschemes'
" Go code completion integration
Plugin 'Blackrush/vim-gocode'
" Syntax Hilight
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'velocity.vim'
Plugin 'groenewege/vim-less'

" Install plugins if this is the first run
if g:vundle_installed == 0
  echo "Installing Plugins. Please ignore key map erros, if any..."
  echo ""
  :PluginInstall!
  echo "Plugin setup completed"
endif

filetype plugin indent on

" Tabs
fu! SetupNormalTabs()
  setlocal sw=4 ts=4 st=4 noet si ai
endfu

fu! SetupSpaceTabs()
  setlocal sw=4 ts=4 st=4 et si ai
endfu

fu! Setup2SpaceTabs()
  setlocal sw=2 ts=2 st=2 et si ai
endfu

" Messages
fu! Info(msg)
  execute "echom '[ " . a:msg . " ]'"
endfu

" All-modes shortcuts
fu! KeyMap(key, action, insert_mode)
  execute "noremap  <silent> " . a:key . " " . a:action . "<CR>"
  execute "vnoremap <silent> " . a:key . " <C-C>" . a:action . "<CR>"
  if a:insert_mode
    execute "inoremap <silent> " . a:key . " <C-O>" . a:action . "<CR>"
  endif
endfu

" Disposable temporary window
fu! TempWindow(name, clear) abort
  let name = substitute(a:name, "[^a-zA-Z0-9]", "_", "g")
  let bn = bufnr(name)
  if bn == -1
    execute "new " . name
    let bn = bufnr(name)
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal buflisted
  else
    let wn = bufwinnr(bn)
    if wn != -1
      exe wn . "wincmd w"
    else
      exe "split +buffer" . bn
    endif
  endif

  if a:clear
    normal gg
    normal dG
  endif
  wincmd J
endfu

" Mercurial 
fu! HgPull()
  call Info("Pulling changes from remote repository ...")
  !hg pull
endfu

fu! HgPush()
  call Info("Pushing changes to remote repository ...")
  !hg push
endfu

fu! HgDiff()
  call TempWindow("Mercurial Changes", 1)
  setfiletype diff
  execute 'silent r!hg diff --git'
  0
endfu

fu! HgMergeMsg()
  execute "silent r!echo -n 'Merge with '; hg id -i | cut -f 2 -d'+'"
  0d
endfu

fu! Hg(...)
  call TempWindow('Mercurial', 1)
  let hg_cmd = 'silent r!hg '
  for s in a:000
    let hg_cmd = hg_cmd . ' ' . s
  endfor
  execute hg_cmd
  0
endfu

" Maven
fu! Mvn(...)
  let mvn_cmd = 'silent r!mvn '
  for s in a:000
    let mvn_cmd = mvn_cmd . ' ' . s
  endfor
  call TempWindow('Maven', 1)
  echo "Running " . mvn_cmd
  execute mvn_cmd
  setlocal filetype=mvnbuild
  0d
endfu

fu! MavenDebug(port)
  call Info("Starting jdb ... ")
  let jdb = "!jdb -sourcepath " . $PWD . "/src/main/java:" . $PWD . "/src/test/java"
  let jdb = jdb . " -port " . a:port
  execute jdb
endfu

fu! MavenWorkspace()
  let l:pom = findfile("pom.xml", ";")
  if filereadable(l:pom)
    let g:maven_project=1
    setlocal tags=./.tags;
  endif
endfu

fu! MavenCtags()
  call Info("Atualizando tags em sua workspace ...")
  let ctags = "!rm -vf " . g:default_java_workspace . "/.tags &&"
  let ctags = ctags . " find " . g:default_java_workspace . " -type f -iname '*.java' |"
  let ctags = ctags . " xargs ctags -a -f ". g:default_java_workspace . "/.tags"
  let ctags = ctags . " --exclude='*/target/*'  -L - --totals"
  execute ctags

  setlocal tags=./.tags;
  echo "Tag path: " . &tags
endfu

" CTags 
fu! Ctags()
  call Info("Indexing current directory ...")
  let ctags = "!rm -vf ./.tags && find ./ -type f |"
  let ctags = ctags . " xargs ctags -a -f ./.tags "
  let ctags = ctags . " --exclude='*/target/*' --exclude='*min.js'"
  let ctags = ctags . " -L - --totals"
  execute ctags

  setlocal tags=./.tags;
  echo "Tag path " . &tags
endfu

" From http://vim.wikia.com/wiki/Find_files_in_subdirectories
" Find file in current directory and edit it.
function! Find(name)
  let l:list=system("find . -name '".a:name."' | perl -ne 'print \"$.\\t$_\"'")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
    return
  endif
  if l:num != 1
    echo l:list
    let l:input=input("Which ? (CR=nothing)\n")
    if strlen(l:input)==0
      return
    endif
    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
      echo "Not a number"
      return
    endif
    if l:input<1 || l:input>l:num
      echo "Out of range"
      return
    endif
    let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
  else
    let l:line=l:list
  endif
  let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
  execute ":split ".l:line
endfunction

" Default options for various file types
augroup filemapping
  au!
  " Python
  au BufRead,BufNewFile *.py call SetupSpaceTabs()
  au FileType python call SetupSpaceTabs()
  " Makefiles
  au BufRead,BufNewFile Makefile call SetupNormalTabs()
  au BufRead,BufNewFile makefile call SetupNormalTabs()
  " XML
  au BufRead,BufNewFile *.xml call SetupNormalTabs()
  au BufRead,BufNewFile *.xml setlocal shiftwidth=2 tabstop=2
  au FileType xml call SetupNormalTabs()
  au FileType xml setlocal shiftwidth=2 tabstop=2
  " TXT
  au BufRead,BufNewFile *.txt call Setup2SpaceTabs()
  " Velocity
  au BufRead,BufNewFile *.vm setlocal filetype=velocity
  " Vim
  au BufRead,BufNewFile *.vimrc call Setup2SpaceTabs()
  au BufRead,BufNewFile vimrc call Setup2SpaceTabs()
  au FileType vim call Setup2SpaceTabs()
  " Java
  au BufRead,BufNewFile *.java compiler javac
  au BufRead,BufNewFile *.java setlocal makeprg=javac\ %
  au BufRead,BufNewFile *.java let g:syntastic_java_javac_options = "-Xlint -encoding utf-8"
  au BufRead,BufNewFile *.java call SetupNormalTabs() | setlocal sw=2 ts=2
  " Bean shell
  au BufReadPost,BufNewFile *.bsh setlocal filetype=java

  " Go AppEngine support via 'goapp'
  if executable('goapp')
    au BufRead,BufNewFile *.go setlocal makeprg=goapp\ test\ -c
    au BufRead,BufNewFile *.go let g:syntastic_go_checkers=['goapp']
  else
    au BufRead,BufNewFile *.go setlocal makeprg=go\ test\ -c
    au BufRead,BufNewFile *.go let g:syntastic_go_checkers=['go']
  end

  " Conveniencia para revisar o diff antes do commit
  au BufRead /tmp/hg-editor-* call HgDiff()

  " Posiciona a janela QuickFix sempre na parte inferior da tela
  au FileType qf wincmd J
augroup END

" Java/Maven workspace setup
let g:default_java_workspace="~/workspace"
augroup workspace
  au!
  let s:workspace_init = 1
  autocmd VimEnter * call MavenWorkspace()
  autocmd FileType java TagbarOpen
augroup END

" Mercurial
command! -nargs=+ Hg call Hg("<args>")

" Ctags
command! Ctags call Ctags()

" Maven
command! -nargs=+ Mvn call Mvn("<args>")
command! MavenCtags   call MavenCtags()
command! MavenBuild   :Mvn clean package
command! MavenTest    call Mvn("-o", "test", "-DskipTests=false", "-Dtest=".expand("%:t:r"), "-DfailIfNoTests=true")
command! MavenTestAll :Mvn -o test 
command! MavenInstall :Mvn -o clean install
command! MavenClean   :Mvn -o clean
command! MavenDebug   call MavenDebug(5005)

" Find
command! -nargs=1 Find :call Find("<args>")

" \s save
call KeyMap('<Leader>s', ':update', 0)
" \x close all
call KeyMap("<Leader>x", ":quitall", 0)
" \u pull changes
call KeyMap("<Leader>u", ":Hg pull", 0)
" \p push changes
call KeyMap("<Leader>p", ":Hg push", 0)
" \i mvn install
call KeyMap("<Leader>i", ":MavenInstall", 0)
" \b mvn clean package
call KeyMap("<Leader>b", ":MavenBuild", 0)
" \t mvn test
call KeyMap("<Leader>t", ":MavenTest", 0)
" Ctrl F11 open file tree
call KeyMap("<C-F11>", ":NERDTreeToggle", 1)
" Ctrl F10 open tag tree
call KeyMap("<C-F10>", ":TagbarToggle", 1)
" Ctrl Shift F format code
call KeyMap("<C-S-F>", ":normal gg=G", 1)
" \f format code
call KeyMap("<Leader>f", ":normal gg=G", 0)
" \w change window 
call KeyMap("<Leader>w", ":wincmd W", 0)
" \+ increase window vertical size
call KeyMap("<Leader>+", ":exe \"vertical resize \" . (winheight(0) * 3/2)<CR>", 0)
" \- decrease window vertical size
call KeyMap("<Leader>-", ":exe \"vertical resize \" . (winheight(0) * 2/3)<CR>", 0)
" Omnicomplete
inoremap <Leader>, <C-X><C-O>
inoremap <C-Space> <C-X><C-O>
inoremap <C-@> <C-X><C-O>
" Move line/block up: \k
nnoremap <leader>k :m-2<cr>
vnoremap <leader>k :m'<-2<cr>gv=gv
" Move line/block down: \j
nnoremap <leader>j :m+1<cr>
vnoremap <leader>j :m'>+1<cr>gv=gv
" Duplicate line/block down: \y
nnoremap <leader>y :t.<cr>
vnoremap <leader>y :t'>.<cr>gv=gv

" Configurações padrão para usar no Vim/GVim
filetype on
set modeline
set modelines=5
set nomousehide
set nowrap
set number
set hlsearch
set sw=4 ts=4

" Tema/syntaxe
if &t_Co >= 256
  try
    colorscheme pascal
  catch
    echo "Unable to setup colorscheme"
  endtry
else
  colorscheme pascal 
endif
syntax on

" Mouse/scroll
set mouse=a
set scrolloff=2

" Goodies with Syntastic
let g:syntastic_full_redraws=1
let g:syntastic_auto_loc_list=0

" Per-project .vimrc
" From: http://damien.lespiau.name/blog/2009/03/18/per-project-vimrc/comment-page-1/
set exrc
set secure
"--------------------------
"MAPEAMENTOS
"---------------------------
" Mapeia a tecla <F2> para salvar e permanecer no arquivo
map <F2> :w<CR><INSERT>
imap <F2> <ESC>:w<CR><INSERT>


" Mapeia a tecla <F3> para criar uma estrutura de programa em C++
au BufNewFile,BufRead *.cpp map <F3> a#include <iostream><CR><CR>using namespace std;<CR><CR>int main() {<CR>cout << "Ola Mundo!\n";<CR>return 0;<CR>}


" Mapeia a tecla <F3> para criar uma estrutura de programa em Java
au BufNewFile,BufRead *.java map <F3> apublic class Main {<CR>public static void main (String args[]) {<CR>System.out.println("Ola Mundo!");<CR>System.exit(0);<CR>}<CR>}


" Mapeia a tecla <F4> para indentar o codigo do programa
map  <F4> gg=G
imap <F4> <ESC>gg=G


" Mapeia a tecla <F5> para compilar e executar o programa em C++
au BufNewFile,BufRead *.cpp map <F5> :w<CR>:!clear && echo "Compilando % ..." && echo && g++ "%" -o "%<" && clear && ./"%<"<CR>
au BufNewFile,BufRead *.cpp imap <F5> <ESC>:w<CR>:!clear && echo "Compilando % ..." && echo && g++ "%" -o "%<" && clear && ./"%<"<CR>


" Mapeia a tecla <F5> para compilar e executar o progrma em Java
au BufNewFile,BufRead *.java map <F5> :w<CR>:!clear && echo "Compilando % ..." && echo && javac "%" && clear && java "%<"<CR>
au BufNewFile,BufRead *.java imap <F5> <ESC>:w<CR>:!clear && echo "Compilando % ..." && echo && javac "%" && clear && java "%<"<CR>


" Mapeia a tecla <F6> para executar o programa compilado em C++
au BufNewFile,BufRead *.cpp map <F6> :w<CR>:!clear && ./"%<"<CR>
au BufNewFile,BufRead *.cpp imap <F6> <ESC>:w<CR>:!clear && ./"%<"<CR>


" Mapeia a tecla <F6> para executar o programa compilado em Java
au BufNewFile,BufRead *.java map <F6> :w<CR>:!clear && java "%<"<CR>
au BufNewFile,BufRead *.java imap <F6> <ESC>:w<CR>:!clear && java "%<"<CR>


" Mapeia a combinacao de teclas <F7> para salvar o arquivo e sair do editor VIM
map  <F7> :wqa!<CR>
imap <F7> <ESC>:wqa!<CR>


" Mapeia a combinacao de teclas <F8> para abandonar o editor VIM
map  <F8> :qa!<CR>
imap <F8> <ESC>:qa!<CR>
