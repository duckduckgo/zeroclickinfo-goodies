package DDG::Goodie::IsAwesome::5ika;
# ABSTRACT: 5ika' first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_5ika";
zci is_cached   => 1;

name "IsAwesome 5ika";
description "Hey world, i'm awesome";
primary_example_queries "duckduckhack 5ika";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/5ika.pm";
attribution github => ["https://github.com/5ika/", "5ika"],
            twitter => "05Sika";

# Triggers
triggers start => "duckduckhack 5ika";

# Handle statement
handle remainder => sub {

    return if $_;
    return "Sika is awesome !";
};

1;
