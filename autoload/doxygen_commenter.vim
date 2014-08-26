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

  for l:item in split(substitute(matchlist(join(l:range), '[^(]*(\([^)]*\))')[1], '\s*,\s*', ',', "g"), ',\zs')
    let l:param = split(substitute(l:item,'\s*$','','g'), '\s\zs')[-1]
    let l:param = substitute(l:param, '[\,,\*]', '', "g")
    call add(l:params, l:param)
  endfor

  let l:result['params']=l:params
  return l:result
endfunction

let g:doxygen_commenter#parse_functions = {
      \ 'c': 's:parse_c',
      \}

function! doxygen_commenter#comment_func()
  let l:funcstart = line(".")
  let l:funcend   = line(".")
  let l:bufend    = line("$")

  while l:bufend >= l:funcend
    let l:line = getline(l:funcend)
    if l:line =~# ")"
      break
    endif
    let l:funcend = l:funcend + 1
  endwhile

  if l:funcend > l:bufend
    echoerr "not found function end"
  else
    if has_key(g:doxygen_commenter#parse_functions, &filetype)
      let l:result = function(g:doxygen_commenter#parse_functions[&filetype])(s:readbuf(l:funcstart,l:funcend))
      call append(l:funcstart - 1 , s:create_funcheader_comment(l:result['params']))
    else
      echoerr "filetype=" .&filetype . "is not supported"
    endif
  endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
