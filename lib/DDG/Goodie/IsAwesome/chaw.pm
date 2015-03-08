package DDG::Goodie::IsAwesome::chaw;
# ABSTRACT: chaw's first goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_chaw";
zci is_cached   => 1;

name "IsAwesome chaw";
description "A first Goodie, wishing happy hacking to the world.";
primary_example_queries "duckduckhack chaw";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/chaw.pm";
attribution github => ["https://github.com/chaw/", "chaw"];

# Triggers
triggers start => "duckduckhack chaw";

# Handle statement
handle remainder => sub {
    return if $_;
    return "chaw wishes you Happy Hacking!";
};

1;
