package DDG::Goodie::TmuxCheatSheet;
# ABSTRACT: Provide a cheatsheet for common tmux commands

use DDG::Goodie;

zci answer_type => 'tmux_cheat';
zci is_cached   => 1;

name "TmuxCheatSheet";
source "http://www.openbsd.org/cgi-bin/man.cgi?query=tmux&sektion=1";
description "Tmux cheat sheet";
category "cheat_sheets";
topics "computing", "geek", "programming", "sysadmin";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/TmuxCheatSheet.pm";

primary_example_queries 'tmux help', 'tmux cheat sheet', 'tmux commands';
secondary_example_queries 'tmux quick reference', 'tmux guide';

triggers startend => (
    'tmux cheat sheet',
    'tmux cheatsheet',
    'tmux commands',
    'tmux guide',
    'tmux help',
    'tmux quick reference',
    'tmux reference',
    'cheatsheet tmux',
    'cheat sheet tmux',
    'guide tmux',
    'reference tmux',
    'quick reference tmux',
    'help tmux',
);

attribution github  => ["charles-l",            "Charles Saternos"],
            twitter => ["theninjacharlie",           "Charles Saternos"],
            web     => ["http://charles-l.github.io", "Charles Saternos"];

my $HTML = share("tmux_cheat_sheet.html")->slurp(iomode => '<:encoding(UTF-8)');
my $TEXT= share("tmux_cheat_sheet.txt")->slurp(iomode => '<:encoding(UTF-8)');

handle remainder => sub {
    return
        heading => 'Tmux Cheat Sheet',
        html    => $HTML,
        answer   => $TEXT,
};

1;
