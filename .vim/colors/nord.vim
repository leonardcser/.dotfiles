set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "nord"

" Nord palette from named_colors.lua
" nord0  #2E3440  black
" nord1  #3B4252  dark_gray
" nord2  #434C5E  gray
" nord3  #4C566A  light_gray
"        #616E88  light_gray_bright
" nord4  #D8DEE9  darkest_white
" nord5  #E5E9F0  darker_white
" nord6  #ECEFF4  white
" nord7  #8FBCBB  teal
" nord8  #88C0D0  off_blue
" nord9  #81A1C1  glacier
" nord10 #6E82AC  blue
" nord11 #BF616A  red
" nord12 #D08770  orange
" nord13 #EBCB8B  yellow
" nord14 #A3BE8C  green
" nord15 #B48EAD  purple

" Editor
hi Normal        guifg=#D8DEE9 guibg=NONE
hi CursorLine    guibg=#191D23
hi CursorLineNr  guifg=#D8DEE9
hi LineNr        guifg=#4C566A
hi ColorColumn   guibg=#191D23
hi SignColumn     guibg=NONE
hi VertSplit     guifg=#4C566A guibg=NONE
hi StatusLine    guifg=#D8DEE9 guibg=#3B4252
hi StatusLineNC  guifg=#4C566A guibg=#3B4252
hi Visual        guibg=#434C5E
hi Search        guifg=#2E3440 guibg=#EBCB8B
hi IncSearch     guifg=#2E3440 guibg=#88C0D0
hi MatchParen    guifg=#88C0D0 guibg=#4C566A
hi Pmenu         guifg=#D8DEE9 guibg=#3B4252
hi PmenuSel      guifg=#88C0D0 guibg=#434C5E
hi PmenuSbar     guibg=#3B4252
hi PmenuThumb    guibg=#4C566A
hi Folded        guifg=#616E88 guibg=#3B4252
hi FoldColumn    guifg=#616E88 guibg=NONE
hi NonText       guifg=#4C566A
hi SpecialKey    guifg=#4C566A
hi Directory     guifg=#81A1C1
hi ErrorMsg      guifg=#BF616A guibg=NONE
hi WarningMsg    guifg=#EBCB8B
hi Title         guifg=#D8DEE9 gui=bold
hi WildMenu      guifg=#88C0D0 guibg=#3B4252

" Syntax
hi Comment       guifg=#616E88 gui=NONE
hi Constant      guifg=#ECEFF4
hi String        guifg=#A3BE8C
hi Character     guifg=#A3BE8C
hi Number        guifg=#B48EAD
hi Boolean       guifg=#81A1C1
hi Float         guifg=#B48EAD
hi Identifier    guifg=#D8DEE9
hi Function      guifg=#88C0D0
hi Statement     guifg=#81A1C1
hi Conditional   guifg=#81A1C1
hi Repeat        guifg=#81A1C1
hi Label         guifg=#81A1C1
hi Operator      guifg=#81A1C1
hi Keyword       guifg=#81A1C1
hi Exception     guifg=#81A1C1
hi PreProc       guifg=#81A1C1
hi Include       guifg=#81A1C1
hi Define        guifg=#81A1C1
hi Macro         guifg=#81A1C1
hi PreCondit     guifg=#81A1C1
hi Type          guifg=#8FBCBB
hi StorageClass  guifg=#81A1C1
hi Structure     guifg=#8FBCBB
hi Typedef       guifg=#8FBCBB
hi Special       guifg=#D8DEE9
hi SpecialChar   guifg=#EBCB8B
hi Tag           guifg=#81A1C1
hi Delimiter     guifg=#ECEFF4
hi SpecialComment guifg=#616E88
hi Debug         guifg=#BF616A
hi Underlined    guifg=#81A1C1 gui=underline
hi Error         guifg=#BF616A guibg=NONE
hi Todo          guifg=#EBCB8B guibg=NONE gui=bold

" Diff
hi DiffAdd       guifg=#A3BE8C guibg=#3B4252
hi DiffChange    guifg=#EBCB8B guibg=#3B4252
hi DiffDelete    guifg=#BF616A guibg=#3B4252
hi DiffText      guifg=#88C0D0 guibg=#434C5E

" Spell
hi SpellBad      guifg=#BF616A gui=undercurl
hi SpellCap      guifg=#EBCB8B gui=undercurl
hi SpellLocal    guifg=#88C0D0 gui=undercurl
hi SpellRare     guifg=#B48EAD gui=undercurl

" Git
hi diffAdded     guifg=#A3BE8C
hi diffRemoved   guifg=#BF616A
