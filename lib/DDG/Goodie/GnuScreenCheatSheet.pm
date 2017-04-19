package DDG::Goodie::GnuScreenCheatSheet;
# ABSTRACT: Provide a cheatsheet for common GNU screen commands

use strict;
use DDG::Goodie;

zci answer_type => 'gnuscreen_cheat';
zci is_cached   => 1;

name "CheatSheet";
source "https://www.gnu.org/software/screen/manual/screen.html";
description "GNU Screen cheat sheet";
category "cheat_sheets";
topics "computing", "geek", "programming", "sysadmin";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/GnuScreenCheatSheet.pm";

primary_example_queries 'screen help', 'screen cheat sheet', 'screen commands', 'gnu screen help', 'gnu screen cheat sheet', 'gnu screen commands';
secondary_example_queries 'screen quick reference', 'screen guide',' gnu screen quick reference', 'gnu screen guide';

triggers startend => (
    'screen cheat sheet',
    'screen cheatsheet',
    'screen commands',
    'screen guide',
    'screen help',
    'screen quick reference',
    'screen reference',
    'cheatsheet screen',
    'cheat sheet screen',
    'guide screen',
    'reference screen',
    'quick reference screen',
    'help screen',
);

attribution github  => ["dnmfarrell",            "David Farrell"],
            twitter => ["perltricks",           "David Farrell"],
            web     => ["http://perltricks.com", "David Farrell"];

my $HTML = share("gnuscreen_cheat_sheet.html")->slurp(iomode => '<:encoding(UTF-8)');
my $TEXT= share("gnuscreen_cheat_sheet.txt")->slurp(iomode => '<:encoding(UTF-8)');

handle remainder => sub {
    return
        heading => 'GNU Screen Cheat Sheet',
        html    => $HTML,
        answer   => $TEXT,
};

1;
