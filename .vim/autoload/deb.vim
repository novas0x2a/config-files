" Vim autoload file for browsing debian package.
" copyright (C) 2007-2008, arno renevier <arenevier@fdn.fr>
" Distributed under the GNU General Public License (version 2 or above)
" Last Change: 2008 april 1
" 
" Inspired by autoload/tar.vim by Charles E Campbell
"
" Latest version of that file can be found at
" http://www.fdn.fr/~arenevier/vim/autoload/deb.vim
" It should also be available at
" http://www.vim.org/scripts/script.php?script_id=1970

if &cp || exists("g:loaded_deb") || v:version < 700
    finish
endif
let g:loaded_deb= "v1.4"

fun! deb#read(debfile, member)

    " checks if ar and tar are installed
    if !s:hascmd("ar") || !s:hascmd("tar")
        return
    endif

    let l:target = a:member

    let l:archmember = s:dataFileName(a:debfile) " default archive member to extract
    if l:archmember == ""
        echohl WarningMsg | echo "***error*** (deb#read) no valid data file found in debian archive"
        return
    elseif l:archmember == "data.tar.gz"
        let l:unpcmp = "tar zxfO "
    elseif l:archmember == "data.tar.bz2"
        let l:unpcmp = "tar jxfO "
    elseif l:archmember == "data.tar.lzma"
        if !s:hascmd("lzma")
            return
        endif
        let l:unpcmp = "lzma -d | tar xfO "
    elseif l:archmember == "data.tar"
        let l:unpcmp = "tar xfO "
    endif

    if a:member =~ '^\* ' " information control file
        let l:archmember = "control.tar.gz"
        let l:target = substitute(l:target, "^\* ", "", "")
        let l:unpcmp = "tar zxfO "
    elseif a:member =~ ' -> ' " symbolic link
        let l:target = split(a:member,' -> ')[0]
        let l:linkname = split(a:member,' -> ')[1]

        if l:linkname =~ "^\/" " direct symlink: path is already absolute
            let l:target = ".".l:linkname

        else 
        " transform relative path to absolute path

            " first, get basename for target
            let l:target = substitute(l:target, "\/[^/]*$", "", "")

            " while it begins with ../
            while l:linkname =~ "^\.\.\/" 

                " removes one level of ../ in linkname
                let l:linkname = substitute(l:linkname, "^\.\.\/", "", "")

                " go one directory up in target
                let l:target = substitute(l:target, "\/[^/]*$", "", "")
            endwhile

            let l:target = l:target."/".l:linkname
        endif
    endif
    
    " we may preprocess some files (such as man pages, or changelogs)
    let l:preproccmd = ""
        
    "
    " unzip man pages
    "
    if l:target =~ "\.\/usr\/share\/man\/.*\.gz$"
        
        " try to fail gracefully if a command is not available
        if !s:hascmd("gzip")
            return
        elseif !s:hascmd("nroff") 
            let l:preproccmd = "| gzip -cd"
        elseif !s:hascmd("col")
            let l:preproccmd = "| gzip -cd | nroff -mandoc"
        else
            let l:preproccmd = "| gzip -cd | nroff -mandoc | col -b"
        endif
    
    "
    " unzip other .gz files
    "
    elseif l:target =~ '.*\.gz$'
        if !s:hascmd("gzip")
            return
        endif
        let l:preproccmd = "| gzip -cd"
    endif

    " read content
    exe "silent r! ar p " . s:QuoteFile(a:debfile) . " " . s:QuoteFile(l:archmember) . " | " . l:unpcmp . " - " . s:QuoteFile(l:target) . l:preproccmd
    " error will be treated in calling function
    if v:shell_error != 0
        return
    endif

    exe "file deb:".l:target

    0d

    setlocal nomodifiable nomodified readonly

endfun

