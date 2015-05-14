package DDG::Goodie::EclipseCheatSheet;
# ABSTRACT: A cheatsheet for useful eclipse commands

use strict;
use DDG::Goodie;

zci answer_type => "eclipse_cheat_sheet";
zci is_cached   => 1;

name "EclipseCheatSheet";
description "eclipse cheatsheet";
source "http://www.shortcutworld.com/shortcuts.php?l=en&p=win&application=Eclipse";

category "cheat_sheets";
topics "computing", "geek", "programming", "sysadmin";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/EclipseCheatSheet.pm";
attribution github  => ["https://github.com/dmcdowell", "dmcdowell"];

primary_example_queries "eclipse cheatsheet", "eclipse cheat sheet", "eclipse commands", "eclipse help", "eclipse shortcuts", "eclipse shortcut";
secondary_example_queries "eclipse reference", "eclipse guide", "eclipse quick reference";

triggers startend => "eclipse cheatsheet", 
                     "eclipse cheat sheet",
                     "eclipse help", 
                     "eclipse commands", 
                     "eclipse shortcuts",
                     "eclipse shortcut",
                     "eclipse guide",
                     "eclipse reference", 
                     "eclipse quick reference",
                     "cheatsheet eclipse",
                     "cheat sheet eclipse",
                     "help eclipse",
                     "commands eclipse",
                     "shortcuts eclipse",
                     "shortcut eclipse",
                     "guide eclipse", 
                     "reference eclipse", 
                     "quick reference eclipse";

my $TEXT = scalar share('eclipse_cheat_sheet.txt')->slurp(iomode => '<:encoding(UTF-8)'),
my $HTML = scalar share('eclipse_cheat_sheet.html')->slurp(iomode => '<:encoding(UTF-8)');

handle remainder => sub {
    return 
        heading => 'Eclipse Cheat Sheet',
        answer  => $TEXT,
        html    => $HTML,
};

1;
