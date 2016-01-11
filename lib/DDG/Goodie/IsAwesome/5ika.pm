package DDG::Goodie::IsAwesome::5ika;
# ABSTRACT: 5ika' first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_5ika";
zci is_cached   => 1;

# Triggers
triggers start => "duckduckhack 5ika";

# Handle statement
handle remainder => sub {

    return if $_;
    return "Sika is awesome !";
};

1;
