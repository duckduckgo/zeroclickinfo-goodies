package DDG::Goodie::IsAwesome::chaw;
# ABSTRACT: chaw's first goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_chaw";
zci is_cached   => 1;

# Triggers
triggers start => "duckduckhack chaw";

# Handle statement
handle remainder => sub {
    return if $_;
    return "chaw wishes you Happy Hacking!";
};

1;
