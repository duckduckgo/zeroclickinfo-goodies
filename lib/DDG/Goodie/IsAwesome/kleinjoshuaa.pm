package DDG::Goodie::IsAwesome::kleinjoshuaa;
# ABSTRACT: kleinjoshuaa's first goodie


use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_kleinjoshuaa";
zci is_cached   => 1;

name "IsAwesome kleinjoshuaa";
description "My first Goodie, it lets the world know that kleinjoshuaa is awesome";
primary_example_queries "duckduckhack kleinjoshuaa";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/kleinjoshuaa.pm";
attribution github => ["https://github.com/kleinjoshuaa", "kleinjoshuaa"];

# Triggers
triggers start => "duckduckhack kleinjoshuaa";

# Handle statement
handle remainder => sub {
    return if $_;
    return "kleinjoshuaa is awesome and has successfully completed the duckduckhack goodie tutorial!";
};

1;
