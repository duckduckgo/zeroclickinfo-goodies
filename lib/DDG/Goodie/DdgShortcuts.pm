package DDG::Goodie::DdgShortcuts;
# ABSTRACT: Returns a cheat sheet for DuckDuckGo keyboard shortcuts

use DDG::Goodie;

zci answer_type => "ddg_shortcuts";
zci is_cached   => 1;

name "DDG_Shortcuts";
description "DuckDuckGo Shortcuts Cheat Sheet";
primary_example_queries "DuckDuckGo shortcuts", "shortcuts";
secondary_example_queries "keyboard shortcuts", "shortcuts cheatsheet";
category "cheat_sheets";
topics "computing", "geek", "trivia";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DDGShortcuts.pm";
attribution github  => ['https://github.com/Qeole','Qeole'],
            twitter => ['https://twitter.com/qeole','Qeole'];

triggers any => "shortcuts";
triggers startend => "shortcuts";

my $TEXT = scalar share('ddg_shortcuts.txt')->slurp,
my $HTML = scalar share('ddg_shortcuts.html')->slurp;

handle remainder => sub {

    # Combination of "keyboard", "cheat sheet", "duckduckgo" (or aliases), or nothing
    return unless $_ =~ /^\s*(((duck\s*duck\s*go|ddg)( ?'?s)?|cheat\s*sheet|keyboard)\s*)*$/i;

    return
        heading => "DuckDuckGo Shortcuts Cheat Sheet",
        answer  => $TEXT,
        html    => $HTML,
};

1;
