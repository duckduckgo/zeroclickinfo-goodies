package DDG::Goodie::IsAwesome::jeet09;
# ABSTRACT: Jitu's first Goodie
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_jeet09";
zci is_cached   => 1;

name "IsAwesome jeet09";
description "My first Goodie, it let's the world know that Jitu is awesome";
primary_example_queries "duckduckhack jeet09";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/jeet09.pm";
attribution github => ["https://github.com/jeet09", "Jitu"],
            twitter => "jeet09";

# Triggers
triggers start => "duckduckhack jeet09", "jeet09 duckduckhack";

# Handle statement
handle remainder => sub {
    return if $_;
    return "Jitu is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;
