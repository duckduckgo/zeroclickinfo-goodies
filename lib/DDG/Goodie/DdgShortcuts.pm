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
attribution github => "Qeole",
            twitter => "qeole";

triggers any => "shortcuts";
triggers startend => "shortcuts";

handle remainder => sub {

    # Combination of "keyboard", "cheat sheet", "duckduckgo" (or aliases), or nothing
    return unless $_ =~ /^\s*(((duck\s*duck\s*go|ddg)( ?'?s)?|cheat\s*sheet|keyboard)\s*)*$/i;

    return
        heading => "DuckDuckGo Shortcuts Cheat Sheet",
        html    => html_cheat_sheet(),
        answer  => text_cheat_sheet(),
};

my $HTML;

sub html_cheat_sheet {
    $HTML //= share("ddg_shortcuts.html")
        ->slurp(iomode => '<:encoding(UTF-8)');
    return $HTML;
}

my $TEXT;

sub text_cheat_sheet {
    $TEXT //= share("ddg_shortcuts.txt")
        ->slurp(iomode => '<:encoding(UTF-8)');
    return $TEXT;
}

1;
