if exists("g:loaded_obsession_manager")
    finish
endif
let g:loaded_obsession_manager = 1

if !exists('g:obsession_manager_dir')
    let g:obsession_manager_dir = expand('~/.vim/sessions/')
endif

command! -bang -bar -nargs=? -complete=customlist,s:obsession_complete ObsessionManager call s:obsession_manager(<bang>0, <q-args>)

function! s:obsession_manager(bang, file) abort
    if a:bang
        Obsession!
        return 1
    endif

    if empty(a:file)
        echoerr "ObsessionManager: No session name provided!"
        return 0
    endif

    let session_file = fnameescape(g:obsession_manager_dir . substitute(a:file, '/', '%', 'g') . '.session')

    if filereadable(session_file)
        execute 'source' session_file
    else
        execute 'Obsession' session_file
    endif

    return 1
endfunction

function! s:obsession_complete(ArgLead, CmdLine, CursorPos) abort
    let str = empty(a:ArgLead) ? '' : '*' . a:ArgLead
    let result = glob(fnamemodify(g:obsession_manager_dir, ':p') . str . '*.session', 0, 1)
    let result = map(result, "fnamemodify(v:val, ':t:r')")
    let result = map(result, "substitute(v:val, '%', '/', 'g')")
    return result
endfunction