fun! deb#browse(file)

    " checks if necessary utils are installed
    if !s:hascmd("dpkg") || !s:hascmd("ar") || !s:hascmd("tar")
        return
    endif

    " checks if file is readable
    if !filereadable(a:file)
        return
    endif
    if a:file =~ "'"
        echohl WarningMsg | echo "***error*** (deb#Browse) filename cannot contain quote character (" . a:file . ")"
        return
    endif

    let keepmagic = &magic
    set magic

    " set filetype to "deb"
    set ft=deb

    setlocal modifiable noreadonly

    " set header
    exe "$put ='".'\"'." deb.vim version ".g:loaded_deb."'"
    exe "$put ='".'\"'." Browsing debian package ".a:file."'"
    $put=''

    " package info
    "exe "silent read! dpkg -I ".a:file
    "$put=''

    " display information control files
    let l:infopos = line(".")
    exe "silent read! ar p " . s:QuoteFile(a:file) . " control.tar.gz | tar zt"

    $put=''

    " display data files
    let l:listpos = line(".")
    exe "silent read! dpkg -c ". s:QuoteFile(a:file)

    " format information control list
    " removes '* ./' line
    exe (l:infopos + 1). 'd'
    " add a star before each line
    exe "silent " . (l:infopos + 1). ',' . (l:listpos - 2) . 's/^/\* /'
    
    " format data list
    exe "silent " . l:listpos . ',$s/^.*\s\(\.\/\(\S\|\).*\)$/\1/'
    
    if v:shell_error != 0
        echohl WarningMsg | echo "***warning*** (deb#Browse) error when listing content of " . a:file
        let &magic = keepmagic
        return
    endif

    0d

    setlocal nomodifiable readonly
    noremap <silent> <buffer> <cr> :call <SID>DebBrowseSelect()<cr>
    let &magic = keepmagic

endfun

fun! s:DebBrowseSelect()
    let l:fname= getline(".")

    " sanity check
    if (l:fname !~ '^\.\/') && (l:fname !~ '^\* \.\/')
        return
    endif
    if l:fname =~ "'"
        echohl WarningMsg | echo "***error*** (DebBrowseSelect) filename cannot contain quote character (" . l:fname . ")"
        return
    endif

    " do nothing on directories
    " TODO: find a way to detect symlinks to directories, to be able not to
    " open them
    if (l:fname =~ '\/$')
        return
    endif

    " need to get it now since a new window will open
    let l:curfile= expand("%")
   
    " open new window
    new
    wincmd _

    call deb#read(l:curfile, l:fname)

    if v:shell_error != 0
        echohl WarningMsg | echo "***warning*** (DebBrowseSelect) error when reading " . l:fname
        return
    endif

    filetype detect

    " zipped files, are unziped in deb#read, but filetype may not
    " automatically work.
    if l:fname =~ "\.\/usr\/share\/man\/.*\.gz$"
        set filetype=man
    elseif l:fname =~ "\.\/usr\/share\/doc\/.*\/changelog.Debian.gz$"
        set filetype=debchangelog
    endif

endfun

" return data file name for debian package. This can be either data.tar.gz,
" data.tar.bz2 or data.tar.lzma
fun s:dataFileName(deb)
    for fn in ["data.tar.gz", "data.tar.bz2", "data.tar.lzma", "data.tar"]
        " [0:-2] is to remove trailing null character from command output
        if (system("ar t " . "'" . a:deb . "'" . " " . fn))[0:-2] == fn
            return fn
        endif
    endfor
    return "" " no debian data format in this archive
endfun

fun s:QuoteFile(file)
    " we need to escape %, #, <, and >
    " see :help cmdline-specialk
    return "'" .  substitute(a:file, '\([%#<>]\)', '\\\1', 'g') . "'"
endfun

" return 1 if cmd exists
" display error message and return 0 otherwise
fun s:hascmd(cmd)
    if executable(a:cmd)
        return 1
    else
        echohl Error | echo "***error*** " . a:cmd . " not available on your system"
        return 0
    else
endfu

