" ============================================================================
" File:        doxygen_commenter.vim
" Description: This plugin is created comment for  Doxygen
" Author:      hidetzu <hidetzu@gmail.com>
" Licence:     This file is placed in the public domain.
" Website:     http://hidetzu.github.com/doxygen_commenter/
" Version:     0.0.1
" Note:
" ============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! s:readbuf(startline, endline)
  return getline(a:startline, a:endline)
endfunction

function! s:create_funcheader_comment( params )
  let l:result=[]
  call add(l:result, "/**")
  call add(l:result, " *@brief")

  for l:param in a:params
    call add(l:result, " *@param " . l:param)
  endfor
  call add(l:result, " *@result")
  call add(l:result, " */")
  return l:result
endfunction

function! s:parse_c(range)
  let l:range = a:range
  let l:result= {}
  let l:params=[]

  for l:word in l:range
    for l:item in split(l:word, '[\,(,)]\zs')
      if l:item =~# '('
        continue
      endif

      for l:item2 in split(l:item, '\s\zs')
        if l:item2 =~# ','
          call add(l:params, substitute(l:item2, ',', '', 'g'))
        elseif l:item2 =~# ')'
          call add(l:params, substitute(l:item2, ')', '', 'g'))
        endif
      endfor
    endfor
  endfor

  let l:result['params']=l:params
  return l:result
endfunction

function! doxygen_commenter#comment_func()
  let l:funcstart = line(".")
  let l:funcend   = line(".")

  while getline(l:funcend) !~# "{"
    let l:funcend = l:funcend + 1
  endwhile

  if &ft == 'c'
    let l:result = s:parse_c(s:readbuf(l:funcstart, l:funcend))
    call append(l:funcstart - 1 , s:create_funcheader_comment(l:result['params']))
  endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
