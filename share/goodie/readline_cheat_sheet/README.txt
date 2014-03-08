SYNOPSIS

    fetch.sh 
    parser.pl


DESCRIPTION

fetch.sh downloads the cheat sheet data from 
    https://github.com/kablamo/readline-cheat-sheet

parser.pl parses the html retrieved by fetch.sh and generates
vim_cheat_sheet.html and vim_cheat_sheet.txt which are used by
DDG::Goodie::ReadlineCheatSheet.


REQUIREMENTS

    Text::Xslate v3.1.0
    JSON         v2.90
    Web::Scraper v0.37


