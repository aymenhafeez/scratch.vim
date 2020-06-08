" File: scratch.vim
" Original Author: Yegappan Lakshmanan (yegappan AT yahoo DOT com)
" Forked By:       Aymen Hafeez (aymennh AT gmail DOT com)
" Version:         1.1
" Location:        https://github.com/aymenhafeez/scratch.vim/
" Last Modified:   16 April, 2020

" TODO : Make vim doc file

if exists('loaded_scratch') || &cp
    finish
endif
let loaded_scratch=1

if !exists('split_size')
    let split_size = 11
endif

if !exists('split_direction')
    let split_direction = 'aboveleft'
endif

let ScratchBufferName = "\\*scratch\\*"

" Open the scratch buffer
function! s:ScratchBufferOpen(new_win)
    let split_win = a:new_win

    " If the current buffer is modified then open the scratch buffer in a new
    " window
    if !split_win && &modified
        let split_win = 1
    endif

    " Check whether the scratch buffer is already created
    let scr_bufnum = bufnr(g:ScratchBufferName)
    if scr_bufnum == -1
        " open a new scratch buffer
        if split_win
            exe "new " . g:ScratchBufferName
        else
            exe "edit " . g:ScratchBufferName
        endif
    else
        " Scratch buffer is already created. Check whether it is open
        " in one of the windows
        let scr_winnum = bufwinnr(scr_bufnum)
        if scr_winnum != -1
            " Jump to the window which has the scratch buffer if we are not
            " already in that window
            if winnr() != scr_winnum
                exe scr_winnum . "wincmd w"
            endif
        else
            " Create a new scratch buffer
            if split_win
                exe g:split_direction .  g:split_size . "split +buffer" . scr_bufnum
            else
                exe "buffer " . scr_bufnum
            endif
        endif
    endif
endfunction

" ScratchMarkBuffer
" Mark a buffer as scratch
function! s:ScratchMarkBuffer()
    setlocal
        \ buftype=nowrite
        \ bufhidden=hide
        \ noswapfile
        \ nobuflisted
        \ filetype=vim
endfunction

autocmd BufNewFile \*scratch\* call s:ScratchMarkBuffer()

" Command to edit the scratch buffer in the current window
command! -nargs=0 Scratch call s:ScratchBufferOpen(0)
" Command to open the scratch buffer in a new split window
command! -nargs=0 Sscratch call s:ScratchBufferOpen(1)

