local opt = vim.opt -- for conciseness

opt.shortmess = "I" -- disable native nvim greeter / intro message / splash screen (however you wanna call it)

-- line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)
opt.relativenumber = true -- show relative line numbers

-- scrolling
opt.scrolloff = 5 -- determines the number of context lines you would like to see above and below the cursor. See https://vim.fandom.com/wiki/Keep_your_cursor_centered_vertically_on_the_screen

-- tabs & indentation
opt.tabstop = 4 -- 4 spaces for tabs (prettier default)
opt.shiftwidth = 4 -- 4 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping
-- opt.textwidth = 80
opt.colorcolumn = "50,72,120" -- show visual columns at 50,72,120

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- sounds
opt.vb = true -- never ever make my terminal beep

--
-- Appearance
--

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.iskeyword:append("-") -- consider string-string as whole word

-- turn off swapfile
opt.swapfile = false

-- conceal certain syntax and only show it when cursor is placed in the line (nice for writing MD, HTML, ...)
-- opt.conceallevel = 3 -- commented out since hides certain control characters in non MD files
