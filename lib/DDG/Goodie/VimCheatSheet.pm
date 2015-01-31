package DDG::Goodie::VimCheatSheet;
# ABSTRACT: Provide a cheatsheet for common vim syntax

use DDG::Goodie;

zci answer_type => "vim_cheat";
zci is_cached   => 1;

name "VimCheatSheet";
description "Vim cheat sheet";
source "http://rtorruellas.com/vim-cheat-sheet/";
code_url "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Goodie/VimCheatSheet.pm";
category "cheat_sheets";
topics "computing", "geek", "programming", "sysadmin";

primary_example_queries 'vim help', 'vim cheat sheet', 'vim commands';
secondary_example_queries 'vi quick reference', 'vi commands', 'vi guide';

triggers startend => (
    'vi cheat sheet',
    'vi cheatsheet',
    'vi commands',
    'vi guide',
    'vi help',
    'vi quick reference',
    'vi reference',
    'vim cheat sheet',
    'vim cheatsheet',
    'vim commands',
    'vim guide',
    'vim help',
    'vim quick reference',
    'vim reference',
);

attribution github  => ["kablamo",            "Eric Johnson"],
            twitter => ["kablamo_",           "Eric Johnson"],
            web     => ["http://kablamo.org", "Eric Johnson"];

my $HTML = share("vim_cheat_sheet.html")->slurp(iomode => '<:encoding(UTF-8)');
my $TEXT = share("vim_cheat_sheet.txt")->slurp(iomode => '<:encoding(UTF-8)');

handle remainder => sub {
    return
        heading => 'Vim Cheat Sheet',
        html    => $HTML,
        answer  => $TEXT,
};

1;
