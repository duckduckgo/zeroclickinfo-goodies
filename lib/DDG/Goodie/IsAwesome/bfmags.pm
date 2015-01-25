package DDG::Goodie::IsAwesome::bfmags;
# ABSTRACT: bfmags's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_bfmags";
zci is_cached   => 1;

name "IsAwesome bfmags";
description "My first Goodie, it let's the world know that bfmags is awesome";
primary_example_queries "duckduckhack bfmags";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/bfmags.pm";
attribution github => ["https://github.com/bfmags", "bfmags"],
            twitter => "bfmags";

# Triggers
triggers start => "duckduckhack bfmags";

handle remainder => sub {
    return if $_;
    return "bfmags is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
