package DDG::Goodie::GermanCheatsheet;
# ABSTRACT: German Cheatsheet Goodie

use DDG::Goodie;

zci answer_type => "german_cheatsheet";
zci is_cached   => 1;

name "GermanCheatsheet";
description "A Cheatsheet Key Travel Phrases";
primary_example_queries "German Cheatsheet", "English to German Cheatsheet";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/GermanCheatsheet.pm";
attribution github => ["AdamSC1-DDG", "Adam Cochran"],
            twitter => "adamscochran";

# Triggers
triggers any => "german cheatsheet", "cheatsheet german";

my $HTML = share("german_cheatsheet.html")->slurp(iomode => "<:encoding(UTF-8)");


handle remainder => sub {
    return if $_;
    return heading -> "English to German Cheat Sheet",
        html => $HTML;
};

1;
