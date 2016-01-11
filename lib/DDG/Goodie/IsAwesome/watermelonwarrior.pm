package DDG::Goodie::IsAwesome::watermelonwarrior;
# ABSTRACT: Watermelonwarrior's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_watermelonwarrior";
zci is_cached   => 1;

# Triggers
triggers start => "duckduckhack watermelonwarrior";

# Handle statement
handle remainder => sub {
    return if $_;
    return "watermelonwarrior is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
