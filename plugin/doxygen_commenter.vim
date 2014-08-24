" ============================================================================
" File:        doxygen_commenter.vim
" Description: This plugin is created comment for  Doxygen
" Author:      hidetzu <hidetzu@gmail.com>
" Licence:     This file is placed in the public domain.
" Website:     http://hidetzu.github.com/doxygen_commenter/
" Version:     0.0.1
" Note:
" ============================================================================

if exists('g:loaded_doxygen_commenter')
  finish
endif

let g:loaded_doxygen_commenter = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 Doxfunc call doxygen_commenter#comment_func()

let &cpo  = s:save_cpo
unlet s:save_cpo
